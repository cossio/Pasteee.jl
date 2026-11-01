using Test: @test, @testset, @test_throws
import HTTP
import JSON
import Pasteee

# The round trip every backend must support: the in-process mock below, and the
# live Paste.ee API when PASTEEE_APPKEY is set.
function roundtrip(appkey::AbstractString)
    id = Pasteee.paste(appkey, "Batido de mamey"; expiration="3600")
    paste = Pasteee.get(appkey, id)
    @test paste["sections"][1]["contents"] == "Batido de mamey"

    Pasteee.delete(appkey, id)
    @test_throws HTTP.StatusError Pasteee.get(appkey, id)

    pastes = Pasteee.pastes(appkey; perpage=12, page=2)
    @test pastes["current_page"] == 2
    @test pastes["per_page"] == 12
end

const MOCK_APPKEY = "mock-appkey"

json_response(status::Int, data) =
    HTTP.Response(status, ["Content-Type" => "application/json"], JSON.json(data))

error_response(status::Int, message::AbstractString) =
    json_response(status, Dict("success" => false, "errors" => [Dict("message" => message)]))

function query_params(query::AbstractString)
    return Dict(String(k) => String(v) for (k, v) in (split(kv, '='; limit=2) for kv in split(query, '&'; keepempty=false)))
end

# In-memory stand-in for the endpoints of the Paste.ee v1 API that Pasteee.jl calls
# (https://pastee.github.io/docs/). Every request is recorded in `requests`.
function mock_pasteee(requests::Vector{Any})
    store = Dict{String,Any}()
    return function (req::HTTP.Request)
        path, query = let parts = split(req.target, '?'; limit=2)
            String(parts[1]), length(parts) == 2 ? String(parts[2]) : ""
        end
        body = String(req.body)
        push!(requests, (; req.method, path, query, body,
            token = HTTP.header(req, "X-Auth-Token"),
            content_type = HTTP.header(req, "Content-Type")))

        HTTP.header(req, "X-Auth-Token") == MOCK_APPKEY || return error_response(401, "Invalid application key.")

        if req.method == "POST" && path == "/v1/pastes"
            data = JSON.parse(body)
            id = "mock$(length(store) + 1)"
            store[id] = Dict("id" => id, "description" => data["description"], "sections" => data["sections"])
            return json_response(201, Dict("id" => id, "link" => "https://paste.ee/p/$id"))
        elseif req.method == "GET" && path == "/v1/pastes"
            params = query_params(query)
            return json_response(200, Dict(
                "current_page" => parse(Int, params["page"]),
                "per_page" => parse(Int, params["perpage"]),
                "data" => collect(values(store))))
        elseif startswith(path, "/v1/pastes/")
            id = chopprefix(path, "/v1/pastes/")
            haskey(store, id) || return error_response(404, "Paste not found.")
            if req.method == "GET"
                return json_response(200, Dict("paste" => store[id]))
            elseif req.method == "DELETE"
                delete!(store, id)
                return json_response(200, Dict("success" => true))
            end
        end
        return error_response(404, "Not found.")
    end
end

@testset "Pasteee" begin
    @testset "mock API" begin
        requests = Any[]
        server = HTTP.serve!(mock_pasteee(requests), "127.0.0.1", 0; listenany=true)
        default_url = Pasteee.API_URL[]
        Pasteee.API_URL[] = "http://127.0.0.1:$(HTTP.port(server))/v1"
        try
            roundtrip(MOCK_APPKEY)

            @test [(r.method, r.path) for r in requests] == [
                ("POST", "/v1/pastes"),
                ("GET", "/v1/pastes/mock1"),
                ("DELETE", "/v1/pastes/mock1"),
                ("GET", "/v1/pastes/mock1"),
                ("GET", "/v1/pastes"),
            ]
            @test all(r.token == MOCK_APPKEY for r in requests)

            post = requests[1]
            @test post.content_type == "application/json"
            @test JSON.parse(post.body) == Dict(
                "description" => "",
                "expiration" => "3600",
                "sections" => [Dict("name" => "", "syntax" => "", "contents" => "Batido de mamey")])
            @test query_params(requests[end].query) == Dict("perpage" => "12", "page" => "2")

            sections = [Pasteee.Section("x = 1"; name="code", syntax="julia"), Pasteee.Section("notes")]
            id = Pasteee.paste(MOCK_APPKEY, sections; description="two sections")
            paste = Pasteee.get(MOCK_APPKEY, id)
            @test paste["description"] == "two sections"
            @test paste["sections"] == [
                Dict("name" => "code", "syntax" => "julia", "contents" => "x = 1"),
                Dict("name" => "", "syntax" => "", "contents" => "notes")]
            @test JSON.parse(requests[end - 1].body)["expiration"] == "never"

            @test_throws HTTP.StatusError Pasteee.paste("wrong-appkey", "rejected")
        finally
            Pasteee.API_URL[] = default_url
            close(server)
        end
    end

    appkey = get(ENV, "PASTEEE_APPKEY", "")
    if isempty(appkey)
        @info "PASTEEE_APPKEY is not set; skipping tests against the live Paste.ee API."
    else
        @testset "live API" begin
            roundtrip(appkey)
        end
    end
end

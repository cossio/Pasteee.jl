module Pasteee

import HTTP
import JSON

"""
    Section(contents; name = "", syntax = "")

Creates a paste `Section` with `contents`.
The `syntax` argument determines syntax highlight.
"""
struct Section
    name::String
    syntax::String
    contents::String
    Section(contents::String; name::String = "", syntax::String = "") = new(name, syntax, contents)
end

dict(sec::Section) = Dict("name" => sec.name, "syntax" => sec.syntax, "contents" => sec.contents)

"""
    paste(appkey, sections; description = "", expiration = "never")

Submit a paste to Paste.ee and return its `id`.
The `sections` argument is either a `Vector` of [`Section`](@ref) objects,
or a single `Section` object.

The `expiration` setting can be set to `"never"` (default), or to a number of seconds given
as a `String` (e.g., `"3600"` for one hour).

See <https://pastee.github.io/docs/>.
"""
function paste(
    appkey::AbstractString,
    sections::AbstractVector{Section};
    description::AbstractString = "",
    #encrypted::Bool = false, # Not sure how this works
    expiration::AbstractString = "never"
)
    headers = ["X-Auth-Token" => appkey, "Content-Type" => "application/json"]
    data = Dict{String,Any}(
        "sections" => dict.(sections),
        "expiration" => expiration,
        "description" => description
    )
    # if encrypted
    #     data["encrypted"] = true
    # end
    response = HTTP.post("https://api.paste.ee/v1/pastes", headers, JSON.json(data))
    return JSON.parse(String(response.body))["id"]
end

paste(appkey::AbstractString, section::Section; kw...) = paste(appkey, [section]; kw...)

"""
    paste(appkey, contents::String; name = "", syntax = "", ...)

Paste a single section with `contents`, `name` and `syntax` given.
"""
function paste(
    appkey::AbstractString, contents::String;
    name::String = "",
    syntax::String = "",
    kwargs...
)
    paste(appkey, Section(contents; name, syntax); kwargs...)
end

"""
    delete(appkey, id)

Deletes paste `id` from Paste.ee.
"""
function delete(appkey::AbstractString, id::AbstractString)
    headers = ["X-Auth-Token" => appkey]
    HTTP.request("DELETE", "https://api.paste.ee/v1/pastes/$id", headers)
    return nothing
end

"""
    get(appkey, id)

Fetch paste `id` from Paste.ee.
"""
function get(appkey::AbstractString, id::AbstractString)
    headers = ["X-Auth-Token" => appkey]
    response = HTTP.get("https://api.paste.ee/v1/pastes/$id", headers)
    return JSON.parse(String(response.body))["paste"]
end

"""
    pastes(appkey; perpage = 25, page = 1)

Retrieve all pastes, organized in pages containing `perpage` entries.
Returns entries in page number `page`.
"""
function pastes(appkey::AbstractString; perpage::Int = 25, page::Int = 1)
    headers = ["X-Auth-Token" => appkey, "Content-Type" => "application/json"]
    data = Dict("perpage" => perpage, "page" => page)
    response = HTTP.get("https://api.paste.ee/v1/pastes", headers, JSON.json(data))
    return JSON.parse(String(response.body))
end

end # module

using Test: @test, @testset, @test_throws
import Pasteee
import HTTP

const appkey = ENV["PASTEEE_APPKEY"]

@testset "Pasteee" begin
    id = Pasteee.paste(appkey, "Batido de mamey"; expiration="3600")
    paste = Pasteee.get(appkey, id)
    @test paste["sections"][1]["contents"] == "Batido de mamey"

    Pasteee.delete(appkey, id)
    @test_throws HTTP.ExceptionRequest.StatusError Pasteee.get(appkey, id)

    pastes = Pasteee.pastes(appkey; perpage=12, page=2)
    @test pastes["current_page"] == 2
    @test pastes["per_page"] == 12
end

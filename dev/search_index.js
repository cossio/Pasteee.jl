var documenterSearchIndex = {"docs":
[{"location":"literate/examples/","page":"Examples","title":"Examples","text":"EditURL = \"https://github.com/cossio/Pasteee.jl/blob/master/docs/src/literate/examples.jl\"","category":"page"},{"location":"literate/examples/#Examples","page":"Examples","title":"Examples","text":"","category":"section"},{"location":"literate/examples/","page":"Examples","title":"Examples","text":"import Pasteee","category":"page"},{"location":"literate/examples/","page":"Examples","title":"Examples","text":"To access the Paste.ee API, you need an Application Key. You can create yours at the following link: https://paste.ee/account/api (after logging in to Paste.ee) In that page, first create an Application, then click ACTIONS -> AUTHORIZATION PAGE, and then SUBMIT. You will see the Application Key.","category":"page"},{"location":"literate/examples/","page":"Examples","title":"Examples","text":"# The following line and its output need to be hidden to avoid exposing the key.\nconst appkey = ENV[\"PASTEEE_APPKEY\"]; nothing #hide","category":"page"},{"location":"literate/examples/","page":"Examples","title":"Examples","text":"In the following examples I assume that you have assigned your Application Key to the appkey variable.","category":"page"},{"location":"literate/examples/","page":"Examples","title":"Examples","text":"Create a paste that expires in one hour.","category":"page"},{"location":"literate/examples/","page":"Examples","title":"Examples","text":"id = Pasteee.paste(appkey, \"Hola mundo\"; expiration=\"3600\")","category":"page"},{"location":"literate/examples/","page":"Examples","title":"Examples","text":"The paste can be retrieved using the returned id.","category":"page"},{"location":"literate/examples/","page":"Examples","title":"Examples","text":"paste = Pasteee.get(appkey, id)","category":"page"},{"location":"literate/examples/","page":"Examples","title":"Examples","text":"Paste.ee pastes are organized in sections. Here we retrieve the contents of section number 1 of the paste we just created.","category":"page"},{"location":"literate/examples/","page":"Examples","title":"Examples","text":"paste[\"sections\"][1][\"contents\"]","category":"page"},{"location":"literate/examples/","page":"Examples","title":"Examples","text":"Delete the paste.","category":"page"},{"location":"literate/examples/","page":"Examples","title":"Examples","text":"Pasteee.delete(appkey, id)","category":"page"},{"location":"literate/examples/","page":"Examples","title":"Examples","text":"","category":"page"},{"location":"literate/examples/","page":"Examples","title":"Examples","text":"This page was generated using Literate.jl.","category":"page"},{"location":"reference/#Reference","page":"Reference","title":"Reference","text":"","category":"section"},{"location":"reference/","page":"Reference","title":"Reference","text":"Modules = [Pasteee]","category":"page"},{"location":"reference/#Pasteee.Section","page":"Reference","title":"Pasteee.Section","text":"Section(contents; name = \"\", syntax = \"\")\n\nCreates a paste Section with contents. The syntax argument determines syntax highlight.\n\n\n\n\n\n","category":"type"},{"location":"reference/#Pasteee.delete-Tuple{AbstractString, AbstractString}","page":"Reference","title":"Pasteee.delete","text":"delete(appkey, id)\n\nDeletes paste id from Paste.ee.\n\n\n\n\n\n","category":"method"},{"location":"reference/#Pasteee.get-Tuple{AbstractString, AbstractString}","page":"Reference","title":"Pasteee.get","text":"get(appkey, id)\n\nFetch paste id from Paste.ee.\n\n\n\n\n\n","category":"method"},{"location":"reference/#Pasteee.paste-Tuple{AbstractString, AbstractVector{Pasteee.Section}}","page":"Reference","title":"Pasteee.paste","text":"paste(appkey, sections; description = \"\", expiration = \"never\")\n\nSubmit a paste to Paste.ee and return its id. The sections argument is either a Vector of Section objects, or a single Section object.\n\nThe expiration setting can be set to \"never\" (default), or to a number of seconds given as a String (e.g., \"3600\" for one hour).\n\nSee https://pastee.github.io/docs/.\n\n\n\n\n\n","category":"method"},{"location":"reference/#Pasteee.paste-Tuple{AbstractString, String}","page":"Reference","title":"Pasteee.paste","text":"paste(appkey, contents::String; name = \"\", syntax = \"\", ...)\n\nPaste a single section with contents, name and syntax given.\n\n\n\n\n\n","category":"method"},{"location":"reference/#Pasteee.pastes-Tuple{AbstractString}","page":"Reference","title":"Pasteee.pastes","text":"pastes(appkey; perpage = 25, page = 1)\n\nRetrieve all pastes, organized in pages containing perpage entries. Returns entries in page number page.\n\n\n\n\n\n","category":"method"},{"location":"#Pasteee.jl-Documentation","page":"Home","title":"Pasteee.jl Documentation","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"A Julia wrapper around the Paste.ee API.","category":"page"},{"location":"","page":"Home","title":"Home","text":"See https://pastee.github.io/docs/.","category":"page"},{"location":"#Installation","page":"Home","title":"Installation","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"This package is registered. Install with:","category":"page"},{"location":"","page":"Home","title":"Home","text":"import Pkg\nPkg.add(\"Pasteee\")","category":"page"},{"location":"","page":"Home","title":"Home","text":"The source code is hosted on Github: https://github.com/cossio/Pasteee.jl","category":"page"},{"location":"#Usage","page":"Home","title":"Usage","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"This package doesn't export any symbols. There are three main functions:","category":"page"},{"location":"","page":"Home","title":"Home","text":"Pasteee.paste to create a paste\nPasteee.get to retrieve a paste\nPasteee.delete to delete a paste","category":"page"},{"location":"","page":"Home","title":"Home","text":"See the Examples for usage help. See also the Reference section.","category":"page"}]
}

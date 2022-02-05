#=
# Examples
=#

import Pasteee

#=
To access the Pasteee API, you need an Application Key.
You can create yours at the following link:
<https://paste.ee/account/api>
(after logging in to [Paste.ee](https://paste.ee/))
In that page, first create an Application,
then click ACTIONS -> AUTHORIZATION PAGE, and then SUBMIT.
You will see the Application Key.
=#

#=
In the following examples I assume that you have assigned your
Application Key to the `KEY` variable.
=#

const KEY = ENV["PASTEEE_APPKEY"]; nothing #hide

# Create a paste that expires in one hour.

id = Pasteee.paste(KEY, "Hola mundo"; expiration="3600")

# The paste can be retrieved using the returned `id`.

paste = Pasteee.get(KEY, id)

# Paste.ee pastes are organized in sections.
# Here we retrieve the contents of section number 1 of the paste we just created.

paste["sections"][1]["contents"]

# Delete the paste.

Pasteee.delete(KEY, id)
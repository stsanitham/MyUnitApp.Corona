require( "Webservice.ServiceManager" )
local json = require("json")


 function Get_AllMyunitappdocument()
 	local List_array = {}

		response = Webservice.GET_ALL_MYUNITAPP_DOCUMENT()

		response = response.response.body

		response = json.decode(response)

		--print("GET_ALL_MYUNITAPP_DOCUMENT"..response[1].DocumentFileName)

		return response

end
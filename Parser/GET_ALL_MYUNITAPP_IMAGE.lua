require( "Webservice.ServiceManager" )
local json = require("json")


 function Get_AllMyunitappImage()
 	local List_array = {}

		response = Webservice.GET_ALL_MYUNITAPP_IMAGE()

		response = response.response.body

		response = json.decode(response)

		--print("GET_LIST_OF_RANKS"..response[1].ImageFileName)

		return response

end
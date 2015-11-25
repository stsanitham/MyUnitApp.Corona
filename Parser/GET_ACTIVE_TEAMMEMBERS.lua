

require( "Webservice.ServiceManager" )
local json = require("json")


function GetActiveTeammembers()
	local List_array = {}

	response = Webservice.GET_ACTIVE_TEAMMEMBERS()

	response = response.response.body

	response = json.decode(response)

		--print("GetActiveTeammembers"..response[1].Last_Name)

		return response

	end


	function GetActiveTeammemberDetails(contactId)

		local List_array = {}

		response = Webservice.GET_ACTIVE_TEAMMEMBERDETAILS(contactId)

		response = response.response.body

		--response = json.encode(response)

		--print("GetActiveTeammemberDetails "..response)


		response = json.decode(response)


		return response


	end
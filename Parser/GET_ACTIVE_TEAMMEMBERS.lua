

require( "Webservice.ServiceManager" )
local json = require("json")


function GetActiveTeammembers()
	local List_array = {}

	response = Webservice.GET_ACTIVE_TEAMMEMBERS()

	response = response.response.body

	response = json.decode(response)

		print("GetActiveTeammembers"..json.encode(response[1]))

		return response

	end


	function GetActiveTeammemberDetails(contactId)

		local List_array = {}

		response = Webservice.GET_ACTIVE_TEAMMEMBERDETAILS(contactId)

		response = response.response.body

		--response = json.encode(response)

		print("GetActiveTeammemberDetails "..json.encode(response))


		response = json.decode(response)


		return response


	end
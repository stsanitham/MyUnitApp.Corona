--GetSearchByUnitNumberOrDirectorName


require( "Webservice.ServiceManager" )
local json = require("json")


function GetSearchByUnitNumberOrDirectorName(search_value)
	local List_array = {}

	response = Webservice.GET_SEARCHBY_UnitNumberOrDirectorName(search_value)

	if response.response.body ~= nil then

	response = response.response.body

	response = json.decode(response)

	return response
	end
		

	end
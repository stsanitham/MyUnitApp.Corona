require( "Webservice.ServiceManager" )
local json = require("json")


 function GET_LIST_OF_RANKS()
 	local List_array = {}

		response = Webservice.GET_LIST_OF_RANKS()

		response = response.response.body

		response = json.decode(response)

		--print(#response)

		if response ~= nil then

		for i=1,#response do

			List_array[i] = {}
			List_array[i][1] = response[i].MkRankLevel
			List_array[i][2] = response[i].MkRankId

		end

		end


	return List_array
 end

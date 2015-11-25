require( "Webservice.ServiceManager" )

local json = require("json")


 function Get_MYUNITAPP_GOALS()

 	local response = 0

 	response = Webservice.GET_MYUNITAPP_GOALS()

	response = response.response.body

	response = json.decode(response)

 	--print("response"..response)
	
 	return response.MyUnitBuzzGoals
 end
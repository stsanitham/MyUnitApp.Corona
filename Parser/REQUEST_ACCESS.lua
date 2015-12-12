require( "Webservice.ServiceManager" )
local json = require("json")


 function REQUEST_ACCESS(Name,Email,Phone,UnitNumber,MKRank,Comment)

 	local response = 0

 	response = Webservice.REQUEST_ACCESS(Name,Email,Phone,UnitNumber,MKRank,Comment)

	response = response.response.body

	response = json.decode(response)

 	--print("response"..response)
	
 	return response
 end

  function LOGIN_ACCESS(UnitNumber,UserName,Password)

 	local response = 0

 	spinner_show()

 	response = Webservice.LOGIN_ACCESS(UnitNumber,UserName,Password)

	response = response.response.body

	response = json.decode(response)

	--response = response.RequestAccessStatus

	print(json.encode(response))

	spinner_hide()
 	return response
 end

  function FORGET_PASSWORD(UnitNumber,UserName)

 	local response = 0

 	spinner_show()

 	response = Webservice.Forget_Password(UnitNumber,UserName,Password)

	response = response.response.body

	response = json.decode(response)

	--response = response.RequestAccessStatus

	print("forget : "..json.encode(response))

	spinner_hide()
 	return response
 end
 

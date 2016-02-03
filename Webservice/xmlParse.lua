local network = require('network')
local json = require('json')
local Applicationconfig = require("Utils.ApplicationConfig")

local request = {}

local count ={}


local requestid

local function splitUrl( URL )
	return URL:gsub(ApplicationConfig.BASE_URL,"")	
end


function request.new(url, method, params,listner)

	
	print("enter "..url)


	if string.find(url,"/MyUnitBuzz/GetListOfMkRanks") or string.find(url,"/MyUnitBuzz/MyUnitBuzzRequestAccess") or string.find(url,"/MyUnitBuzz/SaveMyUnitBuzzMessages") then

		spinner_hide()

	else

		spinner_show()

	end

	requestId = network.request( url, method, function(event)  if ( event.isError ) then

		print( "Network error!" )

	else
		
		print ( "RESPONSE: " .. event.response )

		response = json.decode(event.response)


		spinner_hide()

		listner(response)


		end end, params )


	--[[if(url:sub(1,string.find(url,"?")-1) == "http://api.myunitapp.dotnetethic.com/MyUnitBuzz/GetSearchByUnitNumberOrDirectorName") then

		

	end]]


end

return request
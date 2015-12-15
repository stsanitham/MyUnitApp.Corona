local network = require('network')
local json = require('json')

local request = {}

local count ={}


local requestid

function request.new(url, method, params,listner)

	spinner_show()
	
	
	print("enter "..url)

	

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
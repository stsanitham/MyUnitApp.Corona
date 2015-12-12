local network = require('network')
local json = require('json')

local request = {}

local function networkListener( event )


end

local requestid

function request.new(url, method, params,listner)

	spinner_show()
	
	

	print("enter "..url)

	network.cancel( requestid )
	
	requestid = network.request( url, method, function(event)  if ( event.isError ) then

		print( "Network error!" )

	else
		
		print ( "RESPONSE: " .. event.response )

		response = json.decode(event.response)


		spinner_hide()

		listner(response)


		end end, params )


end

return request
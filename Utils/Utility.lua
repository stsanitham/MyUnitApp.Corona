
Utils = {}

Utils.convertHexToRGB = function(hexCode)
   assert(#hexCode == 7, "The hex value must be passed in the form of #XXXXXX");
   local hexCode = hexCode:gsub("#","")
   return tonumber("0x"..hexCode:sub(1,2))/255,tonumber("0x"..hexCode:sub(3,4))/255,tonumber("0x"..hexCode:sub(5,6))/255;
   
end


Utils.emailValidation = function(email)
	if (email:match("[A-Za-z0-9%.%%%+%-]+@[A-Za-z0-9%.%%%+%-]+%.%w%w%w?%w?")) then
	   return true
	else
	    return false                
	end
end

Utils.getIpAddress = function ( )
		local someRandomIP = "192.168.1.122" 
		local someRandomPort = "3102" 
		local mySocket = socket.udp() 
		mySocket:setpeername(someRandomIP,someRandomPort) 
		local myDevicesIpAddress, somePortChosenByTheOS = mySocket:getsockname()
 
		print(myDevicesIpAddress,somePortChosenByTheOS)

		return myDevicesIpAddress
end


return Utils

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


Utils.SnackBar = function ( snackString )

print("snack")

local function SnackFun( event )

	timer.cancel(event.source);event.source = nil

	for i=1,snackGroup.numChildren do
		if snackGroup[snackGroup.numChildren] then snackGroup[snackGroup.numChildren]:removeSelf();snackGroup[snackGroup.numChildren]=nil end
	end
end

for i=1,snackGroup.numChildren do

	if snackGroup[snackGroup.numChildren] then snackGroup[snackGroup.numChildren]:removeSelf();snackGroup[snackGroup.numChildren]=nil end

end


SnankBg = display.newRect(snackGroup,display.contentWidth/2,display.contentHeight,display.contentWidth,35)
SnankBg.y =display.contentHeight-SnankBg.contentHeight/2
SnankBg:setFillColor(0,0,0,0.5)

SnankText = display.newText(snackGroup,snackString,0,0,native.systemFontBold,SnackBar.textSize)
SnankText.x=SnankBg.x;SnankText.y=SnankBg.y
SnankText:setFillColor(Utils.convertHexToRGB(SnackBar.textColor))

snackGroup:toFront()

SnackTimer = timer.performWithDelay(3000, SnackFun )


end

Utils.makeTimeStamp = function ( dateString )

	local pattern = "(%d+)%-(%d+)%-(%d+)T(%d+):(%d+):(%d+)"
	local year, month, day, hour, minute, seconds, tzoffset, offsethour, offsetmin =
	dateString:match(pattern)
	local timestamp = os.time( {year=year, month=month, day=day, hour=hour, min=minute, sec=seconds, isdst=false} )

	return timestamp;
end

Utils.GetMonth = function ( monthString)

monthString = monthString:lower()

if monthString == "jan" then monthString = Month[monthString] end



return monthString
end

Utils.CssforTextView = function ( Object,Style )

if Style.Font_Family then Object.font = Style.Font_Family end
if Style.Font_Size_ios then Object.fontSize = Style.Font_Size_ios end
if Style.Text_Color then Object:setFillColor( Utils.convertHexToRGB( Style.Text_Color ))  end

--if Style.Font_Weight then Object:setFillColor( Utils.convertHexToRGB( Style.Text_Color ))  end

--if Style.Text_Alignment then Object.align = Style.Text_Alignment   end


end

Utils.CssforTextField= function ( Object,Style )

if Style.Font_Family then Object.font = Style.Font_Family end
if Style.Font_Size_ios then Object.fontSize = Style.Font_Size_ios end
--if Style.Text_Alignment then Object.align = Style.Text_Alignment   end


end



return Utils
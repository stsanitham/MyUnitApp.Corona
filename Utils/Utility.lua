

Utils = {}
function doesFileExist( fname, path )

    local results = false

    local filePath = system.pathForFile( fname, path )

    --filePath will be 'nil' if file doesn't exist and the path is 'system.ResourceDirectory'
    if ( filePath ) then
        filePath = io.open( filePath, "r" )
    end

    if ( filePath ) then
        print( "File found: " .. fname )
        --clean up file handles
        filePath:close()
        results = true
    else
        print( "File does not exist: " .. fname )
    end

    return results
end

Utils.copyDatabaseTo = function( srcName, srcPath, dstName, dstPath, overwrite)
      local results = false

    local srcPath = doesFileExist( srcName, srcPath )

    if ( srcPath == false ) then
        return nil  -- nil = source file not found
    end

    --check to see if destination file already exists
    if not ( overwrite ) then
        if ( doesFileExist( dstName, dstPath ) ) then
            return 1  -- 1 = file already exists (don't overwrite)
        end
    end

    --copy the source file to the destination file
    local rfilePath = system.pathForFile( srcName, srcPath )
    local wfilePath = system.pathForFile( dstName, dstPath )

    local rfh = io.open( rfilePath, "rb" )
    local wfh = io.open( wfilePath, "wb" )

    if not ( wfh ) then
        print( "writeFileName open error!" )
        return false
    else
        --read the file from 'system.ResourceDirectory' and write to the destination directory
        local data = rfh:read( "*a" )
        if not ( data ) then
            print( "read error!" )
            return false
        else
            if not ( wfh:write( data ) ) then
                print( "write error!" )
                return false
            end
        end
    end

    results = 2  -- 2 = file copied successfully!

    --clean up file handles
    rfh:close()
    wfh:close()

    return results
end

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

SnackTimer = timer.performWithDelay(800, SnackFun )


end

Utils.PhoneMasking = function ( value )

print(value)

    if string.find( value,"%(" ) then
        value=string.gsub(value,"%(","")
    end
    if string.find( value," " ) ~= nil then
        value=string.gsub(value," ","")
    end
    if string.find( value,"%)" ) ~= nil then
        value=string.gsub(value,"%)","")
    end
    if string.find( value,"%-" ) ~= nil then
        value=string.gsub(value,"%-","")
    end

            if value:len() >= 10 then

                 value = value:sub(1,10)

            end

    print( "length : "..value:len())

    if value:len() == 1  or value:len() == 2 then

    elseif value:len() == 3 then

        value = "("..value

    elseif value:len() == 4 then

         value = "("..value:sub( 1, 3 )..") "..value:sub( 4,4 )

    elseif value:len() == 5 then

         value = "("..value:sub( 1, 3 )..") "..value:sub( 4,5 )

    elseif value:len() == 6 then

         value = "("..value:sub( 1, 3 )..") "..value:sub( 4,6 )

    elseif value:len() == 7 then

         value = "("..value:sub( 1, 3 )..") "..value:sub( 4,6 ).."-"..value:sub( 7,7)

     elseif value:len() == 8 then

         value = "("..value:sub( 1, 3 )..") "..value:sub( 4,6 ).."-"..value:sub( 7,8)

     elseif value:len() == 9 then

         value = "("..value:sub( 1, 3 )..") "..value:sub( 4,6 ).."-"..value:sub( 7,9)

     elseif value:len() == 10 then

         value = "("..value:sub( 1, 3 )..") "..value:sub( 4,6 ).."-"..value:sub( 7,10)


    end


return value
end

Utils.makeTimeStamp = function ( dateString )

	local pattern = "(%d+)%-(%d+)%-(%d+)T(%d+):(%d+):(%d+)"
	local year, month, day, hour, minute, seconds =
	dateString:match(pattern)
	local timestamp = os.time( {year=year, month=month, day=day, hour=hour, min=minute, sec=seconds, isdst=false} )

	return timestamp;
end

Utils.GetMonth = function ( monthString)

monthString = monthString:lower()

monthString = Month[monthString]



return monthString
end


Utils.GetWeek = function ( weekString)

weekString = weekString:lower()

 weekString = Week[weekString] 



return weekString
end

Utils.getTime = function(time,format,TimeZone)
function format_time(timestamp, format, tzoffset, tzname)
   if tzoffset == "local" then  -- calculate local time zone (for the server)
      local now = os.time()
      local local_t = os.date("*t", now)
      local utc_t = os.date("!*t", now)
      local delta = (local_t.hour - utc_t.hour)*60 + (local_t.min - utc_t.min)
      local h, m = math.modf( delta / 60)
      tzoffset = string.format("%+.4d", 100 * h + 60 * m)
   end
   tzoffset = tzoffset or "GMT"
   format = format:gsub("%%z", tzname or tzoffset)
   if tzoffset == "GMT" then
      tzoffset = "+0000"
   end
   tzoffset = tzoffset:gsub(":", "")

   local sign = 1
   if tzoffset:sub(1,1) == "-" then
      sign = -1
      tzoffset = tzoffset:sub(2)
   elseif tzoffset:sub(1,1) == "+" then
      tzoffset = tzoffset:sub(2)
   end
   tzoffset = sign * (tonumber(tzoffset:sub(1,2))*60 +
tonumber(tzoffset:sub(3,4)))*60
   return os.date(format, timestamp + tzoffset)
end

local tzoffset
        if TimeZone == "Eastern Standard Time" then
            tzoffset = "-04:00"

        elseif TimeZone == "Hawaiian Standard Time" then
             tzoffset = "-10:00"

        elseif TimeZone == "Alaskan Standard Time" then
             tzoffset = "-09:00"

        elseif TimeZone == "Mountain Standard Time" then
             tzoffset = "-06:00"

        elseif TimeZone == "Pacific Standard Time" then
             tzoffset = "-07:00"

        elseif TimeZone == "Central Standard Time" then
             tzoffset = "-05:00"

        elseif TimeZone == "US Mountain Standard Time" then
             tzoffset = "-06:00"
        else
            tzoffset = "local"
        end

return format_time(time,format,tzoffset,"")


end


Utils.CssforTextView = function ( Object,Style )

if Style.Font_Family then Object.font = Style.Font_Family end
if Style.Font_Size_ios then Object.fontSize = Style.Font_Size_ios end
if Style.Text_Color then Object:setFillColor( Utils.convertHexToRGB( Style.Text_Color ))  end

--if Style.Font_Weight then Object:setFillColor( Utils.convertHexToRGB( Style.Text_Color ))  end

--if Style.Text_Alignment then Object.align = Style.Text_Alignment   end


end

Utils.encrypt = function ( value )

-- local encryptedData = mime.b64 ( cipher:encrypt ( value, "MUB" ) )

--local encryptedData = mime.b64 ( cipher:encrypt ( value, "MUB" ) )

return value
end



Utils.decrypt = function ( value )

-- local decryptedData = cipher:decrypt ( mime.unb64 ( value ), "MUB" )

--local decryptedData = cipher:decrypt ( mime.unb64 ( value ), "MUB" )

return value
end


Utils.CssforTextField= function ( Object,Style )

if Style.Font_Family then Object.font = Style.Font_Family end
if Style.Font_Size_ios then Object.fontSize = Style.Font_Size_ios end
--if Style.Text_Alignment then Object.align = Style.Text_Alignment   end

end



return Utils

local request = require('Webservice.xmlParse')
local Applicationconfig = require("Utils.ApplicationConfig")
local Utility = require("Utils.Utility")
Webservice = {}
require("socket")
local json = require("json")
local crypto = require("crypto")
local mime = require("mime")
local http = require("socket.http")
local path = system.pathForFile( "MyUnitBuzz.db", system.DocumentsDirectory )
local db = sqlite3.open( path )


local function splitUrl( URL )

	local Url

	if IsLive then

		Url = ApplicationConfig.Version..URL:gsub(ApplicationConfig.BASE_URL,"")

	else
		Url = URL:gsub(ApplicationConfig.BASE_URL,"")	

	end


	return Url
end
local function check(value)
	if value == nil then
		value=""
	else
	end
return value
end


function string.urlEncode( str )
	if ( str ) then
		str = string.gsub( str, "\n", "\r\n" )
		str = string.gsub( str, "([^%w ])",
			function (c) return string.format( "%%%02X", string.byte(c) ) end )
		str = string.gsub( str, " ", "+" )
	end
	return str
end


function Webservice.GET_LIST_OF_RANKS(postExecution)


	local request_value = {}
	local params = {}
	local headers = {}
	headers["Timestamp"] = os.date("!%A, %B %d, %Y %I:%M:%S %p")
	headers["IpAddress"] = Utility.getIpAddress()
	headers["UniqueId"] = system.getInfo("deviceID")
	headers["Accept"] = "application/json"
	headers["Content-Type"] = "application/json"

	headers["UserAuthorization"]= ""

	
	method="GET"

	local canonicalizedHeaderString

	local url = splitUrl(ApplicationConfig.GET_LIST_OF_RANKS)

--	print("Url : "..url)



		canonicalizedHeaderString = tostring(method .. "\n".. headers["Timestamp"] .. "\n"..url:lower())

	
	authenticationkey = ApplicationConfig.API_PUBLIC_KEY..":"..mime.b64(crypto.hmac( crypto.sha256,canonicalizedHeaderString,ApplicationConfig.API_PRIVATE_KEY,true))
	headers["Authentication"] = authenticationkey

--	print("time : "..headers["Timestamp"])

	resbody =  "?languageId=1&countryId=1&"

	request_value.url=ApplicationConfig.GET_LIST_OF_RANKS..resbody
	request_value.headers = headers
	request_value.method = method
	--response = M.xmlParser( request_value)
	params={headers = headers}

	request.new( ApplicationConfig.GET_LIST_OF_RANKS..resbody,method,params,postExecution)

	return 
end


function Webservice.REQUEST_ACCESS(requestFromStatus,directorName,directorEmail,firstName,lastName,Email,Phone,UnitNumber,MKRank,Comment,postExecution)

	local request_value = {}
	local params = {}
	local headers = {}
	headers["Timestamp"] = os.date("!%A, %B %d, %Y %I:%M:%S %p")
	headers["IpAddress"] = Utility.getIpAddress()
	headers["UniqueId"] = system.getInfo("deviceID")
	headers["Accept"] = "application/json"
	headers["Content-Type"] = "application/json"

	headers["UserAuthorization"]= ""

	
	method="POST"

	local url = splitUrl(ApplicationConfig.REQUEST_ACCESS)
	local canonicalizedHeaderString = tostring(method .. "\n".. headers["Timestamp"] .. "\n"..url:lower())
	authenticationkey = ApplicationConfig.API_PUBLIC_KEY..":"..mime.b64(crypto.hmac( crypto.sha256,canonicalizedHeaderString,ApplicationConfig.API_PRIVATE_KEY,true))
	headers["Authentication"] = authenticationkey

local v = 

[[{

  "FirstName": "]]..firstName..[[",
  "LastName": "]]..lastName..[[",
  "EmailAddress": "]]..Email..[[",
  "PhoneNumber": "]]..Phone..[[",
  "Comments": "]]..Comment..[[",
  "UnitNumber": "]]..UnitNumber..[[",
  "DirectorName": "]]..directorName..[[",
  "RequestAccessStatus": "]]..requestFromStatus..[[",
  "DirectorEmailAddress": "]]..directorEmail..[[",
  "MkRankId": "]]..MKRank..[[",
  "TypeLanguageCountry": {
    "LanguageId": 1,
    "CountryId": 1,
  },
}]]

	--headers["Content-Type"] = "application/x-www-form-urlencoded"
	--headers["Content-Length"]= string.len(v)

	params={headers = headers,body = v}


	print("Send Message Request :"..json.encode(params))

	request.new( ApplicationConfig.REQUEST_ACCESS,method,params,postExecution)
	

	return response

end





function Webservice.SEND_MESSAGE(message,videopath,imagepath,imagename,imagesize,pushmethod,postExecution)

	local request_value = {}
	local params = {}
	local headers = {}
	headers["Timestamp"] = os.date("!%A, %B %d, %Y %I:%M:%S %p")
	headers["IpAddress"] = Utility.getIpAddress()
	headers["UniqueId"] = system.getInfo("deviceID")
	headers["Accept"] = "application/json"
	headers["Content-Type"] = "application/json"
	
	method="POST"

	local url = splitUrl(ApplicationConfig.SEND_MESSAGE)
	local canonicalizedHeaderString = tostring(method .. "\n".. headers["Timestamp"] .. "\n"..url:lower())
	authenticationkey = ApplicationConfig.API_PUBLIC_KEY..":"..mime.b64(crypto.hmac( crypto.sha256,canonicalizedHeaderString,ApplicationConfig.API_PRIVATE_KEY,true))
	headers["Authentication"] = authenticationkey

	--headers["Authentication"] = "Or2tf5TjnfLObg5qZ1VfLOd:7jzSWXG+0oRq9skt1lNESuiZcTSQLVurPn3eZaqMk84="


	for row in db:nrows("SELECT * FROM logindetails WHERE id=1") do
		print("UserId :"..row.UserId)
		UserId = row.UserId
		AccessToken = row.AccessToken
		ContactId = row.ContactId
		EmailAddess = row.EmailAddess

	end

	headers["UserAuthorization"]= UserId..":"..AccessToken..":"..ContactId

	--local v = "MyUnitBuzzMessageId=1&MyUnitBuzzMessage="..message.."&MessageStatus="..pushmethod.."&UserId="..UserId.."&EmailAddress="..EmailAddess.."&MessageDate="..headers["Timestamp"].."&TimeZone=Eastern Standard Time"
--02/02/2016 9:21:48 PM
--local time = os.date("%I")


-- if message ~="" then

-- 	v = v.."MyUnitBuzzMessage": "]]..message..[["
local v = [[

{
  "MyUnitBuzzMessage": "]]..message..[[",
  "VideoFilePath": "]]..videopath..[[",
  "MessageStatus": "]]..pushmethod..[[",
  "MessageDate": "]]..os.date("%m/%d/%Y %I:%M:%S %p")..[[",
   "UserId": "]]..UserId..[[",
   "EmailAddress": "]]..EmailAddess..[[",
	"ImageFilePath": "]]..imagepath..[[",
	 "ImageFileName": "]]..imagename..[[",
	  "ImageFileSize": "]]..imagesize..[[",
   "TimeZone": "Eastern Standard Time",
}
]]


	params={headers = headers,body = v}

	print("Send Message Request :"..json.encode(params))

	request.new( ApplicationConfig.SEND_MESSAGE,method,params,postExecution)
	
	return response

end




function Webservice.DOCUMENT_UPLOAD(file_inbytearray,filename,filetype,postExecution)

	local request_value = {}
	local params = {}
	local headers = {}
	headers["Timestamp"] = os.date("!%A, %B %d, %Y %I:%M:%S %p")
	headers["IpAddress"] = Utility.getIpAddress()
	headers["UniqueId"] = system.getInfo("deviceID")
	headers["Accept"] = "application/json"
	headers["Content-Type"] = "application/json"
	
	method="POST"

	local url = splitUrl(ApplicationConfig.DOCUMENT_UPLOAD)
	local canonicalizedHeaderString = tostring(method .. "\n".. headers["Timestamp"] .. "\n"..url:lower())
	authenticationkey = ApplicationConfig.API_PUBLIC_KEY..":"..mime.b64(crypto.hmac( crypto.sha256,canonicalizedHeaderString,ApplicationConfig.API_PRIVATE_KEY,true))
	headers["Authentication"] = authenticationkey


	for row in db:nrows("SELECT * FROM logindetails WHERE id=1") do
		print("UserId :"..row.UserId)
		UserId = row.UserId
		AccessToken = row.AccessToken
		ContactId = row.ContactId
		EmailAddess = row.EmailAddess

	end

	headers["UserAuthorization"]= UserId..":"..AccessToken..":"..ContactId

local v = [[

{
  "UserId": "]]..UserId..[[",
  "File": "]]..file_inbytearray..[[",
  "FileName": "]]..filename..[[",
  "FileType": "]]..filetype..[[",
}
]]

 -- "IsOverwrite": "true",
 --  "IsResize": "true",

	params={headers = headers,body = v}

	print("Send Message Request :"..json.encode(params))

	request.new( ApplicationConfig.DOCUMENT_UPLOAD,method,params,postExecution)
	
	return response

end





function Webservice.LOGIN_ACCESS(Device_OS,Unique_Id,Model,Version,GCM,UnitNumber,UserName,Password,postExecution)

	local request_value = {}
	local params = {}
	local headers = {}
	headers["Timestamp"] = os.date("!%A, %B %d, %Y %I:%M:%S %p")
	headers["IpAddress"] = Utility.getIpAddress()
	headers["UniqueId"] = system.getInfo("deviceID")
	headers["Accept"] = "application/json"
	headers["UserAuthorization"]= ""
	headers["Content-Type"] = "application/json"
	method="POST"

	local url = splitUrl(ApplicationConfig.LOGIN_ACCESS)
	local canonicalizedHeaderString = tostring(method .. "\n".. headers["Timestamp"] .. "\n"..url:lower())
	authenticationkey = ApplicationConfig.API_PUBLIC_KEY..":"..mime.b64(crypto.hmac( crypto.sha256,canonicalizedHeaderString,ApplicationConfig.API_PRIVATE_KEY,true))
	headers["Authentication"] = authenticationkey



Version="1.1.0"

local resbody =
[[
{
	"EmailAddress": "]] .. UserName .. [[",
	"Password": "]] .. Password .. [[",
	"UnitNumber": "]] .. UnitNumber .. [[",

	"MobDevice":
	{
		"DOS": "]] .. Device_OS .. [[",
		"UQId": "]] .. Unique_Id .. [[",
		"MOD": "]] .. Model .. [[",
		"DN": "]] .. Model .. [[",
		"Ver": "]] .. Version .. [[",
		"GCMUQId": "]] .. GCM .. [[",
		
	},
}
]]



	--local resbody = "EmailAddress="..string.urlEncode(UserName).."&Password="..string.urlEncode(Password).."&UnitNumber="..UnitNumber.."&MobDevice="..pushInfo


	--headers["Content-Type"] = "application/x-www-form-urlencoded"
	--headers["Content-Length"]= string.len(resbody)


	params={headers = headers,body = resbody}



	print("url :"..resbody)
	
	request.new( ApplicationConfig.LOGIN_ACCESS,method,params,postExecution)

	return response

end

function Webservice.Forget_Password(UnitNumber,UserName,postExecution)

	local request_value = {}
	local params = {}
	local headers = {}
	headers["Timestamp"] = os.date("!%A, %B %d, %Y %I:%M:%S %p")
	headers["IpAddress"] = Utility.getIpAddress()
	headers["UniqueId"] = system.getInfo("deviceID")
	headers["Accept"] = "application/json"
	headers["UserAuthorization"]= ""
	headers["Content-Type"] = "application/json"
	method="POST"

	local url = splitUrl(ApplicationConfig.ForgotPassword)
	local canonicalizedHeaderString = tostring(method .. "\n".. headers["Timestamp"] .. "\n"..url:lower())
	authenticationkey = ApplicationConfig.API_PUBLIC_KEY..":"..mime.b64(crypto.hmac( crypto.sha256,canonicalizedHeaderString,ApplicationConfig.API_PRIVATE_KEY,true))
	headers["Authentication"] = authenticationkey

	local country = {}

	country="LanguageId=1&CountryId=1"

	local resbody = "EmailAddress="..string.urlEncode(UserName).."&UnitNumber="..string.urlEncode(UnitNumber).."&TypeLanguageCountry="..country

	headers["Content-Type"] = "application/x-www-form-urlencoded"
	headers["Content-Length"]= string.len(resbody)


	params={headers = headers,body = resbody}

	print("url :"..json.encode(params))

	request.new( ApplicationConfig.ForgotPassword,method,params,postExecution)


	return response

end




function Webservice.GET_ALL_MYUNITAPP_IMAGE(postExecution)
	local request_value = {}
	local params = {}
	local headers = {}
	headers["Timestamp"] = os.date("!%A, %B %d, %Y %I:%M:%S %p")
	headers["IpAddress"] = Utility.getIpAddress()
	headers["UniqueId"] = system.getInfo("deviceID")
	headers["Accept"] = "application/json"
	headers["Content-Type"] = "application/json"
	method="GET"

	local url = splitUrl(ApplicationConfig.GetAllMyUnitAppImage)
	local canonicalizedHeaderString = tostring(method .. "\n".. headers["Timestamp"] .. "\n"..url:lower())
	authenticationkey = ApplicationConfig.API_PUBLIC_KEY..":"..mime.b64(crypto.hmac( crypto.sha256,canonicalizedHeaderString,ApplicationConfig.API_PRIVATE_KEY,true))
	headers["Authentication"] = authenticationkey

	for row in db:nrows("SELECT * FROM logindetails WHERE id=1") do
		print("UserId :"..row.UserId)
		UserId = row.UserId
		AccessToken = row.AccessToken
		ContactId = row.ContactId

	end

	

	headers["UserAuthorization"]= UserId..":"..AccessToken..":"..ContactId

	local resbody = "userid="..string.urlEncode(UserId)


	params={headers = headers}

	request.new( ApplicationConfig.GetAllMyUnitAppImage.."?"..resbody,method,params,postExecution)

	return response
end



function Webservice.GET_ALL_MYUNITAPP_DOCUMENT(postExecution)
	local request_value = {}
	local params = {}
	local headers = {}
	headers["Timestamp"] = os.date("!%A, %B %d, %Y %I:%M:%S %p")
	headers["IpAddress"] = Utility.getIpAddress()
	headers["UniqueId"] = system.getInfo("deviceID")
	headers["Accept"] = "application/json"
	headers["Content-Type"] = "application/json"
	method="GET"

	local url = splitUrl(ApplicationConfig.GetAllMyUnitAppDocument)
	local canonicalizedHeaderString = tostring(method .. "\n".. headers["Timestamp"] .. "\n"..url:lower())
	authenticationkey = ApplicationConfig.API_PUBLIC_KEY..":"..mime.b64(crypto.hmac( crypto.sha256,canonicalizedHeaderString,ApplicationConfig.API_PRIVATE_KEY,true))
	headers["Authentication"] = authenticationkey

	for row in db:nrows("SELECT * FROM logindetails WHERE id=1") do
		print("UserId :"..row.UserId)
		UserId = row.UserId
		AccessToken = row.AccessToken
		ContactId = row.ContactId

	end

	headers["UserAuthorization"]= UserId..":"..AccessToken..":"..ContactId
	
	local resbody = "userid="..string.urlEncode(UserId)

	params={headers = headers}

	request.new(ApplicationConfig.GetAllMyUnitAppDocument.."?"..resbody,method,params,postExecution)

	return response
end




function Webservice.GET_ACTIVE_TEAMMEMBERS(postExecution)
	local request_value = {}
	local params = {}
	local headers = {}
	headers["Timestamp"] = os.date("!%A, %B %d, %Y %I:%M:%S %p")
	headers["IpAddress"] = Utility.getIpAddress()
	headers["UniqueId"] = system.getInfo("deviceID")
	headers["Accept"] = "application/json"
	headers["Content-Type"] = "application/json"
	method="GET"

	local url = splitUrl(ApplicationConfig.GetActiveTeammembers)
	local canonicalizedHeaderString = tostring(method .. "\n".. headers["Timestamp"] .. "\n"..url:lower())
	authenticationkey = ApplicationConfig.API_PUBLIC_KEY..":"..mime.b64(crypto.hmac( crypto.sha256,canonicalizedHeaderString,ApplicationConfig.API_PRIVATE_KEY,true))
	headers["Authentication"] = authenticationkey

	for row in db:nrows("SELECT * FROM logindetails WHERE id=1") do
		print("UserId :"..row.UserId)
		UserId = row.UserId
		AccessToken = row.AccessToken
		ContactId = row.ContactId
	end

	
	headers["UserAuthorization"]= UserId..":"..AccessToken..":"..ContactId
	
	local resbody = "userid="..string.urlEncode(UserId)


	params={headers = headers}

	request.new(ApplicationConfig.GetActiveTeammembers.."?"..resbody,method,params,postExecution)
	


	return response
end



function Webservice.GET_ACTIVE_TEAMMEMBERDETAILS(contactId,postExecution)
	local request_value = {}
	local params = {}
	local headers = {}
	headers["Timestamp"] = os.date("!%A, %B %d, %Y %I:%M:%S %p")
	headers["IpAddress"] = Utility.getIpAddress()
	headers["UniqueId"] = system.getInfo("deviceID")
	headers["Accept"] = "application/json"
	headers["Content-Type"] = "application/json"
	method="GET"

	local url = splitUrl(ApplicationConfig.GetActiveTeammemberDetails)
	local canonicalizedHeaderString = tostring(method .. "\n".. headers["Timestamp"] .. "\n"..url:lower())
	authenticationkey = ApplicationConfig.API_PUBLIC_KEY..":"..mime.b64(crypto.hmac( crypto.sha256,canonicalizedHeaderString,ApplicationConfig.API_PRIVATE_KEY,true))
	headers["Authentication"] = authenticationkey

	for row in db:nrows("SELECT * FROM logindetails WHERE id=1") do
		print("UserId :"..row.UserId)
		UserId = row.UserId
		AccessToken = row.AccessToken
		ContactId = row.ContactId

	end

	headers["UserAuthorization"]= UserId..":"..AccessToken..":"..ContactId
	

	local resbody = "contactId="..contactId


	params={headers = headers}

	request.new(ApplicationConfig.GetActiveTeammemberDetails.."?"..resbody,method,params,postExecution)
	
	return response
end



function Webservice.GET_MYUNITAPP_GOALS(postExecution)
	local request_value = {}
	local params = {}
	local headers = {}
	headers["Timestamp"] = os.date("!%A, %B %d, %Y %I:%M:%S %p")
	headers["IpAddress"] = Utility.getIpAddress()
	headers["UniqueId"] = system.getInfo("deviceID")
	headers["Accept"] = "application/json"
	headers["Content-Type"] = "application/json"
	method="GET"

	local url = splitUrl(ApplicationConfig.GetMyUnitAppGoals)
	local canonicalizedHeaderString = tostring(method .. "\n".. headers["Timestamp"] .. "\n"..url:lower())
	authenticationkey = ApplicationConfig.API_PUBLIC_KEY..":"..mime.b64(crypto.hmac( crypto.sha256,canonicalizedHeaderString,ApplicationConfig.API_PRIVATE_KEY,true))
	headers["Authentication"] = authenticationkey


	for row in db:nrows("SELECT * FROM logindetails WHERE id=1") do
		print("UserId :"..row.UserId)
		UserId = row.UserId
		UserId = row.UserId
		AccessToken = row.AccessToken
		ContactId = row.ContactId

	end

	headers["UserAuthorization"]= UserId..":"..AccessToken..":"..ContactId
	local resbody = "userid="..UserId


	params={headers = headers}

	request.new(ApplicationConfig.GetMyUnitAppGoals.."?"..resbody,method,params,postExecution)
	
	return response
end



function Webservice.Get_All_MyCalendars(postExecution)


local request_value = {}
local params = {}
local headers = {}
headers["Timestamp"] = os.date("!%A, %B %d, %Y %I:%M:%S %p")
headers["IpAddress"] = Utility.getIpAddress()
headers["UniqueId"] = system.getInfo("deviceID")
headers["Accept"] = "application/json"

headers["Content-Type"] = "application/json"
method="GET"

local url = splitUrl(ApplicationConfig.GetAllMyCalendars)
local canonicalizedHeaderString = tostring(method .. "\n".. headers["Timestamp"] .. "\n"..url:lower())
authenticationkey = ApplicationConfig.API_PUBLIC_KEY..":"..mime.b64(crypto.hmac( crypto.sha256,canonicalizedHeaderString,ApplicationConfig.API_PRIVATE_KEY,true))
headers["Authentication"] = authenticationkey


for row in db:nrows("SELECT * FROM logindetails WHERE id=1") do
	print("UserId :"..row.UserId)
	UserId = row.UserId
	AccessToken = row.AccessToken
	ContactId = row.ContactId

end


headers["UserAuthorization"]= UserId..":"..AccessToken..":"..ContactId

local resbody = "userid="..string.urlEncode(UserId)


	params={headers = headers}

	request.new(ApplicationConfig.GetAllMyCalendars.."?"..resbody,method,params,postExecution)
	
return response
end


function Webservice.Get_TicklerEvents(CalendarId,UserId,startdate,enddate,IsShowAppointment,IsShowCall,IsShowParty,IsShowTask,IsShowFamilyTime,IsPublic,postExecution)
local request_value = {}
local params = {}
local headers = {}
headers["Timestamp"] = os.date("!%A, %B %d, %Y %I:%M:%S %p")
headers["IpAddress"] = Utility.getIpAddress()
headers["UniqueId"] = system.getInfo("deviceID")
headers["Accept"] = "application/json"
--headers["Content-Type"] = "application/json"
method="POST"

for row in db:nrows("SELECT * FROM logindetails WHERE id=1") do
	print("UserId :"..row.UserId)
	UserId = row.UserId
	AccessToken = row.AccessToken
	ContactId = row.ContactId

end

headers["UserAuthorization"]= UserId..":"..AccessToken..":"..ContactId

local url = splitUrl(ApplicationConfig.GetTicklerEvents)
local canonicalizedHeaderString = tostring(method .. "\n".. headers["Timestamp"] .. "\n"..url:lower())
authenticationkey = ApplicationConfig.API_PUBLIC_KEY..":"..mime.b64(crypto.hmac( crypto.sha256,canonicalizedHeaderString,ApplicationConfig.API_PRIVATE_KEY,true))
headers["Authentication"] = authenticationkey

local resbody = ""
resbody = resbody.."CalendarId="..CalendarId.."&"
resbody = resbody.."UserId="..UserId.."&"
resbody = resbody.."startdate="..startdate.."&"
resbody = resbody.."enddate="..enddate.."&"
resbody = resbody.."IsShowAppointment="..IsShowAppointment.."&"
resbody = resbody.."IsShowCall="..IsShowCall.."&"
resbody = resbody.."IsShowParty="..IsShowParty.."&"
resbody = resbody.."IsShowTask="..IsShowTask.."&"
resbody = resbody.."IsShowFamilyTime="..IsShowFamilyTime.."&"
resbody = resbody.."IsPublic="..IsPublic




	headers["Content-Type"] = "application/x-www-form-urlencoded"
	headers["Content-Length"]= string.len(resbody)


	params={headers = headers,body=resbody}

	print("Request :"..json.encode(params))

	request.new(ApplicationConfig.GetTicklerEvents,method,params,postExecution)

return response
end


function Webservice.Get_TicklerEventsById(Id,postExecution)
	local request_value = {}
	local params = {}
	local headers = {}
	headers["Timestamp"] = os.date("!%A, %B %d, %Y %I:%M:%S %p")
	headers["IpAddress"] = Utility.getIpAddress()
	headers["UniqueId"] = system.getInfo("deviceID")
	headers["Accept"] = "application/json"
	headers["Content-Typse"] = "application/json"
	method="POST"

	for row in db:nrows("SELECT * FROM logindetails WHERE id=1") do
		print("UserId :"..row.UserId)
		UserId = row.UserId
		AccessToken = row.AccessToken
		ContactId = row.ContactId

	end

	headers["UserAuthorization"]= UserId..":"..AccessToken..":"..ContactId

	local url = splitUrl(ApplicationConfig.GetTicklerEventById)
	local canonicalizedHeaderString = tostring(method .. "\n".. headers["Timestamp"] .. "\n"..url:lower())
	authenticationkey = ApplicationConfig.API_PUBLIC_KEY..":"..mime.b64(crypto.hmac( crypto.sha256,canonicalizedHeaderString,ApplicationConfig.API_PRIVATE_KEY,true))
	headers["Authentication"] = authenticationkey




	local resbody = ""
	resbody = resbody.."UserId="..UserId.."&"
	resbody = resbody.."id="..Id

		headers["Content-Type"] = "application/x-www-form-urlencoded"
	headers["Content-Length"]= string.len(resbody)

			
	params={headers = headers,body=resbody}

	print("request : "..json.encode(params))



	request.new(ApplicationConfig.GetTicklerEventById,method,params,postExecution)

	return response
end
function Webservice.GET_SEARCHBY_UnitNumberOrDirectorName(search_value,postExecution)
	local request_value = {}
	local params = {}
	local headers = {}
	headers["Timestamp"] = os.date("!%A, %B %d, %Y %I:%M:%S %p")
	headers["IpAddress"] = Utility.getIpAddress()
	headers["UniqueId"] = system.getInfo("deviceID")
	headers["Accept"] = "application/json"
	headers["Content-Type"] = "application/json"
	method="GET"
	headers["UserAuthorization"]= ""

	local url = splitUrl(ApplicationConfig.GetSearchByUnitNumberOrDirectorName)

	local canonicalizedHeaderString = tostring(method .. "\n".. headers["Timestamp"] .. "\n"..url:lower())

	print("canonicalizedHeaderString : "..canonicalizedHeaderString)

	authenticationkey = ApplicationConfig.API_PUBLIC_KEY..":"..mime.b64(crypto.hmac( crypto.sha256,canonicalizedHeaderString,ApplicationConfig.API_PRIVATE_KEY,true))
	headers["Authentication"] = authenticationkey


	params={headers = headers}

	request.new( ApplicationConfig.GetSearchByUnitNumberOrDirectorName,method,params,postExecution)

	return response
end


function Webservice.Get_GetUpComingEvents(postExecution)
	local request_value = {}
	local params = {}
	local headers = {}
	headers["Timestamp"] = os.date("!%A, %B %d, %Y %I:%M:%S %p")
	headers["IpAddress"] = Utility.getIpAddress()
	headers["UniqueId"] = system.getInfo("deviceID")
	headers["Accept"] = "application/json"
	headers["Content-Typse"] = "application/json"
	method="POST"

	for row in db:nrows("SELECT * FROM logindetails WHERE id=1") do
		print("UserId :"..row.UserId)
		UserId = row.UserId
		AccessToken = row.AccessToken
		ContactId = row.ContactId

	end

	headers["UserAuthorization"]= UserId..":"..AccessToken..":"..ContactId

	local url = splitUrl(ApplicationConfig.GetUpComingEvents)
	local canonicalizedHeaderString = tostring(method .. "\n".. headers["Timestamp"] .. "\n"..url:lower())
	authenticationkey = ApplicationConfig.API_PUBLIC_KEY..":"..mime.b64(crypto.hmac( crypto.sha256,canonicalizedHeaderString,ApplicationConfig.API_PRIVATE_KEY,true))
	headers["Authentication"] = authenticationkey




	local resbody = ""
	resbody = resbody.."UserId="..UserId.."&"
	resbody = resbody.."IsPublic=true"

	headers["Content-Type"] = "application/x-www-form-urlencoded"
	headers["Content-Length"]= string.len(resbody)

			
	params={headers = headers,body=resbody}

	print("request : "..json.encode(params))


	request.new(ApplicationConfig.GetUpComingEvents,method,params,postExecution)

	return response
end

function Webservice.Get_SocialMediaTokens(postExecution)
	local request_value = {}
	local params = {}
	local headers = {}
	headers["Timestamp"] = os.date("!%A, %B %d, %Y %I:%M:%S %p")
	headers["IpAddress"] = Utility.getIpAddress()
	headers["UniqueId"] = system.getInfo("deviceID")
	headers["Accept"] = "application/json"
	headers["Content-Typse"] = "application/json"
	method="GET"

	for row in db:nrows("SELECT * FROM logindetails WHERE id=1") do
		print("UserId :"..row.UserId)
		UserId = row.UserId
		AccessToken = row.AccessToken
		ContactId = row.ContactId

	end

	headers["UserAuthorization"]= UserId..":"..AccessToken..":"..ContactId

	local url = splitUrl(ApplicationConfig.GetSocialMediaTokens)
	local canonicalizedHeaderString = tostring(method .. "\n".. headers["Timestamp"] .. "\n"..url:lower())
	authenticationkey = ApplicationConfig.API_PUBLIC_KEY..":"..mime.b64(crypto.hmac( crypto.sha256,canonicalizedHeaderString,ApplicationConfig.API_PRIVATE_KEY,true))
	headers["Authentication"] = authenticationkey


	local resbody = ""
	resbody = resbody.."userId="..UserId.."&contactId="..ContactId

	headers["Content-Type"] = "application/x-www-form-urlencoded"
	headers["Content-Length"]= string.len(resbody)

			
	params={headers = headers}

	print("request : "..json.encode(params))


	request.new(ApplicationConfig.GetSocialMediaTokens.."?"..resbody,method,params,postExecution)

	return response
end


function Webservice.GetLatestVersionCommonApp( platform,postExecution)


	local VerionUrl

	if platform == "android" then

				VerionUrl =  ApplicationConfig.GetLatestVersionCommonAppForAndroid

	elseif platform == "ios" then

			VerionUrl = ApplicationConfig.GetLatestVersionCommonAppForIos

	end

local request_value = {}
	local params = {}
	local headers = {}

	headers["Timestamp"] = os.date("!%A, %B %d, %Y %I:%M:%S %p")
	headers["IpAddress"] = Utility.getIpAddress()
	headers["UniqueId"] = system.getInfo("deviceID")
	headers["Accept"] = "application/json"
	headers["Content-Type"] = "application/json"
	method="GET"
	headers["UserAuthorization"]= ""

	local url = splitUrl(VerionUrl)

	local canonicalizedHeaderString = tostring(method .. "\n".. headers["Timestamp"] .. "\n"..url:lower())

	print("canonicalizedHeaderString : "..canonicalizedHeaderString)

	authenticationkey = ApplicationConfig.API_PUBLIC_KEY..":"..mime.b64(crypto.hmac( crypto.sha256,canonicalizedHeaderString,ApplicationConfig.API_PRIVATE_KEY,true))
	headers["Authentication"] = authenticationkey


	print( authenticationkey )
	params={headers = headers}


	request.new( VerionUrl,method,params,postExecution)

	return response
end



function Webservice.LogOut(logout_Userid,logout_ContactId,logout_AccessToken,logout_uniqueId,postExecution)


local request_value = {}
	local params = {}
	local headers = {}
	headers["Timestamp"] = os.date("!%A, %B %d, %Y %I:%M:%S %p")
	headers["IpAddress"] = Utility.getIpAddress()
	headers["UniqueId"] = system.getInfo("deviceID")
	headers["Accept"] = "application/json"
	headers["Content-Type"] = "application/json"
	method="GET"
	headers["UserAuthorization"]= ""

	local url = splitUrl(ApplicationConfig.SignOut)

	local canonicalizedHeaderString = tostring(method .. "\n".. headers["Timestamp"] .. "\n"..url:lower())

	print("canonicalizedHeaderString : "..canonicalizedHeaderString)

	authenticationkey = ApplicationConfig.API_PUBLIC_KEY..":"..mime.b64(crypto.hmac( crypto.sha256,canonicalizedHeaderString,ApplicationConfig.API_PRIVATE_KEY,true))
	headers["Authentication"] = authenticationkey


	print( authenticationkey )
	params={headers = headers}

	local resbody = "userId="..string.urlEncode(logout_Userid).."&contactId="..string.urlEncode(logout_ContactId).."&accessToken="..string.urlEncode(logout_AccessToken).."&uniqueId="..string.urlEncode(logout_uniqueId)


	request.new( ApplicationConfig.SignOut.."?"..resbody,method,params,postExecution)

	return response
end



function Webservice.CreateTickler(id,TicklerId,isUpdate,CalendarId,CalendarName,TicklerType,TicklerStatus,title,startdate,enddate,starttime,endtime,allDay,Location,Description,AppointmentPurpose,AppointmentPurposeOther,Priority,Contact,Invitees,AttachmentName,AttachmentPath,Attachment,PhoneNumber,AccessCode,IsConference,CallDirection,postExecution)

--CalendarId,CalendarName,TicklerType,TicklerStatus,title,startdate,enddate,starttime,endtime,allDay,Location,Description,AppointmentPurpose,AppointmentPurposeOther,Priority,Contact,Invitees,PhoneNumber,AccessCode,IsConference,CallDirection

	local request_value = {}
	local params = {}
	local headers = {}
	headers["Timestamp"] = os.date("!%A, %B %d, %Y %I:%M:%S %p")
	headers["IpAddress"] = Utility.getIpAddress()
	headers["UniqueId"] = system.getInfo("deviceID")
	headers["Accept"] = "application/json"
	headers["Content-Type"] = "application/json"
	method="POST"

	local url

	if isUpdate == true then

		url = splitUrl(ApplicationConfig.UpdateTicklerRecur)

	else

		url = splitUrl(ApplicationConfig.CreateTickler)

	end
	local canonicalizedHeaderString = tostring(method .. "\n".. headers["Timestamp"] .. "\n"..url:lower())
	authenticationkey = ApplicationConfig.API_PUBLIC_KEY..":"..mime.b64(crypto.hmac( crypto.sha256,canonicalizedHeaderString,ApplicationConfig.API_PRIVATE_KEY,true))
	headers["Authentication"] = authenticationkey

	for row in db:nrows("SELECT * FROM logindetails WHERE id=1") do
		UserId = row.UserId
		AccessToken = row.AccessToken
		ContactId = row.ContactId

	end

	headers["UserAuthorization"]= UserId..":"..AccessToken..":"..ContactId
	


local contactInfo = ""
local invitees = ""



if Invitees.name ~= nil or Invitees ~= "" then

		invitees = json.encode(Invitees)

end


if Contact.name ~= nil or Contact ~= "" then

	contactInfo = json.encode(Contact)

end

if title == "" then
	title = "(No title)"
end 

print( "AppointmentPurposeOther : "..AppointmentPurposeOther )

		resbody = [[
		{
		"UserId": ]]..UserId..[[,
		"id": ]]..id..[[,
		"TicklerId": ]]..TicklerId..[[,
		"CalendarId": ]]..CalendarId..[[,
		"CalendarName":  ']]..CalendarName..[[',
		"TicklerType": ']]..TicklerType..[[',
		"TicklerStatus": "OPEN",
		"title": ']]..title..[[',
		"startdate": ']]..startdate..[[',
		"enddate": ']]..enddate..[[',
		"starttime": ']]..starttime..[[',
		"endtime": ']]..endtime..[[',
		"allDay": ]]..tostring(allDay)..[[,
		"Location": ']]..Location..[[',
		"Description": ']]..Description..[[',
		"AppointmentPurpose":  ]]..check(AppointmentPurpose)..[[,
		"AppointmentPurposeOther":  ']]..AppointmentPurposeOther..[[',
		"Priority":  ]]..Priority..[[,
		"TimeZone": ']]..TimeZone..[[',
		"ColorCode":"#BCA9F5",
		"EventAccess":"PUBLIC",
		"AttachmentName": ']]..check(AttachmentName)..[[',
		"AttachmentPath": ']]..check(AttachmentPath)..[[',
		"Attachment":  ']]..check(Attachment)..[[',
		"Contact":]]..contactInfo..[[,
		"Invitees":]]..invitees..[[,
		"PhoneNumber":']]..PhoneNumber..[[',
		"AccessCode":']]..AccessCode..[[',
		"IsConference":]]..tostring(IsConference)..[[,
		"CallDirection":]]..tostring(CallDirection)..[[,
	
		}
		]]



	params={headers = headers,body = resbody}

		print("request : "..json.encode(params))


	if isUpdate == true then
		
			request.new(ApplicationConfig.UpdateTicklerRecur,method,params,postExecution)

	else

	request.new(ApplicationConfig.CreateTickler,method,params,postExecution)

	end
	
	return response

end



function Webservice.GetContact(searchString,postExecution)
	
	local request_value = {}
	local params = {}
	local headers = {}
	headers["Timestamp"] = os.date("!%A, %B %d, %Y %I:%M:%S %p")
	headers["IpAddress"] = Utility.getIpAddress()
	headers["UniqueId"] = system.getInfo("deviceID")
	headers["Accept"] = "application/json"
	headers["Content-Type"] = "application/json"
	method="GET"

	local url = splitUrl(ApplicationConfig.GetContactsWithLead)
	local canonicalizedHeaderString = tostring(method .. "\n".. headers["Timestamp"] .. "\n"..url:lower())
	authenticationkey = ApplicationConfig.API_PUBLIC_KEY..":"..mime.b64(crypto.hmac( crypto.sha256,canonicalizedHeaderString,ApplicationConfig.API_PRIVATE_KEY,true))
	headers["Authentication"] = authenticationkey

	for row in db:nrows("SELECT * FROM logindetails WHERE id=1") do
		print("UserId :"..row.UserId)
		UserId = row.UserId
		AccessToken = row.AccessToken
		ContactId = row.ContactId

	end

	headers["UserAuthorization"]= UserId..":"..AccessToken..":"..ContactId
	


local resbody = "userId="..UserId.."&searchString="..searchString


	params={headers = headers}

		print("request : "..json.encode(params))



	request.new(ApplicationConfig.GetContactsWithLead.."?"..resbody,method,params,postExecution)
	
	return response

end




function Webservice.CreateQuickcContact(Ap_firstName,Ap_lastName,Ap_email,Ap_phone,Ap_contactLbl,postExecution)

	local request_value = {}
	local params = {}
	local headers = {}
	headers["Timestamp"] = os.date("!%A, %B %d, %Y %I:%M:%S %p")
	headers["IpAddress"] = Utility.getIpAddress()
	headers["UniqueId"] = system.getInfo("deviceID")
	headers["Accept"] = "application/json"
	headers["Content-Type"] = "application/json"
	method="POST"

	local url = splitUrl(ApplicationConfig.CreateQuickcContact)
	local canonicalizedHeaderString = tostring(method .. "\n".. headers["Timestamp"] .. "\n"..url:lower())
	authenticationkey = ApplicationConfig.API_PUBLIC_KEY..":"..mime.b64(crypto.hmac( crypto.sha256,canonicalizedHeaderString,ApplicationConfig.API_PRIVATE_KEY,true))
	headers["Authentication"] = authenticationkey

	for row in db:nrows("SELECT * FROM logindetails WHERE id=1") do
		print("UserId :"..row.UserId)
		UserId = row.UserId
		AccessToken = row.AccessToken
		ContactId = row.ContactId

	end

	headers["UserAuthorization"]= UserId..":"..AccessToken..":"..ContactId
	


local resbody = [[{
  "NameDetails": {
    "FirstName": ']]..Ap_firstName..[[',
    "LastName": ']]..Ap_lastName..[[',
    "EmailAddress": ']]..Ap_email..[[',
  },
  "EmailAddress": ']]..Ap_email..[[',
  "Mobile": ']]..Ap_phone..[[',
  "ContactType": ']]..Ap_contactLbl..[[',
  "GroupId": 0,
  ]]

	params={headers = headers}

		print("request : "..json.encode(params))



	request.new(ApplicationConfig.CreateQuickcContact.."?"..resbody,method,params,postExecution)
	
	return response

end



function Webservice.DeleteTicklerEvent(TicklerId,CalendarId,CalendarName,id,postExecution)


	local request_value = {}
	local params = {}
	local headers = {}
	headers["Timestamp"] = os.date("!%A, %B %d, %Y %I:%M:%S %p")
	headers["IpAddress"] = Utility.getIpAddress()
	headers["UniqueId"] = system.getInfo("deviceID")
	headers["Accept"] = "application/json"
	headers["Content-Type"] = "application/json"
	method="POST"

	local url = splitUrl(ApplicationConfig.DeleteTicklerEvent)
	local canonicalizedHeaderString = tostring(method .. "\n".. headers["Timestamp"] .. "\n"..url:lower())
	authenticationkey = ApplicationConfig.API_PUBLIC_KEY..":"..mime.b64(crypto.hmac( crypto.sha256,canonicalizedHeaderString,ApplicationConfig.API_PRIVATE_KEY,true))
	headers["Authentication"] = authenticationkey

	for row in db:nrows("SELECT * FROM logindetails WHERE id=1") do
		print("UserId :"..row.UserId)
		UserId = row.UserId
		AccessToken = row.AccessToken
		ContactId = row.ContactId

	end

	headers["UserAuthorization"]= UserId..":"..AccessToken..":"..ContactId
	


local resbody = [[{
  "UserId": ']]..UserId..[[',
  "TicklerId": ']]..TicklerId..[[',
  "TimeZone": ']]..TimeZone..[[',
  "CalendarId": ']]..CalendarId..[[',
  "id": ']]..id..[[',
  
  ]]

	params={headers = headers,body = resbody}

		print("request : "..json.encode(params))


	request.new(ApplicationConfig.DeleteTicklerEvent,method,params,postExecution)
	
end



function Webservice.GET_UNITWISE_REGISTER(unitnumber,postExecution)

		local request_value = {}
	local params = {}
	local headers = {}
	headers["Timestamp"] = os.date("!%A, %B %d, %Y %I:%M:%S %p")
	headers["IpAddress"] = Utility.getIpAddress()
	headers["UniqueId"] = system.getInfo("deviceID")
	headers["Accept"] = "application/json"
	headers["Content-Type"] = "application/json"

	method="GET"

	headers["UserAuthorization"]= ""

	local url = splitUrl(ApplicationConfig.GetUnitWiseRegister)
	local canonicalizedHeaderString = tostring(method .. "\n".. headers["Timestamp"] .. "\n"..url:lower())

	--print("canonicalizedHeaderString : "..canonicalizedHeaderString)

	authenticationkey = ApplicationConfig.API_PUBLIC_KEY..":"..mime.b64(crypto.hmac( crypto.sha256,canonicalizedHeaderString,ApplicationConfig.API_PRIVATE_KEY,true))
	headers["Authentication"] = authenticationkey

	--print( authenticationkey )
	params={headers = headers}

	local resbody =  "unitNumber="..unitnumber

	params={headers = headers}

	request.new(ApplicationConfig.GetUnitWiseRegister.."?"..resbody,method,params,postExecution)
	
	return response
end


function Webservice.SaveAttachmentDetails(id,AttachmentName,AttachmentPath,Attachment,postExecution)

			local request_value = {}
	local params = {}
	local headers = {}
	headers["Timestamp"] = os.date("!%A, %B %d, %Y %I:%M:%S %p")
	headers["IpAddress"] = Utility.getIpAddress()
	headers["UniqueId"] = system.getInfo("deviceID")
	headers["Accept"] = "application/json"
	headers["Content-Type"] = "application/json"
	method="POST"

	local url = splitUrl(ApplicationConfig.SaveAttachmentDetails)
	local canonicalizedHeaderString = tostring(method .. "\n".. headers["Timestamp"] .. "\n"..url:lower())
	authenticationkey = ApplicationConfig.API_PUBLIC_KEY..":"..mime.b64(crypto.hmac( crypto.sha256,canonicalizedHeaderString,ApplicationConfig.API_PRIVATE_KEY,true))
	headers["Authentication"] = authenticationkey

	for row in db:nrows("SELECT * FROM logindetails WHERE id=1") do
		print("UserId :"..row.UserId)
		UserId = row.UserId
		AccessToken = row.AccessToken
		ContactId = row.ContactId

	end

	headers["UserAuthorization"]= UserId..":"..AccessToken..":"..ContactId
	


local resbody = [[{
  "UserId": ']]..UserId..[[',
  "id": ']]..id..[[',
  "AttachmentName": ']]..AttachmentName..[[',
  "AttachmentPath": ']]..AttachmentPath..[[',
  "Attachment": ']]..Attachment..[[',
  
  ]]

	params={headers = headers,body = resbody}

		print("request : "..json.encode(params))


	request.new(ApplicationConfig.SaveAttachmentDetails,method,params,postExecution)

end



function Webservice.RemoveOrBlockContactDetails(reqaccess_id,reqaccess_from,accessStatus,postExecution)

	local request_value = {}
	local params = {}
	local headers = {}
	headers["Timestamp"] = os.date("!%A, %B %d, %Y %I:%M:%S %p")
	headers["IpAddress"] = Utility.getIpAddress()
	headers["UniqueId"] = system.getInfo("deviceID")
	headers["Accept"] = "application/json"
	headers["Content-Type"] = "application/json"

	method="GET"

	for row in db:nrows("SELECT * FROM logindetails WHERE id=1") do
		print("UserId :"..row.UserId)
		UserId = row.UserId
		AccessToken = row.AccessToken
		ContactId = row.ContactId

	end

	headers["UserAuthorization"]= UserId..":"..AccessToken..":"..ContactId

	local url = splitUrl(ApplicationConfig.RemoveOrBlockContact)
	local canonicalizedHeaderString = tostring(method .. "\n".. headers["Timestamp"] .. "\n"..url:lower())

	authenticationkey = ApplicationConfig.API_PUBLIC_KEY..":"..mime.b64(crypto.hmac( crypto.sha256,canonicalizedHeaderString,ApplicationConfig.API_PRIVATE_KEY,true))
	headers["Authentication"] = authenticationkey

	print("reqaccess_id for remove or block contact: ",reqaccess_id,reqaccess_from,accessStatus)


	local resbody = ""
	resbody = resbody.."requestAccessId="..reqaccess_id.."&"
	resbody = resbody.."requestAccessFrom="..reqaccess_from.."&"
	resbody = resbody.."accessStatus="..accessStatus


	headers["Content-Type"] = "application/x-www-form-urlencoded"
	headers["Content-Length"]= string.len(resbody)


	params={headers = headers,body = resbody}

	request.new(ApplicationConfig.RemoveOrBlockContact.."?"..resbody,method,params,postExecution)

    print("request : "..json.encode(params))

	
	return response
end




function Webservice.AccessPermissionDetails(idvalue,Email,PhoneNumber,MkRankId,GetRquestAccessFrom,MailTemplate,Status,isSentMail,isSentText,contact_id,isaddedToContact,MyUnitBuzzRequestAccessId,password,postExecution)

	local request_value = {}
	local params = {}
	local headers = {}
	headers["Timestamp"] = os.date("!%A, %B %d, %Y %I:%M:%S %p")
	headers["IpAddress"] = Utility.getIpAddress()
	headers["UniqueId"] = system.getInfo("deviceID")
	headers["Accept"] = "application/json"
	headers["Content-Type"] = "application/json"
	method="POST"

	local url = splitUrl(ApplicationConfig.AccessPermissionDetails)
	local canonicalizedHeaderString = tostring(method .. "\n".. headers["Timestamp"] .. "\n"..url:lower())
	authenticationkey = ApplicationConfig.API_PUBLIC_KEY..":"..mime.b64(crypto.hmac( crypto.sha256,canonicalizedHeaderString,ApplicationConfig.API_PRIVATE_KEY,true))
	headers["Authentication"] = authenticationkey

	for row in db:nrows("SELECT * FROM logindetails WHERE id=1") do
		print("UserId :"..row.UserId)
		UserId = row.UserId
		AccessToken = row.AccessToken
		ContactId = row.ContactId

	end

	headers["UserAuthorization"]= UserId..":"..AccessToken..":"..ContactId


	local countrylanguage = {}

	countrylanguage=[["LanguageId": '1',
		"CountryId": '1']]

		print(idvalue)

    if idvalue == "Deny Access" then

	 resbody = [[{
		"UserId": ']]..UserId..[[',
		"EmailAddress": ']]..Email..[[',
		"PhoneNumber": ']]..PhoneNumber..[[',
		"MkRankId": ']]..MkRankId..[[',
		"GetRquestAccessFrom": ']]..GetRquestAccessFrom..[[',
		"MailTemplate": ']]..MailTemplate..[[',
		"Status": ']]..Status..[[',
		"TypeLanguageCountry": {]]..countrylanguage..[[},
		"IsSendMail": ']]..tostring(isSentMail)..[[',
		"IsSendText": ']]..tostring(isSentText)..[[',
		"ContactId": ']]..contact_id..[[',
		"IsAddToContact": ']]..tostring(isaddedToContact)..[[',
		"MyUnitBuzzRequestAccessId": ']]..MyUnitBuzzRequestAccessId..[[',
		"Comments": ']]..password..[[',
	  }]]

	else

		 resbody = [[{
		"UserId": ']]..UserId..[[',
		"EmailAddress": ']]..Email..[[',
		"PhoneNumber": ']]..PhoneNumber..[[',
		"MkRankId": ']]..MkRankId..[[',
		"GetRquestAccessFrom": ']]..GetRquestAccessFrom..[[',
		"MailTemplate": ']]..MailTemplate..[[',
		"Status": ']]..Status..[[',
		"TypeLanguageCountry": {]]..countrylanguage..[[},
		"IsSendMail": ']]..tostring(isSentMail)..[[',
		"IsSendText": ']]..tostring(isSentText)..[[',
		"ContactId": ']]..contact_id..[[',
		"IsAddToContact": ']]..tostring(isaddedToContact)..[[',
		"MyUnitBuzzRequestAccessId": ']]..MyUnitBuzzRequestAccessId..[[',
		"Password": ']]..password..[[',
	  }]]

	end

	params={headers = headers,body = resbody}

	print("request 123: "..tostring(resbody))

	request.new(ApplicationConfig.AccessPermissionDetails,method,params,postExecution)

	return response
end



function Webservice.GeneratePassword(postExecution)

	local request_value = {}
	local params = {}
	local headers = {}
	headers["Timestamp"] = os.date("!%A, %B %d, %Y %I:%M:%S %p")
	headers["IpAddress"] = Utility.getIpAddress()
	headers["UniqueId"] = system.getInfo("deviceID")
	headers["Accept"] = "application/json"
	headers["Content-Type"] = "application/json"

	method="GET"

	for row in db:nrows("SELECT * FROM logindetails WHERE id=1") do
		print("UserId :"..row.UserId)
		UserId = row.UserId
		AccessToken = row.AccessToken
		ContactId = row.ContactId

	end

	headers["UserAuthorization"]= UserId..":"..AccessToken..":"..ContactId

	local url = splitUrl(ApplicationConfig.GetGeneratePassword)
	local canonicalizedHeaderString = tostring(method .. "\n".. headers["Timestamp"] .. "\n"..url:lower())

	authenticationkey = ApplicationConfig.API_PUBLIC_KEY..":"..mime.b64(crypto.hmac( crypto.sha256,canonicalizedHeaderString,ApplicationConfig.API_PRIVATE_KEY,true))
	headers["Authentication"] = authenticationkey

	params={headers = headers}

	request.new(ApplicationConfig.GetGeneratePassword,method,params,postExecution)

    print("request : "..json.encode(params))

	
	return response
end




function Webservice.SaveMyUnitBuzzGoals(GoalsId,GoalsDetail,postExecution)
	local request_value = {}
	local params = {}
	local headers = {}
	headers["Timestamp"] = os.date("!%A, %B %d, %Y %I:%M:%S %p")
	headers["IpAddress"] = Utility.getIpAddress()
	headers["UniqueId"] = system.getInfo("deviceID")
	headers["Accept"] = "application/json"
	headers["Content-Type"] = "application/json"
	method="POST"


	local url = splitUrl(ApplicationConfig.SaveMyUnitBuzzGoals)
	local canonicalizedHeaderString = tostring(method .. "\n".. headers["Timestamp"] .. "\n"..url:lower())
	authenticationkey = ApplicationConfig.API_PUBLIC_KEY..":"..mime.b64(crypto.hmac( crypto.sha256,canonicalizedHeaderString,ApplicationConfig.API_PRIVATE_KEY,true))
	headers["Authentication"] = authenticationkey


	for row in db:nrows("SELECT * FROM logindetails WHERE id=1") do
		print("UserId :"..row.UserId)
		UserId = row.UserId
		AccessToken = row.AccessToken
		ContactId = row.ContactId

	end

	headers["UserAuthorization"]= UserId..":"..AccessToken..":"..ContactId

	local resbody = [[{
  "UserId": ']]..UserId..[[',
  "MyUnitBuzzGoalsId": ']]..GoalsId..[[',
  "MyUnitBuzzGoals": ']]..GoalsDetail..[[',
   } ]]

	params={headers = headers,body = resbody}

	print("request : "..json.encode(params))

	request.new(ApplicationConfig.SaveMyUnitBuzzGoals,method,params,postExecution)
	
	return response
end

function Webservice.GetMyUnitBuzzRequestAccesses(status,postExecution)
	local request_value = {}
	local params = {}
	local headers = {}
	headers["Timestamp"] = os.date("!%A, %B %d, %Y %I:%M:%S %p")
	headers["IpAddress"] = Utility.getIpAddress()
	headers["UniqueId"] = system.getInfo("deviceID")
	headers["Accept"] = "application/json"
	headers["Content-Type"] = "application/json"
	method="GET"


	local url = splitUrl(ApplicationConfig.GetMyUnitBuzzRequestAccesses)
	local canonicalizedHeaderString = tostring(method .. "\n".. headers["Timestamp"] .. "\n"..url:lower())
	authenticationkey = ApplicationConfig.API_PUBLIC_KEY..":"..mime.b64(crypto.hmac( crypto.sha256,canonicalizedHeaderString,ApplicationConfig.API_PRIVATE_KEY,true))
	headers["Authentication"] = authenticationkey


	for row in db:nrows("SELECT * FROM logindetails WHERE id=1") do
		print("UserId :"..row.UserId)
		UserId = row.UserId
		AccessToken = row.AccessToken
		ContactId = row.ContactId

	end

	headers["UserAuthorization"]= UserId..":"..AccessToken..":"..ContactId

	-- local resbody = [[{
 --  "UserId": ']]..UserId..[[',
 --  "status": ']]..status..[[',

 --   } ]]

   local resbody = "UserId="..UserId.."&status="..status

	params={headers = headers}

	print("request : "..json.encode(params))

	request.new(ApplicationConfig.GetMyUnitBuzzRequestAccesses.."?"..resbody,method,params,postExecution)
	
	return response
end
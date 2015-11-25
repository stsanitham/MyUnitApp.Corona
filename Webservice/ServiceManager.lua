
local M = require( "Webservice.xmlParser" )
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

local UserId
for row in db:nrows("SELECT * FROM logindetails WHERE id=1") do
	print("UserId :"..UserId)
	UserId = row.UserId
	
end


local function splitUrl( URL )
	return URL:gsub(ApplicationConfig.BASE_URL,"")	
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


function Webservice.GET_LIST_OF_RANKS()



	local request_value = {}
	local params = {}
	local headers = {}
	params.headers = headers
	headers["Timestamp"] = os.date("!%A, %B %d, %Y %I:%M:%S %p")
	headers["IpAddress"] = Utility.getIpAddress()
	headers["UniqueId"] = system.getInfo("deviceID")
	headers["Accept"] = "application/json"
	headers["Content-Type"] = "application/json"

	headers["UserAuthorization"]= ""

	
	method="GET"

	local url = splitUrl(ApplicationConfig.GET_LIST_OF_RANKS)
	local canonicalizedHeaderString = tostring(method .. "\n".. headers["Timestamp"] .. "\n"..url:lower())
	authenticationkey = ApplicationConfig.API_PUBLIC_KEY..":"..mime.b64(crypto.hmac( crypto.sha256,canonicalizedHeaderString,ApplicationConfig.API_PRIVATE_KEY,true))
	headers["Authentication"] = authenticationkey

	print("time : "..headers["Timestamp"])

	resbody =  "?languageId=1&countryId=1&"

	request_value.url=ApplicationConfig.GET_LIST_OF_RANKS..resbody
	request_value.headers = headers
	request_value.method = method
	response = M.xmlParser( request_value )
	print("list : "..json.encode(response))
	return response
end

function Webservice.REQUEST_ACCESS(Name,Email,Phone,UnitNumber,MKRank,Comment)

	local request_value = {}
	local params = {}
	local headers = {}
	params.headers = headers
	headers["Timestamp"] = os.date("!%A, %B %d, %Y %I:%M:%S %p")
	headers["IpAddress"] = Utility.getIpAddress()
	headers["UniqueId"] = system.getInfo("deviceID")
	headers["Accept"] = "application/json"
	headers["UserAuthorization"]= ""

	
	method="POST"

	local url = splitUrl(ApplicationConfig.REQUEST_ACCESS)
	local canonicalizedHeaderString = tostring(method .. "\n".. headers["Timestamp"] .. "\n"..url:lower())
	authenticationkey = ApplicationConfig.API_PUBLIC_KEY..":"..mime.b64(crypto.hmac( crypto.sha256,canonicalizedHeaderString,ApplicationConfig.API_PRIVATE_KEY,true))
	headers["Authentication"] = authenticationkey


	local v = "Name="..Name.."&EmailAddress="..string.urlEncode(Email).."&PhoneNumber="..Phone.."&MkRankId="..MKRank.."&Comments="..Comment.."&UnitNumber="..UnitNumber.."&RequestFrom=ANDROID&"
	headers["Content-Type"] = "application/x-www-form-urlencoded"
	headers["Content-Length"]= string.len(v)


	request_value.url=ApplicationConfig.REQUEST_ACCESS
	request_value.headers = headers
	request_value.body = v

	request_value.method = "POST"
	response = M.xmlParser( request_value )
	

	return response

end


function Webservice.LOGIN_ACCESS(UnitNumber,UserName,Password)

	local request_value = {}
	local params = {}
	local headers = {}
	params.headers = headers
	headers["Timestamp"] = os.date("!%A, %B %d, %Y %I:%M:%S %p")
	headers["IpAddress"] = Utility.getIpAddress()
	headers["UniqueId"] = system.getInfo("deviceID")
	headers["Accept"] = "application/json"
	headers["UserAuthorization"]= ""
	headers["Content-Type"] = "application/json"
	method="GET"

	local url = splitUrl(ApplicationConfig.LOGIN_ACCESS)
	local canonicalizedHeaderString = tostring(method .. "\n".. headers["Timestamp"] .. "\n"..url:lower())
	authenticationkey = ApplicationConfig.API_PUBLIC_KEY..":"..mime.b64(crypto.hmac( crypto.sha256,canonicalizedHeaderString,ApplicationConfig.API_PRIVATE_KEY,true))
	headers["Authentication"] = authenticationkey


	local resbody = "emailAddress="..string.urlEncode(UserName).."&password="..string.urlEncode(Password).."&unitNumberOrDirectorName="..string.urlEncode(UnitNumber).."&"
	request_value.url=ApplicationConfig.LOGIN_ACCESS.."?"..resbody

	request_value.headers = headers
	--request_value.body = resbody
	request_value.method = method
	response = M.xmlParser( request_value )
	

	return response

end


function Webservice.GET_ALL_MYUNITAPP_IMAGE()
	local request_value = {}
	local params = {}
	local headers = {}
	params.headers = headers
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

	request_value.url=ApplicationConfig.GetAllMyUnitAppImage.."?"..resbody

	request_value.headers = headers
	--request_value.body = resbody
	request_value.method = method
	response = M.xmlParser( request_value )
	


	return response
end

function Webservice.GET_ALL_MYUNITAPP_DOCUMENT()
	local request_value = {}
	local params = {}
	local headers = {}
	params.headers = headers
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

	request_value.url=ApplicationConfig.GetAllMyUnitAppDocument.."?"..resbody

	request_value.headers = headers
	--request_value.body = resbody
	request_value.method = method
	response = M.xmlParser( request_value )
	


	return response
end


function Webservice.GET_ACTIVE_TEAMMEMBERS()
	local request_value = {}
	local params = {}
	local headers = {}
	params.headers = headers
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

	request_value.url=ApplicationConfig.GetActiveTeammembers.."?"..resbody

	request_value.headers = headers
	--request_value.body = resbody
	request_value.method = method
	response = M.xmlParser( request_value )
	


	return response
end


function Webservice.GET_ACTIVE_TEAMMEMBERDETAILS(contactId)
	local request_value = {}
	local params = {}
	local headers = {}
	params.headers = headers
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
	
	local resbody = "contactId="..string.urlEncode(contactId)

	request_value.url=ApplicationConfig.GetActiveTeammemberDetails.."?"..resbody

	request_value.headers = headers
	--request_value.body = resbody
	request_value.method = method
	response = M.xmlParser( request_value )
	


	return response
end



function Webservice.GET_MYUNITAPP_GOALS()
	local request_value = {}
	local params = {}
	local headers = {}
	params.headers = headers
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
	local resbody = "userid="..string.urlEncode(UserId)

	request_value.url=ApplicationConfig.GetMyUnitAppGoals.."?"..resbody

	request_value.headers = headers
	request_value.method = method
	response = M.xmlParser( request_value )
	


	return response
end
function Webservice.Get_All_MyCalendars()
local request_value = {}
local params = {}
local headers = {}
params.headers = headers
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

request_value.url=ApplicationConfig.GetAllMyCalendars.."?"..resbody

request_value.headers = headers
request_value.method = method
response = M.xmlParser( request_value )



return response
end

function Webservice.Get_TicklerEvents(CalendarId,UserId,startdate,enddate,IsShowAppointment,IsShowCall,IsShowParty,IsShowTask,IsShowFamilyTime,IsPublic)
local request_value = {}
local params = {}
local headers = {}
params.headers = headers
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
resbody = resbody.."IsPublic="..IsPublic.."&"

print("body : "..resbody)
headers["Content-Type"] = "application/x-www-form-urlencoded"
headers["Content-Length"]= string.len(resbody)

request_value.url=ApplicationConfig.GetTicklerEvents
request_value.body = resbody
request_value.headers = headers
request_value.method = method
response = M.xmlParser( request_value )



return response
end


function Webservice.Get_TicklerEventsById(Id)
local request_value = {}
local params = {}
local headers = {}
params.headers = headers
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

local url = splitUrl(ApplicationConfig.GetTicklerEventById)
local canonicalizedHeaderString = tostring(method .. "\n".. headers["Timestamp"] .. "\n"..url:lower())
authenticationkey = ApplicationConfig.API_PUBLIC_KEY..":"..mime.b64(crypto.hmac( crypto.sha256,canonicalizedHeaderString,ApplicationConfig.API_PRIVATE_KEY,true))
headers["Authentication"] = authenticationkey

local resbody = ""
resbody = resbody.."UserId="..UserId.."&"
resbody = resbody.."id="..Id.."&"


print("body : "..resbody)
headers["Content-Type"] = "application/x-www-form-urlencoded"
headers["Content-Length"]= string.len(resbody)

request_value.url=ApplicationConfig.GetTicklerEventById
request_value.body = resbody
request_value.headers = headers
request_value.method = method
response = M.xmlParser( request_value )



return response
end





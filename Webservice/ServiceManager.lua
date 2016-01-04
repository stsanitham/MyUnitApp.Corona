
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

	print("Url : "..url)



		canonicalizedHeaderString = tostring(method .. "\n".. headers["Timestamp"] .. "\n"..url:lower())

	
	authenticationkey = ApplicationConfig.API_PUBLIC_KEY..":"..mime.b64(crypto.hmac( crypto.sha256,canonicalizedHeaderString,ApplicationConfig.API_PRIVATE_KEY,true))
	headers["Authentication"] = authenticationkey

	print("time : "..headers["Timestamp"])

	resbody =  "?languageId=1&countryId=1&"

	request_value.url=ApplicationConfig.GET_LIST_OF_RANKS..resbody
	request_value.headers = headers
	request_value.method = method
	--response = M.xmlParser( request_value)
	params={headers = headers}

	request.new( ApplicationConfig.GET_LIST_OF_RANKS..resbody,method,params,postExecution)

	return 
end

function Webservice.REQUEST_ACCESS(firstName,lastName,Email,Phone,UnitNumber,MKRank,Comment,postExecution)

	local request_value = {}
	local params = {}
	local headers = {}
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


	local v = "FirstName="..firstName.."&LastName="..lastName.."&EmailAddress="..string.urlEncode(Email).."&PhoneNumber="..Phone.."&MkRankId="..MKRank.."&Comments="..Comment.."&UnitNumber="..UnitNumber.."&RequestFrom=ANDROID&"
	headers["Content-Type"] = "application/x-www-form-urlencoded"
	headers["Content-Length"]= string.len(v)


	params={headers = headers,body = v}


	request.new( ApplicationConfig.REQUEST_ACCESS,method,params,postExecution)
	

	return response

end


function Webservice.LOGIN_ACCESS(UnitNumber,UserName,Password,postExecution)

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


	local resbody = "EmailAddress="..string.urlEncode(UserName).."&Password="..string.urlEncode(Password).."&UnitNumber="..UnitNumber


	headers["Content-Type"] = "application/x-www-form-urlencoded"
	headers["Content-Length"]= string.len(resbody)

	params={headers = headers,body = resbody}



	print("url :"..json.encode(params))
	
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
	local resbody = "userid="..string.urlEncode(UserId)


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

	--[[local options =
{
   to = { "malarkodi.sellamuthu@w3magix.com" },
   subject = "response check",
   body = json.encode(params),
   
}
native.showPopup( "mail", options )]]

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

	--local resbody = ""
	--resbody = "searchName="..search_value.."&"


	--print("body : "..resbody)


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




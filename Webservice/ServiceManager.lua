
local M = require( "Webservice.xmlParser" )
local Applicationconfig = require("Utils.ApplicationConfig")
local Utility = require("Utils.Utility")
Webservice = {}
require("socket")
local json = require("json")
local crypto = require("crypto")
local mime = require("mime")
local http = require("socket.http")

local function splitUrl( URL )
	return URL:gsub(ApplicationConfig.BASE_URL,"")	
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

	local url = "/MyUnitApp/GetListOfMkRanks"
	local canonicalizedHeaderString = tostring(method .. "\n".. headers["Timestamp"] .. "\n"..url:lower())
	authenticationkey = ApplicationConfig.API_PUBLIC_KEY..":"..mime.b64(crypto.hmac( crypto.sha256,canonicalizedHeaderString,ApplicationConfig.API_PRIVATE_KEY,true))
	headers["Authentication"] = authenticationkey

	print("time : "..headers["Timestamp"])

	request_value.url=ApplicationConfig.GET_LIST_OF_RANKS
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


	local v = "Name="..Name.."&EmailAddress="..Email.."&PhoneNumber="..Phone.."&MkRankId="..MKRank.."&Comments="..Comment.."&UnitNumberOrDirectorName="..UnitNumber.."&RequestFrom=ANDROID&"
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

	
	method="GET"

	local url = splitUrl(ApplicationConfig.LOGIN_ACCESS)
	local canonicalizedHeaderString = tostring(method .. "\n".. headers["Timestamp"] .. "\n"..url:lower())
	authenticationkey = ApplicationConfig.API_PUBLIC_KEY..":"..mime.b64(crypto.hmac( crypto.sha256,canonicalizedHeaderString,ApplicationConfig.API_PRIVATE_KEY,true))
	headers["Authentication"] = authenticationkey
	local resbody = "emailAddress="..UserName.."&password="..Password.."&unitNumberOrDirectorName="..UnitNumber.."&"
	headers["Content-Type"] = "application/x-www-form-urlencoded"
	headers["Content-Length"]= string.len(resbody)


	request_value.url=ApplicationConfig.LOGIN_ACCESS
	request_value.headers = headers
	request_value.body = resbody

	request_value.method = method
	response = M.xmlParser( request_value )
	

	return response

end




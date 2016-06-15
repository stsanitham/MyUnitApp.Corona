
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



local function creatHeader(method,URL)

local request_value = {}
	local params = {}
	local headers = {}
	headers["Timestamp"] = os.date("!%A, %B %d, %Y %I:%M:%S %p")
	headers["IpAddress"] = Utility.getIpAddress()
	headers["UniqueId"] = system.getInfo("deviceID")
	headers["Accept"] = "application/json"
	headers["Content-Type"] = "application/json"
	method=method
	local url


		url = splitUrl(URL)


	local canonicalizedHeaderString = tostring(method .. "\n".. headers["Timestamp"] .. "\n"..url:lower())
	authenticationkey = ApplicationConfig.API_PUBLIC_KEY..":"..mime.b64(crypto.hmac( crypto.sha256,canonicalizedHeaderString,ApplicationConfig.API_PRIVATE_KEY,true))
	headers["Authentication"] = authenticationkey

	for row in db:nrows("SELECT * FROM logindetails WHERE id=1") do
		UserId = row.UserId
		AccessToken = row.AccessToken
		ContactId = row.ContactId

	end

	headers["UserAuthorization"]= UserId..":"..AccessToken..":"..ContactId

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




function Webservice.REQUEST_ACCESS(page,requestFromStatus,issentMail,issentText,directorName,directorEmail,firstName,lastName,Email,Phone,UnitNumber,Password,MKRank,Comment,postExecution)

	local request_value = {}
	local params = {}
	local headers = {}
	headers["Timestamp"] = os.date("!%A, %B %d, %Y %I:%M:%S %p")
	headers["IpAddress"] = Utility.getIpAddress()
	headers["UniqueId"] = system.getInfo("deviceID")
	headers["Accept"] = "application/json"
	headers["Content-Type"] = "application/json"

	method="POST"

	local v 

	local url = splitUrl(ApplicationConfig.REQUEST_ACCESS)
	local canonicalizedHeaderString = tostring(method .. "\n".. headers["Timestamp"] .. "\n"..url:lower())
	authenticationkey = ApplicationConfig.API_PUBLIC_KEY..":"..mime.b64(crypto.hmac( crypto.sha256,canonicalizedHeaderString,ApplicationConfig.API_PRIVATE_KEY,true))
	headers["Authentication"] = authenticationkey

		local found=false
		db:exec([[select * from sqlite_master where name='logindetails';]],
		function(...) found=true return 0 end)

		if found then 
		print('table exists!')

		for row in db:nrows("SELECT * FROM logindetails WHERE id=1") do
			UserId = row.UserId
			AccessToken = row.AccessToken
			ContactId = row.ContactId
			UnitNumberValue = row.UnitNumberOrDirector
			langid = row.LanguageId
			countryid = row.CountryId
		end

	          headers["UserAuthorization"]= UserId..":"..AccessToken..":"..ContactId

	    else

	    	  headers["UserAuthorization"]= ""

		end



    if page == "addNewAccessPage" then

		    v = 

			[[{
			  "FirstName": "]]..firstName..[[",
			  "LastName": "]]..lastName..[[",
			  "EmailAddress": "]]..Email..[[",
			  "UnitNumber": "]]..UnitNumberValue..[[",
			  "PhoneNumber": "]]..Phone..[[",
			  "Password": "]]..Password..[[",
			  "UserId": "]]..UserId..[[",
			  "Comments": "]]..Comment..[[",
			  "RequestFrom": "]]..requestFromStatus..[[",
			  "MkRankId": "]]..MKRank..[[",
			  "IsSendText": "]]..tostring(issentText)..[[",
			  "IsSendMail": "]]..tostring(issentMail)..[[",
			  "TypeLanguageCountry": {
			    "LanguageId": "]]..langid..[[",
			    "CountryId": "]]..countryid..[[",
			    
			  },
			  "IsTeamMember": true,
			}]]
	else

			 v = 

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
	  "UniqueId": "]]..headers["UniqueId"]..[[",
	  "MkRankId": "]]..MKRank..[[",
	  "TypeLanguageCountry": {
	    "LanguageId": 1,
	    "CountryId": 1,
	  },
	}]]
  
    end

	--headers["Content-Type"] = "application/x-www-form-urlencoded"
	--headers["Content-Length"]= string.len(v)

	params={headers = headers,body = v}

	print("Send Message Request :"..v)

	request.new( ApplicationConfig.REQUEST_ACCESS,method,params,postExecution)
	
	return response

end





function Webservice.SEND_MESSAGE(MessageId,ConversionFirstName,ConversionLastName,GroupName,DocumentUpload,MessageFileType,message,longmessage,IsScheduled,ScheduledDate,ScheduledTime,videopath,imagepath,imagename,imagesize,audiopath,audioname,audiosize,pushmethod,From,To,Message_Type,postExecution)

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
	local LastName

	for row in db:nrows("SELECT * FROM logindetails WHERE id=1") do
		print("UserId :"..row.UserId)
		UserId = row.UserId
		AccessToken = row.AccessToken
		ContactId = row.ContactId
		EmailAddess = row.EmailAddess
		LastName = row.MemberName

	end

	headers["UserAuthorization"]= UserId..":"..AccessToken..":"..ContactId

local v

if DocumentUpload == "" then
	DocumentUpload=  "' '"
else
	DocumentUpload = json.encode(DocumentUpload)
end

if Message_Type ~= nil and Message_Type ~= "" then

			v = [[

			{
			"MyUnitBuzzLongMessage": "]]..longmessage..[[",
			"MyUnitBuzzMessage": " ",
			"IsScheduled": " ",	
			"ScheduledDate": " ",	
			"ScheduledTime": " ",	
			"VideoFilePath": "]]..videopath..[[",
			"MessageStatus": "]]..pushmethod..[[",
			"MessageDate": "]]..os.date("%m/%d/%Y %I:%M:%S %p")..[[",
			"UserId": "]]..UserId..[[",
			"EmailAddress": "]]..EmailAddess..[[",
			"MyUnitBuzzMessageId": "]]..MessageId..[[",

			"AudioFilePath": "]]..audiopath..[[",
			"AudioFileName": "]]..audioname..[[",
			"AudioFileSize": "]]..audiosize..[[",
			"From": "]]..From..[[",
			"To": "]]..To..[[",
			"MessageType": "]]..Message_Type..[[",

			"TimeZone": "]]..TimeZone..[[",
			"ConversionFirstName": "]]..ConversionFirstName..[[",
			"ConversionLastName": "]]..ConversionLastName..[[",
			"FirstName": " ",
			"LastName": "]]..LastName..[[",
			"GroupName": "]]..GroupName..[[",
			"IsSendNow": "]]..tostring(isSendNow)..[[",
			"MessageFileType": "]]..MessageFileType..[[",
			"DocumentUpload": ]]..(DocumentUpload)..[[

			}
			]]

--			

else

		v = [[

		{
		"MyUnitBuzzMessage": "]]..message..[[",
		"MyUnitBuzzLongMessage": "]]..longmessage..[[",
		"IsScheduled": "]]..IsScheduled..[[",	
		"ScheduledDate": "]]..ScheduledDate..[[",	
		"ScheduledTime": "]]..ScheduledTime..[[",	
		"VideoFilePath": "]]..videopath..[[",
		"MessageStatus": "]]..pushmethod..[[",
		"MessageDate": "]]..os.date("%m/%d/%Y %I:%M:%S %p")..[[",
		"UserId": "]]..UserId..[[",
		"EmailAddress": "]]..EmailAddess..[[",
		"MyUnitBuzzMessageId": "]]..MessageId..[[",
		"AudioFilePath": "]]..audiopath..[[",
		"AudioFileName": "]]..audioname..[[",
		"AudioFileSize": "]]..audiosize..[[",
		"TimeZone": "]]..TimeZone..[[",
		"ConversionFirstName": "]]..ConversionFirstName..[[",
		"ConversionLastName": "]]..ConversionLastName..[[",
		"GroupName": "]]..GroupName..[[",
		"IsSendNow": "]]..tostring(isSendNow)..[[",
		"MessageFileType": "]]..MessageFileType..[[",
		"DocumentUpload": ]]..(DocumentUpload)..[[
		}
		]]
--		"DocumentUpload": ]]..json.encode(DocumentUpload)..[[

end


	params={headers = headers,body = v}

	print("Send Message Request :"..(v))


	       --        local options =
        -- {
        --    to = { "malarkodi.sellamuthu@w3magix.com,petchimuthu.p@w3magix.com"},
        --    subject = "request",
        --    isBodyHtml = true,
        --    body = ""..v,

        -- }
        -- native.showPopup( "mail", options )


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

	print( "Method URL : "..url )
	
	local canonicalizedHeaderString = tostring(method .. "\n".. headers["Timestamp"] .. "\n"..url:lower())
	authenticationkey = ApplicationConfig.API_PUBLIC_KEY..":"..mime.b64(crypto.hmac( crypto.sha256,canonicalizedHeaderString,ApplicationConfig.API_PRIVATE_KEY,true))
	headers["Authentication"] = authenticationkey

--native.showAlert( "test", Unique_Id , { "ok"} )

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

	print("url :"..json.encode(headers))
	
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



function Webservice.GetContactInformation(contactId,postExecution)
	local request_value = {}
	local params = {}
	local headers = {}
	headers["Timestamp"] = os.date("!%A, %B %d, %Y %I:%M:%S %p")
	headers["IpAddress"] = Utility.getIpAddress()
	headers["UniqueId"] = system.getInfo("deviceID")
	headers["Accept"] = "application/json"
	headers["Content-Type"] = "application/json"
	method="GET"

	local url = splitUrl(ApplicationConfig.GetContactInformation)
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

	request.new(ApplicationConfig.GetContactInformation.."?"..resbody,method,params,postExecution)
	
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

function Webservice.Get_SocialMediaTokens(GCM,postExecution)
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


		local Device_OS = system.getInfo("platformName")
		local Unique_Id = system.getInfo("deviceID")
		--local Manufacturer = system.getInfo("targetAppStore")
		local Model = system.getInfo("model")
		local Version = system.getInfo("appVersionString")


	local bodyContent= [["MobDevice":
	{
		"DOS": "]] .. Device_OS .. [[",
		"UQId": "]] .. Unique_Id .. [[",
		"MOD": "]] .. Model .. [[",
		"DN": "]] .. Model .. [[",
		"Ver": "]] .. Version .. [[",
		"GCMUQId": "]] .. GCM .. [[",
		
	}]]

	headers["UserAuthorization"]= UserId..":"..AccessToken..":"..ContactId

	local url = splitUrl(ApplicationConfig.GetSocialMediaTokens)
	local canonicalizedHeaderString = tostring(method .. "\n".. headers["Timestamp"] .. "\n"..url:lower())
	authenticationkey = ApplicationConfig.API_PUBLIC_KEY..":"..mime.b64(crypto.hmac( crypto.sha256,canonicalizedHeaderString,ApplicationConfig.API_PRIVATE_KEY,true))
	headers["Authentication"] = authenticationkey

	print( "GCM : "..GCM )
	local resbody = ""
	resbody = resbody.."userId="..UserId.."&contactId="..ContactId

	headers["Content-Type"] = "application/x-www-form-urlencoded"
	headers["Content-Length"]= string.len(resbody)

			
	params={headers = headers,body = bodyContent}

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

	

	authenticationkey = ApplicationConfig.API_PUBLIC_KEY..":"..mime.b64(crypto.hmac( crypto.sha256,canonicalizedHeaderString,ApplicationConfig.API_PRIVATE_KEY,true))
	headers["Authentication"] = authenticationkey

	print("time : "..headers["Timestamp"])
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

function Webservice.GetUserPreferencebyUserId(postExecution)
local request_value = {}
    local params = {}
    local headers = {}
    headers["Timestamp"] = os.date("!%A, %B %d, %Y %I:%M:%S %p")
    headers["IpAddress"] = Utility.getIpAddress()
    headers["UniqueId"] = system.getInfo("deviceID")
    headers["Accept"] = "application/json"
    headers["Content-Type"] = "application/json"
    method="GET"

    local url = splitUrl(ApplicationConfig.GetUserPreferencebyUserId)

    local canonicalizedHeaderString = tostring(method .. "\n".. headers["Timestamp"] .. "\n"..url:lower())

	print("canonicalizedHeaderString : "..canonicalizedHeaderString)

	authenticationkey = ApplicationConfig.API_PUBLIC_KEY..":"..mime.b64(crypto.hmac( crypto.sha256,canonicalizedHeaderString,ApplicationConfig.API_PRIVATE_KEY,true))
	headers["Authentication"] = authenticationkey

	    for row in db:nrows("SELECT * FROM logindetails WHERE id=1") do
        UserId = row.UserId
        AccessToken = row.AccessToken
        ContactId = row.ContactId

    end

    headers["UserAuthorization"]= UserId..":"..AccessToken..":"..ContactId

	print( authenticationkey )
	params={headers = headers}

	local resbody = "userId="..UserId


	request.new( ApplicationConfig.GetUserPreferencebyUserId.."?"..resbody,method,params,postExecution)

	return response

end

function Webservice.CreateTickler(id,TicklerId,isUpdate,CalendarId,CalendarName,TicklerType,TicklerStatus,title,startdate,enddate,starttime,endtime,allDay,Location,Description,AppointmentPurpose,AppointmentPurposeOther,Priority,Contact,Invitees,AttachmentName,AttachmentPath,Attachment,PhoneNumber,AccessCode,IsConference,CallDirection,colorCode,postExecution)

--CalendarId,CalendarName,TicklerType,TicklerStatus,title,startdate,enddate,starttime,endtime,allDay,Location,Description,AppointmentPurpose,AppointmentPurposeOther,Priority,Contact,Invitees,PhoneNumber,AccessCode,IsConference,CallDirection,colorCode

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

if  Invitees ~= nil then
	if Invitees.name ~= nil then
		invitees = json.encode(Invitees)

	end

else

	Invitees="''"

end


if Contact.name ~= nil or Contact ~= "" then

	contactInfo = json.encode(Contact)

else

	Contact="''"

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
		"AppointmentPurpose":  ']]..check(AppointmentPurpose)..[[',
		"AppointmentPurposeOther":  ']]..AppointmentPurposeOther..[[',
		"Priority":  ]]..Priority..[[,
		"TimeZone": ']]..TimeZone..[[',
		"ColorCode":']]..colorCode..[[',
		"EventAccess":"PUBLIC",
		"AttachmentName": ']]..check(AttachmentName)..[[',
		"AttachmentPath": ']]..check(AttachmentPath)..[[',
		"Attachment":  ']]..check(Attachment)..[[',
		"Contact":]]..contactInfo..[[,
		"Invitees":[]]..invitees..[[],
		"PhoneNumber":']]..PhoneNumber..[[',
		"AccessCode":']]..AccessCode..[[',
		"IsConference":]]..tostring(IsConference)..[[,
		"CallDirection":]]..tostring(CallDirection)..[[
	
		}
		]]



	params={headers = headers,body = resbody}

		print("request : "..resbody)


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

		if MkRankId == nil then
			MkRankId=""
		end

    if idvalue == "Deny Access" then

    	isSentText = false

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

function Webservice.GetMyUnitBuzzRequestAccessPermissionsDetail(requestId,RequestFrom,Status,postExecution)

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

	local url = splitUrl(ApplicationConfig.GetMyUnitBuzzRequestAccessPermissionsDetail)
	local canonicalizedHeaderString = tostring(method .. "\n".. headers["Timestamp"] .. "\n"..url:lower())

	authenticationkey = ApplicationConfig.API_PUBLIC_KEY..":"..mime.b64(crypto.hmac( crypto.sha256,canonicalizedHeaderString,ApplicationConfig.API_PRIVATE_KEY,true))
	headers["Authentication"] = authenticationkey



	local resbody="?myUnitBuzzRequestAccessId="..requestId.."&getRquestAccessFrom="..RequestFrom.."&accessStatus="..Status
	params={headers = headers}

	request.new(ApplicationConfig.GetMyUnitBuzzRequestAccessPermissionsDetail..resbody,method,params,postExecution)

    print("request : "..json.encode(params))

	
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


function Webservice.GetActiveChatTeammembersList(status,postExecution)
	local request_value = {}
	local params = {}
	local headers = {}
	headers["Timestamp"] = os.date("!%A, %B %d, %Y %I:%M:%S %p")
	headers["IpAddress"] = Utility.getIpAddress()
	headers["UniqueId"] = system.getInfo("deviceID")
	headers["Accept"] = "application/json"
	headers["Content-Type"] = "application/json"
	method="GET"


	local url = splitUrl(ApplicationConfig.GetActiveChatTeammembersList)
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

   local resbody = "UserId="..UserId

	params={headers = headers}

	print("request : "..json.encode(params))

	request.new(ApplicationConfig.GetActiveChatTeammembersList.."?"..resbody,method,params,postExecution)
	
	return response
end


function Webservice.CheckExistsRequestStatus(contactid_val,emailvalue,postExecution)
	local request_value = {}
	local params = {}
	local headers = {}
	headers["Timestamp"] = os.date("!%A, %B %d, %Y %I:%M:%S %p")
	headers["IpAddress"] = Utility.getIpAddress()
	headers["UniqueId"] = system.getInfo("deviceID")
	headers["Accept"] = "application/json"
	headers["Content-Type"] = "application/json"
	method="POST"


	local url = splitUrl(ApplicationConfig.CheckExistsRequestStatus)
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
	 --  "ContactId": ']]..Contactid_value..[[',
	 --  "EmailAddress": ']]..emailvalue..[[',
	 --  "MyUnitBuzzRequestAccessId": ']]..Contactid_value..[[',
	 --   } ]]

	 		local resbody = [[{
	  "UserId": ']]..UserId..[[',
	  "ContactId": ']]..contactid_val..[[',
	  "EmailAddress": ']]..emailvalue..[[',
	  "MyUnitBuzzRequestAccessId": ']]..contactid_val..[[',
	   } ]]


    params={headers = headers,body = resbody}

	print("request : "..json.encode(params))

	request.new(ApplicationConfig.CheckExistsRequestStatus,method,params,postExecution)
	
	return response
	
end




function Webservice.CreateMessageChatGroup(groupname,description,stateinfo,grouptypevalue,postExecution)
	local request_value = {}
	local params = {}
	local headers = {}
	headers["Timestamp"] = os.date("!%A, %B %d, %Y %I:%M:%S %p")
	headers["IpAddress"] = Utility.getIpAddress()
	headers["UniqueId"] = system.getInfo("deviceID")
	headers["Accept"] = "application/json"
	headers["Content-Type"] = "application/json"
	method="POST"

	local url = splitUrl(ApplicationConfig.CreateMessageChatGroup)
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
    

    local resbody

	if grouptypevalue == "BROADCAST" then

		  resbody = [[{
		  "UserId": "]]..UserId..[[",
		  "MyUnitBuzzGroupName": "]]..groupname..[[",
		  "Description": "]]..description..[[",
		  "IsActive": "]]..tostring(stateinfo)..[[",
		  "MyUnitBuzzGroupType": "]]..grouptypevalue..[[",
		  "ContactId":"]]..ContactId..[[",
		   } ]]

	else

		  resbody = [[{
		  "UserId": "]]..UserId..[[",
		  "MyUnitBuzzGroupName": "]]..groupname..[[",
		  "Description": "]]..description..[[",
		  "IsActive": "]]..tostring(stateinfo)..[[",
		  "MyUnitBuzzGroupType": "]]..grouptypevalue..[[",
		   } ]]

	end

    params={headers = headers,body = resbody}

	print("create group request : "..json.encode(params))

	request.new(ApplicationConfig.CreateMessageChatGroup,method,params,postExecution)
	
	return response
	
end





function Webservice.GetChatMessageGroupList(groupType,postExecution)
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

	local url = splitUrl(ApplicationConfig.GetChatMessageGroupList)
	local canonicalizedHeaderString = tostring(method .. "\n".. headers["Timestamp"] .. "\n"..url:lower())
	authenticationkey = ApplicationConfig.API_PUBLIC_KEY..":"..mime.b64(crypto.hmac( crypto.sha256,canonicalizedHeaderString,ApplicationConfig.API_PRIVATE_KEY,true))
	headers["Authentication"] = authenticationkey

	headers["UserAuthorization"]= UserId..":"..AccessToken..":"..ContactId

    local resbody = "?userId="..UserId.."&contactId="..ContactId.."&groupType="..groupType

	params={headers = headers}

	print("request : "..json.encode(params))

	request.new(ApplicationConfig.GetChatMessageGroupList..resbody,method,params,postExecution)
	
	return response
end






function Webservice.AddTeamMemberToChatGroup(grouptypevalue,groupid,contacts,postExecution)
	local request_value = {}
	local params = {}
	local headers = {}
	headers["Timestamp"] = os.date("!%A, %B %d, %Y %I:%M:%S %p")
	headers["IpAddress"] = Utility.getIpAddress()
	headers["UniqueId"] = system.getInfo("deviceID")
	headers["Accept"] = "application/json"
	headers["Content-Type"] = "application/json"
	method="POST"

	local url = splitUrl(ApplicationConfig.AddTeamMemberToChatGroup)
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

    local resbody = "userId="..UserId.."&groupId="..groupid


	    if grouptypevalue == "GROUP" then

	    contacts[#contacts+1] = ContactId

	    groupmembers = json.encode(contacts)

	    else

	    contacts[#contacts+1] = ""

	    groupmembers = json.encode(contacts)

	    end


    params={headers = headers,body = groupmembers}

	print("contact request : "..json.encode(params))

	request.new(ApplicationConfig.AddTeamMemberToChatGroup.."?"..resbody,method,params,postExecution)
	
	return response
	
end







function Webservice.GetMessagessListbyMessageStatus(status,postExecution)
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

	local url = splitUrl(ApplicationConfig.GetMessagessListbyMessageStatus)
	local canonicalizedHeaderString = tostring(method .. "\n".. headers["Timestamp"] .. "\n"..url:lower())
	authenticationkey = ApplicationConfig.API_PUBLIC_KEY..":"..mime.b64(crypto.hmac( crypto.sha256,canonicalizedHeaderString,ApplicationConfig.API_PRIVATE_KEY,true))
	headers["Authentication"] = authenticationkey

	headers["UserAuthorization"]= UserId..":"..AccessToken..":"..ContactId

    local resbody = "?userId="..UserId.."&status="..status

	params={headers = headers}

	print("request : "..json.encode(params))

	request.new(ApplicationConfig.GetMessagessListbyMessageStatus..resbody,method,params,postExecution)
	
	return response
end



function Webservice.GetMessagessListbyMessageStatus(status,postExecution)
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

	local url = splitUrl(ApplicationConfig.GetMessagessListbyMessageStatus)
	local canonicalizedHeaderString = tostring(method .. "\n".. headers["Timestamp"] .. "\n"..url:lower())
	authenticationkey = ApplicationConfig.API_PUBLIC_KEY..":"..mime.b64(crypto.hmac( crypto.sha256,canonicalizedHeaderString,ApplicationConfig.API_PRIVATE_KEY,true))
	headers["Authentication"] = authenticationkey

	headers["UserAuthorization"]= UserId..":"..AccessToken..":"..ContactId

    local resbody = "?userId="..UserId.."&status="..status

	params={headers = headers}

	print("request : "..json.encode(params))

	request.new(ApplicationConfig.GetMessagessListbyMessageStatus..resbody,method,params,postExecution)
	
	return response
end



function Webservice.GetMessagessListbyMessageStatus(status,count,pagevalue,postExecution)
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

	local url = splitUrl(ApplicationConfig.GetMessagessListbyMessageStatus)
	local canonicalizedHeaderString = tostring(method .. "\n".. headers["Timestamp"] .. "\n"..url:lower())
	authenticationkey = ApplicationConfig.API_PUBLIC_KEY..":"..mime.b64(crypto.hmac( crypto.sha256,canonicalizedHeaderString,ApplicationConfig.API_PRIVATE_KEY,true))
	headers["Authentication"] = authenticationkey

	headers["UserAuthorization"]= UserId..":"..AccessToken..":"..ContactId

    local resbody = "?userId="..UserId.."&status="..status.."&pageSize="..count.."&page="..pagevalue

	params={headers = headers}

	print("request : "..json.encode(params))

	request.new(ApplicationConfig.GetMessagessListbyMessageStatus..resbody,method,params,postExecution)
	
	return response
end



function Webservice.DeleteMyUnitBuzzMessages(messageId,postExecution)
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

	local url = splitUrl(ApplicationConfig.DeleteMyUnitBuzzMessages)
	local canonicalizedHeaderString = tostring(method .. "\n".. headers["Timestamp"] .. "\n"..url:lower())
	authenticationkey = ApplicationConfig.API_PUBLIC_KEY..":"..mime.b64(crypto.hmac( crypto.sha256,canonicalizedHeaderString,ApplicationConfig.API_PRIVATE_KEY,true))
	headers["Authentication"] = authenticationkey

	headers["UserAuthorization"]= UserId..":"..AccessToken..":"..ContactId

    local resbody = "?userId="..UserId.."&myUnitBuzzMessageId="..messageId

	params={headers = headers}

	print("request : "..json.encode(params))

	request.new(ApplicationConfig.DeleteMyUnitBuzzMessages..resbody,method,params,postExecution)
	
	return response
end



function Webservice.GetMessageGroupTeamMemberList(groupid,groupType,postExecution)

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

	local url = splitUrl(ApplicationConfig.GetMessageGroupTeamMemberList)
	local canonicalizedHeaderString = tostring(method .. "\n".. headers["Timestamp"] .. "\n"..url:lower())

	authenticationkey = ApplicationConfig.API_PUBLIC_KEY..":"..mime.b64(crypto.hmac( crypto.sha256,canonicalizedHeaderString,ApplicationConfig.API_PRIVATE_KEY,true))
	headers["Authentication"] = authenticationkey



	local resbody="?userId="..UserId.."&groupId="..groupid.."&groupType="..groupType
	params={headers = headers}

	request.new(ApplicationConfig.GetMessageGroupTeamMemberList..resbody,method,params,postExecution)

    print("request : "..json.encode(params))

	
	return response
end




function Webservice.UpdateLastActivityDate(postExecution)

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

	local url = splitUrl(ApplicationConfig.UpdateLastActivityDate)
	local canonicalizedHeaderString = tostring(method .. "\n".. headers["Timestamp"] .. "\n"..url:lower())

	authenticationkey = ApplicationConfig.API_PUBLIC_KEY..":"..mime.b64(crypto.hmac( crypto.sha256,canonicalizedHeaderString,ApplicationConfig.API_PRIVATE_KEY,true))
	headers["Authentication"] = authenticationkey



	local resbody="?userId="..UserId.."&contactId="..ContactId
	params={headers = headers}

	request.new(ApplicationConfig.UpdateLastActivityDate..resbody,method,params,postExecution)

    print("request : "..json.encode(params))

	
	return response
end





function Webservice.GetAllSpecialRecognitions(postExecution)

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

	local url = splitUrl(ApplicationConfig.GetAllSpecialRecognitions)
	local canonicalizedHeaderString = tostring(method .. "\n".. headers["Timestamp"] .. "\n"..url:lower())

	authenticationkey = ApplicationConfig.API_PUBLIC_KEY..":"..mime.b64(crypto.hmac( crypto.sha256,canonicalizedHeaderString,ApplicationConfig.API_PRIVATE_KEY,true))
	headers["Authentication"] = authenticationkey


	local resbody="?userId="..UserId

	params={headers = headers}

	request.new(ApplicationConfig.GetAllSpecialRecognitions..resbody,method,params,postExecution)

    print("request for special recognition list : "..json.encode(params))

	
	return response
end




function Webservice.GetSpecialRecognitionPageContent(sr_eventid,postExecution)

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

	local url = splitUrl(ApplicationConfig.GetSpecialRecognitionPageContent)
	local canonicalizedHeaderString = tostring(method .. "\n".. headers["Timestamp"] .. "\n"..url:lower())

	authenticationkey = ApplicationConfig.API_PUBLIC_KEY..":"..mime.b64(crypto.hmac( crypto.sha256,canonicalizedHeaderString,ApplicationConfig.API_PRIVATE_KEY,true))
	headers["Authentication"] = authenticationkey


	local resbody="?userId="..UserId.."&specialRecognitionId="..sr_eventid

	params={headers = headers}

	request.new(ApplicationConfig.GetSpecialRecognitionPageContent..resbody,method,params,postExecution)

    print("request for special recognition details with report type 1 : "..json.encode(params))

	
	return response
end






function Webservice.GetSpecialRecognitionJsonContent(sr_eventid,postExecution)

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

	local url = splitUrl(ApplicationConfig.GetSpecialRecognitionJsonContent)
	local canonicalizedHeaderString = tostring(method .. "\n".. headers["Timestamp"] .. "\n"..url:lower())

	authenticationkey = ApplicationConfig.API_PUBLIC_KEY..":"..mime.b64(crypto.hmac( crypto.sha256,canonicalizedHeaderString,ApplicationConfig.API_PRIVATE_KEY,true))
	headers["Authentication"] = authenticationkey


	local resbody="?userId="..UserId.."&specialRecognitionId="..sr_eventid

	params={headers = headers}

	request.new(ApplicationConfig.GetSpecialRecognitionJsonContent..resbody,method,params,postExecution)

    print("request for special recognition details with report type  : "..json.encode(params))

	
	return response
end





function Webservice.GetAllCountry(postExecution)

	local request_value = {}
	local params = {}
	local headers = {}
	headers["Timestamp"] = os.date("!%A, %B %d, %Y %I:%M:%S %p")
	headers["IpAddress"] = Utility.getIpAddress()
	headers["UniqueId"] = system.getInfo("deviceID")
	headers["Accept"] = "application/json"
	headers["Content-Type"] = "application/json"

	method="GET"


		local found=false
		db:exec([[select * from sqlite_master where name='logindetails';]],
		function(...) found=true return 0 end)

		if found then 
		print('table exists!')

		for row in db:nrows("SELECT * FROM logindetails WHERE id=1") do
			UserId = row.UserId
			AccessToken = row.AccessToken
			ContactId = row.ContactId
			UnitNumberValue = row.UnitNumberOrDirector
			langid = row.LanguageId
			countryid = row.CountryId
		end

	          headers["UserAuthorization"]= UserId..":"..AccessToken..":"..ContactId

	    else

	    	  headers["UserAuthorization"]= ""

		end


	local url = splitUrl(ApplicationConfig.GetAllCountry)
	local canonicalizedHeaderString = tostring(method .. "\n".. headers["Timestamp"] .. "\n"..url:lower())

	authenticationkey = ApplicationConfig.API_PUBLIC_KEY..":"..mime.b64(crypto.hmac( crypto.sha256,canonicalizedHeaderString,ApplicationConfig.API_PRIVATE_KEY,true))
	headers["Authentication"] = authenticationkey

	params={headers = headers}

	request.new(ApplicationConfig.GetAllCountry,method,params,postExecution)

    print("Get all country request : "..json.encode(params))

	
	return response
end






function Webservice.GetCountryLanguagesbyCountryCode(countrycode,postExecution)

	local request_value = {}
	local params = {}
	local headers = {}
	headers["Timestamp"] = os.date("!%A, %B %d, %Y %I:%M:%S %p")
	headers["IpAddress"] = Utility.getIpAddress()
	headers["UniqueId"] = system.getInfo("deviceID")
	headers["Accept"] = "application/json"
	headers["Content-Type"] = "application/json"

	method="GET"


		local found=false
		db:exec([[select * from sqlite_master where name='logindetails';]],
		function(...) found=true return 0 end)

		if found then 
		print('table exists!')

		for row in db:nrows("SELECT * FROM logindetails WHERE id=1") do
			UserId = row.UserId
			AccessToken = row.AccessToken
			ContactId = row.ContactId
			UnitNumberValue = row.UnitNumberOrDirector
			langid = row.LanguageId
			countryid = row.CountryId
		end

	          headers["UserAuthorization"]= UserId..":"..AccessToken..":"..ContactId

	    else

	    	  headers["UserAuthorization"]= ""

		end


	local url = splitUrl(ApplicationConfig.GetCountryLanguagesbyCountryCode)
	local canonicalizedHeaderString = tostring(method .. "\n".. headers["Timestamp"] .. "\n"..url:lower())

	authenticationkey = ApplicationConfig.API_PUBLIC_KEY..":"..mime.b64(crypto.hmac( crypto.sha256,canonicalizedHeaderString,ApplicationConfig.API_PRIVATE_KEY,true))
	headers["Authentication"] = authenticationkey


	local resbody="?countryCode="..countrycode

	params={headers = headers}

	request.new(ApplicationConfig.GetCountryLanguagesbyCountryCode..resbody,method,params,postExecution)

    print("request for registration languages details ########## : "..json.encode(params))
	
	return response
end







function Webservice.GetPositionbyCountryIdandLanguageId(countrycode,languageid,postExecution)

	local request_value = {}
	local params = {}
	local headers = {}
	headers["Timestamp"] = os.date("!%A, %B %d, %Y %I:%M:%S %p")
	headers["IpAddress"] = Utility.getIpAddress()
	headers["UniqueId"] = system.getInfo("deviceID")
	headers["Accept"] = "application/json"
	headers["Content-Type"] = "application/json"

	method="GET"


		local found=false
		db:exec([[select * from sqlite_master where name='logindetails';]],
		function(...) found=true return 0 end)

		if found then 
		print('table exists!')

		for row in db:nrows("SELECT * FROM logindetails WHERE id=1") do
			UserId = row.UserId
			AccessToken = row.AccessToken
			ContactId = row.ContactId
			UnitNumberValue = row.UnitNumberOrDirector
			langid = row.LanguageId
			countryid = row.CountryId
		end

	          headers["UserAuthorization"]= UserId..":"..AccessToken..":"..ContactId

	    else

	    	  headers["UserAuthorization"]= ""

		end


	local url = splitUrl(ApplicationConfig.GetPositionbyCountryIdandLanguageId)
	local canonicalizedHeaderString = tostring(method .. "\n".. headers["Timestamp"] .. "\n"..url:lower())

	authenticationkey = ApplicationConfig.API_PUBLIC_KEY..":"..mime.b64(crypto.hmac( crypto.sha256,canonicalizedHeaderString,ApplicationConfig.API_PRIVATE_KEY,true))
	headers["Authentication"] = authenticationkey


	local resbody="?countryCode="..countrycode.."&languageId="..languageid

	params={headers = headers}

	request.new(ApplicationConfig.GetPositionbyCountryIdandLanguageId..resbody,method,params,postExecution)

    print("request for special recognition position details : "..json.encode(params))

	
	return response
end








function Webservice.MubDirectorRegister(FirstName,LastName,EmailAddress,PhoneNumber,MaryKayId,Country,Language,PositionId,postExecution)
	
	local request_value = {}
	local params = {}
	local headers = {}
	headers["Timestamp"] = os.date("!%A, %B %d, %Y %I:%M:%S %p")
	headers["IpAddress"] = Utility.getIpAddress()
	headers["UniqueId"] = system.getInfo("deviceID")
	headers["Accept"] = "application/json"
	headers["Content-Type"] = "application/json"
	method="POST"


	local url = splitUrl(ApplicationConfig.MubDirectorRegister)
	local canonicalizedHeaderString = tostring(method .. "\n".. headers["Timestamp"] .. "\n"..url:lower())
	authenticationkey = ApplicationConfig.API_PUBLIC_KEY..":"..mime.b64(crypto.hmac( crypto.sha256,canonicalizedHeaderString,ApplicationConfig.API_PRIVATE_KEY,true))
	headers["Authentication"] = authenticationkey


		local found=false
		db:exec([[select * from sqlite_master where name='logindetails';]],
		function(...) found=true return 0 end)

		if found then 
				print('table exists!')

				for row in db:nrows("SELECT * FROM logindetails WHERE id=1") do
					UserId = row.UserId
					AccessToken = row.AccessToken
					ContactId = row.ContactId
					UnitNumberValue = row.UnitNumberOrDirector
					langid = row.LanguageId
					countryid = row.CountryId
				end

	            headers["UserAuthorization"]= UserId..":"..AccessToken..":"..ContactId

	    else

	    	    headers["UserAuthorization"]= ""

		end


		 local resbody = [[{

		    "FirstName": ']]..FirstName..[[',
		    "LastName": ']]..LastName..[[',
		    "EmailAddress": ']]..EmailAddress..[[',
		    "PhoneNumber": ']]..PhoneNumber..[[',
			"MaryKayId": ']]..MaryKayId..[[',
			"Country": ]]..Country..[[,
			"Language": ]]..Language..[[,
			"Position": ]]..PositionId..[[,
		
		} ]]


    params={headers = headers,body = resbody}

	print("request for MUB Director Register : "..resbody)

	request.new(ApplicationConfig.MubDirectorRegister,method,params,postExecution)
	
	return response
	
end










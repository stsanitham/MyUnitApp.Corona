local network = require('network')
local json = require('json')
local Applicationconfig = require("Utils.ApplicationConfig")

local request = {}

local count ={}


local requestid

local function splitUrl( URL )
    return URL:gsub(ApplicationConfig.BASE_URL,"")   
end


function request.new(url, method, params,listner)

   
    print("enter "..url)

    spinner_show()


    if string.find(url,"/MyUnitBuzz/GetListOfMkRanks") or string.find(url,"/MyUnitBuzzCheckExistsRequestStatus") or string.find(url,"/MyUnitBuzz/MyUnitBuzzRequestAccess") or string.find(url,"/MyUnitBuzzCalendar/CreateQuickcContact") or string.find(url,"/MyUnitBuzz/CheckNotInUnitWiseRegister") or string.find(url,"/MyUnitBuzz/SaveMyUnitBuzzMessages") or string.find(url,"/MyUnitBuzz/IsUserAvailable") or string.find(url,"/MyUnitBuzz/GetChatUnReadMessagesList") or string.find(url,"/MyUnitBuzz/UpdateLastChatSyncDate") then

    spinner.isVisible=false

end

requestId = network.request( url, method, function(event)  if ( event.isError ) then

    print( "Network error!" ,event.response)

    spinner_hide()


--             local options =
-- {
--    to = { "malarkodi.sellamuthu@w3magix.com"},
--    subject = "bug",
--    isBodyHtml = true,
--    body = ""..event.response,

-- }
-- native.showPopup( "mail", options )

else
   
    print ( "URL : "..url.."\n\n RESPONSE: " .. event.response )

    local response

     if string.find(url,"/MyUnitBuzz/GetSpecialRecognitionJsonContent") then


         response = json.decode(event.response)
         --response = (event.response)

     else


        response = json.decode(event.response)

    end


    spinner_hide()

    listner(response)


    end end, params )


    --[[if(url:sub(1,string.find(url,"?")-1) == "http://api.myunitapp.dotnetethic.com/MyUnitBuzz/GetSearchByUnitNumberOrDirectorName") then
       

    end]]


end

return request
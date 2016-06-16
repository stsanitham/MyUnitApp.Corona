--------------------------------------------------------
-- MainActivity
--------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )
local composer = require "composer"
local newPanel = require "Utils.newPanel"
local widget = require( "widget" )
local Utility = require( "Utils.Utility" )
EventCalender = require( "res.value.color" )
local sqlite3 = require( "sqlite3" )
local json = require( "json" )
MyUnitBuzzString = require( "res.value.string" )
local Applicationconfig = require("Utils.ApplicationConfig")
local notifications = require( "plugin.notifications" )
local isSendNow
widget.setTheme( "widget_theme_ios" )

--local OneSignal = require("plugin.OneSignal")
GCMValue = 0
ga = require("Utils.GoogleAnalytics.ga")

local launchArgs = ...

pushArray = {}

notificationFlag=false

IsOwner = false

leftPadding_value = 20

TimeZone = ""

chatReceivedFlag=false

--com.spanenterprises.MUBDev

--CommonApp/DirectorApp


AppName = "CommonApp"

environment = system.getInfo( "environment" )

Director_Name = ""

if AppName == "DirectorApp" then
	Unitnumber_value = "123"
else
	Unitnumber_value = ""
end

UnitnumberList = {}

MainGroup = display.newGroup();

popUpGroup = display.newGroup();

AlertGroup = display.newGroup();

chatGroup = display.newGroup();

NewGroupAlert = display.newGroup();

DeleteMessageGroup = display.newGroup();

ScheduledMessageGroup = display.newGroup();

ImageFullViewGroup = display.newGroup();




local W,H = display.contentWidth, display.contentHeight;
NavigationSpeed = 400;
menuShowFlag = false;
menuTransTime = 600;
openPage="main"

isSimulator=false
isAndroid = false
isIos = false
isFacebook = false
isTwitter = false
isGoogle = false

local plateform = system.getInfo( "platformName" )



if plateform == "Mac OS X" or plateform == "Win" then
    isSimulator=true
elseif plateform == "iPhone OS" then
    isIos=true
elseif plateform == "Android" then
    isAndroid=true
end


snackGroup = display.newGroup()
local path = system.pathForFile( "MyUnitBuzz.db", system.DocumentsDirectory )
local db = sqlite3.open( path )


   function scrollTo( position )
        MainGroup.y = position
    end


--changes from mac
local options = {
    width = 32,
    height = 32,
    numFrames = 4,
    sheetContentWidth = 64,
    sheetContentHeight = 64
}
local spinnerSingleSheet = graphics.newImageSheet( "res/assert/processer.png", options )


function SpinneBgtouch(event)
    if event.phase == "ended" then

    end
return true
end

spinner = widget.newSpinner
{
    width = 106/4 ,
    height = 111/4,
    deltaAngle = 10,
    sheet = spinnerSingleSheet,
    startFrame = 1,
    incrementEvery = 20
}

spinner.x=W/2;spinner.y=H/2-45
spinner.isVisible=false

spinnerBg = display.newRect(W/2,H/2,W,H)
spinnerBg.alpha=0
spinnerBg:addEventListener( "touch", SpinneBgtouch )



function spinner_show ()
    spinner.isVisible=true
    spinner:toFront()
    spinnerBg:toFront( )
    spinnerBg.alpha=0.01
    spinner:start()

end


function spinner_hide ()
    spinner.y=H/2-45
    spinner.isVisible=false
    spinnerBg:toBack( )
    spinnerBg.alpha=1
    spinner:toBack()
    spinner:stop()
end



local function panelTransDone( target )
	if ( target.completeState ) then
		print( "PANEL STATE IS: "..target.completeState )
	end
end



function slideAction()
	if(menuShowFlag) then

		transition.to( MainGroup, { time=menuTransTime,x=0,transition=easing.outCubic} )
		panel:hide();
		menuShowFlag =false

	else

		transition.to( MainGroup, { time=menuTransTime,x=panel.width,transition=easing.outCubic} )
		panel:show();
		menuShowFlag =true

	end

end



function menuTouch( event )

	if(event.phase == "began") then
        
		display.getCurrentStage():setFocus( event.target )

		elseif(event.phase == "ended") then

		display.getCurrentStage():setFocus( nil )

		slideAction()

	end

	return true;
end



panel = widget.newPanel{
location = "left",
onComplete = panelTransDone,
width = display.contentWidth * 0.8,
height = H,
speed = menuTransTime,
inEasing = easing.outCubic,
outEasing = easing.outCubic
}


composer.gotoScene( "Controller.splashScreen")

   
--composer.gotoScene( "Controller.pushNotificationPage")



if launchArgs and launchArgs.notification then
     local additionalData,message
            if isAndroid then
                additionalData = launchArgs.notification.androidGcmBundle
                message = additionalData.contents
            elseif isIos then
               additionalData = launchArgs.notification.custom.data
                message = launchArgs.notification.alert
            end

             chatReceivedFlag=true

          if additionalData.messageType ~= nil then

            

        local UserId,ContactId,Name,FromName,GroupName

            for row in db:nrows("SELECT * FROM logindetails WHERE id=1") do
                    UserId = row.UserId
                    ContactId = row.ContactId
                    Name = row.MemberName

            end


        
                Message_date=os.date("!%Y-%m-%dT%H:%M:%S")

                        isDeleted="false"
                        Created_TimeStamp=os.date("!%Y-%m-%dT%H:%M:%S")
                        Updated_TimeStamp=os.date("!%Y-%m-%dT%H:%M:%S")
                        ImagePath=additionalData.image or ""
                        AudioPath=additionalData.audio or ""
                        VideoPath=additionalData.audio or ""
                        MyUnitBuzz_LongMessage=tostring(message)
                        From=additionalData.messageFrom
                        To=additionalData.messageTo
                        Message_Type = additionalData.messageType



                            if additionalData.fFN ~= nil then
                                Name=additionalData.fFN.." "..additionalData.fLN

                            else

                                Name=additionalData.fLN

                            end

                            GroupName=""

                            if Message_Type == "GROUP" then
                                 GroupName=additionalData.gn
                                 FromName=""
                            else


                                   if additionalData.tFN ~= nil then
                                        FromName=additionalData.tFN.." "..additionalData.tLN

                                    else

                                        FromName=additionalData.tLN

                                    end

                            end
            
                    

                        local insertQuery = [[INSERT INTO pu_MyUnitBuzz_Message VALUES (NULL, ']]..UserId..[[',']]..Utils.encrypt(tostring(message))..[[','UPDATE',']]..Message_date..[[',']]..isDeleted..[[',']]..Created_TimeStamp..[[',']]..Updated_TimeStamp..[[',']]..ImagePath..[[',']]..AudioPath..[[',']]..VideoPath..[[',']]..MyUnitBuzz_LongMessage..[[',']]..From..[[',']]..To..[[',']]..Message_Type..[[',']]..Name..[[',']]..FromName..[[',']]..GroupName..[[');]]
                        db:exec( insertQuery )


                        

                        if openPage ~= "MessagingPage" and openPage ~= "main" then


                           --local alert = native.showAlert( "MyUnitBuzz", tostring(message), { "OK" } )
                                 
                        end
       
          
        else

             notificationFlag = true

                if (additionalData) then
                    
                  local options = {
                    isModal = true,
                    effect = "fade",
                    time = 400,
                    params = {

                        additionalValue = additionalData,
                        Message = message

                    }
                }

                -- By some method (a pause button, for example), show the overlay
                composer.showOverlay( "Controller.pushNotificationPage", options )

                else

                  native.showAlert("MyUnitBuzz", message, { "OK" } )

                end


        end
end


function DidReceiveRemoteNotification(message, additionalData, isActive)


    --  if additionalData.messageType ~= nil or additionalData.stacked_notifications[1].messageType ~= nil then

    --     chatReceivedFlag=true

    --     local UserId,ContactId,Name,FromName,GroupName

    --         for row in db:nrows("SELECT * FROM logindetails WHERE id=1") do
    --                 UserId = row.UserId
    --                 ContactId = row.ContactId
    --                 Name = row.MemberName

    --         end


    --         if additionalData.stacked_notifications then


    --             local stakedArray = additionalData.stacked_notifications

    --             for i=1,#stakedArray do
    --                  local Message_date=os.date("!%Y-%m-%dT%H:%M:%S")
    --                     local isDeleted="false"
    --                     local Created_TimeStamp=os.date("!%Y-%m-%dT%H:%M:%S")
    --                     local Updated_TimeStamp=os.date("!%Y-%m-%dT%H:%M:%S")
    --                     local ImagePath=stakedArray[i].image or ""
    --                     AudioPath=stakedArray[i].audio or ""
    --                     VideoPath=stakedArray[i].video or ""
    --                     MyUnitBuzz_LongMessage=tostring(stakedArray[i].message)
    --                     From=stakedArray[i].messageFrom
    --                     To=stakedArray[i].messageTo
    --                     Message_Type = stakedArray[i].messageType



    --                         if stakedArray[i].fFN ~= nil then
    --                             Name=stakedArray[i].fFN.." "..stakedArray[i].fLN

    --                         else

    --                             Name=stakedArray[i].fLN

    --                         end

    --                         GroupName=""

    --                         if Message_Type == "GROUP" then
    --                              GroupName=stakedArray[i].GN
    --                              FromName=""
    --                         else


    --                                if stakedArray[i].tFN ~= nil then
    --                                     FromName=stakedArray[i].tFN.." "..stakedArray[i].tLN

    --                                 else

    --                                     FromName=stakedArray[i].tLN

    --                                 end

    --                         end
            
                    

    --                     local insertQuery = [[INSERT INTO pu_MyUnitBuzz_Message VALUES (NULL, ']]..UserId..[[',']]..Utils.encrypt(tostring(stakedArray[i].message))..[[','UPDATE',']]..Message_date..[[',']]..isDeleted..[[',']]..Created_TimeStamp..[[',']]..Updated_TimeStamp..[[',']]..ImagePath..[[',']]..AudioPath..[[',']]..VideoPath..[[',']]..MyUnitBuzz_LongMessage..[[',']]..From..[[',']]..To..[[',']]..Message_Type..[[',']]..Name..[[',']]..FromName..[[',']]..GroupName..[[');]]
    --                         db:exec( insertQuery )

    --             end

    --         else

    --             Message_date=os.date("!%Y-%m-%dT%H:%M:%S")

    --                     isDeleted="false"
    --                     Created_TimeStamp=os.date("!%Y-%m-%dT%H:%M:%S")
    --                     Updated_TimeStamp=os.date("!%Y-%m-%dT%H:%M:%S")
    --                     ImagePath=additionalData.image or ""
    --                     AudioPath=additionalData.audio or ""
    --                     VideoPath=additionalData.audio or ""
    --                     MyUnitBuzz_LongMessage=tostring(message)
    --                     From=additionalData.messageFrom
    --                     To=additionalData.messageTo
    --                     Message_Type = additionalData.messageType



    --                         if additionalData.fFN ~= nil then
    --                             Name=additionalData.fFN.." "..additionalData.fLN

    --                         else

    --                             Name=additionalData.fLN

    --                         end

    --                         GroupName=""

    --                         if Message_Type == "GROUP" then
    --                              GroupName=additionalData.GN
    --                              FromName=""
    --                         else


    --                                if additionalData.tFN ~= nil then
    --                                     FromName=additionalData.tFN.." "..additionalData.tLN

    --                                 else

    --                                     FromName=additionalData.tLN

    --                                 end

    --                         end
            
                    

    --                     local insertQuery = [[INSERT INTO pu_MyUnitBuzz_Message VALUES (NULL, ']]..UserId..[[',']]..Utils.encrypt(tostring(message))..[[','UPDATE',']]..Message_date..[[',']]..isDeleted..[[',']]..Created_TimeStamp..[[',']]..Updated_TimeStamp..[[',']]..ImagePath..[[',']]..AudioPath..[[',']]..VideoPath..[[',']]..MyUnitBuzz_LongMessage..[[',']]..From..[[',']]..To..[[',']]..Message_Type..[[',']]..Name..[[',']]..FromName..[[',']]..GroupName..[[');]]
    --                     db:exec( insertQuery )


                        

    --                     if openPage ~= "MessagingPage" then


    --                         local alert = native.showAlert( "MyUnitBuzz", tostring(message), { "OK" } )
                                 
    --                     end
       
    --        end
    -- else

    --      notificationFlag = true

    --         if (additionalData) then
                
    --           local options = {
    --             isModal = true,
    --             effect = "fade",
    --             time = 400,
    --             params = {

    --                 additionalValue = additionalData,
    --                 Message = message

    --             }
    --         }

    --         -- By some method (a pause button, for example), show the overlay
    --         composer.showOverlay( "Controller.pushNotificationPage", options )

    --         else

    --           native.showAlert("MyUnitBuzz", message, { "OK" } )

    --         end


    -- end      

end


    -- OneSignal.Init(ApplicationConfig.OneSignal_Appid, ApplicationConfig.ProjectNumber, DidReceiveRemoteNotification)

    -- OneSignal.EnableInAppAlertNotification(false)

 
local function notificationListener( event )


        --native.showAlert( "Push Notification", json.encode( event ),{"Ok"} )

    if ( event.type == "remote" ) then


        -- local options =
        -- {
        --    to = { "anitha.mani@w3magix.com"},
        --    subject = " response",
        --    isBodyHtml = true,
        --    body = ""..json.encode(event),

        -- }

        -- native.showPopup( "mail", options )


        --native.showAlert( "Push Notification", json.encode( event ),{"Ok"} )

            local additionalData={}
            local message
           --  native.showAlert( "Push Notification", json.encode( event ),{"Ok"} )

            if isAndroid then
                additionalData = event.androidGcmBundle
                message = additionalData.contents
            elseif isIos then

               additionalData = event.custom.data
                message = event.alert
            end

               chatReceivedFlag=true

          if additionalData.messageType ~= nil then

            
                    --For Chat recevier-----


                        local UserId,ContactId,Name,FromName,GroupName

                            for row in db:nrows("SELECT * FROM logindetails WHERE id=1") do
                                    UserId = row.UserId
                                    ContactId = row.ContactId
                                    Name = row.MemberName

                            end


                                        Message_date=os.date("!%Y-%m-%dT%H:%M:%S")

                                        isDeleted="false"
                                        Created_TimeStamp=os.date("!%Y-%m-%dT%H:%M:%S")
                                        Updated_TimeStamp=os.date("!%Y-%m-%dT%H:%M:%S")
                                        ImagePath=additionalData.image or ""
                                        AudioPath=additionalData.audio or ""
                                        VideoPath=additionalData.audio or ""
                                        MyUnitBuzz_LongMessage=tostring(message)
                                        From=additionalData.messageFrom
                                        To=additionalData.messageTo
                                        Message_Type = additionalData.messageType


                                       -- local native = native.showAlert("dsadsadsdas",Message_Type,{"ok"})


                                            if additionalData.fFN ~= nil then
                                                Name=additionalData.fFN.." "..additionalData.fLN

                                            else

                                                Name=additionalData.fLN

                                            end

                                            GroupName=""

                                            if Message_Type == "GROUP" then
                                                 GroupName=additionalData.gn
                                                 FromName=""
                                            else


                                  
                                                   if additionalData.tFN ~= nil then
                                                        FromName=additionalData.tFN.." "..additionalData.tLN

                                                    else

                                                        FromName=additionalData.tLN

                                                    end

                                            end
                            
                                    

                                        local insertQuery = [[INSERT INTO pu_MyUnitBuzz_Message VALUES (NULL, ']]..UserId..[[',']]..Utils.encrypt(tostring(message))..[[','UPDATE',']]..Message_date..[[',']]..isDeleted..[[',']]..Created_TimeStamp..[[',']]..Updated_TimeStamp..[[',']]..ImagePath..[[',']]..AudioPath..[[',']]..VideoPath..[[',']]..MyUnitBuzz_LongMessage..[[',']]..From..[[',']]..To..[[',']]..Message_Type..[[',']]..Name..[[',']]..FromName..[[',']]..GroupName..[[');]]
                                        db:exec( insertQuery )


                                        

                                        if openPage ~= "MessagingPage" and openPage ~= "main" then


                                           --local alert = native.showAlert( "MyUnitBuzz", tostring(message), { "OK" } )
                                                 
                                        end

                                        if openPage ~= "main" then

                                            native.setProperty( "applicationIconBadgeNumber", 0 )
                                            system.cancelNotification()
                                        end
       
          
        else


            ----Message Receiver------

                notificationFlag = true

                if (additionalData) then
                    
                  local options = {
                    isModal = true,
                    effect = "fade",
                    time = 400,
                    params = {

                        additionalValue = additionalData,
                        Message = message

                       }
                    }



                -- By some method (a pause button, for example), show the overlay
                composer.showOverlay( "Controller.pushNotificationPage", options )

                else

                  native.showAlert("MyUnitBuzz", message, { "OK" } )

--here
                end


        end


    elseif ( event.type == "remoteRegistration" ) then 
        --code to register your device with the service


        GCMValue = event.token

       -- native.showAlert( "Push Notification", event.token ,{"Ok"} )

   
    end
end

notifications.registerForPushNotifications()

--The notification Runtime listener should be handled from within "main.lua"
Runtime:addEventListener( "notification", notificationListener )


    ---------Google Analytics-------

    ga.init({ -- Only initialize once, not in every file
        isLive = IsLive, -- REQUIRED
        testTrackingID = ApplicationConfig.Analysic_TrackId, -- REQUIRED Tracking ID from Google -- Dev UA-51545075-5
        productionTrackingID = ApplicationConfig.Analysic_TrackId,
        debug = true, -- Recomended when starting
    })


 --native.setProperty( "applicationIconBadgeNumber", 0 )

-----Runtime Error------



local releaseBuild = true   -- Set to true to suppress popup message

-- Error handler
local function myUnhandledErrorListener( event )

    if releaseBuild then
        print( "Handling the unhandled error >>>\n", event.errorMessage )
    else
        print( "Not handling the unhandled error >>>\n", event.errorMessage )
    end
    
    return releaseBuild
end

Runtime:addEventListener("unhandledError", myUnhandledErrorListener)



-- local function listener( event )
--     if event.isShake then
--         print( "The device is being shaken!" )
--     end

--     return true
-- end

-- Runtime:addEventListener( "accelerometer", listener )


local function appexit( response )
    
end




local function onSystemEvent( event )
    
    if (event.type == "applicationStart") then
        
    elseif (event.type == "applicationExit") then 
           
    elseif ( event.type == "applicationSuspend" ) then

      -- Webservice.UpdateLastActivityDate(appexit)
        
    elseif ( event.type == "applicationOpen" ) then

      --  chatReceivedFlag=true

    elseif event.type == "applicationResume" then

      --  chatReceivedFlag=true
    
    end

end



--setup the system listener to catch applicationExit etc
Runtime:addEventListener( "system", onSystemEvent )









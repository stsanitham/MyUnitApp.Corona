        --------------------------------------------------------
        -- MainActivity
        --------------------------------------------------------

        display.setStatusBar(display.HiddenStatusBar)
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
        local resumeCallback = false

        GCMValue = "0"
        ga = require("Utils.GoogleAnalytics.ga")

        local launchArgs = ...

        pushArray = {}

        notificationFlag=false

        IsOwner = false

        leftPadding_value = 20

        TimeZone = ""

        chatReceivedFlag=false

        MessageId = "0"

        MessageIdValue = "0"

        chatReceivedPage = "main"

        --com.spanenterprises.MUBDev

        --CommonApp/DirectorApp

        checkStr = "test 1"


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




if launchArgs and launchArgs.notification then

 local additionalData,message

                    if isAndroid then
                        additionalData = launchArgs.notification.androidGcmBundle
                        message = additionalData.contents
                        --MessageId = additionalData.pnmid
                    elseif isIos then
                        additionalData = launchArgs.notification.custom.data
                        message = launchArgs.notification.alert
                    end

                    
               if additionalData.messageType ~= nil then
                     

                        chatReceivedFlag=true

                        native.setProperty( "applicationIconBadgeNumber", 0 )
                        system.cancelNotification()

  

                                        
               else

                         notificationFlag = true


                          MessageId = additionalData.pnmid
                                          --MessageId = "0"
                                                 chatReceivedFlag=true



                                -- if MessageId ~= "0" and MessageId ~= nil then

                                --             local options = {
                                --                     isModal = true,
                                --                     effect = "slideLeft",
                                --                     time = 300,
                                --                     params = {
                                --                         pagenameval = "pn_detailpage",
                                --                     }
                                --             }


                                --       composer.gotoScene( "Controller.pushNotificationDetailPage", options)

                                -- else

                                --       composer.gotoScene( "Controller.MessagingPage" )

                                -- end
             end

end







        -- -- Decrement the badge number by 1
        -- local function notificationListener( event )

        --     if ( event.type == "local" ) then
        --         -- Handle the local notification
        --         local badge_num = native.getProperty( "applicationIconBadgeNumber" )
        --         badge_num = badge_num - 1
        --         native.setProperty( "applicationIconBadgeNumber", badge_num )

        --     elseif ( event.type == "remote" ) then
        --         -- Handle the push notification
        --         if ( event.badge and event.badge > 0 ) then 
        --             native.setProperty( "applicationIconBadgeNumber", event.badge - 1 )
        --         end
        --     end
        -- end

        -- -- Or clear the badge entirely
        -- native.setProperty( "applicationIconBadgeNumber", 0 )



                            
        

        local function notificationListener( event )



            if ( event.type == "remote" ) then


                -- local options =
                -- {
                --    to = { "malarkodi.sellamuthu@w3magix.com"},
                --    subject = " response",
                --    isBodyHtml = true,
                --    body = ""..json.encode(event),

                -- }

                -- native.showPopup( "mail", options )

                local additionalData={}
                local message

                if isAndroid then
                    additionalData = event.androidGcmBundle
                    message = additionalData.contents
                elseif isIos then

                    additionalData = event.custom.data
                    message = event.alert
                end

                

                if additionalData.messageType ~= nil then

                    
                            --For Chat recevier-----

                              --native.showAlert( "MUB", "response"  ,{"ok"} )


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

                                         chatReceivedFlag=true

                                     if openPage == "main" and openPage == "spalshPage" then

                                             chatReceivedFlag=true
                                            native.setProperty( "applicationIconBadgeNumber", 0 )
                                            system.cancelNotification()
                                            notifications.cancelNotification()

                                        end


                                         if openPage == "MessagingPage" and (chatReceivedPage == "MessagingPage" or chatReceivedPage == "chatPage") then

                                                
                                                                                  

                                             local insertQuery = [[INSERT INTO pu_MyUnitBuzz_Message VALUES (NULL, ']]..UserId..[[',']]..Utils.decrypt(tostring(message))..[[','UPDATE',']]..Message_date..[[',']]..isDeleted..[[',']]..Created_TimeStamp..[[',']]..Updated_TimeStamp..[[',']]..ImagePath..[[',']]..AudioPath..[[',']]..VideoPath..[[',']]..MyUnitBuzz_LongMessage..[[',']]..From..[[',']]..To..[[',']]..Message_Type..[[',']]..Name..[[',']]..FromName..[[',']]..GroupName..[[');]]
                                             db:exec( insertQuery )

                                             native.setProperty( "applicationIconBadgeNumber", 0 )
                                             system.cancelNotification()
                                             notifications.cancelNotification()

                                  

                                        end


                                       

                                
                                
                            else



                    ----Message Receiver------

                    notificationFlag = true

                    chatReceivedFlag = true

                    if (additionalData) then


                            MessageId =  additionalData.pnmid


                                 additionalData = event.androidGcmBundle
                                 message = additionalData.contents
                                 MessageId = additionalData.pnmid
                                         --        -- MessageId = "0"


                                            -- local options =
                                            -- {
                                            --    to = { "anitha.mani@w3magix.com"},
                                            --    subject = " response",
                                            --    isBodyHtml = true,
                                            --    body = ""..json.encode(additionalData).."\n"..message.."\n"..messagidvalue,

                                            -- }

                                            -- native.showPopup( "mail", options )
                                    
                                
                        else

                                  native.showAlert("MyUnitBuzz", message, { "OK" } )
                                  
                            --here
                        end


end


elseif ( event.type == "remoteRegistration" ) then 
                --code to register your device with the service

                GCMValue = event.token

             --  native.showAlert( "Push Notification", event.token ,{"Ok"} )

             
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






        -- local function onNotification( event )

        --   if(event.token ~= nil) then
        --     notification_token = event.token                                                                                                                                                                                                                                                                                                                                                                    
        --   end

        --   if event.type == "remoteRegistration" then
        --     native.showAlert( "remoteRegistration", event.token, { "OK" } )                                                                                                                                                                                                                                                                                                                                                                 
        --   elseif event.type == "remote" then
        --     user.getUser(nil, false)
        --     native.showAlert( "Alert", event.alert, { "OK" } )
        --     --native.showAlert( "remote", json.encode( event ), { "OK" } )                                                                                                                                                                                                                                                                                                                                                                    
        --   end
        
        -- end


        -- Runtime:addEventListener( "notification", onNotification)







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


            elseif ( event.type == "applicationOpen" ) then


            elseif event.type == "applicationResume" then

                resumeCallback = true



                 local function onTimeDelay( event )
                                     
                                               if resumeCallback == true and chatReceivedFlag == true and MessageId ~= nil and MessageId ~= "0" then

                                                            resumeCallback=false
                                                           -- chatReceivedFlag=false

                                                           for j=MainGroup.numChildren, 1, -1 do 
                                                                display.remove(MainGroup[MainGroup.numChildren])
                                                                MainGroup[MainGroup.numChildren] = nil
                                                            end
                                                            composer.removeHidden()

                                                                              local options = {
                                                                        isModal = true,
                                                                        effect = "slideLeft",
                                                                        time = 300,
                                                                        params = {
                                                                            pagenameval = "pn_detailpage",
                                                                        }
                                                                    }

                                                                    composer.gotoScene( "Controller.pushNotificationDetailPage", options) 


                                                          
                                                elseif resumeCallback == true and chatReceivedFlag == true then

                                                resumeCallback=false
                                                chatReceivedFlag=false

                                               for j=MainGroup.numChildren, 1, -1 do 
                                                    display.remove(MainGroup[MainGroup.numChildren])
                                                    MainGroup[MainGroup.numChildren] = nil
                                                end
                                                composer.removeHidden()

                                                                   local options = {
                                                                        isModal = true,
                                                                        effect = "slideLeft",
                                                                        time = 300,
                                                                        params = {
                                                                            pagenameval = "fromMain",
                                                                        }
                                                                    }

                                                                     composer.gotoScene( "Controller.MessagingPage",options )
                                                else

                                                       if openPage == "main" or openPage == "spalshPage" or  openPage == "MessagingPage" or  openPage == "pushNotificationListPage"  then

                                                                   native.setProperty( "applicationIconBadgeNumber", 0 )
                                                                 system.cancelNotification()
                                                                 notifications.cancelNotification()

                                                        else

                                                              chatReceivedFlag=false
                                                        end

                                                 end






                                        end


                                    timer.performWithDelay( 1000, onTimeDelay)
              
                    
                
            end

        end



        --setup the system listener to catch applicationExit etc
        Runtime:addEventListener( "system", onSystemEvent )


local lfs = require( "lfs" )

-- Get raw path to the app documents directory
local doc_path = system.pathForFile( "", system.DocumentsDirectory )

for file in lfs.dir( doc_path ) do
    -- "file" is the current file or directory name
    print( "Found file: " .. file )
end


local function onResize(event)
   print("@@@ Content Scale = " .. tostring(display.contentScaleY))
end
Runtime:addEventListener("resize", onResize)





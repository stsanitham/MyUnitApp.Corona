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
MyUnitBuzzString = require( "res.value.string" )
local Applicationconfig = require("Utils.ApplicationConfig")


widget.setTheme( "widget_theme_ios" )

local OneSignal = require("plugin.OneSignal")
GCMValue = 0
ga = require("Utils.GoogleAnalytics.ga")


pushArray = {}

notificationFlag=false

IsOwner = false

TimeZone = ""

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

local BackFlag = false

 function onKeyEvent( event )
        local phase = event.phase
        local keyName = event.keyName

        if(keyName=="back") then

            if BackFlag then
                BackFlag=false
                os.exit( )
            end

            --BackFlag=true

            if openPage == "signInPage" or openPage == "requestAccess Page" then
                native.setKeyboardFocus(nil)
                
            end

            return true
        else

            return false

        end

        -- we handled the event, so return true.
        -- for default behavior, return false.
        
     end

    -- Add the key callback
   Runtime:addEventListener( "key", onKeyEvent );

	composer.gotoScene( "Controller.splashScreen")


   
--composer.gotoScene( "Controller.pushNotificationPage")



function DidReceiveRemoteNotification(message, additionalData, isActive)

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



OneSignal.Init(ApplicationConfig.OneSignal_Appid, ApplicationConfig.ProjectNumber, DidReceiveRemoteNotification)

OneSignal.EnableInAppAlertNotification(false)


---------Google Analytics-------

ga.init({ -- Only initialize once, not in every file
    isLive = IsLive, -- REQUIRED
    testTrackingID = ApplicationConfig.Analysic_TrackId, -- REQUIRED Tracking ID from Google -- Dev UA-51545075-5
    productionTrackingID = ApplicationConfig.Analysic_TrackId,
    debug = true, -- Recomended when starting
})


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







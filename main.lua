--------------------------------------------------------
-- MainActivity
--------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )
local composer = require "composer"
local newPanel = require "Utils.newPanel"
local widget = require( "widget" )
local Utility = require( "Utils.Utility" )
local stringValue = require( "res.value.color" )
local sqlite3 = require( "sqlite3" )

AppName = "CommonApp"

environment = system.getInfo( "environment" )

if AppName == "DirectorApp" then
	Unitnumber_value = "12345"
else
	Unitnumber_value = ""
end

MainGroup = display.newGroup();

local W,H = display.contentWidth, display.contentHeight;
NavigationSpeed = 400;
menuShowFlag = false;
menuTransTime = 1000;
openPage="main"
menuTitel = {"Home","Event Calender","Career Path","Goals","Resource","Image Library","Social Media","Facebook","Twitter","Instagram","Google+"}
rowValues = {"LandingPage","eventCalenderPage","careerPathPage","goalsPage","resourcePage","imageLibPage","","facebookPage","twitterPage","instagramPage","googlePlusPage"}
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
local spinnerSingleSheet = graphics.newImageSheet( "res/assert/circular-preloaders.png", options )


spinner = widget.newSpinner
{
    width = 50 ,
    height = 50,
    deltaAngle = 10,
    sheet = spinnerSingleSheet,
    startFrame = 1,
    incrementEvery = 20
}

spinner.x=W/2;spinner.y=H/2-45
spinner.isVisible=false


function spinner_show ()
    spinner.isVisible=true
    spinner:toFront()
    spinner:start()

end

function spinner_hide ()
    spinner.isVisible=false
    spinner:toBack()
    spinner:stop()
end

local tablesetup = [[DROP TABLE logindetails;]]
db:exec( tablesetup )

local tablesetup = [[CREATE TABLE IF NOT EXISTS logindetails (id INTEGER PRIMARY KEY autoincrement, UnitNumberOrDirector, EmailAddess, PhoneNumber, Status, UserId, GoogleUsername, GoogleToken, GoogleTokenSecret, GoogleUserId, FacebookUsername, FacebookAccessToken, TwitterUsername, TwitterToken, TwitterTokenSecret, ProfileImageUrl, AccessToken, ContactId);]]
db:exec( tablesetup )

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


 function onKeyEvent( event )
        local phase = event.phase
        local keyName = event.keyName

        if(keyName=="back") then
            if openPage == "signInPage" then
                native.setKeyboardFocus(nil)
            end
        end
        -- we handled the event, so return true.
        -- for default behavior, return false.
        return true
     end

    -- Add the key callback
   Runtime:addEventListener( "key", onKeyEvent );

--[[local function doesFileExist( fname, path )

    local results = false

    -- Path for the file
    local filePath = system.pathForFile( fname, path )

    if ( filePath ) then
        local file, errorString = io.open( filePath, "r" )

        if not file then
            -- Error occurred; output the cause
            print( "File error: " .. errorString )
        else
            -- File exists!
            print( "File found: " .. fname )
            results = true
            -- Close the file handle
            file:close()
        end
    end

    return results
end

function copyFile( srcName, srcPath, dstName, dstPath, overwrite )

    local results = false

    local fileExists = doesFileExist( srcName, srcPath )
    if ( fileExists == false ) then
        return nil  -- nil = Source file not found
    end

    -- Check to see if destination file already exists
    if not ( overwrite ) then
        if ( fileLib.doesFileExist( dstName, dstPath ) ) then
            return 1  -- 1 = File already exists (don't overwrite)
        end
    end

    -- Copy the source file to the destination file
    local rFilePath = system.pathForFile( srcName, srcPath )
    local wFilePath = system.pathForFile( dstName, dstPath )

    local rfh = io.open( rFilePath, "rb" )
   local wfh, errorString = io.open( wFilePath, "wb" )

     if not ( wfh ) then
        -- Error occurred; output the cause
        print( "File error: " .. errorString )
        return false
    else
        -- Read the file and write to the destination directory
        local data = rfh:read( "*a" )
        if not ( data ) then
            print( "Read error!" )
            return false
        else
            if not ( wfh:write( data ) ) then
                print( "Write error!" )
                return false
            end
        end
    end

    results = 2  -- 2 = File copied successfully!

	--


    -- Close file handles
    rfh:close()
    wfh:close()

    return results
    end]]


	--composer.gotoScene( "Controller.careerPathDetailPage")




	composer.gotoScene( "Controller.flapMenu")


--copyFile( "string.lua", system.DocumentsDirectory, "string.lua",system.ResourceDirectory, true )




----------------------------------------------------------------------------------
--
-- instagram Screen
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

local Utility = require( "Utils.Utility" )
local json = require("json")



--------------- Initialization -------------------

local W = display.contentWidth;H= display.contentHeight

local Background,BgText

local menuBtn

local additionalDate={}

openPage="Push Notification Page"



--------------------------------------------------


-----------------Function-------------------------

local function closeDetails( event )
	if event.phase == "began" then
			display.getCurrentStage():setFocus( event.target )
	elseif event.phase == "ended" then
			display.getCurrentStage():setFocus( nil )
			composer.hideOverlay()

			local isChannel1Playing = audio.isChannelPlaying( 1 )
			if isChannel1Playing then
			    audio.pause( 1 )
			    audio.dispose( 1 )
			end
						

			for j=PushGroup.numChildren, 1, -1 do 
											display.remove(PushGroup[PushGroup.numChildren])
											PushGroup[PushGroup.numChildren] = nil
			end

	end

return true

end

local function bgTouch( event )
	if event.phase == "began" then
			display.getCurrentStage():setFocus( event.target )
	elseif event.phase == "ended" then
			display.getCurrentStage():setFocus( nil )

	end

return true

end



------------------------------------------------------

function scene:create( event )

	local sceneGroup = self.view


	additionalDate= event.params.additionalValue
	message = event.params.Message


	--Mail

	--[[local test = json.encode(additionalDate)

	local options =
			{
			   to = "malarkodi.sellamuthu@w3magix.com",
			   subject = "additional data",
			   body = test,
			}
			native.showPopup( "mail", options )]]

	Background = display.newImageRect(PushGroup,"res/assert/background.jpg",W,H)
	Background.x=W/2;Background.y=H/2
	Background.alpha=0.01


	PushNotification_bg = display.newRoundedRect( PushGroup, W/2,H/2, W-50, H/3, 3 )
	PushNotification_bg:setFillColor(Utility.convertHexToRGB(color.tabBarColor))	

	PushNotification_title = display.newText( PushGroup, "Notification", 0, 0, 0,0,native.systemFont,20 )
	PushNotification_title.x= W/2
	PushNotification_title.anchorY=0
	PushNotification_title.y= PushNotification_bg.y-PushNotification_bg.contentHeight/2+10

	PushNotification_msg = display.newText( PushGroup, message,0,0,PushNotification_bg.contentWidth-50, 0,native.systemFont,16 )
	PushNotification_msg.x= W/2
	--PushNotification_msg.anchorX=0
	--PushNotification_msg.anchorY=0
	PushNotification_msg.y= PushNotification_bg.y


	PushNotification_close = display.newText( PushGroup, "Close", 0, 0, 0,0,native.systemFont,20 )
	PushNotification_close.x= W/2
	PushNotification_close.y= PushNotification_bg.y+PushNotification_bg.contentHeight/2-20

	if additionalDate.audio then

		--local destDir = system.TemporaryDirectory  -- Location where the file is stored
		--local result, reason = os.remove( system.pathForFile( "notification.wav", destDir ) )
		--local result, reason = os.remove( system.pathForFile( "notification.mp3", destDir ) )

	local function networkListener( audio_event )

		spinner_hide()

	if ( audio_event.isError ) then
		elseif ( audio_event.phase == "began" ) then
			elseif ( audio_event.phase == "ended" ) then
				

				--local laserSound = audio.loadSound( audio_event.response.filename,system.TemporaryDirectory )
				--local backgroundMusicChannel = audio.play( laserSound, { channel=1, loops=-1 } )

					

			end
		end

		spinner_show()

			network.download(
			additionalDate.audio,
			"GET",
			networkListener,
			additionalDate.audio:match( "([^/]+)$" ),
			system.TemporaryDirectory
			)


		

	end



end

function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then


	elseif phase == "did" then

		Background:addEventListener( "touch", bgTouch )
		PushNotification_close:addEventListener( "touch", closeDetails )
	
	end	
	


end

	function scene:hide( event )

		local sceneGroup = self.view
		local phase = event.phase

		if event.phase == "will" then


			elseif phase == "did" then


			end	

		end


		function scene:destroy( event )
			local sceneGroup = self.view



		end


		scene:addEventListener( "create", scene )
		scene:addEventListener( "show", scene )
		scene:addEventListener( "hide", scene )
		scene:addEventListener( "destroy", scene )


		return scene
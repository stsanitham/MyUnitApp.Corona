----------------------------------------------------------------------------------
--
-- instagram Screen
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

local Utility = require( "Utils.Utility" )



--------------- Initialization -------------------

local W = display.contentWidth
local H= display.contentHeight

local Background,tabBar,menuBtn,BgText,title_bg,back_icon_bg,back_icon,title
local dataFileName = "audio"..
local menuBtn
local filePath
local okBtn,okBtn_txt,cancelBtn,cancelBtn_txt
local userAction="cancel"
openPage="audiorecordPage"

local r                 -- media object for audio recording
local recButton         -- gui buttons
local fSoundPlaying = false   -- sound playback state
local fSoundPaused = false    -- sound pause state

local countdown
--------------------------------------------------


-----------------Function-------------------------

local function closeDetails( event )
	if event.phase == "began" then
			display.getCurrentStage():setFocus( event.target )
	elseif event.phase == "ended" then
			display.getCurrentStage():setFocus( nil )
			if event.target.id =="background" then

			elseif event.target.id == "ok" then
				userAction="ok"
			else
				composer.hideOverlay()
			end

	end

return true

end

local function audioAction( event )
	if event.phase == "began" then
			display.getCurrentStage():setFocus( event.target )
	elseif event.phase == "ended" then
			display.getCurrentStage():setFocus( nil )

			if event.target.id == "play" then
				print("play")
				native.showAlert( "MUB", "dataFileName : "..dataFileName ,{"Ok"})
				    local filePath = system.pathForFile( dataFileName, system.DocumentsDirectory )
		            -- Play back the recording
		            local file = io.open( filePath)
		            
		            if file then
		                io.close( file )
		                fSoundPlaying = true
		                fSoundPaused = false
		                
						playbackSoundHandle = audio.loadStream( dataFileName, system.DocumentsDirectory )
						audio.play( playbackSoundHandle)

						 keyTips.text = "Playing"
		            end  
			elseif event.target.id == "stop" then
				
				if r:isRecording() then
		            r:stopRecording()
		            timer.cancel(countdown)

		            okBtn.isVisible=true
					okBtn_txt.isVisible=true
					cancelBtn.isVisible=true
					cancelBtn_txt.isVisible=true

		            keyTips.text = "Recording Stopped"
		       	end
			elseif event.target.id == "start" then
				 fSoundPlaying = false
		         fSoundPaused = false
		         r:startRecording()

		         local count=0
		         countdown = timer.performWithDelay(1000, function()
		         	count=count+1
		         	timerCount.text = "00:"..count

		         end,-1)

		         keyTips.text = "Recording"

			end

	end

return true

end


------------------------------------------------------

function scene:create( event )

	local sceneGroup = self.view

	print( "audio record" )


    Background = display.newImageRect(sceneGroup,"res/assert/background.jpg",W,H)
	Background.x=W/2;Background.y=H/2
	Background.id="background"
	Background:addEventListener( "touch", closeDetails )

	tabBar = display.newRect(sceneGroup,W/2,0,W,40)
	tabBar.y=tabBar.contentHeight/2
	tabBar:setFillColor(Utils.convertHexToRGB(color.tabBarColor))

	menuBtn = display.newImageRect(sceneGroup,"res/assert/menu.png",23,17)
	menuBtn.anchorX=0
	menuBtn.x=10;menuBtn.y=20;

	BgText = display.newImageRect(sceneGroup,"res/assert/logo-flash-screen.png",398/4,81/4)
	BgText.x=menuBtn.x+menuBtn.contentWidth+5;BgText.y=menuBtn.y
	BgText.anchorX=0

	title_bg = display.newRect(sceneGroup,0,0,W,30)
	title_bg.height = 30
	title_bg.x=W/2;title_bg.y = tabBar.y+tabBar.contentHeight-5
	title_bg:setFillColor( Utils.convertHexToRGB(color.tabbar) )

    back_icon_bg = display.newRect(sceneGroup,0,0,20,20)
	back_icon_bg.x= 5
	back_icon_bg.anchorX=0
	back_icon_bg.anchorY=0
	back_icon_bg.alpha=0.01
	back_icon_bg:setFillColor(0)
	back_icon_bg.y= title_bg.y-8

	back_icon = display.newImageRect(sceneGroup,"res/assert/left-arrow(white).png",20/2,30/2)
	back_icon.x= back_icon_bg.x + 5
	back_icon.anchorX=0
	back_icon.anchorY=0
	back_icon:setFillColor(0)
	back_icon.y= title_bg.y - 8

	title = display.newText(sceneGroup,ChatPage.recordTittle,0,0,native.systemFont,18)
	title.anchorX = 0
	title.x=back_icon.x+15;title.y = title_bg.y
	title:setFillColor(0)

	title:addEventListener( "touch", closeDetails )
	back_icon:addEventListener( "touch", closeDetails )


MainGroup:insert(sceneGroup)

end

function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then

		keyTips = display.newText( sceneGroup, "Press record",  0,0,native.systemFont,16 )
		keyTips:setFillColor( Utils.convertHexToRGB(color.tabBarColor) )
		keyTips.x=W/2;keyTips.y=title_bg.y+title_bg.contentHeight+20


		startBtn = display.newText( sceneGroup, "Start",  0,0,native.systemFont,16 )
		startBtn.x=W/3-10;startBtn.y=H/2+150
		startBtn.id="start"
		startBtn:setFillColor( Utils.convertHexToRGB(color.tabBarColor) )


		playBtn = display.newText( sceneGroup, "Play",  0,0,native.systemFont,16 )
		playBtn.x=W/2;playBtn.y=H/2+150
		playBtn.id="play"
		playBtn:setFillColor( Utils.convertHexToRGB(color.tabBarColor) )



		stopBtn = display.newText( sceneGroup, "Stop",  0,0,native.systemFont,16 )
		stopBtn.x=W/2+50;stopBtn.y=H/2+150
		stopBtn.id="stop"
		stopBtn:setFillColor( Utils.convertHexToRGB(color.tabBarColor) )

		okBtn = display.newImageRect( sceneGroup, "res/assert/positive_alert.png", 100, 30 )
		okBtn.x=W/2-120;okBtn.y=H/2+50
		okBtn.id="ok"
		okBtn.anchorX=0

		okBtn_txt = display.newText( sceneGroup, MessagePage.Send, 0,0,native.systemFont,14 )
		okBtn_txt.x=okBtn.x+25;okBtn_txt.y=okBtn.y
		okBtn_txt.anchorX=0

		cancelBtn = display.newImageRect( sceneGroup, "res/assert/negative_alert.png", 100, 30 )
		cancelBtn.x=W/2;cancelBtn.y=H/2+50
		cancelBtn.id="cancel"
		cancelBtn.anchorX=0

		cancelBtn_txt = display.newText( sceneGroup, CommonWords.cancel, 0,0,native.systemFont,14 )
		cancelBtn_txt.x=cancelBtn.x+25;cancelBtn_txt.y=cancelBtn.y
		cancelBtn_txt.anchorX=0

		okBtn:addEventListener( "touch", closeDetails )
		cancelBtn:addEventListener( "touch", closeDetails )

		    okBtn.isVisible=false
			okBtn_txt.isVisible=false
			cancelBtn.isVisible=false
			cancelBtn_txt.isVisible=false

		
		if "simulator" == system.getInfo("environment") then
		    dataFileName = dataFileName .. ".aif"
		else
		    if isIos then
		        dataFileName = dataFileName .. ".aif"
		    elseif isAndroid then
		        dataFileName = dataFileName .. ".wav"
		    else
		    	print("Unknown OS " .. platformName )
		    end
		end
		print (dataFileName)

		filePath = system.pathForFile( dataFileName, system.DocumentsDirectory )
		r = media.newRecording(filePath)


		timerCount = display.newText( sceneGroup, "00:00",0,0,native.systemFont,75)
		timerCount:setFillColor( 0 )
		timerCount.x=W/2
		timerCount.y=H/2-50


		startBtn:addEventListener( "touch", audioAction )
		playBtn:addEventListener( "touch", audioAction )
		stopBtn:addEventListener( "touch", audioAction )


	elseif phase == "did" then



		menuBtn:addEventListener("touch",menuTouch)
		
	end	
	
MainGroup:insert(sceneGroup)

end

	function scene:hide( event )

		local sceneGroup = self.view
		local phase = event.phase

		if event.phase == "will" then

		elseif phase == "did" then

			if userAction == "ok" then

				event.parant:updateAudio(dataFileName)

			else

				local filePath = system.pathForFile( dataFileName, system.DocumentsDirectory )
	            os.remove( filePath )

			end

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
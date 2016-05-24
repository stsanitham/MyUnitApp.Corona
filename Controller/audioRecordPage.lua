----------------------------------------------------------------------------------
--
-- Audio recording Screen
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

local Utility = require( "Utils.Utility" )
local toast = require('plugin.toast')


--------------- Initialization -------------------

local W = display.contentWidth
local H= display.contentHeight

local Background,tabBar,menuBtn,BgText,title_bg,back_icon_bg,back_icon,title
local dataFileName = "audio"..os.date("%Y%m%d%H%M%S")
local menuBtn
local filePath
local okBtn,okBtn_txt,cancelBtn,cancelBtn_txt
local userAction="cancel"

openPage="audiorecordPage"

local r                 -- media object for audio recording
local recButton         -- gui buttons
local fSoundPlaying = false   -- sound playback state
local fSoundPaused = false    -- sound pause state
 local Seconds,Mintues=0,0
local countdown
local startBtn_txt,playBtn_txt,stopBtn_txt
--------------------------------------------------


-----------------Function-------------------------

local function closeDetails( event )
	if event.phase == "began" then
			display.getCurrentStage():setFocus( event.target )
	elseif event.phase == "ended" then
			display.getCurrentStage():setFocus( nil )
			if event.target.id =="background" then

			elseif event.target.id == "ok" then

				    local filePath = system.pathForFile( dataFileName, system.DocumentsDirectory )
		            local file = io.open( filePath)
		            
		           		if file then
		                	io.close( file )
							userAction="ok"

									if pagevalue == "chat" then

										composer.hideOverlay()

								    elseif pagevalue == "compose" then

								    	local column = native.showAlert("Audio path",pagevalue,{"ok"})

								    	   local function onTimer(event)

												local options = 
												{
													isModal = true,
													effect = "slideRight",
													time = 600,
													params = {
													filename = dataFileName,
													targetaction = "audio"
													}
												}


								  			composer.gotoScene("Controller.composeMessagePage",options)

								  		    end

								  			timer.performWithDelay(1000,onTimer)

								    end

						else

							toast.show("Please record the audio to proceed", {duration = 'long', gravity = 'Bottom', offset = {0, 128}})  

						end
			else

				 local filePath = system.pathForFile( dataFileName, system.DocumentsDirectory )
		            local file = io.open( filePath)
		            
		           		if file then
		                	io.close( file );print("removed")
		                	os.remove(filePath)
		                end


						            if pagevalue == "chat" then

								        composer.hideOverlay()

								    elseif event.target.id == "backicon" or pagevalue ~= "chat" then

								    	print("closing audio page")

								    	--composer.hideOverlay()

								    	composer.gotoScene("Controller.composeMessagePage","slideRight",200)

								    end
			end

	end

return true

end



local function audioAction( event )
	if event.phase == "began" then
			display.getCurrentStage():setFocus( event.target )
	elseif event.phase == "ended" then
			display.getCurrentStage():setFocus( nil )


		if event.target.alpha > 0.6 then

			if event.target.id == "play" then


				startBtn.alpha=0.5
				startBtn_txt.alpha=0.5
				playBtn.alpha=0.5
				playBtn_txt.alpha=0.5
				stopBtn.alpha=1
				stopBtn_txt.alpha=1

	    local filePath = system.pathForFile( dataFileName, system.DocumentsDirectory )
		            -- Play back the recording
		            local file = io.open( filePath)
		            
		            if file then
		                io.close( file )
		                fSoundPlaying = true
		                fSoundPaused = false

		                local isChannelPaused = audio.isChannelPaused( 1 )
						if isChannel1Playing then
						    audio.pause( 1 )
						end
		                	local isChannel1Playing = audio.isChannelPlaying( 1 )
							if isChannel1Playing then
							else
								playbackSoundHandle = audio.loadStream( dataFileName, system.DocumentsDirectory )
								audio.play( playbackSoundHandle, { channel=1, loops=-1 } )
							end

						end  

		            keyTips.text = "Playing"

			elseif event.target.id == "stop" then
				
				startBtn.alpha=1
				startBtn_txt.alpha=1
				playBtn.alpha=1
				playBtn_txt.alpha=1
				stopBtn.alpha=0.5
				stopBtn_txt.alpha=0.5

				if r:isRecording() then
		            r:stopRecording()
		            timer.cancel(countdown)

		            keyTips.text = "Recording Stopped"

		       	end

		       	local isChannel1Playing = audio.isChannelPlaying( 1 )
				if isChannel1Playing or isSimulator then
				    audio.pause( 1 )
				     keyTips.text = "Recording Paused"
				end

			elseif event.target.id == "start" then
				 fSoundPlaying = false
		         fSoundPaused = false
		         r:startRecording()

		        startBtn.alpha=0.5
				startBtn_txt.alpha=0.5
				playBtn.alpha=0.5
				playBtn_txt.alpha=0.5
				stopBtn.alpha=1
				stopBtn_txt.alpha=1
		        	
		         countdown = timer.performWithDelay(1000, function()

		         	if Seconds == 60 then
		         		Seconds=0
		         		Mintues=Mintues+1
		         	end
		         	
		         	timerCount.text = string.format("%02d",Mintues)..":"..string.format("%02d",Seconds)
		         	Seconds=Seconds+1
		         end,-1)

		         keyTips.text = "Recording"

			end
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
	back_icon.id="backicon"
	back_icon.anchorY=0
	back_icon:setFillColor(0)
	back_icon.y= title_bg.y - 8

	title = display.newText(sceneGroup,ChatPage.recordTittle,0,0,native.systemFont,18)
	title.anchorX = 0
	title.x=back_icon.x+15;title.y = title_bg.y
	title:setFillColor(0)

	local audio_bg = display.newImageRect( sceneGroup, "res/assert/audiobg.png",W,H/2-40)
	audio_bg.x=W/2;audio_bg.y=H/2+40
	audio_bg.anchorY=0

	local recordIcon = display.newImageRect( sceneGroup, "res/assert/recordicon.png", 130, 110 )
	recordIcon.x=W/2;recordIcon.y=H/2-80


	title:addEventListener( "touch", closeDetails )
	back_icon:addEventListener( "touch", closeDetails )

MainGroup:insert(sceneGroup)

end





function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then

		if event.params then

			contactid = event.params.contactId 
			messagetype = event.params.MessageType 
			pagevalue = event.params.page 

			print(contactid.."   "..messagetype.."   "..pagevalue)

		end

		if pagevalue == "compose" then

		composer.removeHidden()

		else

		end


		keyTips = display.newText( sceneGroup, "Press ‘Start’ to record",  0,0,native.systemFont,16 )
		keyTips:setFillColor( Utils.convertHexToRGB(color.tabBarColor) )
		keyTips.x=W/2;keyTips.y=title_bg.y+title_bg.contentHeight


		startBtn = display.newImageRect( sceneGroup,"res/assert/audiobtnbg.png",65,55 )
		startBtn.x=W/2-70;startBtn.y=H/2+100
		startBtn.id="start"


		startBtn_txt = display.newText( sceneGroup,"Start",0,0,native.systemFont,16 )
		startBtn_txt.x=startBtn.x;startBtn_txt.y=startBtn.y
		startBtn_txt.id="start"


		playBtn = display.newImageRect( sceneGroup,"res/assert/audiobtnbg.png",65,55 )
		playBtn.x=W/2;playBtn.y=H/2+100
		playBtn.id="play"
		playBtn.play="play"

		playBtn_txt = display.newText( sceneGroup,"Play",0,0,native.systemFont,16 )
		playBtn_txt.x=playBtn.x;playBtn_txt.y=playBtn.y
		playBtn_txt.id="start"



		stopBtn = display.newImageRect( sceneGroup,"res/assert/audiobtnbg.png",65,55 )
		stopBtn.x=W/2+70;stopBtn.y=H/2+100
		stopBtn.id="stop"

		stopBtn_txt = display.newText( sceneGroup,"Stop",0,0,native.systemFont,16 )
		stopBtn_txt.x=stopBtn.x;stopBtn_txt.y=stopBtn.y
		stopBtn_txt.id="start"

		playBtn.alpha=0.5
		playBtn_txt.alpha=0.5
		stopBtn.alpha=0.5
		stopBtn_txt.alpha=0.5

		okBtn = display.newRect( sceneGroup, 0,0, W/2, 45 )
		okBtn.x=0;okBtn.y=H-45
		okBtn.id="ok"
		okBtn.anchorX=0;okBtn.anchorY=0
		okBtn:setFillColor( Utils.convertHexToRGB(color.darkGreen) )

		local okIcon = display.newImageRect( sceneGroup, "res/assert/audiosend.png",25,20 )
		okIcon.x=okBtn.x+20;okIcon.y=okBtn.y+okBtn.contentHeight/2

		okBtn_txt = display.newText( sceneGroup, MessagePage.Send, 0,0,native.systemFont,16 )
		okBtn_txt.x=okIcon.x+25;okBtn_txt.y=okIcon.y
		okBtn_txt.anchorX=0

		cancelBtn = display.newRect( sceneGroup, 0,0, W/2, 45 )
		cancelBtn.x=W/2;cancelBtn.y=H-45
		cancelBtn.id="cancel"
		cancelBtn.anchorX=0;cancelBtn.anchorY=0
		cancelBtn:setFillColor( Utils.convertHexToRGB(color.Lytred) )

		local cancelIcon = display.newImageRect( sceneGroup, "res/assert/audiocancel.png",25,20 )
		cancelIcon.x=cancelBtn.x+20;cancelIcon.y=cancelBtn.y+cancelBtn.contentHeight/2

		cancelBtn_txt = display.newText( sceneGroup, CommonWords.cancel, 0,0,native.systemFont,16 )
		cancelBtn_txt.x=cancelIcon.x+25;cancelBtn_txt.y=cancelIcon.y
		cancelBtn_txt.anchorX=0

		okBtn:addEventListener( "touch", closeDetails )
		cancelBtn:addEventListener( "touch", closeDetails )

		 --    okBtn.isVisible=false
			-- okBtn_txt.isVisible=false
			-- cancelBtn.isVisible=false
			-- cancelBtn_txt.isVisible=false


		
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


		timerCount = display.newText( sceneGroup, "00:00",0,0,native.systemFont,70)
		timerCount:setFillColor( 0 )
		timerCount.x=W/2
		timerCount.y=H/2+10



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

			-- if pagevalue == "compose" then
			-- 	status = "compose"
			-- 	--event.parent:resumeCall(pagevalue)
			-- 	composer.hideOverlay( )
			-- end


		elseif phase == "did" then

			local isChannel1Playing = audio.isChannelPlaying( 1 )
				if isChannel1Playing then

					audio.pause( 1 );audio.stop(1);audio.dispose(1)

				end

			if userAction == "ok" then

					if pagevalue == "compose" then


						-- print("datafilename ",dataFileName)


	     --                local options = 
						-- 	{
						-- 		isModal = true,
						-- 		effect = "slideRight",
						-- 		time = 200,
						-- 		params = {
						-- 		filename = dataFileName,
						-- 		pagevaluename = "audio"
						-- 		}
						-- 	}


			  	-- 		composer.gotoScene("Controller.composeMessagePage",options)


					else

					event.parent:updateAudio(dataFileName)

				    end

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
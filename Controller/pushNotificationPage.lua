----------------------------------------------------------------------------------
--
-- instagram Screen
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local style = require("res.value.style")
local Utility = require( "Utils.Utility" )
local json = require("json")



--------------- Initialization -------------------

local W = display.contentWidth;H= display.contentHeight

local Background,BgText

local menuBtn

local additionalDate={}

openPage="Push Notification Page"

local laserSound,backgroundMusicChannel

local PushGroup

local Background,PushNotification_bg,PushNotification_title_bg,PushNotification_title,PushNotification_msg,playBtn,playBtn_text,downloadBtn,downloadBtn_text,PushNotification_close_bg,PushNotification_close,webView



--------------------------------------------------


-----------------Function-------------------------


local function AudioPush(value)
	local function networkListener( audio_event )

				spinner_hide()

				print( "touched" )

			if ( audio_event.isError ) then
			elseif ( audio_event.phase == "began" ) then
			elseif ( audio_event.phase == "ended" ) then

						local isChannel1Playing = audio.isChannelPlaying( 1 )
						if isChannel1Playing then
						   audio.pause( 1 ); audio.stop( 1 ); audio.dispose( 1 )

						    laserSound=nil
							backgroundMusicChannel=nil

						end

						print( "playing	" )

						 laserSound = audio.loadSound( audio_event.response.filename,system.TemporaryDirectory )
						 backgroundMusicChannel = audio.play( laserSound, { channel=1, loops=1 } )							

			end
	end

				


		
					spinner_show()
				    network.download(
						value,
						"GET",
						networkListener,
						value:match( "([^/]+)$" ),
						system.TemporaryDirectory
											)
				
		
									

end

local function downloadAction(filename)

			local localpath = system.pathForFile( filename, system.TemporaryDirectory )
						
					local path = system.pathForFile("/storage/sdcard1/"..filename)    

					--------------------------- Read ----------------------------
						local file, reason = io.open( localpath, "r" )                              
						local contents
						if file then
						    contents = file:read( "*a" )                                        -- Read contents
						    io.close( file )                                                    -- Close the file (Important!)
						else
						    print("Invalid path")
						    return
						end

					--------------------------- Write ----------------------------
	
						local file = io.open( path, "w" )                                    -- Open the destination path in write mode
		
							if file then
							    file:write(contents)                                                -- Writes the contents to a file
							    io.close(file)                                                      -- Close the file (Important!)
							else
								path = system.pathForFile("/storage/sdcard0/"..filename)
								local file = io.open( path, "w" )                                    -- Open the destination path in write mode
								if file then
								    file:write(contents)                                                -- Writes the contents to a file
								    io.close(file)                                                      -- Close the file (Important!)
								else
								   path = system.pathForFile("/storage/sdcard/"..filename)
									local file = io.open( path, "w" )                                    -- Open the destination path in write mode
									if file then
										file:write(contents)                                                -- Writes the contents to a file
										io.close(file)                                                      -- Close the file (Important!)
									else
									    print("Error")
									    return
									 end
								 end
							end

							native.showAlert( filename, ResourceLibrary.Download_alert, { CommonWords.ok} )

end

local function DownloadPush(  )
	local function DownloadPush_networkListener( audio_event )

				spinner_hide()

			if ( audio_event.isError ) then
			elseif ( audio_event.phase == "began" ) then
			elseif ( audio_event.phase == "ended" ) then

				print( audio_event.response.filename )
					downloadAction(audio_event.response.filename)					

			end
	end

				
	print( additionalDate.audio:match( "([^/]+)$" ) )

	local path = system.pathForFile( additionalDate.audio:match( "([^/]+)$" ), system.TemporaryDirectory )
	local fhd = io.open( path )

				-- Determine if file exists
		if fhd then
			downloadAction(additionalDate.audio:match( "([^/]+)$" ))
		else
			spinner_show()
		    network.download(
				additionalDate.audio,
				"GET",
				DownloadPush_networkListener,
				additionalDate.audio:match( "([^/]+)$" ),
				system.TemporaryDirectory
									)
		end
									

end

local function closeDetailsPush( event )
	if event.phase == "began" then
			display.getCurrentStage():setFocus( event.target )
	elseif event.phase == "ended" then
			display.getCurrentStage():setFocus( nil )

			


			if event.target.id == "Play" then

				if event.target.value:match( "([^/]+)$" ) ~= nil then

					AudioPush(event.target.value)

				end

			elseif event.target.id == "Downlaod" then

				if additionalDate.audio:match( "([^/]+)$" ) ~= nil then

					DownloadPush()

				end

			else
				


				local isChannel1Playing = audio.isChannelPlaying( 1 )
				if isChannel1Playing then
				    audio.pause( 1 )
				    audio.stop( 1 )
				    audio.dispose( 1 )
				     laserSound=nil
							backgroundMusicChannel=nil
				end
				if #pushArray <= 1 then

					notificationFlag=false

				end
				if pushArray[#pushArray] ~= nil then

					print( "close" )

				
					for j=pushArray[#pushArray].numChildren, 1, -1 do 
						display.remove(pushArray[#pushArray][pushArray[#pushArray].numChildren])
						pushArray[#pushArray][pushArray[#pushArray].numChildren] = nil
					end

					display.remove(pushArray[#pushArray]);pushArray[#pushArray]=nil
					
				if pushArray[#pushArray] ~= nil then

					if pushArray[#pushArray].id == "video" then

						for j=pushArray[#pushArray].numChildren, 1, -1 do 
						
							if pushArray[#pushArray][pushArray[#pushArray].numChildren].id == "video" then

								pushArray[#pushArray][pushArray[#pushArray].numChildren].isVisible=true


							end
						end


					end
				end


					composer.hideOverlay()

				end

				

				

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






end

function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	--display.setDefault( "background", 1, 1, 1)
	
	if phase == "will" then


	elseif phase == "did" then


	if pushArray[#pushArray] then

		if pushArray[#pushArray].id == "video" then

			for j=pushArray[#pushArray].numChildren, 1, -1 do 
						
						if pushArray[#pushArray][pushArray[#pushArray].numChildren].id == "video" then

							pushArray[#pushArray][pushArray[#pushArray].numChildren].isVisible=false


						end
			end


		end

	end

	
	pushArray[#pushArray+1] = display.newGroup( )

	 PushGroup = pushArray[#pushArray]
	 PushGroup.id=""

	additionalDate= event.params.additionalValue
	message = event.params.Message
	print( "enter" )

	--additionalDate= {audio="http://c.spanunit.com/000217/Audios/218/loop4_1_.wav"}
	--message = "Lorem Ipsum is simply dummy t--ext of the printing and typesetting industry. Lorem Ipsum has been the industry's st  text of the printing and typesetting industry. Lorem Ipsum has been the industry's st  text of the printing and typesetting industry. Lorem Ipsum has been the industry's st"

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
	Background:addEventListener( "touch", bgTouch )


	PushNotification_bg = display.newRect( PushGroup, W/2,H/2, W-50, H/3 )
	PushNotification_bg:setFillColor(1)	
	PushNotification_bg.strokeWidth=3
	PushNotification_bg.anchorY=0
	PushNotification_bg.y=H/2-PushNotification_bg.contentHeight/2
	PushNotification_bg:setStrokeColor( Utils.convertHexToRGB(sp_Flatmenu_HeaderBg.Background_Color))

	

	--PushNotification_bg:setFillColor(Utility.convertHexToRGB(color.tabBarColor))	

	PushNotification_title_bg = display.newRect( PushGroup, W/2,0, PushNotification_bg.contentWidth, 40 )
	PushNotification_title_bg.y=PushNotification_bg.y+PushNotification_title_bg.contentHeight/2
	PushNotification_title_bg:setFillColor(Utils.convertHexToRGB(sp_Flatmenu_HeaderBg.Background_Color))


	PushNotification_title = display.newText( PushGroup, "Notification", 0, 0, 0,0,native.systemFontBold,16 )
	PushNotification_title.x= PushNotification_title_bg.x-PushNotification_title_bg.contentWidth/2+15
	PushNotification_title.anchorX=0
	PushNotification_title.y= PushNotification_title_bg.y


	if message:len() > 160 then

		message = message:sub(1,160)

	end

	PushNotification_msg = display.newText( PushGroup, "Message : "..message,0,0,PushNotification_title_bg.contentWidth-20, 0,native.systemFont,14 )
	PushNotification_msg.x= W/2
	PushNotification_msg:setFillColor( 0 )
	--PushNotification_msg.anchorX=0
	PushNotification_msg.anchorY=0
	PushNotification_msg.y= PushNotification_title_bg.y+PushNotification_title_bg.contentHeight/2+10

	if additionalDate.video or additionalDate.image then

		PushNotification_bg.height = PushNotification_bg.height+PushNotification_msg.height+30
		PushNotification_bg.y=H/2-PushNotification_bg.contentHeight/2
		PushNotification_title_bg.y=PushNotification_bg.y+PushNotification_title_bg.contentHeight/2
		PushNotification_title.y= PushNotification_title_bg.y
		PushNotification_msg.y= PushNotification_title_bg.y+PushNotification_title_bg.contentHeight/2+10

	elseif additionalDate.audio then

		PushNotification_bg.height = PushNotification_msg.height+100
		PushNotification_bg.y=H/2-PushNotification_bg.contentHeight/2
		PushNotification_title_bg.y=PushNotification_bg.y+PushNotification_title_bg.contentHeight/2
		PushNotification_title.y= PushNotification_title_bg.y
		PushNotification_msg.y= PushNotification_title_bg.y+PushNotification_title_bg.contentHeight/2+10


		playBtn = display.newRect(PushGroup,0,0,85,30)
		playBtn.x=PushNotification_bg.contentWidth/3;playBtn.y = PushNotification_bg.y+PushNotification_bg.contentHeight-playBtn.contentHeight
		playBtn:setFillColor(  Utils.convertHexToRGB(sp_Flatmenu_HeaderBg.Background_Color) )
		playBtn.id="Play"
		playBtn.value=additionalDate.audio


		playBtn_text = display.newText(PushGroup,"Play",0,0,native.systemFont,16)
		playBtn_text.x=playBtn.x;playBtn_text.y=playBtn.y
		Utils.CssforTextView(playBtn_text,sp_primarybutton)	

		--isIos=true

		if isIos ~= true then

		downloadBtn = display.newRect(PushGroup,0,0,85,30)
		downloadBtn.x=PushNotification_bg.contentWidth/2+PushNotification_bg.contentWidth/3;downloadBtn.y = PushNotification_bg.y+PushNotification_bg.contentHeight-downloadBtn.contentHeight
		downloadBtn:setFillColor(  Utils.convertHexToRGB(sp_Flatmenu_HeaderBg.Background_Color))
		downloadBtn.id="Downlaod"

		downloadBtn_text = display.newText(PushGroup,"Download",0,0,native.systemFont,16)
		downloadBtn_text.x=downloadBtn.x;downloadBtn_text.y=downloadBtn.y
		Utils.CssforTextView(downloadBtn_text,sp_primarybutton)	

		downloadBtn:addEventListener( "touch", closeDetailsPush )

		else

			playBtn.x=PushNotification_bg.x
			playBtn_text.x=playBtn.x;playBtn_text.y=playBtn.y

		end

		playBtn:addEventListener( "touch", closeDetailsPush )
		

	else

		PushNotification_bg.height = PushNotification_msg.height+60
		PushNotification_bg.y=H/2-PushNotification_bg.contentHeight/2
		PushNotification_title_bg.y=PushNotification_bg.y+PushNotification_title_bg.contentHeight/2
		PushNotification_title.y= PushNotification_title_bg.y
		PushNotification_msg.y= PushNotification_title_bg.y+PushNotification_title_bg.contentHeight/2+10


	end


	PushNotification_close_bg = display.newRect( PushGroup, PushNotification_bg.x, PushNotification_bg.y, 40,40 )
	PushNotification_close_bg.x=PushNotification_bg.x+PushNotification_bg.contentWidth/2-PushNotification_close_bg.contentWidth/2-5
	PushNotification_close_bg.y =PushNotification_bg.y+PushNotification_close_bg.contentHeight/2
	PushNotification_close_bg:setFillColor(0.4,0.6,0.1)
	PushNotification_close_bg.alpha=0.01

	PushNotification_close = display.newImageRect( PushGroup, "res/assert/icon-close.png",25,25 )
	PushNotification_close.x=PushNotification_close_bg.x
	PushNotification_close.y= PushNotification_close_bg.y

	PushNotification_close_bg:addEventListener( "touch", closeDetailsPush )

	if additionalDate.video then


		PushGroup.id="video"

		 local Url

		if string.find(additionalDate.video:lower( ),"youtube") then

		 if string.find(additionalDate.video,"v=") ~= nil then

		 	local videoId = string.sub(additionalDate.video,string.find(additionalDate.video,"v=")+2,additionalDate.video:len())

		 		local path = system.pathForFile( "story.html", system.TemporaryDirectory )
				local fh, errStr = io.open( path, "w" )

		        if fh then
		            print( "Created file" )
		            fh:write("<!doctype html>\n<html>\n<head>\n<meta charset=\"utf-8\">")
		            fh:write("<meta name=\"viewport\" content=\"width=320; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;\"/>\n")
		            fh:write("<style type=\"text/css\">\n html { -webkit-text-size-adjust: none; font-family: HelveticaNeue-Light, Helvetica, Droid-Sans, Arial, san-serif; font-size: 1.0em; } h1 {font-size:1.25em;} p {font-size:0.9em; } </style>")
		            fh:write("</head>\n<body>\n")
		        
		           
		                Url = "http://www.youtube.com/embed/" .. videoId
		                local height = math.floor(display.contentWidth / 16 * 9)
		                fh:write([[<iframe width="100%" height="]] .. height .. [[" src="]]..Url..[[?html5=1" frameborder="0" allowfullscreen></iframe>]])
		         
		            fh:write( "\n</body>\n</html>\n" )
		            io.close( fh )
		        else
		            print( "Create file failed!" )
		        end
		    else

		    	Url = additionalDate.video


		    end

		elseif string.find(additionalDate.video:lower( ),"facebook") then

			if string.find(additionalDate.video,"videos") ~= nil then

		 	local videoId = string.sub(additionalDate.video,string.find(additionalDate.video,"videos")+7,additionalDate.video:len()-1)

		 		local path = system.pathForFile( "story.html", system.TemporaryDirectory )
				local fh, errStr = io.open( path, "w" )

		        if fh then
		            print( "Created file" )
		            fh:write("<!doctype html>\n<html>\n<head>\n<meta charset=\"utf-8\">")
		            fh:write("<meta name=\"viewport\" content=\"width=320; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;\"/>\n")
		            fh:write("<style type=\"text/css\">\n html { -webkit-text-size-adjust: none; font-family: HelveticaNeue-Light, Helvetica, Droid-Sans, Arial, san-serif; font-size: 1.0em; } h1 {font-size:1.25em;} p {font-size:0.9em; } </style>")
		            fh:write("</head>\n<body>\n")
		        
		           
		                Url = "https://www.facebook.com/video/embed?video_id=" .. videoId
		                local height = math.floor(display.contentWidth / 16 * 9)
		                fh:write([[<iframe width="100%" height="]] .. height .. [[" src="]]..Url..[[?html5=1" frameborder="0" allowfullscreen></iframe>]])
		         
		            fh:write( "\n</body>\n</html>\n" )
		            io.close( fh )
		        else
		            print( "Create file failed!" )
		        end
		    else

		    	Url = additionalDate.video


		    end

		 elseif string.find(additionalDate.video:lower( ),"vimeo") then

			if string.find(additionalDate.video,"vimeo.com") ~= nil then

		 	local videoId = string.sub(additionalDate.video,string.find(additionalDate.video,"vimeo.com")+10,additionalDate.video:len())

		 		local path = system.pathForFile( "story.html", system.TemporaryDirectory )
				local fh, errStr = io.open( path, "w" )

		        if fh then
		            print( "Created file" )
		            fh:write("<!doctype html>\n<html>\n<head>\n<meta charset=\"utf-8\">")
		            fh:write("<meta name=\"viewport\" content=\"width=320; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;\"/>\n")
		            fh:write("<style type=\"text/css\">\n html { -webkit-text-size-adjust: none; font-family: HelveticaNeue-Light, Helvetica, Droid-Sans, Arial, san-serif; font-size: 1.0em; } h1 {font-size:1.25em;} p {font-size:0.9em; } </style>")
		            fh:write("</head>\n<body>\n")
		        
		           
		                Url = "http://player.vimeo.com/video/" .. videoId
		                local height = math.floor(display.contentWidth / 16 * 9)
		                fh:write([[<iframe width="100%" height="]] .. height .. [[" src="]]..Url..[[?html5=1" frameborder="0" allowfullscreen></iframe>]])
		         
		            fh:write( "\n</body>\n</html>\n" )
		            io.close( fh )
		        else
		            print( "Create file failed!" )
		        end
		    else

		    	Url = additionalDate.video


		    end

		else

		    	Url = additionalDate.video


		end 

		     	webView_rect = display.newRect(display.contentCenterX, display.contentCenterY, PushNotification_bg.contentWidth-20, 130 )
		        webView_rect.y=PushNotification_msg.y+PushNotification_msg.contentHeight+5
		        webView_rect.anchorY  = 0

		        webView_rect:setFillColor( 0 )

		        PushGroup:insert( webView_rect)

		        webView = native.newWebView(display.contentCenterX, display.contentCenterY, PushNotification_bg.contentWidth-20, 130 )
		        webView.y=PushNotification_msg.y+PushNotification_msg.contentHeight+5
		        webView.anchorY  = 0
		        webView.id="video"
		        PushGroup:insert( webView)

		        --webView:request("story.html", system.TemporaryDirectory)
		     	webView:request( Url )

		  

    elseif additionalDate.image then

		--

		local PushImage

			local function ImagePush_networkListener( img_event )

				spinner_hide()

			if ( img_event.isError ) then
			elseif ( img_event.phase == "began" ) then
			elseif ( img_event.phase == "ended" ) then

				print( img_event.response.filename )
			PushImage = display.newImage( additionalDate.image:match( "([^/]+)$" ), system.TemporaryDirectory  )  
			PushImage.width = PushNotification_bg.contentWidth-20
				PushImage.height = 130
				PushImage.x=W/2
			PushImage.y=PushNotification_msg.y+PushNotification_msg.contentHeight+5
	        PushImage.anchorY  = 0
	        PushGroup:insert( PushImage)			

			end
	end

	if additionalDate.image:match( "([^/]+)$" ) ~= nil then

		print( additionalDate.image:match( "([^/]+)$" ) )


		local path = system.pathForFile( additionalDate.image:match( "([^/]+)$" ), system.TemporaryDirectory )
		local fhd = io.open( path )

					-- Determine if file exists
			if fhd then
				PushImage = display.newImage( additionalDate.image:match( "([^/]+)$" ), system.TemporaryDirectory  )  
				PushImage.width = PushNotification_bg.contentWidth-20
				PushImage.height = 130
				PushImage.x=W/2
				PushImage.y=PushNotification_msg.y+PushNotification_msg.contentHeight+5
		        PushImage.anchorY  = 0
		        PushGroup:insert( PushImage)
			else
				spinner_show()
			    network.download(
					additionalDate.image,
					"GET",
					ImagePush_networkListener,
					additionalDate.image:match( "([^/]+)$" ),
					system.TemporaryDirectory
										)
			end

	end

		

	end
		
	
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
----------------------------------------------------------------------------------
--
-- chat Screen
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local widget = require("widget")
local lfs = require ("lfs")
local mime = require("mime")
local style = require("res.value.style")
local Utility = require( "Utils.Utility" )
local json = require("json")
local path = system.pathForFile( "MyUnitBuzz.db", system.DocumentsDirectory )
local db = sqlite3.open( path )
local pasteboard = require( "plugin.pasteboard" )
local toast = require('plugin.toast')

local imageFullviewGroup = require( "Controller.imageFullviewGroup" )

--------------- Initialization -------------------

local W = display.contentWidth;
local H= display.contentHeight

local Background,BgText

local AttachmentGroup = display.newGroup( )

local menuBtn,tabButtons,chattabBar,chatScroll,BackBtn,tabBar,title_bg,title,Deleteicon,Copyicon

openPage="MessagingPage"

local BackFlag = false

local ChatBox

local reciveImageFlag=false

local ContactDetails = {}

local ChatHistory = {}

local MeassageList={}

local MessageType=""

local Imagename = ""

local Imagepath = ""

local Imagesize = ""

local MemberName

local image_update_row,audio_update_row

local holdLevel

local chatHoldflag=false

local selectedForDelete

local tabBarGroup = display.newGroup( )

local ChatScrollContent = display.newGroup( )

local UserId,ContactId,To_ContactId

local PHOTO_FUNCTION = media.PhotoLibrary 

local icons_holder_bg,camera_icon,camera_icon_txt,video_icon,video_icon_txt,audio_icon,audio_icon_txt,gallery_icon,gallery_icon_txt,Location_icon,Location_icon_txt,Contact_icon,Contact_icon_txt

for row in db:nrows("SELECT * FROM logindetails WHERE id=1") do
		UserId = row.UserId
		ContactId = row.ContactId
		MemberName = row.MemberName

end



--------------------------------------------------


-----------------Function-------------------------
function makeTimeStamp( dateString )
   local pattern = "(%d+)%-(%d+)%-(%d+)T(%d+):(%d+):(%d+)"
   local year, month, day, hour, minute, seconds, tzoffset, offsethour, offsetmin = dateString:match(pattern)
   local timestamp = os.time(
      { year=year, month=month, day=day, hour=hour, min=minute, sec=seconds, isdst=false }
   )
   local offset = 0
   if ( tzoffset ) then
      if ( tzoffset == "+" or tzoffset == "-" ) then  -- We have a timezone
         offset = offsethour * 60 + offsetmin
         if ( tzoffset == "-" ) then
            offset = offset * -1
         end
         timestamp = timestamp + offset
      end
   end
   return timestamp
end




 function formatSizeUnits(event)

      if (event>=1073741824) then 

      	size=(event/1073741824)..' GB'

      print("size of the image11 ",size)


      elseif (event>=1048576) then   

       	size=(event/1048576)..' MB'

      print("size of the image 22",size)

	  
	  elseif (event > 10485760) then

	  print("highest size of the image ",size)

	    local image = native.showAlert( "Error in Image Upload", "Size of the image cannot be more than 10 MB", { CommonWords.ok } )

	       
      elseif (event>=1024)  then   

      	size = (event/1024)..' KB'

       print("size of the image 33",size)

      else      

  	  end


end



    


    


    local function selectionComplete ( event )
 
        local photo = event.target

        local baseDir = system.DocumentsDirectory

        if photo then

        photo.x = display.contentCenterX
		photo.y = display.contentCenterY
		local w = photo.width
		local h = photo.height
		print( "w,h = ".. w .."," .. h )

		local function rescale()
					
					if photo.width > W or photo.height > H then

						photo.width = photo.width/2
						photo.height = photo.height/2

						intiscale()

					else
               
						return false

					end
				end

		function intiscale()
			
			if photo.width > W or photo.height > H then

				photo.width = photo.width/2
				photo.height = photo.height/2

				rescale()

			else

				return false

			end

		end

		intiscale()

		photoname = "image"..os.date("%Y%m%d%H%M%S")..".png"

        display.save(photo,photoname,system.DocumentsDirectory)


		  local options =  {
				      		effect = "fromTop",
							time = 400,	
								params = {
								imageselected = photoname,
								image = photo,
								sendto = title.text,
								contactId = To_ContactId,
								MessageType = MessageType
							}

							}

			composer.showOverlay("Controller.imagePreviewPage",options)

		photo:removeSelf()

        photo = nil


        path = system.pathForFile( photoname, baseDir)

        local size1 = lfs.attributes (path, "size")

		local fileHandle = io.open(path, "rb")

		file_inbytearray = mime.b64( fileHandle:read( "*a" ) )

		io.close( fileHandle )

            print("mime conversion ",file_inbytearray)

        	print("bbb ",size1)

        formatSizeUnits(size1)

        	--sendImage()

	else

	end

end




-- local function onVideoComplete( event )
--    if ( event.completed ) then
--       media.playVideo( event.url, media.RemoteSource, true, videoPlayBackDone )
--       print( "video duration : ",event.duration )
--       print( "video size : ",event.fileSize )
--    end
-- end




local function attachAction( event )

	if event.phase == "began" then

	elseif event.phase == "ended" then

		if event.target.id =="camera" then

				if media.hasSource( media.Camera ) then
				timer.performWithDelay( 100, function() media.capturePhoto( { listener = selectionComplete, mediaSource = media.Camera } ) 
				end )

			    else

			    	local image1 = native.showAlert( "Camera Unavailable", "Camera is not supported in this device", { CommonWords.ok } )

				end

				ChatBox.isVisible=false



		elseif event.target.id == "video" then

			-- --print( "video" )

			-- 	if ( media.hasSource( PHOTO_FUNCTION ) ) then

			-- 	timer.performWithDelay( 100, function() media.selectVideo( { listener = onVideoComplete, mediaSource = PHOTO_FUNCTION } ) 
			-- 	end )

			-- 	else

			-- 	native.showAlert( "Video Capture Failed", "This device does not have a photo library.", { CommonWords.ok  } )

			-- 	end


			-- 	Runtime:removeEventListener( "enterFrame", printTimeSinceStart )
			-- 	ChatBox.isVisible=false

			 local options = {
		      		effect = "slideRight",
					time = 200,	
						params = {
						contactId = To_ContactId,
						MessageType = MessageType,
						sendto = title.text,
					}

					}

			ChatBox.isVisible=false


			composer.showOverlay( "Controller.videoPage",options)



		elseif event.target.id == "audio" then

			print( "audio" )

			   local options = {
				      		effect = "fromTop",
							time = 200,	
								params = {
								contactId = To_ContactId,
								MessageType = MessageType
							}

							}

			ChatBox.isVisible=false

		    composer.showOverlay( "Controller.audioRecordPage",options)

		elseif event.target.id == "gallery" then

				if media.hasSource( PHOTO_FUNCTION  ) then
				timer.performWithDelay( 100, function() media.selectPhoto( { listener = selectionComplete, mediaSource = PHOTO_FUNCTION } ) 
				end )
				end


		elseif event.target.id == "location" then


		elseif event.target.id == "contact" then

		end

		AttachmentGroup.alpha = 0

	end

return true
end




local function AttachmentTouch( event )

	if event.phase == "began" then

	elseif event.phase == "ended" then
		print( AttachmentGroup.alpha )
		if AttachmentGroup.alpha <= 0.3 then
			AttachmentGroup.yScale=0.1
			AttachmentGroup.alpha = 1

			transition.from( AttachmentGroup, {time=300,alpha=1} )
			transition.scaleTo( AttachmentGroup, {yScale=1.0, time=300 } )
			
		else

			transition.to( AttachmentGroup, {time=300,alpha=0,yScale=0.01} )

		end

	end

return true
end




local function createAttachment( )
	
------------------------------------------- Icons Holder --------------------------------------------

				icons_holder_bg = display.newRect(AttachmentGroup,0,0,W,EditBoxStyle.height+115)
				icons_holder_bg.x=0
				icons_holder_bg.anchorX=0
				icons_holder_bg.anchorY=0
				icons_holder_bg.strokeWidth = 1
				icons_holder_bg:setStrokeColor( 0,0,0,0.1)
				icons_holder_bg.y = tabBar.y+tabBar.height+10
				icons_holder_bg:setFillColor( 1,1,1)

-------------------------------------------- Camera ---------------------------------------------------

				camera_icon = display.newImageRect(AttachmentGroup,"res/assert/camera1.png",40,35)
				camera_icon.x=W/2 - W/3
				camera_icon.anchorX=0
				camera_icon.anchorY=0
				camera_icon.y = icons_holder_bg.y + 7.5
				camera_icon.id="camera"
				camera_icon:addEventListener( "touch", attachAction )


				camera_icon_txt = display.newText(AttachmentGroup,MessagePage.Camera,0,0,native.systemFont,14)
				camera_icon_txt.anchorX = 0
				camera_icon_txt.anchorY = 0
				camera_icon_txt.x = camera_icon.x - 7
				camera_icon_txt.y = camera_icon.y+camera_icon.contentHeight+5
				camera_icon_txt:setFillColor(0)

-------------------------------------------- Video ---------------------------------------------------

				video_icon = display.newImageRect(AttachmentGroup,"res/assert/video1.png",40,35)
				video_icon.x= W/2 - 12
				video_icon.anchorX=0
				video_icon.anchorY=0
				video_icon.y = camera_icon.y
				video_icon.id="video"
				video_icon:addEventListener( "touch", attachAction )


				video_icon_txt = display.newText(AttachmentGroup,MessagePage.Video,0,0,native.systemFont,14)
				video_icon_txt.anchorX = 0
				video_icon_txt.anchorY = 0
				video_icon_txt.x = video_icon.x 
				video_icon_txt.y = video_icon.y+video_icon.contentHeight+5
				video_icon_txt:setFillColor(0)

-------------------------------------------- Audio ---------------------------------------------------

                audio_icon = display.newImageRect(AttachmentGroup,"res/assert/audio1.png",40,35)
				audio_icon.x= W/2 + W/3 - 30
				audio_icon.anchorX=0
				audio_icon.anchorY=0
				audio_icon.y = video_icon.y
				audio_icon.id="audio"
				audio_icon:addEventListener( "touch", attachAction )


				audio_icon_txt = display.newText(AttachmentGroup,MessagePage.Audio,0,0,native.systemFont,14)
				audio_icon_txt.anchorX = 0
				audio_icon_txt.anchorY = 0
				audio_icon_txt.x = audio_icon.x 
				audio_icon_txt.y = audio_icon.y+audio_icon.contentHeight+5
				audio_icon_txt:setFillColor(0)

-------------------------------------------- Gallery ---------------------------------------------------

                gallery_icon = display.newImageRect(AttachmentGroup,"res/assert/gallery1.png",40,35)
				gallery_icon.x= W/2 - W/3 
				gallery_icon.anchorX=0
				gallery_icon.anchorY=0
				gallery_icon.y = camera_icon.y + camera_icon.contentHeight + 35
				gallery_icon.id="gallery"
				gallery_icon:addEventListener( "touch", attachAction )


				gallery_icon_txt = display.newText(AttachmentGroup,MessagePage.Gallery,0,0,native.systemFont,14)
				gallery_icon_txt.anchorX = 0
				gallery_icon_txt.anchorY = 0
				gallery_icon_txt.x = gallery_icon.x - 5
				gallery_icon_txt.y = gallery_icon.y+gallery_icon.contentHeight+5
				gallery_icon_txt:setFillColor(0)


-------------------------------------------- Location ---------------------------------------------------

                Location_icon = display.newImageRect(AttachmentGroup,"res/assert/location1.png",40,35)
				Location_icon.x= W/2 - 12
				Location_icon.anchorX=0
				Location_icon.anchorY=0
				Location_icon.y = gallery_icon.y
				Location_icon.id="location"
				Location_icon:addEventListener( "touch", attachAction )



				Location_icon_txt = display.newText(AttachmentGroup,MessagePage.Location,0,0,native.systemFont,14)
				Location_icon_txt.anchorX = 0
				Location_icon_txt.anchorY = 0
				Location_icon_txt.x = Location_icon.x - 10
				Location_icon_txt.y = Location_icon.y+Location_icon.contentHeight+5
				Location_icon_txt:setFillColor(0)


-------------------------------------------- Contact ---------------------------------------------------

                Contact_icon = display.newImageRect(AttachmentGroup,"res/assert/user1.png",40,35)
				Contact_icon.x= W/2 + W/3 - 30
				Contact_icon.anchorX=0
				Contact_icon.anchorY=0
				Contact_icon.y = Location_icon.y
				Contact_icon.id="contact"
				Contact_icon:addEventListener( "touch", attachAction )



				Contact_icon_txt = display.newText(AttachmentGroup,MessagePage.Contact,0,0,native.systemFont,14)
				Contact_icon_txt.anchorX = 0
				Contact_icon_txt.anchorY = 0
				Contact_icon_txt.x = Contact_icon.x - 7
				Contact_icon_txt.y = Contact_icon.y+Contact_icon.contentHeight+5
				Contact_icon_txt:setFillColor(0)
end 



	local function ChatTouch( event )

		if event.phase == "began" then
			print( "touching" )
			holdLevel=0
			chatHoldflag=true


		elseif event.phase == "moved" then
			 local dy = math.abs( ( event.y - event.yStart ) )
	        -- If the touch on the button has moved more than 10 pixels,
	        -- pass focus back to the scroll view so it can continue scrolling

	        if ( dy > 10 ) then
	        	display.getCurrentStage():setFocus( nil )
	            chatScroll:takeFocus( event )
	            holdLevel=0
	            chatHoldflag=false
	        end

		elseif event.phase == "ended" then

			chatHoldflag=false
			

			if holdLevel > 25 then

				Deleteicon.value=event.target.id
				Deleteicon.type=event.target.type
				Deleteicon.contentPath=event.target.contentPath

				Copyicon.type = event.target.type

					if Copyicon.type ~= "text" then

						Copyicon.isVisible = false

					else

						Copyicon.isVisible = true

					end
				
				Copyicon.value = event.target.chat

				if selectedForDelete ~= nil then 

					if Copyicon.type ~= "text" then

						Copyicon.isVisible = false

					else

						Copyicon.isVisible = true

					end

					if selectedForDelete.y ~= nil then
					 selectedForDelete:removeSelf();selectedForDelete=nil 

					-- attachment_icon.isVisible =true
					 end 
				end

				selectedForDelete = display.newRect( W/2,event.target.y+event.target.contentHeight/2,W,event.target.contentHeight+15)
				selectedForDelete:setFillColor( 0.3,0.6,0.5,0.4 )
				event.target.group:insert( selectedForDelete )

				print("delete Action")
			else

				if event.target.type == "image" and selectedForDelete == nil then

					imageviewname = event.target.imageviewname

				local options = {
					      		effect = "fromTop",
								time = 200,	
								params = {
									imagenameval = imageviewname,
								}
								}


					composer.showOverlay("Controller.imageFullviewPage",options)

			    end


			end

			holdLevel=0

				
				
		end

	return true

	end



	local function recivedNetwork( event )
	    if ( event.isError ) then
	        print( "Network error - download failed: ", event.response )
	    elseif ( event.phase == "began" ) then
	        print( "Progress Phase: began" )
	    elseif ( event.phase == "ended" ) then
	        print( "Displaying response image file" )
	        reciveImageFlag=true
	  		
	    end
	end



	local function receviednotifyDownload( event )
		if event.phase == "began" then
				display.getCurrentStage():setFocus( event.target )
		elseif event.phase == "ended" then
				display.getCurrentStage():setFocus( nil )

	--    event.target.object.isVisible = true
	--    event.target.object:toFront()
	--    event.target.object:start()


				spinner.isVisible=false

				local options = {
				    width = 32,
				    height = 32,
				    numFrames = 4,
					sheetContentWidth = 64,
					sheetContentHeight = 64
					}

					local spinnerSingleSheet = graphics.newImageSheet( "res/assert/imagespinner.png", options )

					local image_spinner = widget.newSpinner
						{
						  width = 106/4 ,
						  height = 111/4,
						  deltaAngle = 10,
						  sheet = spinnerSingleSheet,
						  startFrame = 1,
						  incrementEvery = 20
						}

						image_spinner.x=event.target.x+event.target.contentWidth/2;image_spinner.y=event.target.y+event.target.contentHeight/2
						image_spinner:toFront();image_spinner:start()
						event.target.object:insert(image_spinner)


		network.download(
		event.target.id,
		"GET",
		recivedNetwork,
		event.target.id:match( "([^/]+)$" ),
		system.DocumentsDirectory
		)

		event.target:removeSelf( );event.target = nil

    --   event.target:removeSelf()
    --   event.target = nil
		--image_spinner:toBack()
        --image_spinner:stop()

		end

	return true
	end

local function audioPlayComplete( event )

	print( "complete" )

	    if ( event.completed ) then



				for i=#MeassageList, 1, -1 do 
					local group = MeassageList[#MeassageList]

						for j=group.numChildren, 1, -1 do 

							if group[j].value == "pause" then

								group[j]:setSequence( "play" )
								group[j].value="play"
		      					group[j]:play()

		      				end


						end
												
				end

		end
end

local function audioPlay( event )
			if event.phase == "began" then
				display.getCurrentStage():setFocus( event.target )
		elseif event.phase == "ended" then
				display.getCurrentStage():setFocus( nil )

					local audioname = event.target.id:match( "([^/]+)$" )

					--native.showAlert( "MUB", "audioname" ,{"ok"} )
					if not audioname then
						audioname = event.target.id
					end

					 local filePath = system.pathForFile( audioname, system.DocumentsDirectory )
		            -- Play back the recording
		            local file = io.open( filePath)
		            
		            if file then
		                io.close( file )

		                	

		               
		                if event.target.value == "play" then
               	

		                	 local isChannel1Playing = audio.isChannelPlaying( 2 )
								if isChannel1Playing or isSimulator then

									 for i=#MeassageList, 1, -1 do 
												local group = MeassageList[#MeassageList]

												for j=group.numChildren, 1, -1 do 

													

													if group[j].value == "pause" then

														group[j]:setSequence( "play" )
														group[j].value="play"
	      												group[j]:play()

													end

									   		 	end
												
										end




									event.target:setSequence( "pause" )
			      					event.target:play()
			      					event.target.value="pause"
			      					if event.target.channel == 2 then
			      					 	audio.resume( 2 )

			      					end

								else

									local laserSound = audio.loadSound( filePath )
					                local laserChannel = audio.play( laserSound,{channel=2,onComplete = audioPlayComplete} )
					                event.target:setSequence( "pause" )
			      					event.target:play()
			      					event.target.value="pause"
			      					event.target.channel=2
								end
			           

	      				elseif event.target.value == "pause" then
	      						print( "pause" )
	      						 local isChannel1Playing = audio.isChannelPlaying( 2 )
									if isChannel1Playing or isSimulator then
									    audio.pause( 2 )
									end
									     event.target:setSequence( "play" )
				      					event.target:play()
				      					event.target.value="play"
									

									

	      				end

		            else

		            end

		-- network.download(
		-- event.target.id,
		-- "GET",
		-- recivedNetwork,
		-- event.target.id:match( "([^/]+)$" ),
		-- system.DocumentsDirectory
		-- )

		end

	return true
end






local function videoPlay( event )
		
		if event.phase == "began" then
				display.getCurrentStage():setFocus( event.target )
		elseif event.phase == "ended" then
				display.getCurrentStage():setFocus( nil )

					local videoname = event.target.id:match( "([^/]+)$" )

					 local filePath = system.pathForFile( videoname, system.DocumentsDirectory )
		            -- Play back the recording
		            local file = io.open( filePath)
		            
		            if file then
		                io.close( file )

		               
		                if event.target.value == "play" then
		                	print("play")


	                	
	      				end

		            end
		end

	return true
end





	local function sendMeaasage()

		for i=#MeassageList, 1, -1 do 
				display.remove(MeassageList[#MeassageList])
				MeassageList[#MeassageList] = nil
		end

		for i=#ChatHistory, 1, -1 do 
				ChatHistory[#ChatHistory] = nil
		end

		for row in db:nrows("SELECT * FROM pu_MyUnitBuzz_Message WHERE (Message_To='"..tostring(To_ContactId):lower().."') OR (Message_From='"..tostring(To_ContactId):lower().."') ") do

			local q = "UPDATE pu_MyUnitBuzz_Message SET Message_Status='SEND' WHERE id='"..row.id.."';"
			db:exec( q )

			ChatHistory[#ChatHistory+1] = row

		end

		

		local dateVlaue=""

		for i=1,#ChatHistory do

			if ChatHistory[i].Message_Type:lower() == MessageType:lower() then

			local dateLable = nil
			local datevalue = nil

			MeassageList[#MeassageList+1] = display.newGroup()

			local tempGroup = MeassageList[#MeassageList]

			local bg = display.newRect(0,0,W-100,25 )
			tempGroup:insert(bg);bg.anchorX=0;bg.anchorY=0;bg.id=ChatHistory[i].id;bg.group=tempGroup;bg.type = "text"
			
			bg:addEventListener( "touch", ChatTouch )


			if MeassageList[#MeassageList-1] ~= nil then
				bg.y=MeassageList[#MeassageList-1][1].y+MeassageList[#MeassageList-1][1].contentHeight+20
			else
				bg.y=0
			end
		
			if dateVlaue =="" or (Utils.getTime(makeTimeStamp(dateVlaue),"%d/%m/%Y",TimeZone) ~= Utils.getTime(makeTimeStamp(ChatHistory[i].Update_Time_Stamp),"%d/%m/%Y",TimeZone) )then

				print( "coming" ..dateVlaue,ChatHistory[i].Update_Time_Stamp)
				dateVlaue =ChatHistory[i].Update_Time_Stamp

				dateLable = display.newRect( tempGroup, W/2, bg.y+5, 80,20 )
				bg.y=bg.y+30
				dateLable:setFillColor( Utils.convertHexToRGB(color.tabBarColor) )
				dateLable.alpha=0.3

				datevalue = display.newText( tempGroup,  Utils.getTime(makeTimeStamp(ChatHistory[i].Update_Time_Stamp),"%B %d, %Y",TimeZone), 0,0,native.systemFont,11)
				datevalue.x=dateLable.x;datevalue.y=dateLable.y
				datevalue:setFillColor( 0,0,0,0.6 )

				if Utils.getTime(makeTimeStamp(ChatHistory[i].Update_Time_Stamp),"%B %d, %Y",TimeZone) == Utils.getTime(os.time(os.date( "!*t" )),"%B %d, %Y",TimeZone) then

					datevalue.text = ChatPage.Today

				else

					local t = os.date( "!*t" )
					t.day=t.day-1

					if Utils.getTime(makeTimeStamp(ChatHistory[i].Update_Time_Stamp),"%B %d, %Y",TimeZone) == Utils.getTime(os.time(t),"%B %d, %Y",TimeZone) then

					datevalue.text = ChatPage.Yesterday

					end

				end

			end




			if ChatHistory[i].Message_From == tostring(ContactId) then

					bg.x = W-65
					bg.anchorX = 1


			  local filePath = system.pathForFile( ChatHistory[i].Message_From..".png",system.TemporaryDirectory )
			  local fhd = io.open( filePath )

			  local Image

					 if fhd then

							Image = display.newImageRect(tempGroup,ChatHistory[i].Message_From..".png",system.TemporaryDirectory,45,38)
							io.close( fhd )

					else
								Image = display.newImageRect(tempGroup,"res/assert/twitter_placeholder.png",35,35)

					end

										Image.x=W-35;Image.y=bg.y+bg.height/2

										local mask = graphics.newMask( "res/assert/masknew.png" )

										Image:setMask( mask )

			else

							bg.x=65

							local Image = display.newImageRect(tempGroup,To_ContactId..".png",system.TemporaryDirectory,45,38)

							if not Image then
								Image = display.newImageRect(tempGroup,"res/assert/twitter_placeholder.png",35,35)
								Image.x=30;Image.y=bg.y+bg.height/2

							end

										Image.x=30;Image.y=bg.y+bg.height/2

										local mask = graphics.newMask( "res/assert/masknew.png" )

										Image:setMask( mask )

				
			end



			local chat	


			if ChatHistory[i].MyUnitBuzz_Message:len() > 40 then

				chat = display.newText( Utils.decrypt(ChatHistory[i].MyUnitBuzz_Message),W-80,0,W-115,0,native.systemFont,12)

			else

				chat = display.newText( Utils.decrypt(ChatHistory[i].MyUnitBuzz_Message),W-80,0,native.systemFont,12)

			end

			chat.anchorY=0;chat.anchorX = 0;chat.x=bg.x+5;chat.y=bg.y
			tempGroup:insert( chat )

		
			bg.width = chat.contentWidth+10;bg.height = chat.contentHeight+10
			bg.chat=chat.text


			local owner

			if MessageType == "GROUP" then

				owner = display.newText(tempGroup,"",0,0,native.systemFont,14)
				owner.anchorY=0
				owner.anchorX = 0
				owner.x=chat.x
				owner.y=chat.y
				owner:setTextColor(1,1,0)
				chat.y=owner.y+20


				bg.height = bg.height+20

				if ChatHistory[i].Message_From == tostring(ContactId) then

					owner.text = MemberName
				else
					owner.text = ChatHistory[i].ToName or "(~No Name)"
				end
			

				if owner.contentWidth > bg.contentWidth then
						bg.width = owner.contentWidth+10	
				end

			
			end

				bg.height = bg.height+10
				bg.width = bg.width+35


			--------audio Attachment---------------

			print( "Status = "..ChatHistory[i].Audio_Path )

				if ChatHistory[i].Audio_Path  ~= nil and ChatHistory[i].Audio_Path ~= "" and ChatHistory[i].Audio_Path ~= "NULL" and ChatHistory[i].Audio_Path ~= " " then

					local audioname = ChatHistory[i].Audio_Path:match( "([^/]+)$" )

					 local audio

					 bg.type = "audio"

					 local filePath = system.pathForFile( audioname,system.DocumentsDirectory )
				 	 local fhd = io.open( filePath )

					  bg.contentPath = filePath



					
					if fhd then	

							spinner.isVisible=false

							bg.width=bg.width+25;bg.height=bg.height+30

							local sheetData2 = { width=30, height=30, numFrames=2, sheetContentWidth=60, sheetContentHeight=30 }
							local sheet1 = graphics.newImageSheet( "res/assert/playpause.png", sheetData2 )

							local sequenceData = {
				                { name="play", sheet=sheet1, start=1, count=1, time=220, loopCount=1 },
				                { name="pause", sheet=sheet1, start=2, count=1, time=220, loopCount=1 },
				                }
				           --chat.text=""

				           chat.size=14
							local playIcon = display.newSprite( sheet1, sequenceData )
							playIcon.x=bg.x-bg.contentWidth/2;playIcon.y=bg.y+bg.contentHeight/2
							playIcon.id=ChatHistory[i].Audio_Path
							playIcon.value="play"
							playIcon:addEventListener( "touch", audioPlay )
							playIcon:setSequence( "play" )
      						playIcon:play()
							tempGroup:insert(playIcon)

							if ChatHistory[i].Message_From ~= tostring(ContactId) then
								playIcon.x = bg.x+bg.contentWidth/2
							end
					else

						if ChatHistory[i].Audio_Path == "DEFAULT" then
								

								spinner.isVisible=false

								    local options = {
												    width = 32,
												    height = 32,
												    numFrames = 4,
												    sheetContentWidth = 64,
												    sheetContentHeight = 64
												}

									local spinnerSingleSheet = graphics.newImageSheet( "res/assert/imagespinner.png", options )
 
								    local image_spinner = widget.newSpinner
														{
														    width = 106/4 ,
														    height = 111/4,
														    deltaAngle = 10,
														    sheet = spinnerSingleSheet,
														    startFrame = 1,
														    incrementEvery = 20
														}

										image_spinner.x=bg.x-bg.contentWidth/2;image_spinner.y=bg.y+bg.contentHeight/2
									    image_spinner:toFront();image_spinner:start()


									    image_spinner:start()

									    tempGroup:insert(image_spinner)

									    bg.height = bg.height+20;bg.width = bg.width+20



						else
							
							--When audio notification receives

							local downloadimage = display.newImageRect(tempGroup,"res/assert/download_image.jpg", 45, 45 )
									downloadimage.x = bg.x+bg.contentWidth/4
									downloadimage.id = ChatHistory[i].Audio_Path
									downloadimage.anchorX = 0
									downloadimage.anchorY = 0
									downloadimage.object = tempGroup
									downloadimage.y = bg.y
									downloadimage.isVisible = true
									downloadimage:toFront()

									bg.width=bg.width+20;bg.height=bg.height+25


									downloadimage:addEventListener( "touch", receviednotifyDownload )
							

						end

					end


				end


			--------- Video Attachment ---------------


				if ChatHistory[i].Video_Path  ~= nil and ChatHistory[i].Video_Path ~= "" and ChatHistory[i].Video_Path ~= "NULL" and ChatHistory[i].Video_Path ~= " " then

					local videoname = ChatHistory[i].Video_Path:match( "([^/]+)$" )

					 local video

					 bg.type = "video"

					 local filePath = system.pathForFile( videoname,system.DocumentsDirectory )
				 	 local fhd = io.open( filePath )

					  bg.contentPath = filePath

					
					if fhd then	
							bg.width=bg.width+25;bg.height=bg.height+20

							local sheetData2 = { width=30, height=30, numFrames=2, sheetContentWidth=60, sheetContentHeight=30 }
							local sheet1 = graphics.newImageSheet( "res/assert/playpause.png", sheetData2 )

							local sequenceData = {
				                { name="play", sheet=sheet1, start=1, count=1, time=220, loopCount=1 },
				                { name="pause", sheet=sheet1, start=2, count=1, time=220, loopCount=1 },
				                }

							local playIcon = display.newSprite( sheet1, sequenceData )
							playIcon.x=bg.x-bg.contentWidth/2;playIcon.y=bg.y+bg.contentHeight/2-5
							playIcon.id=ChatHistory[i].Video_Path
							playIcon.value="play"
							playIcon:addEventListener( "touch", videoPlay )
							playIcon:setSequence( "play" )
      						playIcon:play()
							tempGroup:insert(playIcon)

							if ChatHistory[i].Message_From ~= tostring(ContactId) then
								playIcon.x = bg.x+bg.contentWidth/2
							end
					else

						if ChatHistory[i].Video_Path == "DEFAULT" then
								

								spinner.isVisible=false

								    local options = {
												    width = 32,
												    height = 32,
												    numFrames = 4,
												    sheetContentWidth = 64,
												    sheetContentHeight = 64
												}

									local spinnerSingleSheet = graphics.newImageSheet( "res/assert/imagespinner.png", options )
 
								    local image_spinner = widget.newSpinner
														{
														    width = 106/4 ,
														    height = 111/4,
														    deltaAngle = 10,
														    sheet = spinnerSingleSheet,
														    startFrame = 1,
														    incrementEvery = 20
														}

										image_spinner.x=bg.x-bg.contentWidth/2;image_spinner.y=bg.y+bg.contentHeight/2
									    image_spinner:toFront();image_spinner:start()


									    image_spinner:start()

									    tempGroup:insert(image_spinner)

									    bg.height = bg.height+20;bg.width = bg.width+15



						else
							
							--When audio notification receives

							local downloadimage = display.newImageRect(tempGroup,"res/assert/download_image.jpg", 45, 45 )
									downloadimage.x = bg.x+bg.contentWidth/4
									downloadimage.id = ChatHistory[i].Video_Path
									downloadimage.anchorX = 0
									downloadimage.anchorY = 0
									downloadimage.object = tempGroup
									downloadimage.y = bg.y
									downloadimage.isVisible = true
									downloadimage:toFront()

									bg.width=bg.width+20;bg.height=bg.height+25


									downloadimage:addEventListener( "touch", receviednotifyDownload )
							

						end

					end


				end



			--------Image Attachment---------------

			if ChatHistory[i].Image_Path  ~= nil and ChatHistory[i].Image_Path ~= "" then

				 Imagename = ChatHistory[i].Image_Path:match( "([^/]+)$" )

				 local image

				 local filePath = system.pathForFile( Imagename,system.DocumentsDirectory )
			 	 local fhd = io.open( filePath )

			 	 bg.type = "image";bg.contentPath = filePath; bg.imageviewname = Imagename
				
					if fhd or ChatHistory[i].Image_Path == "DEFAULT" then	

								spinner.isVisible=false

							    if MessageType == "GROUP" then	
										
									image = display.newImageRect( tempGroup, Imagename,system.DocumentsDirectory, 200, 170 )
									image.id = ChatHistory[i].Image_Path

									bg.width = image.contentWidth+5
									bg.height = image.contentHeight+23.5

									owner.anchorY=0
									owner.anchorX = 0
									owner.x=chat.x
									owner.y=bg.y+1

									image.anchorY=0
									image.anchorX = 0
									image.x=bg.x+2.5

									image.y=owner.y+20	

								else

								    image = display.newImageRect( tempGroup, Imagename,system.DocumentsDirectory, 200, 170 )
								    image.id = ChatHistory[i].Image_Path

									image.anchorY=0
									image.anchorX = 0
									image.x=bg.x+2.5
									image.y=bg.y+2.5

									bg.width = image.contentWidth+5
									bg.height = image.contentHeight+5

								end

							io.close( fhd )

					else

					

						if ChatHistory[i].Image_Path == "DEFAULT" then

								image = display.newImageRect( tempGroup, "res/assert/detail_defalut.jpg", 200, 170 )
								image.id = ChatHistory[i].Image_Path;bg.width = image.contentWidth+5;bg.height = image.contentHeight+23.5

								if MessageType == "GROUP" then	

									owner.anchorY=0;owner.anchorX = 0;owner.x=chat.x;owner.y=bg.y+1 
									image.anchorY=0;image.anchorX = 0;image.x=bg.x+2.5;image.y=owner.y+20
									bg.width = image.contentWidth+5
									bg.height = image.contentHeight+23.5
								else
									image.anchorY=0;image.anchorX = 0;image.x=bg.x+2.5;image.y=bg.y+2.5
									bg.width = image.contentWidth+5
									bg.height = image.contentHeight+5	


								end
						

								spinner.isVisible=false


								local options = {
												    width = 32,
												    height = 32,
												    numFrames = 4,
												    sheetContentWidth = 64,
												    sheetContentHeight = 64
												}

										local spinnerSingleSheet = graphics.newImageSheet( "res/assert/imagespinner.png", options )

								local image_spinner = widget.newSpinner

												{
												    width = 106/4 ,
												    height = 111/4,
												    deltaAngle = 10,
												    sheet = spinnerSingleSheet,
												    startFrame = 1,
												    incrementEvery = 20
												}

												image_spinner.x=image.x-image.contentWidth/2;image_spinner.y=image.y+image.contentHeight/2
											    image_spinner:toFront();image_spinner:start()

											   tempGroup:insert(image_spinner)

						else
							--When image notification recive



							    if MessageType == "GROUP" then	
									
									image = display.newImageRect( tempGroup, "res/assert/download_default.jpg", 200, 170 )
								    bg.width = image.contentWidth+5;bg.height = image.contentHeight+23.5

									owner.anchorY=0;owner.anchorX = 0;owner.x=chat.x;owner.y=bg.y+1
									image.anchorY=0;image.anchorX = 0;image.x=bg.x+2.5;image.y=owner.y+20	
									
									spinner.isVisible=false

								    local options = {
												    width = 32,
												    height = 32,
												    numFrames = 4,
												    sheetContentWidth = 64,
												    sheetContentHeight = 64
												}

									local spinnerSingleSheet = graphics.newImageSheet( "res/assert/imagespinner.png", options )
 
								    local image_spinner = widget.newSpinner
														{
														    width = 106/4 ,
														    height = 111/4,
														    deltaAngle = 10,
														    sheet = spinnerSingleSheet,
														    startFrame = 1,
														    incrementEvery = 20
														}

										image_spinner.x=image.x-image.contentWidth/2;image_spinner.y=image.y+image.contentHeight/2
									    image_spinner:toFront();image_spinner:start()


									    image_spinner.isVisible = false

									    tempGroup:insert(image_spinner)


									local downloadimage = display.newImageRect(tempGroup,"res/assert/download_image.jpg", 45, 45 )
									downloadimage.x = image.x+image.contentWidth/2-25
									downloadimage.id = ChatHistory[i].Image_Path
									downloadimage.anchorX = 0
									downloadimage.anchorY = 0
									--downloadimage.object = image_spinner
									downloadimage.y = image.y+image.contentHeight/2-25
									downloadimage.isVisible = true
									downloadimage:toFront()


									downloadimage:addEventListener( "touch", receviednotifyDownload )



								else

									image = display.newImageRect( tempGroup, "res/assert/download_default.jpg", 200, 170 )
									image.anchorY=0;image.anchorX = 0;image.x=bg.x+2.5;image.y=bg.y+2.5

									bg.width = image.contentWidth+5;bg.height = image.contentHeight+5	


									local downloadimage = display.newImageRect(tempGroup,"res/assert/download_image.jpg", 45, 45 )
									downloadimage.x = image.x+image.contentWidth/2-25
									downloadimage.id = ChatHistory[i].Image_Path
									downloadimage.anchorX = 0
									downloadimage.anchorY = 0
									downloadimage.object = tempGroup
									downloadimage.y = image.y+image.contentHeight/2-25
									downloadimage.isVisible = true
									downloadimage:toFront()


									downloadimage:addEventListener( "touch", receviednotifyDownload )

								end

						end

					end	


				if ChatHistory[i].Message_From == tostring(ContactId) then
					image.x = bg.x-bg.contentWidth+2.5
				end

			end



			local time = display.newText( tempGroup, Utils.getTime(makeTimeStamp(ChatHistory[i].Update_Time_Stamp),"%I:%M %p",TimeZone), 0, 0 , native.systemFont ,10 )
			time.x=bg.x-5
			time.y=bg.y+bg.contentHeight-time.contentHeight/2-10
			time.anchorX=bg.anchorX;time.anchorY=bg.anchorY

				
			local arrow = display.newImageRect( tempGroup, "res/assert/whitetriangle.png", 8, 8 )
			arrow.x=bg.x-5
			arrow.y=bg.y-0.3
			arrow.anchorY=0


			if ChatHistory[i].Message_From == tostring(ContactId) then
				chat.x = bg.x-bg.contentWidth+5
									time.x=bg.x-2.5

				if owner ~= nil then print("$$$ : "..owner.text);owner.x=chat.x end
				bg:setFillColor( Utils.convertHexToRGB(color.tabBarColor) )

			else
				time.x=bg.x+bg.contentWidth-time.contentWidth-2.5
				bg:setFillColor( Utils.convertHexToRGB(color.Gray) )
			end



			if ChatHistory[i].Message_From == tostring(ContactId) then
				arrow.x=bg.x+2
				arrow:setFillColor( Utils.convertHexToRGB(color.tabBarColor) )

			else
			
			arrow:scale( -1, 1 )
			arrow.x=arrow.x+2
			arrow:setFillColor( Utils.convertHexToRGB(color.Gray) )

			end

			chatScroll:insert(tempGroup)

		end

	end

	chatScroll:scrollTo( "bottom", { time=200 } )

	end




function get_videomodel( response )
	
--	print(json.encode(response))

local options =
{
   to = { "anitha.mani@w3magix.com"},
   subject = "video response",
   isBodyHtml = true,
   body = ""..event.response,

}
native.showPopup( "mail", options )

end




function get_imagemodel(response)


		Imagepath = response.Abspath

		Imagename = response.FileName

		Imagesize = size

		ChatBox_bg.isVisible = true

		ChatBox.isVisible = true

		sendBtn_bg.isVisible = true

		sendBtn.isVisible = true

		local q = "UPDATE pu_MyUnitBuzz_Message SET Image_Path='"..Imagepath.."' WHERE id='"..image_update_row.."';"
		db:exec( q )

		--sendMeaasage()

			local Message_date,isDeleted,Created_TimeStamp,Updated_TimeStamp,ImagePath,AudioPath,VideoPath,MyUnitBuzz_LongMessage,From,To,Message_Type
			
			Message_date=os.date("%Y-%m-%dT%H:%M:%S")
			isDeleted="false"
			Created_TimeStamp=os.date("!%Y-%m-%dT%H:%M:%S")
			Updated_TimeStamp=os.date("!%Y-%m-%dT%H:%M:%S")
			ImagePath= Imagepath or ""
			AudioPath="NULL"
			VideoPath="NULL"
			MyUnitBuzz_LongMessage=ChatBox.text
			From=ContactId
			To=To_ContactId
			Message_Type = MessageType


			Webservice.SEND_MESSAGE(ChatBox.text,ChatBox.text,"","","","",ImagePath,Imagename,Imagesize,"","","","SEND",From,To,Message_Type,get_sendMssage)

	end





	local function printTimeSinceStart( event )


			if chatHoldflag == true then

				holdLevel=holdLevel+1

					if holdLevel > 25 then

						Deleteicon.isVisible=true
						--Copyicon.isVisible=true

					if Copyicon.type ~= "text" then

						Copyicon.isVisible = false

					else

						Copyicon.isVisible = true

					end


						attachment_icon.isVisible = false

					end

			end

			if reciveImageFlag == true then
				reciveImageFlag=false
				sendMeaasage()
			end

		    if chatReceivedFlag==true then

			chatReceivedFlag=false

			sendMeaasage()
			end 

			-- if selectedForDelete ~= nil then 
			-- 	if selectedForDelete.y ~= nil then
			-- 	 selectedForDelete:removeSelf();selectedForDelete=nil 
			-- 	 end 
			-- end

			tabBar:toFront( );menuBtn:toFront( );BgText:toFront( );title_bg:toFront( );title:toFront( );BackBtn:toFront( );Deleteicon:toFront( );Copyicon:toFront( );attachment_icon:toFront()
		    		
		    end




local function deleteAction( event )

	if event.phase == "ended" then
 
		if event.target.id == "delete" then

				if event.target.type ~= "text" then

					os.remove( event.target.contentPath )

				end

				local q = [[DELETE FROM pu_MyUnitBuzz_Message WHERE id=]]..event.target.value..[[;]]
				db:exec( q )
				sendMeaasage()

		elseif event.target.id == "copy" then
						

						pasteboard.copy( "string", event.target.value)

						toast.show(ChatPage.Message_Copied, {duration = 'long', gravity = 'Center', offset = {0, 128}})  

		end		
					Copyicon.isVisible=false
					Deleteicon.isVisible=false

					attachment_icon.isVisible = true

			if selectedForDelete ~= nil then 

				 if selectedForDelete.y ~= nil then

				 selectedForDelete:removeSelf();selectedForDelete=nil 
				 end 

			end

	end

return true

end




function get_sendMssage(response)

	ChatBox.text=""

    if image_name_png.isVisible == true and image_name_close.isVisible == true then

    	image_name_png.isVisible = false 

    	image_name_close.isVisible = false 

    	sendBtn.isVisible = false

    	sendBtn_bg.isVisible = false

    	recordBtn.isVisible = true

    end

	sendMeaasage()

end




local function DetailAction( event )
	if event.phase == "began" then

		display.getCurrentStage():setFocus( event.target )

	elseif ( event.phase == "moved" ) then
        local dy = math.abs( ( event.y - event.yStart ) )
       
	        if ( dy > 10 ) then
	        	display.getCurrentStage():setFocus( nil )
	            chatScroll:takeFocus( event )
	        end

	elseif event.phase == "ended" then
			display.getCurrentStage():setFocus( nil )

				      local options = {
				      		effect = "fromTop",
							time = 200,	
								params = {
								contactId = To_ContactId,
								MessageType = MessageType
							}

							}


			ChatBox.isVisible=false
		    composer.showOverlay( "Controller.Chathead_detailPage", options )

	end

return true
end




local function backAction( event )
	if event.phase == "began" then

		display.getCurrentStage():setFocus( event.target )

	elseif ( event.phase == "moved" ) then
        local dy = math.abs( ( event.y - event.yStart ) )
       
	        if ( dy > 10 ) then
	        	display.getCurrentStage():setFocus( nil )
	            chatScroll:takeFocus( event )
	        end

	elseif event.phase == "ended" then
			display.getCurrentStage():setFocus( nil )

				      local options = {
				      		effect = "flipFadeOutIn",
							time = 200,	

							}

				    composer.gotoScene( "Controller.MessagingPage", options )

	end

return true
end



local function ChatSendAction( event )
	if event.phase == "began" then

			display.getCurrentStage():setFocus( event.target )

	elseif ( event.phase == "moved" ) then
        local dy = math.abs( ( event.y - event.yStart ) )
        -- If the touch on the button has moved more than 10 pixels,
        -- pass focus back to the scroll view so it can continue scrolling

        if ( dy > 10 ) then
        	display.getCurrentStage():setFocus( nil )
            chatScroll:takeFocus( event )
        end

	elseif event.phase == "ended" then
			display.getCurrentStage():setFocus( nil )



	if ChatBox.text ~= nil and ChatBox.text ~= "" and ChatBox.text ~= " " and ChatBox.text ~= "\n" then
			
			print( "%%%%%%%%%%%%%%%" )
			local Message_date,isDeleted,Created_TimeStamp,Updated_TimeStamp,ImagePath,AudioPath,VideoPath,MyUnitBuzz_LongMessage,From,To,Message_Type
			
			Message_date=os.date("%Y-%m-%dT%H:%M:%S")
			isDeleted="false"
			Created_TimeStamp=os.date("!%Y-%m-%dT%H:%M:%S")
			Updated_TimeStamp=os.date("!%Y-%m-%dT%H:%M:%S")
			ImagePath= ""
			AudioPath="NULL"
			VideoPath="NULL"
			MyUnitBuzz_LongMessage=ChatBox.text
			From=ContactId
			To=To_ContactId
			Message_Type = MessageType


		    --	native.showAlert("Type",Message_Type,{CommonWords.ok})

				print(UserId.."\n"..ChatBox.text.."\n"..Message_date.."\n"..isDeleted.."\n"..Created_TimeStamp.."\n"..Updated_TimeStamp.."\n"..MyUnitBuzz_LongMessage.."\n"..From.."\n"..To_ContactId.."\n"..MemberName.."\n end" )
				local insertQuery = [[INSERT INTO pu_MyUnitBuzz_Message VALUES (NULL, ']]..UserId..[[',']]..Utils.encrypt(ChatBox.text)..[[','SEND',']]..Message_date..[[',']]..isDeleted..[[',']]..Created_TimeStamp..[[',']]..Updated_TimeStamp..[[',']]..ImagePath..[[',']]..AudioPath..[[',']]..VideoPath..[[',']]..MyUnitBuzz_LongMessage..[[',']]..From..[[',']]..To..[[',']]..Message_Type..[[',']]..title.text..[[',']]..MemberName..[[',']]..title.text..[[');]]
				db:exec( insertQuery )


			Webservice.SEND_MESSAGE(ChatBox.text,ChatBox.text,"","","","",ImagePath,Imagename,Imagesize,"","","","SEND",From,To,Message_Type,get_sendMssage)


		    else

		    	if Imagename ~= nil or Imagename ~= "" then

		    		if ChatBox.text ~= nil and ChatBox.text ~= "" then


		            local Message_date,isDeleted,Created_TimeStamp,Updated_TimeStamp,ImagePath,ImageName,ImageSize,AudioPath,VideoPath,MyUnitBuzz_LongMessage,From,To,Message_Type
					
					Message_date=os.date("%Y-%m-%dT%H:%M:%S")
					isDeleted="false"
					Created_TimeStamp=os.date("!%Y-%m-%dT%H:%M:%S")
					Updated_TimeStamp=os.date("!%Y-%m-%dT%H:%M:%S")
					ImagePath=Imagepath
					ImageName = Imagename
					ImageSize = Imagesize
					AudioPath="NULL"
					VideoPath="NULL"
					MyUnitBuzz_LongMessage=ChatBox.text
					From=ContactId
					To=To_ContactId
					Message_Type = MessageType


					local insertQuery = [[INSERT INTO pu_MyUnitBuzz_Message VALUES (NULL, ']]..UserId..[[','Image','SEND',']]..Message_date..[[',']]..isDeleted..[[',']]..Created_TimeStamp..[[',']]..Updated_TimeStamp..[[',']]..ImagePath..[[',']]..AudioPath..[[',']]..VideoPath..[[',']]..MyUnitBuzz_LongMessage..[[',']]..From..[[',']]..To..[[',']]..Message_Type..[[',']]..title.text..[[',']]..MemberName..[[',']]..title.text..[[');]]
					db:exec( insertQuery )



					    Webservice.SEND_MESSAGE(ChatBox.text,ChatBox.text,"","","","",ImagePath,ImageName,ImageSize,"","","","SEND",From,To,Message_Type,get_sendMssage)

                   end
                   end
	         end

	end

return true
end




local function onTimer ( event )

	BackFlag = false

end




local function onKeyEvent( event )

        local phase = event.phase
        local keyName = event.keyName

        if phase == "up" then

        if keyName=="back" then

        	if BackFlag == false then

        		Utils.SnackBar(ChatPage.PressAgain)

        		BackFlag = true

        		timer.performWithDelay( 3000, onTimer )

                return true

            elseif BackFlag == true then

			 os.exit() 

            end
            
        end

    end

        return false
 end






	function ImageClose(event)

		    local phase = event.phase

			if phase=="began" then

				display.getCurrentStage():setFocus( event.target )

			elseif phase=="ended" then

				display.getCurrentStage():setFocus( nil )

				image_name_png.text = ""

				image_name_close.isVisible = false

				--ChatBox_bg.isVisible = true

			  --  ChatBox.isVisible = true

				os.remove( path )


			end

	end




local function CreateTabBarIcons( )

	if tab_Group_btn ~= nil then if tab_Group_btn.y then tab_Group_btn:removeSelf( );tab_Group_btn=nil end end
	if tab_Message_btn ~= nil then if tab_Message_btn.y then tab_Message_btn:removeSelf( );tab_Message_btn=nil end end
	if tab_Contact_btn ~= nil then if tab_Contact_btn.y then tab_Contact_btn:removeSelf( );tab_Contact_btn=nil end end


	tab_Group_btn = display.newImageRect( tabBarGroup, "res/assert/group.png", 35/1.4, 31/1.4 )
	tab_Group_btn.x=tab_Group.x
	tab_Group_btn.y=tab_Group.y+tab_Group_btn.contentHeight/2-8
	tab_Group_btn.anchorY=0



	tab_Message_btn = display.newImageRect( tabBarGroup, "res/assert/chats.png", 35/1.4, 31/1.4 )
	tab_Message_btn.x=tab_Message.x
	tab_Message_btn.y=tab_Message.y+tab_Message_btn.contentHeight/2-8
	tab_Message_btn.anchorY=0



	tab_Contact_btn = display.newImageRect( tabBarGroup, "res/assert/Consultant.png", 35/1.4, 31/1.4 )
	tab_Contact_btn.x=tab_Contact.x
	tab_Contact_btn.y=tab_Contact.y+tab_Contact_btn.contentHeight/2-8
	tab_Contact_btn.anchorY=0


end


	local function TabbarTouch( event )

		if event.phase == "began" then 

		elseif event.phase == "ended" then

		
			if event.target.id == "message" then

				title.text = ChatPage.Chats

			    	CreateTabBarIcons()

			    	tab_Message_btn:removeSelf( );tab_Message_btn=nil

			    	tab_Message_btn = display.newImageRect( tabBarGroup, "res/assert/chats active.png", 35/1.4, 31/1.4 )
					tab_Message_btn.x=tab_Message.x
					tab_Message_btn.y=tab_Message.y+tab_Message_btn.contentHeight/2-8
					tab_Message_btn.anchorY=0
					tab_Message_btn:scale(0.1,0.1)

					tab_Message_txt:setFillColor( Utils.convertHexToRGB(color.tabBarColor) )

					local circle = display.newCircle( tabBarGroup, tab_Message_btn.x, tab_Message_btn.y+tab_Message_btn.contentHeight/2, 25 )
					circle.strokeWidth=4
					circle:scale(0.1,0.1)
					circle.alpha=0.3
					circle:setFillColor( Utils.convertHexToRGB(color.tabBarColor) )
					circle:setStrokeColor( Utils.convertHexToRGB(color.tabBarColor) )

					--tab_Group_txt:setFillColor( 0.3 )
					tab_Message_txt:setFillColor( Utils.convertHexToRGB(color.tabBarColor) )
					tab_Contact_txt:setFillColor(  0.3  )


					local function listener1( obj )

						circle:removeSelf( );circle=nil
						tab_Message_btn:scale(0.9,0.9)
					 	
					 	 overlay = display.newImageRect( tabBarGroup, "res/assert/overlay.png", 55,56/1.4)
					    overlay.y=tabBg.y+6;overlay.x=tab_Message_btn.x

					      local options = {
									time = 300,	 
									params = { tabbuttonValue3 =event.target.id}
									}

				    composer.gotoScene( "Controller.MessagingPage", options )
					end


					transition.to( circle, { time=200, delay=100, xScale=1,yScale=1,alpha=0 } )
					transition.to( tab_Message_btn, { time=200, delay=100, xScale=1,yScale=1 , onComplete=listener1} )


			elseif event.target.id == "group" then


				CreateTabBarIcons()


					tab_Group_btn:removeSelf( );tab_Group_btn=nil

					tab_Group_btn = display.newImageRect( tabBarGroup, "res/assert/group active.png", 35/1.4, 31/1.4 )
					tab_Group_btn.x=tab_Group.x
					tab_Group_btn.y=tab_Group.y+tab_Group_btn.contentHeight/2-8
					tab_Group_btn.anchorY=0
					tab_Group_btn:scale(0.1,0.1)

					tab_Group_txt:setFillColor( Utils.convertHexToRGB(color.tabBarColor) )
					tab_Message_txt:setFillColor( 0.3 )
					tab_Contact_txt:setFillColor(  0.3  )

					local circle = display.newCircle( tabBarGroup, tab_Group_btn.x, tab_Group_btn.y+tab_Group_btn.contentHeight/2, 25 )
					circle.strokeWidth=4
					circle:scale(0.1,0.1)
					circle.alpha=0.3
					circle:setFillColor( Utils.convertHexToRGB(color.tabBarColor) )
					circle:setStrokeColor( Utils.convertHexToRGB(color.tabBarColor) )

					local function listener1( obj )

						circle:removeSelf( );circle=nil
						tab_Group_btn:scale(0.8,0.8)

					    overlay = display.newImageRect( tabBarGroup, "res/assert/overlay.png", 55,56/1.4)
					    overlay.y=tabBg.y+6;overlay.x=tab_Group_btn.x

					        local options = {
									time = 300,	  
									params = { tabbuttonValue3 =event.target.id}
									}

				    composer.gotoScene( "Controller.groupPage", options )
					end

					if overlay then if overlay.y then overlay:removeSelf( );overlay=nil end end
					

					transition.to( circle, { time=200, delay=100, xScale=1,yScale=1,alpha=0 } )
					transition.to( tab_Group_btn, { time=220, delay=100, xScale=1.3,yScale=1.3 , onComplete=listener1} )

   				

				
			elseif event.target.id == "contact" then

			    	CreateTabBarIcons()

			    	tab_Contact_btn:removeSelf( );tab_Contact_btn=nil

			    	tab_Contact_btn = display.newImageRect( tabBarGroup, "res/assert/Consultant active.png", 35/1.4, 31/1.4 )
					tab_Contact_btn.x=tab_Contact.x
					tab_Contact_btn.y=tab_Contact.y+tab_Contact_btn.contentHeight/2-8
					tab_Contact_btn.anchorY=0
					tab_Contact_btn:scale(0.1,0.1)

					tab_Contact_txt:setFillColor( Utils.convertHexToRGB(color.tabBarColor) )

					local circle = display.newCircle( tabBarGroup, tab_Contact_btn.x, tab_Contact_btn.y+tab_Contact_btn.contentHeight/2, 25 )
					circle.strokeWidth=4
					circle:scale(0.1,0.1)
					circle.alpha=0.3
					circle:setFillColor( Utils.convertHexToRGB(color.tabBarColor) )
					circle:setStrokeColor( Utils.convertHexToRGB(color.tabBarColor) )

					tab_Group_txt:setFillColor( 0.3 )
					tab_Message_txt:setFillColor( 0.3 )
					tab_Contact_txt:setFillColor(  Utils.convertHexToRGB(color.tabBarColor)  )


					local function listener1( obj )

						circle:removeSelf( );circle=nil
						tab_Contact_btn:scale(0.9,0.9)
					 	
					 	 overlay = display.newImageRect( tabBarGroup, "res/assert/overlay.png", 55,56/1.4)
					    overlay.y=tabBg.y+6;overlay.x=tab_Contact_btn.x

					      local options = {
									time = 300,	 
									params = { tabbuttonValue3 =event.target.id}
									}

				    composer.gotoScene( "Controller.consultantListPage", options )
					end

					transition.to( circle, { time=200, delay=100, xScale=1,yScale=1,alpha=0 } )
					transition.to( tab_Contact_btn, { time=200, delay=100, xScale=1,yScale=1 , onComplete=listener1} )

   				

			end

	    end

    return true 

	end




	local function scrollAction(value)

		       		-- if value == 0 then
		       		-- else

		       		-- end
	ChatScrollContent.y=value

	end




	local function ChatBoxHandler( event )

   		 if ( event.phase == "began" ) then
        -- user begins editing numericField

        if isIos then

	      	local pWidth, pHeight = display.pixelWidth, display.pixelHeight
			if (pHeight < 1000) then
			   scrollAction(-180)
			else
			    scrollAction(-150)
			end
	 
	    end
        

        elseif event.phase == "submitted" then
       		

       	elseif event.phase == "ended" then

       		scrollAction(0)

        elseif event.phase == "editing" then

        	if (event.newCharacters=="\n") then
        		event.target.text = event.text:sub(1,event.target.text:len()-1)
				native.setKeyboardFocus( nil )
			end

				if event.text:len() > 500 then

						event.target.text = event.text:sub(1,500)

				end

	    end   
	end




	local function RecordAction(event)


		local filePath = system.pathForFile( "newRecording.wav", system.DocumentsDirectory )
		local r = media.newRecording( filePath )

		if event.phase == "began" then
			display.getCurrentStage():setFocus( event.target )

			r:startRecording()

			ChatBox.text= ChatPage.RecordStartText 


		elseif event.phase == "ended" then
				display.getCurrentStage():setFocus( nil )

				ChatBox.text=""
				r:stopRecording()


		end

 			return true

	end





	local function scrollListener( event )

	    local phase = event.phase
	   
	    if ( phase == "began" ) then print( "Scroll view was touched" )

	    	Deleteicon.isVisible=false
	    	Copyicon.isVisible=false
	    	-- chatReceivedFlag=true
	    	holdLevel=0

	    	attachment_icon.isVisible = true

	    	if selectedForDelete ~= nil then 
					if selectedForDelete.y ~= nil then
					 selectedForDelete:removeSelf();selectedForDelete=nil 
					 end 
				end

	    elseif ( phase == "moved" ) then print( "Scroll view was moved" )
	    elseif ( phase == "ended" ) then print( "Scroll view was released" )

			transition.to( AttachmentGroup, {time=300,alpha=0,yScale=0.01} )

	    local view = chatScroll:getView()

	    if view.contentHeight < 300 then

	    	 chatScroll:scrollTo( "bottom", { time=500 } )

	    end
	    	
	    end

	    -- In the event a scroll limit is reached...
	    if ( event.limitReached ) then

	        if ( event.direction == "up" ) then print( "Reached bottom limit" )
		    elseif ( event.direction == "down" ) then print( "Reached top limit" )
	        elseif ( event.direction == "left" ) then print( "Reached right limit" )
	        elseif ( event.direction == "right" ) then print( "Reached left limit" )
	        end

	        
	    end

	    return true
	end





	function get_audiomodel( response )

				composer.removeHidden()

				ChatBox.isVisible=true


			local audiopath = response.Abspath

			local audioname = response.FileName

			audiosize = size

	
			local q = "UPDATE pu_MyUnitBuzz_Message SET Audio_Path='"..audiopath.."' WHERE id='"..audio_update_row.."';"
			db:exec( q )

			

				local Message_date,isDeleted,Created_TimeStamp,Updated_TimeStamp,ImagePath,AudioPath,VideoPath,MyUnitBuzz_LongMessage,From,To,Message_Type
				
				Message_date=os.date("%Y-%m-%dT%H:%M:%S")
				isDeleted="false"
				Created_TimeStamp=os.date("!%Y-%m-%dT%H:%M:%S")
				Updated_TimeStamp=os.date("!%Y-%m-%dT%H:%M:%S")
				ImagePath= ""
				AudioPath=audiopath or ""
				VideoPath="NULL"
				MyUnitBuzz_LongMessage=ChatBox.text
				From=ContactId
				To=To_ContactId
				Message_Type = MessageType



				Webservice.SEND_MESSAGE("Audio","Audio","","","","","","","",AudioPath,audioname,audiosize,"SEND",From,To,Message_Type,get_sendMssage)

				--sendMeaasage()

	end




	function scene:updateAudio(dataFileName)

		ChatBox_bg.isVisible = true

		sendBtn_bg.isVisible = true

		sendBtn.isVisible = true

		--local function timedelayAudioAction(event)

	    local filePath = system.pathForFile( dataFileName, system.DocumentsDirectory )
		            -- Play back the recording
		            local file = io.open( filePath)
		            
		            if file then
		                io.close( file )
		            else
		            	dataFileName="test.wav"
			           	filePath = system.pathForFile( dataFileName, system.DocumentsDirectory )
		            end

		                local Message_date,isDeleted,Created_TimeStamp,Updated_TimeStamp,ImagePath,ImageName,ImageSize,AudioPath,VideoPath,MyUnitBuzz_LongMessage,From,To,Message_Type

					    Message_date=os.date("%Y-%m-%dT%H:%M:%S")
						isDeleted="false"
						Created_TimeStamp=os.date("!%Y-%m-%dT%H:%M:%S")
						Updated_TimeStamp=os.date("!%Y-%m-%dT%H:%M:%S")
						ImagePath=""
						ImageName = ""
						ImageSize = ""
						AudioPath="DEFAULT"
						VideoPath=""
						MyUnitBuzz_LongMessage=ChatBox.text
						From=ContactId
						To=To_ContactId
						Message_Type = MessageType

						local insertQuery = [[INSERT INTO pu_MyUnitBuzz_Message VALUES (NULL, ']]..UserId..[[','Audio','SEND',']]..Message_date..[[',']]..isDeleted..[[',']]..Created_TimeStamp..[[',']]..Updated_TimeStamp..[[',']]..ImagePath..[[',']]..AudioPath..[[',']]..VideoPath..[[',']]..MyUnitBuzz_LongMessage..[[',']]..From..[[',']]..To..[[',']]..Message_Type..[[',']]..title.text..[[',']]..MemberName..[[',']]..title.text..[[');]]
						db:exec( insertQuery )




					for row in db:nrows("SELECT * FROM pu_MyUnitBuzz_Message WHERE Audio_Path= 'DEFAULT'") do
					   audio_update_row = row.id 

					end 

					


					 	local path = system.pathForFile( dataFileName, system.DocumentsDirectory)

				        local size = lfs.attributes (path, "size")

						local fileHandle = io.open(path, "rb")

						local file_inbytearray = mime.b64( fileHandle:read( "*a" ) )

						formatSizeUnits(size)

						 Webservice.DOCUMENT_UPLOAD(file_inbytearray,dataFileName,"Audios",get_audiomodel)


						 sendMeaasage()
			--end

			--timer = timer.performWithDelay( 100, timedelayAudioAction ,1 )

	end




	function scene:resumeImageCallBack(photoviewname,button_idvalue)


		ChatBox.isVisible=true

		if photoviewname  ~= nil and photoviewname ~= "" then

				if button_idvalue == "cancel" then


				elseif button_idvalue == "send" then

					Imagename = photoviewname:match( "([^/]+)$" )


					    local Message_date,isDeleted,Created_TimeStamp,Updated_TimeStamp,ImagePath,ImageName,ImageSize,AudioPath,VideoPath,MyUnitBuzz_LongMessage,From,To,Message_Type

					    Message_date=os.date("%Y-%m-%dT%H:%M:%S")
						isDeleted="false"
						Created_TimeStamp=os.date("!%Y-%m-%dT%H:%M:%S")
						Updated_TimeStamp=os.date("!%Y-%m-%dT%H:%M:%S")
						ImagePath=photoviewname
						ImageName = Imagename
						ImageSize = Imagesize
						AudioPath="NULL"
						VideoPath="NULL"
						MyUnitBuzz_LongMessage=ChatBox.text
						From=ContactId
						To=To_ContactId
						Message_Type = MessageType

						local insertQuery = [[INSERT INTO pu_MyUnitBuzz_Message VALUES (NULL, ']]..UserId..[[','Image','SEND',']]..Message_date..[[',']]..isDeleted..[[',']]..Created_TimeStamp..[[',']]..Updated_TimeStamp..[[',']]..ImagePath..[[',']]..AudioPath..[[',']]..VideoPath..[[',']]..MyUnitBuzz_LongMessage..[[',']]..From..[[',']]..To..[[',']]..Message_Type..[[',']]..title.text..[[',']]..MemberName..[[',']]..title.text..[[');]]
						db:exec( insertQuery )


					for row in db:nrows("SELECT * FROM pu_MyUnitBuzz_Message WHERE Image_Path= '"..Imagename.."'") do
					   image_update_row = row.id 

					end 

				   Webservice.DOCUMENT_UPLOAD(file_inbytearray,photoname,"Images",get_imagemodel)

				  sendMeaasage()


				end

		end

	end







	function scene:resumeVideoCallBack(videofilename,button_idvalue,videofilesize)

		print("resume game calling")


		composer.removeHidden()

		if videofilename  ~= nil and videofilename ~= "" then

				if button_idvalue == "cancel" then

					print("cancel pressed")

				elseif button_idvalue == "send" then


		            local nativelaert = native.showAlert("MUB","videopath",{"ok"})



					local filePath = system.pathForFile( videofilename, system.DocumentsDirectory )
		            -- Play back the recording
		            local file = io.open( filePath)
		            
		            if file then

		                io.close( file )
		            else
		            	videofilename="test.mp4"
			           	filePath = system.pathForFile( videofilename, system.DocumentsDirectory )
		            end

					    local Message_date,isDeleted,Created_TimeStamp,Updated_TimeStamp,ImagePath,ImageName,ImageSize,AudioPath,VideoPath,MyUnitBuzz_LongMessage,From,To,Message_Type

					    Message_date=os.date("%Y-%m-%dT%H:%M:%S")
						isDeleted="false"
						Created_TimeStamp=os.date("!%Y-%m-%dT%H:%M:%S")
						Updated_TimeStamp=os.date("!%Y-%m-%dT%H:%M:%S")
						ImagePath="NULL"
						ImageName = ""
						ImageSize = ""
						AudioPath="NULL"
						VideoPath="DEFAULT"
						MyUnitBuzz_LongMessage=ChatBox.text
						From=ContactId
						To=To_ContactId
						Message_Type = MessageType

						local insertQuery = [[INSERT INTO pu_MyUnitBuzz_Message VALUES (NULL, ']]..UserId..[[',']]..Utils.encrypt(ChatBox.text)..[[','SEND',']]..Message_date..[[',']]..isDeleted..[[',']]..Created_TimeStamp..[[',']]..Updated_TimeStamp..[[',']]..ImagePath..[[',']]..AudioPath..[[',']]..VideoPath..[[',']]..MyUnitBuzz_LongMessage..[[',']]..From..[[',']]..To..[[',']]..Message_Type..[[',']]..title.text..[[',']]..MemberName..[[',']]..title.text..[[');]]
						db:exec( insertQuery )


					for row in db:nrows("SELECT * FROM pu_MyUnitBuzz_Message WHERE Video_Path= 'DEFAULT'") do
					   image_update_row = row.id 

					end 

				   Webservice.DOCUMENT_UPLOAD(videofilesize,videofilename,"Videos",get_videomodel)

				  sendMeaasage()


				end

		end

	end





	function scene:resumeGame()

		print("resume game")

			ChatBox.isVisible=true

	end



------------------------------------------------------

function scene:create( event )

	local sceneGroup = self.view


	Background = display.newImageRect(sceneGroup,"res/assert/background.jpg",W,H)
	Background.x=W/2;Background.y=H/2

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
	title_bg.x=W/2;title_bg.y = tabBar.y+tabBar.contentHeight-5
	title_bg:setFillColor( Utils.convertHexToRGB(color.tabbar) )

	BackBtn = display.newImageRect( sceneGroup, "res/assert/right-arrow(gray-).png",15,15 )
	BackBtn.anchorX = 0
	BackBtn.x=25;BackBtn.y = title_bg.y
	BackBtn.xScale=-1
	--BackBtn:setFillColor(0)

	title = display.newText(sceneGroup,"",0,0,native.systemFont,18)
	title.anchorX = 0
	title.x=BackBtn.x+BackBtn.contentWidth-5;title.y = title_bg.y
	title:setFillColor(0)

	title.text = ChatPage.Chats

	Deleteicon = display.newImageRect( sceneGroup, "res/assert/delete1.png", 15, 15 )
	Deleteicon.x=W-20;Deleteicon.y=title_bg.y
	Deleteicon.isVisible=false
	Deleteicon.id="delete"
	Deleteicon:addEventListener( "touch", deleteAction )

	Copyicon = display.newImageRect( sceneGroup, "res/assert/copy-icon.png", 15, 15 )
	Copyicon.x=W-50;Copyicon.y=title_bg.y
	Copyicon.isVisible=false
	Copyicon.id="copy"
	Copyicon:addEventListener( "touch", deleteAction )

MainGroup:insert(sceneGroup)

end




function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then

			if event.params then
				nameval = event.params.tabbuttonValue2
			end

			composer.removeHidden()


	elseif phase == "did" then


		ContactDetails = event.params.contactDetails

		print( "ContactDetails : "..json.encode(ContactDetails) )

		To_ContactId = ContactDetails.Contact_Id or ContactDetails.Message_To or ContactDetails.MyUnitBuzzGroupId


			if tostring(To_ContactId) == tostring(ContactId) then
				   To_ContactId=ContactDetails.Message_From
			end


			if ContactDetails.MyUnitBuzzGroupId ~= nil then

				MessageType = "GROUP"

			else

				MessageType = "INDIVIDUAL"

			end

		
		if ContactDetails.Message_Type then

			MessageType=ContactDetails.Message_Type

		end


		if MessageType == "GROUP" then

			title.text = ContactDetails.GroupName or ContactDetails.MyUnitBuzzGroupName
		else

			title.text = ContactDetails.Name or ContactDetails.ToName or ContactDetails.MyUnitBuzzGroupName
		end


		ChatBox_bg = display.newRect(ChatScrollContent,0,H-100, W-50, 40 )
		ChatBox_bg.anchorY=0;ChatBox_bg.anchorX=0
		ChatBox_bg.x=5
		ChatBox_bg.width = W-50
		ChatBox_bg.strokeWidth = 1
		ChatBox_bg:setStrokeColor( Utils.convertHexToRGB(color.LtyGray))


		ChatBox = native.newTextBox( 0, ChatBox_bg.y, ChatBox_bg.contentWidth, ChatBox_bg.contentHeight-5 )
		ChatBox.isEditable = true
		ChatBox.anchorY=0;ChatBox.anchorX=0
		ChatBox.x=ChatBox_bg.x
		ChatBox.size=16
		ChatBox.hasBackground = false
		ChatScrollContent:insert( ChatBox )


		image_name_png = display.newText("",ChatBox_bg.x, ChatBox_bg.contentHeight-5  ,native.systemFont,14)
		image_name_png.text = ""
		image_name_png.value = "imagenamepng"
		image_name_png.id="imagenamepng"
		image_name_png:setFillColor( Utils.convertHexToRGB(color.tabBarColor))
		image_name_png.x = ChatBox_bg.x + 10
		image_name_png.y= ChatBox_bg.y+10
		image_name_png.anchorY = 0 
		image_name_png.anchorX = 0
		image_name_png.isVisible = false
		ChatScrollContent:insert(image_name_png)
		--image_name_png.anchorX=0


		image_name_close = display.newImageRect("res/assert/icon-close.png",20,20)
		image_name_close.id = "image close"
		image_name_close.anchorX=0
		image_name_close.anchorY=0
		ChatScrollContent:insert(image_name_close)
		image_name_close.x= ChatBox_bg.width - 30
		image_name_close.isVisible = false
		image_name_close.y=ChatBox_bg.y+10


		sendBtn = display.newImageRect( ChatScrollContent, "res/assert/msg_send.png", 25,20 )
		sendBtn.x=ChatBox_bg.x+ChatBox_bg.contentWidth+5
		sendBtn.y=ChatBox_bg.y+ChatBox_bg.contentHeight/2-sendBtn.contentHeight/2
		sendBtn.anchorY=0;sendBtn.anchorX=0

		sendBtn_bg = display.newRect( ChatScrollContent, sendBtn.x+5, sendBtn.y+5, 45,45 )
		sendBtn_bg:setFillColor( 0,0,0,0.01 )


		chatScroll = widget.newScrollView(
	    {
	        top = 125,
	        left = 0,
	        width = W,
	        height = H-175,
	        listener = scrollListener,
	        hideBackground=true,
	        hideScrollBar=true,
	        horizontalScrollDisabled=true,  
	    }
	    )

		chatScroll.anchorY=0
		chatScroll.anchorX=0
		chatScroll.x=0;chatScroll.y=title_bg.y+title_bg.contentHeight/2
		ChatScrollContent:insert( chatScroll )

		sendMeaasage()

		sceneGroup:insert( ChatScrollContent )
	

		------------------------------------------- attachment icon -----------------------------------------


		attachment_icon = display.newImageRect(sceneGroup,"res/assert/attached.png",20,20)
		attachment_icon.x= W-40;attachment_icon.y = tabBar.y+35
		attachment_icon:setFillColor( 0 )
		attachment_icon.isVisible = true
		attachment_icon:addEventListener( "touch", AttachmentTouch )


		createAttachment()
		AttachmentGroup.anchorX=0;AttachmentGroup.anchorY=0
		AttachmentGroup.alpha=0
		AttachmentGroup.y=AttachmentGroup.y+68
		AttachmentGroup.anchorChildren = true

		sceneGroup:insert( AttachmentGroup )


		--Tabbar---

		tabBg = display.newRect( tabBarGroup, W/2, H-40, W, 40 )
		tabBg.anchorY=0
		tabBg.strokeWidth = 1
		tabBg:setStrokeColor( Utils.convertHexToRGB(color.tabBarColor),0.7 )

		tab_Group = display.newRect(tabBarGroup,0,0,70,40)
		tab_Group.x=W/2-W/3;tab_Group.y=tabBg.y
		tab_Group.anchorY=0
		tab_Group.alpha=0.01
		tab_Group.id="group"
		tab_Group:setFillColor( 0.2 )

		tab_Message = display.newRect(tabBarGroup,0,0,70,40)
		tab_Message.x=W/2;tab_Message.y=tabBg.y
		tab_Message.anchorY=0
		tab_Message.alpha=0.01
		tab_Message.id="message"
		tab_Message:setFillColor( 0.2 )

		tab_Contact = display.newRect(tabBarGroup,0,0,70,40)
		tab_Contact.x=W/2+W/3;tab_Contact.y=tabBg.y
		tab_Contact.anchorY=0
		tab_Contact.alpha=0.01
		tab_Contact.id="contact"
		tab_Contact:setFillColor( 0.2 )

		tab_Group:addEventListener( "touch", TabbarTouch )
		tab_Message:addEventListener( "touch", TabbarTouch )
		tab_Contact:addEventListener( "touch", TabbarTouch )

		CreateTabBarIcons()


	if tab_Message_btn then tab_Message_btn:removeSelf( );tab_Message_btn=nil end

		tab_Message_btn = display.newImageRect( tabBarGroup, "res/assert/chats active.png", 35/1.4, 31/1.4 )
		tab_Message_btn.x=tab_Message.x
		tab_Message_btn.y=tab_Message.y+tab_Message_btn.contentHeight/2-8
		tab_Message_btn.anchorY=0

		overlay = display.newImageRect( tabBarGroup, "res/assert/overlay.png", 55,56/1.4)
		overlay.y=tabBg.y+6;overlay.x=tab_Message_btn.x

		tab_Group_txt = display.newText( tabBarGroup,ChatPage.Group ,0,0,native.systemFont,11 )
		tab_Group_txt.x=tab_Group_btn.x;tab_Group_txt.y=tab_Group_btn.y+tab_Group_btn.contentHeight+5
		tab_Group_txt:setFillColor( 0.3 )


		tab_Message_txt = display.newText( tabBarGroup, ChatPage.Chats ,0,0,native.systemFont,11 )
		tab_Message_txt.x=tab_Message_btn.x;tab_Message_txt.y=tab_Message_btn.y+tab_Message_btn.contentHeight+5
		tab_Message_txt:setFillColor( 0.3 )

		tab_Contact_txt = display.newText( tabBarGroup, ChatPage.Consultant_List ,0,0,native.systemFont,11 )
		tab_Contact_txt.x=tab_Contact_btn.x;tab_Contact_txt.y=tab_Contact_btn.y+tab_Contact_btn.contentHeight+5
		tab_Contact_txt:setFillColor( 0.3 )

		sceneGroup:insert( tabBarGroup )


		sendBtn_bg:addEventListener( "touch", ChatSendAction )
		menuBtn:addEventListener("touch",menuTouch)
		ChatBox:addEventListener( "userInput", ChatBoxHandler )

	
		Runtime:addEventListener( "enterFrame", printTimeSinceStart )
		Runtime:addEventListener( "key", onKeyEvent )
		BackBtn:addEventListener( "touch", backAction )
		title:addEventListener( "touch", DetailAction )
		
	end	

MainGroup:insert(sceneGroup)

end




	function scene:hide( event )

		local sceneGroup = self.view
		local phase = event.phase

		if event.phase == "will" then

			Runtime:removeEventListener( "enterFrame", printTimeSinceStart )
				Runtime:removeEventListener( "key", onKeyEvent )
				image_name_close:removeEventListener( "touch", ImageClose )


		elseif phase == "did" then

				composer.removeHidden()

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
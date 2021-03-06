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
require( "Controller.genericAlert" )


--------------- Initialization -------------------

local W = display.contentWidth;
local H= display.contentHeight
local isdeleted = false
local Background,BgText

local AttachmentGroup = display.newGroup( )

local menuBtn,tabButtons,chattabBar,chatScroll,BackBtn,tabBar,title_bg,title,Deleteicon,Copyicon

openPage="MessagingPage"

chatReceivedPage = "chatPage"

local BackFlag = false

local ChatBox

local reciveImageFlag=false

local ContactDetails = {}

local ChatHistory = {}

local MeassageList={}

local MessageType=""

local GroupTypeValue = ""

local Imagename = ""

local Imagepath = ""

local Imagesize = ""

local MemberName,timerId

local UserName = ""

local image_update_row,audio_update_row

local holdLevel = 0

local chatHoldflag=false

local selectedForDelete = {}

local selectedForDeleteID = {}

local tabBarGroup = display.newGroup( )

local ChatScrollContent = display.newGroup( )

local UserId,ContactId,To_ContactId,EmailAddess

local PHOTO_FUNCTION = media.PhotoLibrary 

local deleteMsgCount = 0

local helpText 

local broadcastflag = false
local broadcastlist = {}


---local tab_Group_btn,tab_Message_btn,tab_Contact_btn,tab_broadcast_btn,tabBg,tab_Group,tab_Contact

local icons_holder_bg,camera_icon,camera_icon_txt,video_icon,video_icon_txt,audio_icon,audio_icon_txt,gallery_icon,gallery_icon_txt,Location_icon,Location_icon_txt,Contact_icon,Contact_icon_txt

for row in db:nrows("SELECT * FROM logindetails WHERE id=1") do
	UserId = row.UserId
	ContactId = row.ContactId
	MemberName = row.MemberName
	EmailAddess = row.EmailAddess

end

local MessageId = 0

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

		local option ={
							 {content=CommonWords.ok,positive=true},
						}
						genericAlert.createNew(ChatPage.ImageUploadError,ChatPage.ImageSize,option)

		--local image = native.showAlert( ChatPage.ImageUploadError,ChatPage.ImageSize, { CommonWords.ok } )

		
	elseif (event>=1024)  then   

		size = (event/1024)..' KB'

		print("size of the image 33",size)

	else      

	end

	

end



local function selectionComplete ( event )
	
	local photo = event.target

   --  

   print( "Selected photo : "..json.encode(event) )

   local baseDir = system.DocumentsDirectory

   if photo then

   	photo.x = display.contentCenterX
   	photo.y = display.contentCenterY
   	local w = photo.width
   	local h = photo.height
   	print( "w,h = ".. w .."," .. h )


		 --                local options =
			-- {
			--    to = { "malarkodi.sellamuthu@w3magix.com" },
			--    subject = "Corona Mail",
			--     body = "content : "..photo.x.." and "..photo.width,
			
			-- }
   --          native.showPopup("mail", options)

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
   		sendto = UserName,
   		contactId = To_ContactId,
   		MessageType = MessageType,
   		value = "Chat",
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
		print( "here cliked ###########" )
		display.getCurrentStage():setFocus( event.target )


	elseif ( event.phase == "moved" ) then
				local dy = math.abs( ( event.y - event.yStart ) )
				
				if ( dy > 10 ) then
					display.getCurrentStage():setFocus( nil )
					chatScroll:takeFocus( event )
				end

	elseif event.phase == "ended" then

		display.getCurrentStage():setFocus( nil )

		if event.target.id =="camera" then

			if media.hasSource( media.Camera ) then
				timer.performWithDelay( 100, function() media.capturePhoto( { listener = selectionComplete, mediaSource = media.Camera } ) 
					end )

			else


										local option ={
											 {content=CommonWords.ok,positive=true},
											-- {content=CommonWords.cancel,positive=true},
										}
									genericAlert.createNew(ChatPage.CameraUnavailable,ChatPage.CameraNotSupported,option)


				--local image1 = native.showAlert( ChatPage.CameraUnavailable, ChatPage.CameraNotSupported, { CommonWords.ok } )

			end

			ChatBox.isVisible=false



		elseif event.target.id == "video" then


			local options = {
				effect = "fromTop",
				time = 200,	
				params = {
					contactId = To_ContactId,
					MessageType = MessageType,
					page = "chat"
				}

			}


			ChatBox.isVisible=false

			composer.showOverlay( "Controller.messagePage",options)


		elseif event.target.id == "audio" then

			print( "audio" )

			local options = {
				effect = "fromTop",
				time = 200,	
				params = {
					contactId = To_ContactId,
					MessageType = MessageType,
					page = "chat"
				}

			}

			ChatBox.isVisible=false

			composer.showOverlay( "Controller.audioRecordPage",options)

		elseif event.target.id == "gallery" then

			if media.hasSource( media.SavedPhotosAlbum  ) then
				timer.performWithDelay( 100, function() media.selectPhoto( { listener = selectionComplete, mediaSource = media.SavedPhotosAlbum } ) 
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
		print( "AttachmentGroup.alpha : ",AttachmentGroup.alpha)

		if attachment_icon.isVisible == true then

			if AttachmentGroup.alpha <= 0.3 then
				AttachmentGroup.yScale=0.1
				AttachmentGroup.alpha = 1
				AttachmentGroup:toFront( )

				transition.from( AttachmentGroup, {time=300,alpha=1} )
				transition.scaleTo( AttachmentGroup, {yScale=1.0, time=300 } )
				
			else

				transition.to( AttachmentGroup, {time=300,alpha=0,yScale=0.01} )

			end

		end

	end

	return true
end


local function ChatTouch( event )

	if event.phase == "began" then
		print( "touching" )
		
		chatHoldflag=true
		holdLevel=0



	elseif event.phase == "moved" then

		local dy = math.abs( ( event.y - event.yStart ) )
	        -- If the touch on the button has moved more than 10 pixels,
	        -- pass focus back to the scroll view so it can continue scrolling

	        if ( dy > 10 ) then
	        	display.getCurrentStage():setFocus( nil )
	        	chatScroll:takeFocus( event )
	        	holdLevel=0

	        	if #selectedForDelete == 0 then
	        			Deleteicon.isVisible=false
						Copyicon.isVisible=false
						Forwardicon.isVisible=false

	        	end
	        	--Deleteicon.isVisible=false
	        	chatHoldflag=false
	        end

	        elseif event.phase == "ended" then

	        chatHoldflag=false
	        print( holdLevel )

	        if holdLevel > 25 then

	        	if event.target.selected == "false" then
	        		print( "here ###" )

	        		Deleteicon.detail=selectedForDeleteID
	        		Deleteicon.type=event.target.type
	        		Deleteicon.contentPath=event.target.contentPath



	        		Copyicon.type = event.target.type


				--local native22 = native.showAlert("MUB",Deleteicon.detail.."    "..Deleteicon.type.."    "..Deleteicon.contentPath,{"ok"})


				if Copyicon.type ~= "text" then

					Copyicon.isVisible = false

				else

					Copyicon.isVisible = true

				end
				
				Copyicon.detail = event.target.chat

				if Copyicon.type ~= "text" then

					Copyicon.isVisible = false

				else

					Copyicon.isVisible = true

				end

				Forwardicon.isVisible=true

				for i=1,#selectedForDelete do
					if selectedForDelete[i] ~= nil and selectedForDelete[i].y ~= nil then
						selectedForDelete[i]:removeSelf();selectedForDelete[i]=nil 

						-- attachment_icon.isVisible =true
					end

					selectedForDeleteID[i]=nil
				end

				

				for i=#MeassageList, 1, -1 do 
					local group = MeassageList[i]
					print( "Type : "..group[1].type,group[1].selected )
					group[1].selected = "false"
					
				end

				print("Select : "..event.target.selected )

				

				event.target.selected = "true"
				selectedForDeleteID[#selectedForDeleteID+1] = { id = event.target.id, filetype = event.target.type, contentPath = event.target.contentPath,contactid = event.target.From}
				selectedForDelete[#selectedForDeleteID] = display.newRect( W/2,event.target.y+event.target.contentHeight/2,W,event.target.contentHeight+15)
				selectedForDelete[#selectedForDeleteID]:setFillColor( 0.3,0.6,0.5,0.4 )
				event.target.group:insert( selectedForDelete[#selectedForDeleteID] )


				deleteMsgCount = deleteMsgCount + 1
				title.text = deleteMsgCount
				print("delete Action")

			end
			
		else

			print("*****************")


			if (event.target.type == "image" or  event.target.type == "video" )  and deleteMsgCount == 0  then

				if event.target.type == "image"  then

					local imageviewname = event.target.imageviewname

					local filePath = system.pathForFile( imageviewname, system.DocumentsDirectory )
								            -- Play back the recording
								            local file = io.open( filePath)
								            
								            if file then

								            	io.close( file )

								            	

								            	local options = {
								            		effect = "fromTop",
								            		time = 200,	
								            		params = {
								            			pagename="image",
								            			imagenameval = imageviewname,
								            		}
								            	}


								            	composer.showOverlay("Controller.imageFullviewPage",options)

								            end

								        elseif event.target.type == "video"  then

								        	local options = {
								        		effect = "fromTop",
								        		time = 200,	
								        		params = {
								        			pagename = "video",
								        			imagenameval = event.target.contentPath,
								        		}
								        	}


								        	composer.showOverlay("Controller.imageFullviewPage",options)

								        else

								        end

								    else
								    	print( "Lenght : "..json.encode(event.target) )

								    	if deleteMsgCount >= 1 and event.target.selected == "false" then
								    		
								    		event.target.selected = "true"
								    		selectedForDeleteID[#selectedForDeleteID+1] = { id = event.target.id,filetype = event.target.type,contentPath = event.target.contentPath,contactid = event.target.From}

								    		selectedForDelete[#selectedForDeleteID] = display.newRect( W/2,event.target.y+event.target.contentHeight/2,W,event.target.contentHeight+15)
								    		selectedForDelete[#selectedForDeleteID]:setFillColor( 0.3,0.6,0.5,0.4 )
								    		event.target.group:insert( selectedForDelete[#selectedForDeleteID] )
								    		print( "more selecting ")

								    		deleteMsgCount = deleteMsgCount+1
								    		title.text =deleteMsgCount
								    		Copyicon.isVisible = false
								    	elseif event.target.selected == "true" then
								    		for k=1,#selectedForDeleteID do
								    			if selectedForDeleteID[k].id == event.target.id then
								    				
								    				selectedForDeleteID[k].id = 0
								    				selectedForDeleteID[k].filetype = ""
								    				selectedForDeleteID[k].contentPath = ""
								    				selectedForDeleteID[k].contactid = ""
								    				selectedForDelete[k]:removeSelf()

								    			end

								    		end
								    		deleteMsgCount = deleteMsgCount-1

								    		if deleteMsgCount >= 0 then
								    			title.text = deleteMsgCount
								    		else
											--title.text = 1
										end
										
										if tonumber(deleteMsgCount) == 0 then

											title.text = UserName
											if title.text:len() > 20 then
								  				title.text = title.text:sub(1,20  ).."..."
								    		end
											Deleteicon.isVisible=false
											Copyicon.isVisible=false
											Forwardicon.isVisible=false
									    	-- chatReceivedFlag=true
									    	
									    	for i=#MeassageList, 1, -1 do 
									    		local group = MeassageList[i]
									    		print( "Type : "..group[1].type,group[1].selected )
									    		group[1].selected = "false"
									    		
									    	end

									    	attachment_icon.isVisible = true

									    	for i=1,#selectedForDelete do
									    		if selectedForDelete[i].y ~= nil then
									    			selectedForDelete[i]:removeSelf();selectedForDelete[i]=nil 

														-- attachment_icon.isVisible =true
													end
													selectedForDeleteID[i]=nil
												end

											end

										end
										

									end


								end

								
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

	--local nativealert123 = native.showAlert( "MUB", event.target.id , { "ok"})


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
			local group = MeassageList[i]

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
		            				local group = MeassageList[i]

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
		            			

		            		else

		            			if  audio.isChannelPaused( 2 ) then
		            				audio.resume( 2 )

		            			else

		            				local filePath = system.pathForFile( audioname, system.DocumentsDirectory )
		            				local laserSound = audio.loadStream( audioname, system.DocumentsDirectory )

		            				audio.play( laserSound,{ channel=2,onComplete = audioPlayComplete } )
		            				audio.setMaxVolume( 1, { channel=2 } )
		            				event.target:setSequence( "pause" )
		            				event.target:play()
		            				event.target.value="pause"


		            			end

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





   local function sendMeaasage()



		    for i=#MeassageList, 1, -1 do 
		    	display.remove(MeassageList[#MeassageList])
		    	MeassageList[#MeassageList] = nil
		    end

		    for i=#ChatHistory, 1, -1 do 
		    	ChatHistory[#ChatHistory] = nil
		    end

				 --   for row in db:nrows("SELECT * FROM pu_MyUnitBuzz_Message WHERE (Message_To='"..tostring(To_ContactId):lower().."') OR (Message_From='"..tostring(To_ContactId):lower().."') OR (Message_Type='BROADCAST') ") do


			  --   	if row.Message_Type == "BROADCAST" and broadcastflag == true then

			    			   		

					-- 		    	for i=1,#broadcastlist do

					-- 		    		if tonumber(broadcastlist[i]) == tonumber(row.Message_To) then
					-- 		    			row.Message_Type="individual"
					-- 		    			ChatHistory[#ChatHistory+1] = row

					-- 		    		end

					-- 		    	end

							    
					-- elseif (row.Message_Type == "BROADCAST" and broadcastflag == false and MessageType:lower( ) == "broadcast") and (row.Message_To==tostring(To_ContactId)) then
					-- 	local q = "UPDATE pu_MyUnitBuzz_Message SET Message_Status='SEND' WHERE id='"..row.id.."';"
				 --    	db:exec( q )


				 --    	ChatHistory[#ChatHistory+1] = row

			  --   	elseif MessageType:upper( ) == "INDIVIDUAL" then

				 --    	local q = "UPDATE pu_MyUnitBuzz_Message SET Message_Status='SEND' WHERE id='"..row.id.."';"
				 --    	db:exec( q )


				 --    	ChatHistory[#ChatHistory+1] = row
				 --    end

		   -- 	 	end

		   -- 	 	if MessageType:upper( ) == "GROUP" then


		   	 		for row in db:nrows("SELECT * FROM pu_MyUnitBuzz_Message WHERE (Message_To='"..tostring(To_ContactId):lower().."') OR (Message_From='"..tostring(To_ContactId):lower().."')") do

		   	 		    	local q = "UPDATE pu_MyUnitBuzz_Message SET Message_Status='SEND' WHERE id='"..row.id.."';"
				    		db:exec( q )


				    		ChatHistory[#ChatHistory+1] = row

				    end

		   	 	--end

		    

		    local dateVlaue=""

		    for i=1,#ChatHistory do
		    	
		    	print( "here : "..ChatHistory[i].Message_Type:lower(), MessageType:lower() )

				if ChatHistory[i].Message_Type:lower() == MessageType:lower() then
					print( "hai" )


					local dateLable = nil
					local datevalue = nil

					MeassageList[#MeassageList+1] = display.newGroup()

					local tempGroup = MeassageList[#MeassageList]

					local bg = display.newRect(tempGroup,0,0,W-100,25 )
					bg.anchorX=0;bg.anchorY=0;bg.id=ChatHistory[i].id;bg.group=tempGroup;bg.type = "text"
					bg.selected = "false"
					bg:addEventListener( "touch", ChatTouch )


					if MeassageList[#MeassageList-1] ~= nil then
						bg.y=MeassageList[#MeassageList-1][1].y+MeassageList[#MeassageList-1][1].contentHeight+20
					else
						bg.y=0
					end

					bg.From =  0
					
					if dateVlaue =="" or (Utils.getTime(makeTimeStamp(dateVlaue),"%d/%m/%Y",TimeZone) ~= Utils.getTime(makeTimeStamp(ChatHistory[i].Update_Time_Stamp),"%d/%m/%Y",TimeZone) )then

						dateVlaue =ChatHistory[i].Update_Time_Stamp

						dateLable = display.newRect( tempGroup, W/2, bg.y+5, 80,20 )
						bg.y=bg.y+30
						dateLable:setFillColor( Utils.convertHexToRGB(color.primaryColor) )
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

						bg.From =  ChatHistory[i].Message_From


						local filePath = system.pathForFile( ChatHistory[i].Message_From..".png",system.DocumentsDirectory )
						local fhd = io.open( filePath )

						local Image

						if fhd then

							Image = display.newImageRect(tempGroup,ChatHistory[i].Message_From..".png",system.DocumentsDirectory,45,38)
							io.close( fhd )

						else
							Image = display.newImageRect(tempGroup,"res/assert/twitter_placeholder.png",35,35)

						end

						Image.x=W-35;Image.y=bg.y+bg.height/2

						local mask = graphics.newMask( "res/assert/masknew.png" )

						Image:setMask( mask )

					else

						bg.x=65

						local Image = display.newImageRect(tempGroup,To_ContactId..".png",system.DocumentsDirectory,45,38)

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

					if string.find(chat.text,"https://") or string.find(chat.text,"http://") then

						bg.type = "video"

				-- chat.text =  chat.text:match("https?://www%.[^/]+(/v/%d+/)%w+")

				local pattern = "https?://[%w-_%.%?%.:/%+=&]+"

				print( "URL value : "..string.match(chat.text, pattern)  )


				bg.contentPath=string.match(chat.text, pattern)

			end


			if chat.text:len() > 450 then

				bg.width = bg.width - 10

			end


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

			if ChatHistory[i].Audio_Path  ~= nil and ChatHistory[i].Audio_Path ~= "" and ChatHistory[i].Audio_Path ~= "NULL" and ChatHistory[i].Audio_Path ~= " " then

				local audioname = ChatHistory[i].Audio_Path:match( "([^/]+)$" )

				local audio

				bg.type = "audio"

				local filePath = system.pathForFile( audioname,system.DocumentsDirectory )
				local fhd = io.open( filePath )

				bg.contentPath = filePath


				if fhd or ChatHistory[i].Audio_Path == "DEFAULT"  then	

					spinner_hide()

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
				       		
							--When audio notification receives

							local downloadimage = display.newImageRect(tempGroup,"res/assert/download_image.jpg", 45, 45 )
							downloadimage.x = bg.x+bg.contentWidth/4
							downloadimage.id = ChatHistory[i].Audio_Path
							downloadimage.anchorX = 0
							downloadimage.anchorY = 0
							downloadimage.object = tempGroup
							downloadimage.y = bg.y+5
							downloadimage.isVisible = true
							downloadimage:toFront()

							bg.width=bg.width+20;bg.height=bg.height+30


							if MessageType == "GROUP" then

								downloadimage.y= downloadimage.y+20

							end
							

							downloadimage:addEventListener( "touch", receviednotifyDownload )

						

					end

				end


					--------video Attachment---------------

					if ChatHistory[i].Video_Path  ~= nil and ChatHistory[i].Video_Path ~= "" and ChatHistory[i].Video_Path ~= "NULL" then

						bg.type = "video"
						bg.contentPath = ChatHistory[i].Video_Path

					end
					
			--------Image Attachment---------------

			if ChatHistory[i].Image_Path  ~= nil and ChatHistory[i].Image_Path ~= "" and ChatHistory[i].Image_Path ~= "NULL" then

				print( "Here >>>>>>>>>> "..ChatHistory[i].Image_Path )
				Imagename = ChatHistory[i].Image_Path:match( "([^/]+)$" )

				local image

				local filePath = system.pathForFile( Imagename,system.DocumentsDirectory )
				local fhd = io.open( filePath )

				bg.type = "image";bg.contentPath = filePath; bg.imageviewname = Imagename
				
				if fhd or ChatHistory[i].Image_Path == "DEFAULT" then	

					spinner.isVisible=false

					spinner_hide()

					if MessageType == "GROUP" then	
						
						image = display.newImageRect( tempGroup, Imagename,system.DocumentsDirectory, 220, 170 )
						image.id = ChatHistory[i].Image_Path

						

						owner.anchorY=0
						owner.anchorX = 0
						owner.x=chat.x
						owner.y=bg.y+1

						image.anchorY=0
						image.anchorX = 0
						image.x=bg.x+2.5

						image.y=owner.y+20	

						bg.width = image.contentWidth+5
						chat.y = image.y+image.contentHeight+3
						bg.height = image.contentHeight+chat.height+42

					else

						image = display.newImageRect( tempGroup, Imagename,system.DocumentsDirectory, 220, 170 )
						image.id = ChatHistory[i].Image_Path

						image.anchorY=0
						image.anchorX = 0
						image.x=bg.x+2.5
						image.y=bg.y+2.5

						bg.width = image.contentWidth+5

						chat.y = image.y+image.contentHeight+5
						bg.height = image.contentHeight+chat.height+25

					end

					io.close( fhd )

				else

							--When image notification recive
							if MessageType == "GROUP" then	
								
								image = display.newImageRect( tempGroup, "res/assert/download_default.jpg", 220, 170 )
								bg.width = image.contentWidth+5;bg.height = image.contentHeight+23.5

								owner.anchorY=0;owner.anchorX = 0;owner.x=chat.x;owner.y=bg.y+1
								image.anchorY=0;image.anchorX = 0;image.x=bg.x+2.5;image.y=owner.y+20	
								
								
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

								chat.y = image.y+image.contentHeight+3
								bg.height = image.contentHeight+chat.height+42

							else

								image = display.newImageRect( tempGroup, "res/assert/download_default.jpg", 220, 170 )
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

								chat.y = image.y+image.contentHeight+5
								bg.height = image.contentHeight+chat.height+25

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
					arrow.y=bg.y
					arrow.anchorY=0


					if ChatHistory[i].Message_From == tostring(ContactId) then
						chat.x = bg.x-bg.contentWidth+5
						time.x=bg.x-2.5

						if owner ~= nil then print("$$$ : "..owner.text);owner.x=chat.x end
						bg:setFillColor( Utils.convertHexToRGB(color.primaryColor) )

					else

						time.x=bg.x+bg.contentWidth-time.contentWidth-2.5
						bg:setFillColor( Utils.convertHexToRGB(color.Gray) )

					end



					if ChatHistory[i].Message_From == tostring(ContactId) then
						arrow.x=bg.x+2
						arrow:setFillColor( Utils.convertHexToRGB(color.primaryColor) )
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



	local function printTimeSinceStart( event )

		tabBar:toFront( );menuBtn:toFront( );BgText:toFront( );title_bg:toFront( );title:toFront( );BackBtn:toFront( );Deleteicon:toFront( );Copyicon:toFront( );attachment_icon:toFront()
		helpText:toFront( )
		Forwardicon:toFront( )
		if chatHoldflag == true then

			holdLevel=holdLevel+1

			if holdLevel > 25 then

				Deleteicon.isVisible=true
				Forwardicon.isVisible=true

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

			
			local function getupdateLastChatSyncDate( respose )
				sendMeaasage()
			end

			Webservice.UpdateLastChatSyncDate(getupdateLastChatSyncDate)
		end 

			-- if selectedForDelete ~= nil then 
			-- 	if selectedForDelete.y ~= nil then
			-- 	 selectedForDelete:removeSelf();selectedForDelete=nil 
			-- 	 end 
			-- end
			
		end





		local function deleteAction( event )

			if event.phase == "ended" then

			
			
			if event.target.id == "delete" then

				print( json.encode(selectedForDeleteID) )

				

				local function onComplete( event )  
					--if event.action == "clicked" then

						local i = event
						if i == 1 then

							for i=1,#selectedForDeleteID do

								local q = [[DELETE FROM pu_MyUnitBuzz_Message WHERE id=]]..selectedForDeleteID[i].id..[[;]]
								db:exec( q )

								print( selectedForDeleteID[i].type )

								if selectedForDeleteID[i].filetype ~= "text" then

									os.remove( selectedForDeleteID[i].contentPath )

								end

							end
							
							sendMeaasage()

							Copyicon.isVisible=false
							Deleteicon.isVisible=false
							Forwardicon.isVisible=false

							attachment_icon.isVisible = true

							for i=1,#selectedForDelete do
								if selectedForDelete[i].y ~= nil then
									selectedForDelete[i]:removeSelf();selectedForDelete[i]=nil 

									-- attachment_icon.isVisible =true
								end
								selectedForDeleteID[i]=nil
							end

							title.text = UserName

							if title.text:len() > 20 then
				  				title.text = title.text:sub(1,20  ).."..."
				    		end

							deleteMsgCount = 0
							
						elseif i == 2 then
								    	--Details

								    	
								    end
							--	end
							end


							if deleteMsgCount == 1 then

								print( json.encode(selectedForDeleteID[1]) , ContactId )
								if selectedForDeleteID[1].contactid == ContactId then

									local option ={
											 {content=CommonWords.ok,positive=true},
											 {content=CommonWords.cancel,positive=true},
										}
									genericAlert.createNew(MessagePage.DeleteText,ChatPage.DeleteMessage,option,onComplete)

									--local alert = native.showAlert(MessagePage.DeleteText, ChatPage.DeleteMessage, { CommonWords.ok , CommonWords.cancel }, onComplete )
								else

										local option ={
											 {content=CommonWords.ok,positive=true},
											 {content=CommonWords.cancel,positive=true},
										}
									genericAlert.createNew(MessagePage.DeleteText,ChatPage.DeleteMessageFrom..UserName.."?",option,onComplete)

									--local alert = native.showAlert(MessagePage.DeleteText, ChatPage.DeleteMessageFrom..UserName.."?", { CommonWords.ok , CommonWords.cancel }, onComplete )
								end

							else

										local option ={
											 {content=CommonWords.ok,positive=true},
											 {content=CommonWords.cancel,positive=true},
										}
									genericAlert.createNew(MessagePage.DeleteText,MessagePage.DeleteText.." "..tostring(deleteMsgCount)..ChatPage.MessageText,option,onComplete)


								--local alert = native.showAlert(MessagePage.DeleteText, MessagePage.DeleteText.." "..tostring(deleteMsgCount)..ChatPage.MessageText, { CommonWords.ok , CommonWords.cancel }, onComplete )

							end

							

						elseif event.target.id == "copy" then
							
							pasteboard.copy( "string", event.target.detail)

							toast.show(ChatPage.Message_Copied, {duration = 'long', gravity = 'Center', offset = {0, 128}})  
							title.text = UserName	

								if title.text:len() > 20 then
					  				title.text = title.text:sub(1,20  ).."..."
					    		end

							deleteMsgCount=0
							Deleteicon.isVisible=false
							Copyicon.isVisible=false
							Forwardicon.isVisible=false

							attachment_icon.isVisible = true

							for i=1,#selectedForDelete do
								if selectedForDelete[i].y ~= nil then
									selectedForDelete[i]:removeSelf();selectedForDelete[i]=nil 

								-- attachment_icon.isVisible =true
								end
							selectedForDeleteID[i]=nil
							end
						elseif event.target.id == "forward" then

							


							local function forwardFunction( event )

									local options = {
										time = 200,	
										params = { status = "forward",forwardDetails = selectedForDeleteID,ChatDetails = ContactDetails }
									}
								composer.gotoScene( "Controller.MessagingPage",options)
							end
							forwardTimer = timer.performWithDelay( 1000, forwardFunction )


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
				print( isdeleted )
				if tostring(isdeleted) == "false" then
					local options = {
						effect = "fromTop",
						time = 200,	
						params = {
							contactId = To_ContactId,
							MessageType = MessageType,
							GroupTypeValue = GroupTypeValue,
						}

					}


					ChatBox.isVisible=false
					composer.showOverlay( "Controller.Chathead_detailPage", options )
				end

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


				if deleteMsgCount > 0 then
					deleteMsgCount=0
					title.text = UserName
					if title.text:len() > 20 then
		  				title.text = title.text:sub(1,20  ).."..."
		    		end

					Deleteicon.isVisible=false
					Copyicon.isVisible=false
					Forwardicon.isVisible=false
					    	-- chatReceivedFlag=true
					    	

					    	attachment_icon.isVisible = true

					    	for i=1,#selectedForDelete do
					    		if selectedForDelete[i].y ~= nil then
					    			selectedForDelete[i]:removeSelf();selectedForDelete[i]=nil 

										-- attachment_icon.isVisible =true
									end
									selectedForDeleteID[i]=nil
								end

								for i=#MeassageList, 1, -1 do 
									local group = MeassageList[i]
									print( "Type : "..group[1].type,group[1].selected )
									group[1].selected = "false"
									
								end


							else


								local options = {
									effect = "flipFadeOutIn",
									time = 200,
									 params = {
                                          status = "fromChat",
                                        }

								}

								composer.gotoScene( "Controller.MessagingPage", options )


							end

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


        	if string.find(ChatBox.text,"https://") or string.find(ChatBox.text,"http://") then


        		ChatBox.text =  ChatBox.text:match("https?://www%.[^/]+(/v/%d+/)%w+")

        		local pattern = "https?://[%w-_%.%?%.:/%+=&]+"

        		print( "URL value : "..string.match(ChatBox.text, pattern)  )


        		VideoPath=string.match(ChatBox.text, pattern)

        	end

        	
		    --	native.showAlert("Type",Message_Type,{CommonWords.ok})

		     if 	Message_Type:lower( ) == "broadcast" then

			    for i=1,#broadcastlist do

				    local insertQuery = [[INSERT INTO pu_MyUnitBuzz_Message VALUES (NULL, ']]..UserId..[[',']]..Utils.encrypt(ChatBox.text)..[[','SEND',']]..Message_date..[[',']]..isDeleted..[[',']]..Created_TimeStamp..[[',']]..Updated_TimeStamp..[[',']]..ImagePath..[[',']]..AudioPath..[[',']]..VideoPath..[[',']]..MyUnitBuzz_LongMessage..[[',']]..From..[[',']]..broadcastlist[i].to..[[','INDIVIDUAL',']]..MemberName..[[',']]..broadcastlist[i].UserName..[[',']]..broadcastlist[i].UserName..[[','yes');]]
				    db:exec( insertQuery )

				end
			end


		    print(UserId.."\n"..ChatBox.text.."\n"..Message_date.."\n"..isDeleted.."\n"..Created_TimeStamp.."\n"..Updated_TimeStamp.."\n"..MyUnitBuzz_LongMessage.."\n"..From.."\n"..To_ContactId.."\n"..MemberName.."\n end" )
		    local insertQuery = [[INSERT INTO pu_MyUnitBuzz_Message VALUES (NULL, ']]..UserId..[[',']]..Utils.encrypt(ChatBox.text)..[[','SEND',']]..Message_date..[[',']]..isDeleted..[[',']]..Created_TimeStamp..[[',']]..Updated_TimeStamp..[[',']]..ImagePath..[[',']]..AudioPath..[[',']]..VideoPath..[[',']]..MyUnitBuzz_LongMessage..[[',']]..From..[[',']]..To..[[',']]..Message_Type..[[',']]..MemberName..[[',']]..UserName..[[',']]..UserName..[[','no');]]
		    db:exec( insertQuery )

		    local ConversionFirstName,ConversionLastName,GroupName
		    local DocumentUpload = {}

		    if MessageType == "GROUP" then

		    	ConversionFirstName="";ConversionLastName="";GroupName=UserName;DocumentUpload=""

		    elseif MessageType == "INDIVIDUAL" then

		    	ConversionFirstName="";ConversionLastName=UserName;GroupName="";DocumentUpload=""

		    elseif MessageType == "BROADCAST" then

		    	if IsOwner == true then

		    		ConversionFirstName="";ConversionLastName=UserName;GroupName=UserName;DocumentUpload=""

		    	else
		    		
		    		ConversionFirstName="";ConversionLastName=UserName;GroupName="";DocumentUpload=""

		    	end

		    end
		    

		    Webservice.SEND_MESSAGE(MessageId,ConversionFirstName,ConversionLastName,GroupName,DocumentUpload,"",ChatBox.text,ChatBox.text,"","","","",ImagePath,Imagename,Imagesize,"","","","SEND",From,To,Message_Type,get_sendMssage)
		    
		   
		    
		    ChatBox.text = ""

		    native.setKeyboardFocus( ChatBox )
		    sendMeaasage()


		    


		    
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
			if tab_broadcast_btn ~= nil then if tab_broadcast_btn.y then tab_broadcast_btn:removeSelf( );tab_broadcast_btn=nil end end


			tab_Group_btn = display.newImageRect( tabBarGroup, "res/assert/group.png", 35/1.4, 31/1.4 )
			tab_Group_btn.x=tab_Group.x
			tab_Group_btn.y=tab_Group.y+tab_Group_btn.contentHeight/2-8
			tab_Group_btn.anchorY=0



			tab_Message_btn = display.newImageRect( tabBarGroup, "res/assert/chats.png", 35/1.4, 31/1.4 )
			tab_Message_btn.x=tab_Message.x
			tab_Message_btn.y=tab_Message.y+tab_Message_btn.contentHeight/2-8
			tab_Message_btn.anchorY=0

			if IsOwner == true then

				tab_broadcast_btn = display.newImageRect( tabBarGroup, "res/assert/resource.png", 35/1.4, 31/1.4 )
				tab_broadcast_btn.x=tab_Boradcast.x
				tab_broadcast_btn.y=tab_Boradcast.y+tab_broadcast_btn.contentHeight/2-8
				tab_broadcast_btn.anchorY=0
				tab_broadcast_btn:setFillColor( 0 )

			end


			tab_Contact_btn = display.newImageRect( tabBarGroup, "res/assert/Consultant.png", 35/1.4, 31/1.4 )
			tab_Contact_btn.x=tab_Contact.x
			tab_Contact_btn.y=tab_Contact.y+tab_Contact_btn.contentHeight/2-8
			tab_Contact_btn.anchorY=0


		end


		local function TabbarTouch( event )

			if event.phase == "began" then 

				elseif event.phase == "ended" then
				
				if event.target.id == "message" then

				--title.text = ChatPage.Chats


			elseif event.target.id == "broadcast" then


				CreateTabBarIcons()


				tab_broadcast_btn:removeSelf( );tab_broadcast_btn=nil

				tab_broadcast_btn = display.newImageRect( tabBarGroup, "res/assert/resource.png", 35/1.4, 31/1.4 )
				tab_broadcast_btn.x=tab_Boradcast.x
				tab_broadcast_btn.y=tab_Boradcast.y+tab_broadcast_btn.contentHeight/2-8
				tab_broadcast_btn.anchorY=0
				tab_broadcast_btn:scale(0.1,0.1)
				tab_broadcast_btn:setFillColor( Utils.convertHexToRGB(color.primaryColor) )

				tab_Broadcast_txt:setFillColor( Utils.convertHexToRGB(color.primaryColor) )
				tab_Message_txt:setFillColor( 0.3 )
				tab_Contact_txt:setFillColor(  0.3  )
				tab_Group_txt:setFillColor(  0.3  )

				local circle = display.newCircle( tabBarGroup, tab_broadcast_btn.x, tab_broadcast_btn.y+tab_broadcast_btn.contentHeight/2, 25 )
				circle.strokeWidth=4
				circle:scale(0.1,0.1)
				circle.alpha=0.3
				circle:setFillColor( Utils.convertHexToRGB(color.primaryColor) )
				circle:setStrokeColor( Utils.convertHexToRGB(color.primaryColor) )

				local function listener1( obj )

					circle:removeSelf( );circle=nil
					tab_broadcast_btn:scale(0.8,0.8)

					overlay = display.newImageRect( tabBarGroup, "res/assert/overlay.png", 55,56/1.4)
					overlay.y=tabBg.y+6;overlay.x=tab_broadcast_btn.x

					local options = {
						time = 300,	  
						params = { tabbuttonValue3 =event.target.id}
					}

					composer.gotoScene( "Controller.broadCastPage", options )
				end

				if overlay then overlay:removeSelf( );overlay=nil end

				transition.to( circle, { time=200, delay=100, xScale=1,yScale=1,alpha=0 } )
				transition.to( tab_broadcast_btn, { time=220, delay=100, xScale=1.3,yScale=1.3 , onComplete=listener1} )

				


			elseif event.target.id == "group" then

				CreateTabBarIcons()


				tab_Group_btn:removeSelf( );tab_Group_btn=nil

				tab_Group_btn = display.newImageRect( tabBarGroup, "res/assert/group active.png", 35/1.4, 31/1.4 )
				tab_Group_btn.x=tab_Group.x
				tab_Group_btn.y=tab_Group.y+tab_Group_btn.contentHeight/2-8
				tab_Group_btn.anchorY=0
				tab_Group_btn:scale(0.1,0.1)

				tab_Group_txt:setFillColor( Utils.convertHexToRGB(color.primaryColor) )
				tab_Message_txt:setFillColor( 0.3 )
				tab_Contact_txt:setFillColor(  0.3  )
				if IsOwner == true then
					tab_Broadcast_txt:setFillColor( 0.3 )
				end

				local circle = display.newCircle( tabBarGroup, tab_Group_btn.x, tab_Group_btn.y+tab_Group_btn.contentHeight/2, 25 )
				circle.strokeWidth=4
				circle:scale(0.1,0.1)
				circle.alpha=0.3
				circle:setFillColor( Utils.convertHexToRGB(color.primaryColor) )
				circle:setStrokeColor( Utils.convertHexToRGB(color.primaryColor) )

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

				if overlay then overlay:removeSelf( );overlay=nil end

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

				tab_Contact_txt:setFillColor( Utils.convertHexToRGB(color.primaryColor) )

				local circle = display.newCircle( tabBarGroup, tab_Contact_btn.x, tab_Contact_btn.y+tab_Contact_btn.contentHeight/2, 25 )
				circle.strokeWidth=4
				circle:scale(0.1,0.1)
				circle.alpha=0.3
				circle:setFillColor( Utils.convertHexToRGB(color.primaryColor) )
				circle:setStrokeColor( Utils.convertHexToRGB(color.primaryColor) )

				tab_Group_txt:setFillColor( 0.3 )
				tab_Message_txt:setFillColor( 0.3 )
				if IsOwner == true then
					tab_Broadcast_txt:setFillColor( 0.3 )
				end
				tab_Contact_txt:setFillColor(  Utils.convertHexToRGB(color.primaryColor)  )


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

				if overlay then overlay:removeSelf( );overlay=nil end

				transition.to( circle, { time=200, delay=100, xScale=1,yScale=1,alpha=0 } )
				transition.to( tab_Contact_btn, { time=200, delay=100, xScale=1,yScale=1 , onComplete=listener1} )

				

			end

		end

		return true 

	end




	local function scrollAction(value)

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
		            
		            local Message_date,isDeleted,Created_TimeStamp,Updated_TimeStamp,ImagePath,ImageName,ImageSize,AudioPath,VideoPath,MyUnitBuzz_LongMessage,From,To,Message_Type

		            Message_date=os.date("%Y-%m-%dT%H:%M:%S")
		            isDeleted="false"
		            Created_TimeStamp=os.date("!%Y-%m-%dT%H:%M:%S")
		            Updated_TimeStamp=os.date("!%Y-%m-%dT%H:%M:%S")
		            ImagePath=""
		            ImageName = ""
		            ImageSize = ""
		            AudioPath=dataFileName
		            VideoPath=""
		            MyUnitBuzz_LongMessage=ChatBox.text
		            From=ContactId
		            To=To_ContactId
		            Message_Type = MessageType


		           if 	Message_Type:lower( ) == "broadcast" then

					    for i=1,#broadcastlist do

		          			  local insertQuery = [[INSERT INTO pu_MyUnitBuzz_Message VALUES (NULL, ']]..UserId..[[','Audio','SEND',']]..Message_date..[[',']]..isDeleted..[[',']]..Created_TimeStamp..[[',']]..Updated_TimeStamp..[[',']]..ImagePath..[[',']]..AudioPath..[[',']]..VideoPath..[[',']]..MyUnitBuzz_LongMessage..[[',']]..From..[[',']]..broadcastlist[i].to..[[','INDIVIDUAL',']]..MemberName..[[',']]..broadcastlist[i].UserName..[[',']]..broadcastlist[i].UserName..[[','yes');]]
						    db:exec( insertQuery )

						end
					end

		            local insertQuery = [[INSERT INTO pu_MyUnitBuzz_Message VALUES (NULL, ']]..UserId..[[','Audio','SEND',']]..Message_date..[[',']]..isDeleted..[[',']]..Created_TimeStamp..[[',']]..Updated_TimeStamp..[[',']]..ImagePath..[[',']]..AudioPath..[[',']]..VideoPath..[[',']]..MyUnitBuzz_LongMessage..[[',']]..From..[[',']]..To..[[',']]..Message_Type..[[',']]..MemberName..[[',']]..UserName..[[',']]..UserName..[[','no');]]
		            db:exec( insertQuery )




		            for row in db:nrows("SELECT * FROM pu_MyUnitBuzz_Message WHERE Audio_Path= '"..dataFileName.."'") do
		            	audio_update_row = row.id 

		            end 

		            local path = system.pathForFile( dataFileName, system.DocumentsDirectory)

		            local size = lfs.attributes (path, "size")

		            local fileHandle = io.open(path, "rb")

		            local file_inbytearray = mime.b64( fileHandle:read( "*a" ) )

		            formatSizeUnits(size)

		            composer.removeHidden()

		            ChatBox.isVisible=true



		            local audioname = dataFileName

		            audiosize = size


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

		            local ConversionFirstName,ConversionLastName,GroupName
		            local DocumentUpload = {}

		            if MessageType == "GROUP" then

		            	ConversionFirstName="";ConversionLastName="";GroupName=MemberName
		            	DocumentUpload[1] = {
		            		UserId = UserId,
		            		File = file_inbytearray,
		            		FileName = dataFileName,
		            		FileType = "Audios"
		            	}

		            else
		            	ConversionFirstName="";ConversionLastName=MemberName;GroupName=""

		            	
		            	DocumentUpload[1] = {
		            		UserId = UserId,
		            		File = file_inbytearray,
		            		FileName = dataFileName,
		            		FileType = "Audios"
		            	}

		            	



		            end

		            MessageFileType="Audios"

		            

		            Webservice.SEND_MESSAGE(MessageId,ConversionFirstName,ConversionLastName,GroupName,DocumentUpload,MessageFileType,"Audio","Audio","","","","","","","",AudioPath,audioname,audiosize,"SEND",From,To,Message_Type,get_sendMssage)

		            

			
								-- Webservice.DOCUMENT_UPLOAD(file_inbytearray,dataFileName,"Audios",get_audiomodel)


						sendMeaasage()
			--end

			--timer = timer.performWithDelay( 100, timedelayAudioAction ,1 )


		end




		function scene:resumeImageCallBack(captionname,photoviewname,button_idvalue)

			composer.removeHidden()

			ChatBox.isVisible=true

			if photoviewname  ~= nil and photoviewname ~= "" then

				    if button_idvalue == "cancel" then


					elseif button_idvalue == "send" then

					Imagename = photoviewname:match( "([^/]+)$" )

								if captionname == "" then

									captionname= "Image"

								end

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
					MyUnitBuzz_LongMessage=captionname
					From=ContactId
					To=To_ContactId
					Message_Type = MessageType

					 if 	Message_Type:lower( ) == "broadcast" then

					    for i=1,#broadcastlist do

							local insertQuery = [[INSERT INTO pu_MyUnitBuzz_Message VALUES (NULL, ']]..UserId..[[',']]..captionname..[[','SEND',']]..Message_date..[[',']]..isDeleted..[[',']]..Created_TimeStamp..[[',']]..Updated_TimeStamp..[[',']]..ImagePath..[[',']]..AudioPath..[[',']]..VideoPath..[[',']]..MyUnitBuzz_LongMessage..[[',']]..From..[[',']]..broadcastlist[i].to..[[',']]..Message_Type..[[',']]..MemberName..[[',']]..broadcastlist[i].UserName..[[',']]..broadcastlist[i].UserName..[[','yes');]]
						    db:exec( insertQuery )

						end
					end

					local insertQuery = [[INSERT INTO pu_MyUnitBuzz_Message VALUES (NULL, ']]..UserId..[[',']]..captionname..[[','SEND',']]..Message_date..[[',']]..isDeleted..[[',']]..Created_TimeStamp..[[',']]..Updated_TimeStamp..[[',']]..ImagePath..[[',']]..AudioPath..[[',']]..VideoPath..[[',']]..MyUnitBuzz_LongMessage..[[',']]..From..[[',']]..To..[[',']]..Message_Type..[[',']]..MemberName..[[',']]..UserName..[[',']]..UserName..[[','no');]]
					db:exec( insertQuery )


					for row in db:nrows("SELECT * FROM pu_MyUnitBuzz_Message WHERE Image_Path= '"..Imagename.."'") do
						image_update_row = row.id 

					end 




					Imagesize = size

					ChatBox_bg.isVisible = true

					ChatBox.isVisible = true

					sendBtn_bg.isVisible = true

					sendBtn.isVisible = true

		--sendMeaasage()

		local Message_date,isDeleted,Created_TimeStamp,Updated_TimeStamp,ImagePath,AudioPath,VideoPath,MyUnitBuzz_LongMessage,From,To,Message_Type
		
		Message_date=os.date("%Y-%m-%dT%H:%M:%S")
		isDeleted="false"
		Created_TimeStamp=os.date("!%Y-%m-%dT%H:%M:%S")
		Updated_TimeStamp=os.date("!%Y-%m-%dT%H:%M:%S")
		ImagePath= photoviewname or ""
		AudioPath="NULL"
		VideoPath="NULL"
		MyUnitBuzz_LongMessage=captionname
		From=ContactId
		To=To_ContactId
		Message_Type = MessageType


		local path = system.pathForFile( Imagename, system.DocumentsDirectory)

		local size = lfs.attributes (path, "size")

		local fileHandle = io.open(path, "rb")

		local file_inbytearray = mime.b64( fileHandle:read( "*a" ) )

		formatSizeUnits(size)


		local ConversionFirstName,ConversionLastName,GroupName
		local DocumentUpload = {}

		if MessageType == "GROUP" then

			ConversionFirstName="";ConversionLastName="";GroupName=MemberName
			DocumentUpload[1] = {
				UserId = UserId,
				File = file_inbytearray,
				FileName = Imagename,
				FileType = "Images"
			}

		else
			ConversionFirstName="";ConversionLastName=MemberName;GroupName=""

			
			DocumentUpload[1] = {
				UserId = UserId,
				File = file_inbytearray,
				FileName = Imagename,
				FileType = "Images"
			}

			



		end

		MessageFileType="Images"

		ChatBox.text = ""

		
		Webservice.SEND_MESSAGE(MessageId,ConversionFirstName,ConversionLastName,GroupName,DocumentUpload,MessageFileType,ChatBox.text,captionname,"","","","",ImagePath,Imagename,Imagesize,"","","","SEND",From,To,Message_Type,get_sendMssage)

		

				   --Webservice.DOCUMENT_UPLOAD(file_inbytearray,photoname,"Images",get_imagemodel)

				   sendMeaasage()


				end

			end

		end







		function scene:resumeVideocall(button_idvalue,url)

			print("resume game calling"..url)


			composer.removeHidden()


			ChatBox.isVisible=true
			
			if url  ~= nil and url ~= "" then

				if button_idvalue == "cancel" then

					print("cancel pressed")

					elseif button_idvalue == "send" then

					print("send pressed")

					local Message_date,isDeleted,Created_TimeStamp,Updated_TimeStamp,ImagePath,ImageName,ImageSize,AudioPath,VideoPath,MyUnitBuzz_LongMessage,From,To,Message_Type

					Message_date=os.date("%Y-%m-%dT%H:%M:%S")
					isDeleted="false"
					Created_TimeStamp=os.date("!%Y-%m-%dT%H:%M:%S")
					Updated_TimeStamp=os.date("!%Y-%m-%dT%H:%M:%S")
					ImagePath="NULL"
					ImageName = "NULL"
					ImageSize = "NULL"
					AudioPath="NULL"
					VideoPath=url or "NULL"
					MyUnitBuzz_LongMessage=url
					From=ContactId
					To=To_ContactId
					Message_Type = MessageType

					if 	Message_Type:lower( ) == "broadcast" then

					    for i=1,#broadcastlist do

							local insertQuery = [[INSERT INTO pu_MyUnitBuzz_Message VALUES (NULL, ']]..UserId..[[',']]..Utils.encrypt(url)..[[','SEND',']]..Message_date..[[',']]..isDeleted..[[',']]..Created_TimeStamp..[[',']]..Updated_TimeStamp..[[',']]..ImagePath..[[',']]..AudioPath..[[',']]..VideoPath..[[',']]..MyUnitBuzz_LongMessage..[[',']]..From..[[',']]..broadcastlist[i].to..[[','INDIVIDUAL',']]..MemberName..[[',']]..broadcastlist[i].UserName..[[',']]..broadcastlist[i].UserName..[[','yes');]]
						    db:exec( insertQuery )

						end
					end	  

					local insertQuery = [[INSERT INTO pu_MyUnitBuzz_Message VALUES (NULL, ']]..UserId..[[',']]..Utils.encrypt(url)..[[','SEND',']]..Message_date..[[',']]..isDeleted..[[',']]..Created_TimeStamp..[[',']]..Updated_TimeStamp..[[',']]..ImagePath..[[',']]..AudioPath..[[',']]..VideoPath..[[',']]..MyUnitBuzz_LongMessage..[[',']]..From..[[',']]..To..[[',']]..Message_Type..[[',']]..MemberName..[[',']]..UserName..[[',']]..UserName..[[','no');]]
					db:exec( insertQuery )


					for row in db:nrows("SELECT * FROM pu_MyUnitBuzz_Message WHERE Video_Path= 'DEFAULT'") do
						image_update_row = row.id 

					end 


					local ConversionFirstName,ConversionLastName,GroupName
			    local DocumentUpload = {}

			    if MessageType == "GROUP" then

			    	ConversionFirstName="";ConversionLastName="";GroupName=UserName;DocumentUpload=""

			    elseif MessageType == "INDIVIDUAL" then

			    	ConversionFirstName="";ConversionLastName=UserName;GroupName="";DocumentUpload=""

			    elseif MessageType == "BROADCAST" then

			    	if IsOwner == true then

			    		ConversionFirstName="";ConversionLastName=UserName;GroupName=UserName;DocumentUpload=""

			    	else
			    		
			    		ConversionFirstName="";ConversionLastName=UserName;GroupName="";DocumentUpload=""

			    	end

			    end
		    

		    Webservice.SEND_MESSAGE(MessageId,ConversionFirstName,ConversionLastName,GroupName,DocumentUpload,"",MyUnitBuzz_LongMessage,MyUnitBuzz_LongMessage,"","","","",ImagePath,Imagename,Imagesize,"","","","SEND",From,To,Message_Type,get_sendMssage)
		    
	  
		    
		    ChatBox.text = ""


					sendMeaasage()


				end

			end

		end





		function scene:resumeGameNormal(status,name)

			print("resume game")

			composer.removeHidden()
			title.text = name

			if title.text:len() > 20 then
  				title.text = title.text:sub(1,20  ).."..."
    		end

			ChatBox.isVisible=true


			if status == "delete" then

				if MessageType:lower( ) == "group" then

					composer.gotoScene( "Controller.groupPage" )

				else

					composer.gotoScene( "Controller.broadCastPage" )

				end

			end

		end



		function scene:resumeGame(value,status)

			print("resume game with values")

			composer.removeHidden()

			
			local options = {
				effect = "crossFade",
				time = 100,	
				params = json.decode(value)
			}



			local function doAction( event )
				composer.showOverlay( "Controller.consultantListPage", options )
			end


			timer.performWithDelay( 100, doAction,1 )

		end




		function scene:resumeEditGame(editedGroupName,contactId)

			print("Edited Group Name : "..editedGroupName)

			composer.removeHidden()

			local options = {
				effect = "fromTop",
				time = 200,	
				params = {
					contactId = contactId,
					MessageType = MessageType,
					GroupTypeValue = GroupTypeValue,
				}

			}


			
			UserName = editedGroupName
			title.text = UserName

			if title.text:len() > 20 then
  				title.text = title.text:sub(1,20  ).."..."
    		end

			local function doAction( event )

					if openPage == "MessagingPage" then
						composer.showOverlay( "Controller.Chathead_detailPage", options )
					end
				
			end


			timerId = timer.performWithDelay( 200, doAction,1 )

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
icons_holder_bg:addEventListener( "touch", attachAction )
				--icons_holder_bg.height = icons_holder_bg.height/2

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




-------------------------------------------- Gallery ---------------------------------------------------

gallery_icon = display.newImageRect(AttachmentGroup,"res/assert/gallery1.png",40,35)
gallery_icon.x= W/2 - 12
gallery_icon.anchorX=0
gallery_icon.anchorY=0
gallery_icon.y = camera_icon.y 
gallery_icon.id="gallery"
gallery_icon:addEventListener( "touch", attachAction )


gallery_icon_txt = display.newText(AttachmentGroup,MessagePage.Gallery,0,0,native.systemFont,14)
gallery_icon_txt.anchorX = 0
gallery_icon_txt.anchorY = 0
gallery_icon_txt.x = gallery_icon.x - 5
gallery_icon_txt.y = gallery_icon.y+gallery_icon.contentHeight+5
gallery_icon_txt:setFillColor(0)


-------------------------------------------- Audio ---------------------------------------------------




audio_icon = display.newImageRect(AttachmentGroup,"res/assert/audio1.png",40,35)
audio_icon.x= W/2 + W/3 - 30
audio_icon.anchorX=0
audio_icon.anchorY=0
audio_icon.y = gallery_icon.y
audio_icon.id="audio"
audio_icon:addEventListener( "touch", attachAction )


audio_icon_txt = display.newText(AttachmentGroup,MessagePage.Audio,0,0,native.systemFont,14)
audio_icon_txt.anchorX = 0
audio_icon_txt.anchorY = 0
audio_icon_txt.x = audio_icon.x 
audio_icon_txt.y = audio_icon.y+audio_icon.contentHeight+5
audio_icon_txt:setFillColor(0)


-------------------------------------------- Video ---------------------------------------------------

video_icon = display.newImageRect(AttachmentGroup,"res/assert/video1.png",40,35)
video_icon.x= W/2 - W/3
video_icon.anchorX=0
video_icon.anchorY=0
video_icon.y = audio_icon.y+audio_icon.contentHeight+30
video_icon.id="video"
video_icon:addEventListener( "touch", attachAction )


video_icon_txt = display.newText(AttachmentGroup,MessagePage.Video,0,0,native.systemFont,14)
video_icon_txt.anchorX = 0
video_icon_txt.anchorY = 0
video_icon_txt.x = video_icon.x 
video_icon_txt.y = video_icon.y+video_icon.contentHeight+5
video_icon_txt:setFillColor(0)

end 


------------------------------------------------------

function scene:create( event )

	local sceneGroup = self.view


	Background = display.newImageRect(sceneGroup,"res/assert/background.jpg",W,H)
	Background.x=W/2;Background.y=H/2

	tabBar = display.newRect(sceneGroup,W/2,0,W,40)
	tabBar.y=tabBar.contentHeight/2
	tabBar:setFillColor(Utils.convertHexToRGB(color.primaryColor))

	menuBtn = display.newImageRect(sceneGroup,"res/assert/menu.png",23,17)
	menuBtn.anchorX=0
	menuBtn.x=10;menuBtn.y=20;

	BgText = display.newImageRect(sceneGroup,"res/assert/logo.png",398/4,81/4)
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
	Deleteicon.x=W-50;Deleteicon.y=title_bg.y
	Deleteicon.isVisible=false
	Deleteicon.id="delete"
	Deleteicon:addEventListener( "touch", deleteAction )

	Copyicon = display.newImageRect( sceneGroup, "res/assert/copy-icon.png", 15, 15 )
	Copyicon.x=W-80;Copyicon.y=title_bg.y
	Copyicon.isVisible=false
	Copyicon.id="copy"
	Copyicon:addEventListener( "touch", deleteAction )

	Forwardicon = display.newImageRect( sceneGroup, "res/assert/forward_thumb.png", 18, 16 )
	Forwardicon.x=W-20;Forwardicon.y=title_bg.y
	Forwardicon.isVisible=false
	Forwardicon.id="forward"
	Forwardicon:setFillColor( 0 )
	Forwardicon:addEventListener( "touch", deleteAction )


	MainGroup:insert(sceneGroup)

end

local function get_ForwarChatMessageDetails( response )
	-- body
end


local function SendFowardMessage( list )


	local ChatListArray = {}


	for i= 1,#list do

		local tempgroup
		 for row in db:nrows("SELECT * FROM pu_MyUnitBuzz_Message WHERE rowid='"..list[i].id.."'") do

		 	tempgroup=row
						    	
		end


	


	local Message_date,isDeleted,Created_TimeStamp,Updated_TimeStamp,ImagePath,AudioPath,VideoPath,MyUnitBuzz_LongMessage,From,To,Message_Type
        		
        

        	Message_date=os.date("%Y-%m-%dT%H:%M:%S")
        	isDeleted="false"
        	Created_TimeStamp=os.date("!%Y-%m-%dT%H:%M:%S")
        	Updated_TimeStamp=os.date("!%Y-%m-%dT%H:%M:%S")
        	ImagePath= tempgroup.Image_Path:match( "([^/]+)$" )  or ""
        	AudioPath=tempgroup.Audio_Path:match( "([^/]+)$" ) or ""
        	VideoPath=tempgroup.Video_Path or ""
        	MyUnitBuzz_LongMessage=tempgroup.MyUnitBuzz_Message
        	From=ContactId
        	To=To_ContactId
        	Message_Type = MessageType
        	MessageFileType=""


        	if string.find(tempgroup.MyUnitBuzz_Message,"https://") or string.find(tempgroup.MyUnitBuzz_Message,"http://") then

        		local pattern = "https?://[%w-_%.%?%.:/%+=&]+"

	       		VideoPath=string.match(tempgroup.MyUnitBuzz_Message, pattern)

        	end


        	
		    --	native.showAlert("Type",Message_Type,{CommonWords.ok})

		    if 	Message_Type:lower( ) == "broadcast" then

					    for i=1,#broadcastlist do

		    				local insertQuery = [[INSERT INTO pu_MyUnitBuzz_Message VALUES (NULL, ']]..UserId..[[',']]..Utils.encrypt(MyUnitBuzz_LongMessage)..[[','SEND',']]..Message_date..[[',']]..isDeleted..[[',']]..Created_TimeStamp..[[',']]..Updated_TimeStamp..[[',']]..ImagePath..[[',']]..AudioPath..[[',']]..VideoPath..[[',']]..MyUnitBuzz_LongMessage..[[',']]..From..[[',']]..broadcastlist[i].to..[[',']]..Message_Type..[[',']]..MemberName..[[',']]..broadcastlist[i].UserName..[[',']]..broadcastlist[i].UserName..[[','yes');]]
						    db:exec( insertQuery )

						end
			end	

		    print(UserId.."\n"..tempgroup.MyUnitBuzz_Message.."\n"..Message_date.."\n"..isDeleted.."\n"..Created_TimeStamp.."\n"..Updated_TimeStamp.."\n"..MyUnitBuzz_LongMessage.."\n"..From.."\n"..To.."\n"..MemberName.."\n end" )
		    local insertQuery = [[INSERT INTO pu_MyUnitBuzz_Message VALUES (NULL, ']]..UserId..[[',']]..Utils.encrypt(MyUnitBuzz_LongMessage)..[[','SEND',']]..Message_date..[[',']]..isDeleted..[[',']]..Created_TimeStamp..[[',']]..Updated_TimeStamp..[[',']]..ImagePath..[[',']]..AudioPath..[[',']]..VideoPath..[[',']]..MyUnitBuzz_LongMessage..[[',']]..From..[[',']]..To..[[',']]..Message_Type..[[',']]..MemberName..[[',']]..UserName..[[',']]..UserName..[[','no');]]
		    db:exec( insertQuery )

		    local ConversionFirstName,ConversionLastName,GroupName
		    local DocumentUpload = {}

		    if Message_Type == "GROUP" then

		    	ConversionFirstName="";ConversionLastName="";GroupName=UserName

		    elseif Message_Type == "INDIVIDUAL" then

		    	ConversionFirstName="";ConversionLastName=UserName;GroupName=""

		    elseif Message_Type == "BROADCAST" then

		    	if IsOwner == true then

		    		ConversionFirstName="";ConversionLastName=UserName;GroupName=UserName;DocumentUpload=""

		    	else
		    		
		    		ConversionFirstName="";ConversionLastName=UserName;GroupName=""

		    	end

		    end

		    print( "AudioPath : "..AudioPath )

		    if ImagePath ~= nil and ImagePath ~= "" and ImagePath ~= "NULL" then
	
		    	local path = system.pathForFile( ImagePath, system.DocumentsDirectory)

				local size = lfs.attributes (path, "size")

				local fileHandle = io.open(path, "rb")

				local file_inbytearray = mime.b64( fileHandle:read( "*a" ) )

				formatSizeUnits(size)

				
					if Message_Type == "GROUP" then

						DocumentUpload[1] = {
							UserId = UserId,
							File = file_inbytearray,
							FileName = ImagePath,
							FileType = "Images"
						}

					else
						
						DocumentUpload[1] = {
							UserId = UserId,
							File = file_inbytearray,
							FileName = ImagePath,
							FileType = "Images"
						}

					end

					MessageFileType="Images"

		    elseif AudioPath ~= nil and AudioPath ~= "" and AudioPath ~= "NULL" then

		    	local path = system.pathForFile( AudioPath, system.DocumentsDirectory)

				local size = lfs.attributes (path, "size")

				local fileHandle = io.open(path, "rb")

				local file_inbytearray = mime.b64( fileHandle:read( "*a" ) )

				formatSizeUnits(size)

				
					if Message_Type == "GROUP" then

						DocumentUpload[1] = {
							UserId = UserId,
							File = file_inbytearray,
							FileName = AudioPath,
							FileType = "Audios"
						}

					else
						
						DocumentUpload[1] = {
							UserId = UserId,
							File = file_inbytearray,
							FileName = AudioPath,
							FileType = "Audios"
						}

					end

		    	FileType = "Audios"

		    elseif VideoPath ~= nil and VideoPath ~= "" and VideoPath ~= "NULL" then

		    	DocumentUpload=""

		    else

		    	DocumentUpload=""

		    end


		    	-- ChatListArray[#ChatListArray+1] = {}
		    	-- local tempArray = ChatListArray[#ChatListArray+1]

		    	ChatListArray[#ChatListArray+1] = {MyUnitBuzzLongMessage=MyUnitBuzz_LongMessage,MyUnitBuzzMessage=MyUnitBuzz_LongMessage,IsScheduled="",ScheduledDate="",ScheduledTime="",VideoFilePath=VideoPath,MessageStatus="SEND",MessageDate=Message_date,UserId=UserId,EmailAddress=EmailAddess,MyUnitBuzzMessageId="0",AudioFilePath=AudioPath,AudioFileName=AudioPath,AudioFileSize=0,From=From,To=To,MessageType=Message_Type,TimeZone=TimeZone,ConversionFirstName=ConversionFirstName,ConversionLastName=ConversionLastName,FirstName="",LastName=MemberName,GroupName=GroupName,IsSendNow=tostring(isSendNow),MessageFileType=MessageFileType,DocumentUpload=DocumentUpload}
		  

		   		--Webservice.SEND_MESSAGE(MessageId,ConversionFirstName,ConversionLastName,GroupName,DocumentUpload,MessageFileType,MyUnitBuzz_LongMessage,MyUnitBuzz_LongMessage,"","","","",ImagePath,Imagename,Imagesize,"","","","SEND",From,To,Message_Type,get_sendMssage)
	 	   end



	 	   	Webservice.ForwarChatMessageDetails(ChatListArray,get_ForwarChatMessageDetails)

	  		sendMeaasage()
		 	  
end


function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then

			if event.params then

				nameval = event.params.tabbuttonValue2
				pagevalue = event.params.typevalue


			end

			composer.removeHidden()


	elseif phase == "did" then

				if event.params.contactDetails ~= nil then
					ContactDetails = event.params.contactDetails
				else
					ContactDetails = ""
				end

				print("ContactDetails : "..json.encode( ContactDetails ))

	    	To_ContactId = ContactDetails.Contact_Id or ContactDetails.Message_To or ContactDetails.MyUnitBuzzGroupId


			if tostring(To_ContactId) == tostring(ContactId) then
				To_ContactId=ContactDetails.Message_From
			end


			if ContactDetails.MyUnitBuzzGroupId ~= nil then

					if ContactDetails.MyUnitBuzzGroupType == "BROADCAST" then
						MessageType = "BROADCAST"
					else
						MessageType = "GROUP"
					end

			else

				     MessageType = "INDIVIDUAL"

			end

			
			if ContactDetails.Message_Type then

				MessageType=ContactDetails.Message_Type

			end



			if MessageType == "GROUP" then

					title.text = ContactDetails.GroupName or ContactDetails.MyUnitBuzzGroupName
			else

					if ContactId == ContactDetails.Message_From then

						title.text = ContactDetails.ToName or ContactDetails.MyUnitBuzzGroupName
					else
						title.text = ContactDetails.FromName or ContactDetails.MyUnitBuzzGroupName
					end


					if ContactDetails.Name ~= nil then
						title.text = ContactDetails.Name
					end
				
			end



		UserName = title.text

		

			if title.text:len() > 20 then
  				title.text = title.text:sub(1,20  ).."..."
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
		image_name_png:setFillColor( Utils.convertHexToRGB(color.primaryColor))
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
		sendBtn.anchorY=0;
		sendBtn.anchorX=0


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


		------------------------------------------- attachment icon -----------------------------------------

		

		attachment_icon = display.newImageRect(sceneGroup,"res/assert/attached.png",20,20)
		attachment_icon.x= W-40;attachment_icon.y = tabBar.y+35
		attachment_icon.isVisible = true
		

		attachment_icon_bg = display.newRect( sceneGroup, W-40, tabBar.y+35, 60, 40 )
		attachment_icon_bg.x=attachment_icon.x
		attachment_icon_bg.y=attachment_icon.y
		attachment_icon_bg:setFillColor( 0.3,0.2,0 )
		attachment_icon_bg.alpha=0.01
		attachment_icon_bg:addEventListener( "touch", AttachmentTouch )


		createAttachment()

		AttachmentGroup.anchorX=0;AttachmentGroup.anchorY=0
		AttachmentGroup.alpha=0
		AttachmentGroup.y=AttachmentGroup.y+68
		AttachmentGroup.anchorChildren = true

		sceneGroup:insert( AttachmentGroup )


		 helpText = display.newText(sceneGroup,ChatDetails.GroupWarning,0,0,W-20,0,native.systemFont,14)
		helpText.x=W/2
		helpText.isVisible=false
		helpText.y=ChatBox_bg.y+ChatBox_bg.contentHeight/2
		helpText:setTextColor( 0,0,0,0.5 )

		if MessageType:lower( ) == "group" then
			helpText.text = ChatDetails.GroupWarning
		elseif MessageType:lower( ) == "broadcast" then
			helpText.text = ChatDetails.BroadcastWarning
		end

		-- local function getBroastcastDetailsbyContactId( response )

			

		-- 	if #response > 0 then

		-- 		broadcastflag=true

		-- 		for i=1,#response do
		-- 			--print( response[i].MyUnitBuzzGroupId )
		-- 			broadcastlist[#broadcastlist+1] = response[i].MyUnitBuzzGroupId
		-- 		end

		-- 	end



		-- 	sendMeaasage()

		-- 	if  MessageType == "INDIVIDUAL" and event.params ~= nil and event.params.status == "forward" then
					

		-- 					SendFowardMessage( event.params.forwardDetails)

		-- 	end

		-- end

		 local function getCheckChatGroupStatus( response )
		 	print( "here" )
		 		if #response <= 0  then


		 				 for row in db:nrows("SELECT * FROM pu_MyUnitBuzz_Message WHERE (Message_To='"..tostring(To_ContactId):lower().."') OR (Message_From='"..tostring(To_ContactId):lower().."') ") do

					    	local q = "UPDATE pu_MyUnitBuzz_Message SET Is_Deleted='true';"
					    	db:exec( q )
					    	
					    end

		 			isdeleted = true
		 			helpText.isVisible=true
		 			ChatBox_bg.width = W-10
					ChatBox.isVisible = false

					attachment_icon.isVisible = false
					attachment_icon_bg.isVisible = false
					sendBtn.isVisible = false
					sendBtn_bg.isVisible = false

				else


					for i=1,#response do
						local userName

						if response[i].FirstName ~= nil then
							userName = response[i].FirstName.." "..response[i].LastName
						else
							userName = response[i].LastName
						end
						--print( response[i].MyUnitBuzzGroupId )
						broadcastlist[#broadcastlist+1] = {to = response[i].ContactId,UserName = userName}

					end


					 for row in db:nrows("SELECT * FROM pu_MyUnitBuzz_Message WHERE (Message_To='"..tostring(To_ContactId):lower().."') OR (Message_From='"..tostring(To_ContactId):lower().."') ") do

					    	local q = "UPDATE pu_MyUnitBuzz_Message SET Is_Deleted='false';"
					    	db:exec( q )
					    	
					 end

					 if event.params ~= nil and event.params.status == "forward" then
					 	print( "hai" )
					 	SendFowardMessage( event.params.forwardDetails)

					 else
					 	print( "not forward _______" )
					 	sendMeaasage()

					 end




		 		end
		 end



		
		if MessageType == "GROUP" or MessageType == "BROADCAST" then


		    	Webservice.CheckChatGroupStatus(To_ContactId,getCheckChatGroupStatus)
		 else


		 	if event.params ~= nil and event.params.status == "forward" then
					 	print( "hai" )
					 	SendFowardMessage( event.params.forwardDetails)

			else
					 	print( "not forward _______" )
					 	sendMeaasage()

			end

		 	--	Webservice.GetBroastcastDetailsbyContactId(To_ContactId,getBroastcastDetailsbyContactId)

		
		end

		sceneGroup:insert( ChatScrollContent )

		--Tabbar---

		tabBg = display.newRect( tabBarGroup, W/2, H-40, W, 40 )
		tabBg.anchorY=0
		tabBg.strokeWidth = 1
		tabBg:setStrokeColor( Utils.convertHexToRGB(color.primaryColor),0.7 )

		tab_Group = display.newRect(tabBarGroup,0,0,70,40)
		tab_Group.x=W/2-W/3;tab_Group.y=tabBg.y
		tab_Group.anchorY=0
		tab_Group.alpha=0.01
		tab_Group.id="group"
		tab_Group:setFillColor( 0.2 )

		tab_Message = display.newRect(tabBarGroup,0,0,70,40)
		if IsOwner == true then
			tab_Message.x=W/2-W/8
		else
			tab_Message.x = W/2
		end
		tab_Message.y=tabBg.y
		tab_Message.anchorY=0
		tab_Message.alpha=0.01
		tab_Message.id="message"
		tab_Message:setFillColor( 0.2 )

		if IsOwner == true then
			tab_Boradcast = display.newRect(tabBarGroup,0,0,70,40)
			tab_Boradcast.x=W/2+W/10;tab_Boradcast.y=tabBg.y
			tab_Boradcast.anchorY=0
			tab_Boradcast.alpha=0.01
			tab_Boradcast.id="broadcast"
			tab_Boradcast:setFillColor( 0.2 )

			tab_Boradcast:addEventListener( "touch", TabbarTouch )
		end

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

		tab_Group_txt = display.newText( tabBarGroup,  ChatPage.Group ,0,0,native.systemFont,11 )
		tab_Group_txt.x=tab_Group_btn.x;tab_Group_txt.y=tab_Group_btn.y+tab_Group_btn.contentHeight+5
		tab_Group_txt:setFillColor( 0.3 )

		tab_Message_txt = display.newText( tabBarGroup,  ChatPage.Chats,0,0,native.systemFont,11 )
		tab_Message_txt.x=tab_Message_btn.x;tab_Message_txt.y=tab_Message_btn.y+tab_Message_btn.contentHeight+5
		tab_Message_txt:setFillColor( Utils.convertHexToRGB(color.primaryColor) )

		if IsOwner == true then
			tab_Broadcast_txt = display.newText( tabBarGroup,ChatPage.Broadcast,0,0,native.systemFont,11 )
			tab_Broadcast_txt.x=tab_broadcast_btn.x;tab_Broadcast_txt.y=tab_Message_btn.y+tab_Message_btn.contentHeight+5
			tab_Broadcast_txt:setFillColor( 0.3 )
		end

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
		chatReceivedPage = "main"
		Runtime:removeEventListener( "enterFrame", printTimeSinceStart )
		Runtime:removeEventListener( "key", onKeyEvent )
		image_name_close:removeEventListener( "touch", ImageClose )
		if timerId ~= nil then timer.cancel( timerId );timerId=nil end

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
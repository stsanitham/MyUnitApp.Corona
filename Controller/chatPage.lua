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



    
	function get_imagemodel(response)

		print("SuccessMessage")

		Imagepath = response.Abspath

		Imagename = response.FileName

		Imagesize = size

		print("Imagesize................",Imagesize)

			image_name_png.isVisible = true

			image_name_png.text = Imagename

			image_name_close.isVisible = true

			sendBtn_bg.isVisible = true

			sendBtn.isVisible = true

			recordBtn.isVisible = false

	end



      

    local function sendImage( )

	Webservice.DOCUMENT_UPLOAD(file_inbytearray,photoname,"Images",get_imagemodel)

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

		photoname = "image"..os.date("%Y%m%d%H%m%S")..".jpg"

        display.save(photo,photoname,system.DocumentsDirectory)

        photo:removeSelf()

        photo = nil


        path = system.pathForFile( photoname, baseDir)

        local size = lfs.attributes (path, "size")

		local fileHandle = io.open(path, "rb")

		file_inbytearray = mime.b64( fileHandle:read( "*a" ) )

		io.close( fileHandle )

            print("mime conversion ",file_inbytearray)

        	print("bbb ",size)

        	formatSizeUnits(size)

        	sendImage()

	else

	end

end





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

		elseif event.target.id == "video" then

			print( "video" )

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

			Runtime:removeEventListener( "enterFrame", printTimeSinceStart )
			ChatBox.isVisible=false

		    composer.showOverlay( "Controller.audioRecordPage",options)

		elseif event.target.id == "gallery" then


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
			Copyicon.value = event.target.chat

			if selectedForDelete ~= nil then 
				if selectedForDelete.y ~= nil then
				 selectedForDelete:removeSelf();selectedForDelete=nil 
				 end 
			end

			selectedForDelete = display.newRect( W/2,event.target.y+event.target.contentHeight/2,W,event.target.contentHeight+15)
			selectedForDelete:setFillColor( 0.3,0.6,0.5,0.4 )
			event.target.group:insert( selectedForDelete )

			print("delete Action")

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



local function receviedimageDownload( event )
	if event.phase == "began" then
			display.getCurrentStage():setFocus( event.target )
	elseif event.phase == "ended" then
			display.getCurrentStage():setFocus( nil )

			network.download(
	event.target.id,
	"GET",
	recivedNetwork,
	event.target.id:match( "([^/]+)$" ),
	system.DocumentsDirectory
	)

	end

return true
end


local function sendMeaasage()
	
	ChatBox.text=""
	

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

		ChatHistory[#ChatHistory+1] =row

	end

	
	local dateVlaue=""

	for i=1,#ChatHistory do


		local dateLable = nil
		local datevalue = nil

		MeassageList[#MeassageList+1] = display.newGroup( )

		local tempGroup = MeassageList[#MeassageList]

	--	print( "ChatHistory : "..json.encode(ChatHistory[i]) )
        

		local bg = display.newRect(0,0,W-100,25 )
		tempGroup:insert(bg)
		
		bg.anchorX=0;bg.anchorY=0
		bg.id=ChatHistory[i].id
		bg.group=tempGroup
		bg:addEventListener( "touch", ChatTouch )


		if MeassageList[#MeassageList-1] ~= nil then
			bg.y=MeassageList[#MeassageList-1][1].y+MeassageList[#MeassageList-1][1].contentHeight+20
		else
			bg.y=0
		end
			bg.x=5

			--


			

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

			--print( Utils.getTime(makeTimeStamp(ChatHistory[i].Update_Time_Stamp),"%B %d, %Y",TimeZone) .." and ".. Utils.getTime(os.time(os.date( "!*t" )),"%B %d, %Y",TimeZone) )

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

			
				print( "here" )
				bg.x=W-65
				bg.anchorX=1


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
		chat.anchorY=0
		chat.anchorX = 0
		chat.x=bg.x+5;chat.y=bg.y
	

		tempGroup:insert( chat )

	
		bg.width = chat.contentWidth+10	
		bg.height = chat.contentHeight+10
		bg.chat=chat.text

		local owner

		if MessageType == "GROUP" then

			owner = display.newText(tempGroup,"",0,0,native.systemFont,14)
			owner.anchorY=0
			owner.anchorX = 0
			owner.x=chat.x
			owner.y=chat.y
			owner:setTextColor( 1, 1, 0 )
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


			if ChatHistory[i].Image_Path  ~= nil and ChatHistory[i].Image_Path ~= "" then

			Imagename = ChatHistory[i].Image_Path:match( "([^/]+)$" )

							print( "here value : "..Imagename)

			local image

			 local filePath = system.pathForFile( Imagename,system.DocumentsDirectory )
		 	 local fhd = io.open( filePath )
			
				if fhd then		

					print("@@@@@@@@@@@@")
						
					image = display.newImageRect( tempGroup, Imagename,system.DocumentsDirectory, 200, 170 )
					io.close( fhd )

				else

					--network download
					image = display.newImageRect( tempGroup, "res/assert/detail_defalut.jpg", 200, 170 )
					image.id=ChatHistory[i].Image_Path
					image:addEventListener( "touch", receviedimageDownload )

				end


			image.anchorY=0
			image.anchorX = 0
			image.x=bg.x+2.5
			image.y=bg.y+2.5

			bg.width = image.contentWidth+5
			bg.height = image.contentHeight+5		


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
			if owner ~= nil then print("$$$ : "..owner.text);owner.x=chat.x end
			bg:setFillColor( Utils.convertHexToRGB(color.tabBarColor) )

		else
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

chatScroll:scrollTo( "bottom", { time=200 } )

end


	local function printTimeSinceStart( event )



			tabBar:toFront( );menuBtn:toFront( );BgText:toFront( );title_bg:toFront( );title:toFront( );BackBtn:toFront( );Deleteicon:toFront( );Copyicon:toFront( );attachment_icon:toFront()

			if chatHoldflag == true then

				holdLevel=holdLevel+1

					if holdLevel > 25 then

						print("delete Action")

						Deleteicon.isVisible=true
						Copyicon.isVisible=true

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

			if selectedForDelete ~= nil then 
				if selectedForDelete.y ~= nil then
				 selectedForDelete:removeSelf();selectedForDelete=nil 
				 end 
			end
		    	
		    	
		    end


local function deleteAction( event )
	if event.phase == "ended" then

 
		if event.target.id == "delete" then


				local q = [[DELETE FROM pu_MyUnitBuzz_Message WHERE id=]]..event.target.value..[[;]]
				db:exec( q )
				sendMeaasage()

		elseif event.target.id == "copy" then
						
						print( event.target.value )

						pasteboard.copy( "string", event.target.value)

						toast.show(ChatPage.Message_Copied, {duration = 'long', gravity = 'Center', offset = {0, 128}})  



		end		
				Copyicon.isVisible=false
				Deleteicon.isVisible=false
	end

return true
end



function get_sendMssage(response)

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

							print( "Message_Type          :  "..To_ContactId )
					Runtime:removeEventListener( "enterFrame", printTimeSinceStart )
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

		print( "###############" )
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


print("Imagename : "..Imagename)

			if ChatBox.text ~= nil and ChatBox.text ~= "" then
			
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


		--	native.showAlert("Type",Message_Type,{CommonWords.ok})

				print(UserId.."\n"..ChatBox.text.."\n"..Message_date.."\n"..isDeleted.."\n"..Created_TimeStamp.."\n"..Updated_TimeStamp.."\n"..MyUnitBuzz_LongMessage.."\n"..From.."\n"..To_ContactId.."\n"..MemberName.."\n end" )
				local insertQuery = [[INSERT INTO pu_MyUnitBuzz_Message VALUES (NULL, ']]..UserId..[[',']]..Utils.encrypt(ChatBox.text)..[[','SEND',']]..Message_date..[[',']]..isDeleted..[[',']]..Created_TimeStamp..[[',']]..Updated_TimeStamp..[[',']]..ImagePath..[[',']]..AudioPath..[[',']]..VideoPath..[[',']]..MyUnitBuzz_LongMessage..[[',']]..From..[[',']]..To..[[',']]..Message_Type..[[',']]..title.text..[[',']]..MemberName..[[',']]..title.text..[[');]]
				db:exec( insertQuery )

				print( ChatBox.text,ChatBox.text,"","","","","SEND",From,To,Message_Type )


			Webservice.SEND_MESSAGE(ChatBox.text,ChatBox.text,"","","","",ImagePath,Imagename,Imagesize,"SEND",From,To,Message_Type,get_sendMssage)


		    elseif Imagename ~= nil or Imagename ~= "" then

		    	    print("ertertertertt")

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


				--	native.showAlert("Type",Message_Type,{CommonWords.ok})

						print(UserId.."\n"..ChatBox.text.."\n"..Message_date.."\n"..isDeleted.."\n"..Created_TimeStamp.."\n"..Updated_TimeStamp.."\n"..MyUnitBuzz_LongMessage.."\n"..From.."\n"..To_ContactId.."\n"..MemberName.."\n end" )
						local insertQuery = [[INSERT INTO pu_MyUnitBuzz_Message VALUES (NULL, ']]..UserId..[[',']]..Utils.encrypt(ChatBox.text)..[[','SEND',']]..Message_date..[[',']]..isDeleted..[[',']]..Created_TimeStamp..[[',']]..Updated_TimeStamp..[[',']]..ImagePath..[[',']]..AudioPath..[[',']]..VideoPath..[[',']]..MyUnitBuzz_LongMessage..[[',']]..From..[[',']]..To..[[',']]..Message_Type..[[',']]..title.text..[[',']]..MemberName..[[',']]..title.text..[[');]]
						db:exec( insertQuery )

						print( ChatBox.text,ChatBox.text,"","","","","SEND",From,To,Message_Type )


					Webservice.SEND_MESSAGE(ChatBox.text,ChatBox.text,"","","","",ImagePath,ImageName,ImageSize,"SEND",From,To,Message_Type,get_sendMssage)



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

				title.text = ChatPage.Messages

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

	        if ( string.sub( system.getInfo("model"), 1, 2 ) == "iP" ) then

	        	scrollAction(-150)
	        else
	        	scrollAction(-170)


	        end

	    end
        


        elseif event.phase == "submitted" then
       		
       		

       	elseif event.phase == "ended" then

       		scrollAction(0)

        elseif event.phase == "editing" then

        	if (event.newCharacters=="\n") then
				native.setKeyboardFocus( nil )
			end

				-- if event.text:len() > 250 then

				-- 		event.target.text = event.text:sub(1,250)

			

				-- 	end

        	if event.text:len() >=1 then


        		sendBtn.isVisible=true
        		recordBtn.isVisible=false
        	else
        		sendBtn.isVisible=false
        		recordBtn.isVisible=true
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
    elseif ( phase == "moved" ) then print( "Scroll view was moved" )
    elseif ( phase == "ended" ) then print( "Scroll view was released" )

    local view = chatScroll:getView()

    print( "Size : "..view.contentHeight )

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

function scene:resumeGame()

			composer.removeHidden()

			ChatBox.isVisible=true

		Runtime:addEventListener( "enterFrame", printTimeSinceStart )



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

	title = display.newText(sceneGroup,FlapMenu.chatMessageTitle,0,0,native.systemFont,18)
	title.anchorX = 0
	title.x=BackBtn.x+BackBtn.contentWidth-5;title.y = title_bg.y
	title:setFillColor(0)

	title.text = FlapMenu.chatMessageTitle

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




		-- cameraBtn = display.newImageRect( sceneGroup, "res/assert/user.png", 25,20 )
		-- cameraBtn.x=ChatBox_bg.x+ChatBox_bg.contentWidth-35
		-- cameraBtn.y=ChatBox_bg.y+ChatBox_bg.contentHeight/2-cameraBtn.contentHeight/2
		-- cameraBtn.anchorY=0;cameraBtn.anchorX=0
		-- cameraBtn.isVisible=true

		sendBtn = display.newImageRect( ChatScrollContent, "res/assert/msg_send.png", 25,20 )
		sendBtn.x=ChatBox_bg.x+ChatBox_bg.contentWidth+5
		sendBtn.y=ChatBox_bg.y+ChatBox_bg.contentHeight/2-sendBtn.contentHeight/2
		sendBtn.anchorY=0;sendBtn.anchorX=0
		sendBtn.isVisible=false

		sendBtn_bg = display.newRect( ChatScrollContent, sendBtn.x+5, sendBtn.y+5, 45,45 )
		sendBtn_bg:setFillColor( 0,0,0,0.01 )

		recordBtn = display.newImageRect( ChatScrollContent, "res/assert/record.png", 25,20 )
		recordBtn.x=ChatBox_bg.x+ChatBox_bg.contentWidth+5
		recordBtn.y=ChatBox_bg.y+ChatBox_bg.contentHeight/2-recordBtn.contentHeight/2
		recordBtn.anchorY=0;recordBtn.anchorX=0


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
		--cameraBtn:addEventListener("touch", UploadImageAction)
		menuBtn:addEventListener("touch",menuTouch)
		ChatBox:addEventListener( "userInput", ChatBoxHandler )
		recordBtn:addEventListener( "touch", RecordAction )

	
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
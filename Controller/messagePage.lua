----------------------------------------------------------------------------------
--
-- instagram Screen
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


--------------- Initialization -------------------

local W = display.contentWidth;H= display.contentHeight

local Background, BgText, Message_content, send_button, send_button_text, url_dropdown , url_textcontent, feed_url, feed_cancelbutton,

      urlhelp_text

local menuBtn

openPage="messagePage"

local BackFlag = false

local Imagepath = ""

local Imagesize = "" 

local Imagename = ""

local Message_content = ""

local feedurl = ""

local VideoUrlGroup = display.newGroup( )

local VideoTypeArray = {"YouTube","Vimeo","Facebook","Yahoo"}

local messageGroup , photo

local PHOTO_FUNCTION = media.PhotoLibrary 	

---------------------------------------------------


---------------------Function----------------------



local function closeDetails( event )
	if event.phase == "began" then
			display.getCurrentStage():setFocus( event.target )
	elseif event.phase == "ended" then
			display.getCurrentStage():setFocus( nil )

	end

return true

end



local function FocusComplete( event )

	if event.phase == "began" then

		native.setKeyboardFocus(nil)

	elseif event.phase == "ended" then

	end
	
end 



local function onTouchAction( event )

	if event.phase == "began" then

			display.getCurrentStage():setFocus( event.target )

			native.setKeyboardFocus(nil)

			print("target message")

	elseif event.phase == "ended" then

			display.getCurrentStage():setFocus( nil )

            if event.target.id == "eventname" then

            	print("target message 111")

				if VideoUrlGroup.isVisible == true then

					print("feedurl  visible")

					VideoUrlGroup.isVisible = false

					feed_url.isVisible = true

					feed_url_bg.isVisible = false

				else

					print("feedurl not visible")

					VideoUrlGroup.isVisible = true

					feed_url.isVisible = false

					feed_url_bg.isVisible = true

				end

		   print( "event name" )

		end
	end

return true

end




local function VideoType_Render( event )

    local row = event.row

    local rowHeight = row.contentHeight
    local rowWidth = row.contentWidth

    local rowTitle = display.newText(row, VideoTypeArray[row.index], 0, 0, nil, 14 )
    rowTitle:setFillColor(0)
    rowTitle.anchorX = 0
    rowTitle.x = 5
    rowTitle.y = rowHeight * 0.5

    row.name=VideoTypeArray[row.index]

    print("row name ",row.name)

end



local function VideoType_Touch( event )
	local phase = event.phase
	local row = event.target

	native.setKeyboardFocus(nil)

	if( "press" == phase ) then

		elseif ( "release" == phase ) then
			
			if  VideoUrlGroup.isVisible == true then

				VideoUrlGroup.isVisible=false

				url_dropdown.text = row.name

				feed_url.isVisible = true

				feed_url_bg.isVisible = false

			end

		end
	end



local function textfield( event )

		if ( event.phase == "began" ) then

			print("event.target", event.target)

			event.target:setTextColor(color.black)

			current_textField = event.target;

			current_textField.size=16	

			if "*" == event.target.text:sub(1,1) then

				print("event.target 111", event.target.text:sub(1,1))

				print("event.target 222", event.target.text)

				event.target.text=""

			end


		elseif (event.phase == "submitted" ) then

			if(current_textField.id == "video url") then

			native.setKeyboardFocus( nil )

			end


		elseif ( event.phase == "editing" ) then

			
		end

end



	local function SetError( displaystring, object )

		object.text=displaystring
		object.size=11
		object:setTextColor(1,0,0)

	end



local function MessageLimitation( event )

	   if event.phase == "began" then

	   	print( "123" )

	   elseif event.phase == "submitted" then

			   if event.target.id =="messagecontent" or event.target.newCharacters=="\n" then

			   	print("here is the focus")
			   	--native.setKeyboardFocus( feed_url )
			   	native.setKeyboardFocus( nil )

			   end
		   if event.target.id =="messagecontent" then

		   		native.setKeyboardFocus( nil )

		   		native.setKeyboardFocus( feed_url )

		   end

	   elseif event.phase == "editing" then

	  

		if (string.len(event.target.text) > 160) then

		       event.target.text = event.target.text:sub(1, 160)
		end

		print( event.newCharacters )

	    if (event.newCharacters=="\n") then
			native.setKeyboardFocus( nil )
		end

	end

end


	local function bgTouch( event )

	if event.phase == "began" then
	display.getCurrentStage():setFocus( event.target )

	elseif event.phase == "ended" then
	display.getCurrentStage():setFocus( nil )

	end

	return true

	end


--------------------------------------------------- message sending functions----------------------------------------


	function MessageSending( Request_response )

	print("response after sending message ",Request_response)


	end



	function get_messagemodel(response)

		MessageSending(response)

		print("SuccessMessage")

		local sentalert = native.showAlert( Message.SuccessMsg, Message.SuccessContent, { CommonWords.ok })

		Message_content.text = ""

		feed_url.isVisible = true

		feed_url.text = ""

		Imagepath = ""

		Imagename = ""

		Imagesize = ""

		url_dropdown.text = "YouTube"

			image_name_png.text = ""

			upload_button.isVisible = true

			image_content_bg.isVisible = true

			image_name_close.isVisible = false

			upload_text.isVisible = true

	end



    local function sendMessage ( method )

		    if Message_content.text == nil  then

		    	Message_content.text = ""

		    end


		Webservice.SEND_MESSAGE(Message_content.text,feed_url.text,Imagepath,Imagename,Imagesize,method,get_messagemodel)

    end

    ----------------------------------------------------------------



-------------------image sending functions------------------------------

  


	function get_imagemodel(response)

		print("SuccessMessage")

		print( "content : "..response.Abspath )

		--local sentalert = native.showAlert( Message.SuccessMsgForImage, Message.SuccessContentForImage, { CommonWords.ok })

		Imagepath = response.Abspath

		Imagename = response.FileName

		Imagesize = size

			image_name_png.isVisible = true

			image_name_png.text = Imagename

			image_content_bg.isVisible = true

			upload_button.isVisible = false

			upload_text.isVisible = false

			image_name_close.isVisible = true

   --          local options =
			-- {
			--    to = { "anitha.mani@w3magix.com" },
			--    subject = "Corona Mail",
			--     body = "content : "..response.Abspath,
			   
			-- }
   --          native.showPopup("mail", options)

	end



    local function sendImage( )

	Webservice.DOCUMENT_UPLOAD(file_inbytearray,photoname,"Images",get_imagemodel)

    end

-----------------------------------------------------------------------

    function formatSizeUnits(event)

      if (event>=1073741824) then 

      	size=(event/1073741824)..' GB'

      print("size of the image11 ",size)


       elseif (event>=1048576) then   

       	size=(event/1048576)..' MB'

      print("size of the image 22",size)


      elseif (event>=1024)  then   

      	size = (event/1024)..' KB'

       print("size of the image 33",size)


      else      

  	  end

end





     local function selectionComplete ( event )

        print(event.target)
 
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

		photoname = "photo.jpg"

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



local function onComplete(event)

	if "clicked"==event.action then

		local i = event.index 

	if 1 == i then

		if media.hasSource( PHOTO_FUNCTION  ) then
		timer.performWithDelay( 100, function() media.selectPhoto( { listener = selectionComplete, mediaSource = PHOTO_FUNCTION } ) 
		end )
	    end

	elseif 2 == i then

		if media.hasSource( media.Camera ) then
        timer.performWithDelay( 100, function() media.capturePhoto( { listener = selectionComplete, mediaSource = media.Camera } ) 
		end )
	    end

		end

end

end


    function onImageButtonTouch( event )

    	local phase = event.phase

    	if phase=="began" then

    		display.getCurrentStage():setFocus( event.target )

	
    	elseif phase=="ended" then

    	display.getCurrentStage():setFocus( nil )

    	--sendMessage("SEND")

        local alert = native.showAlert(Message.FileSelect, Message.FileSelectContent, {Message.FromGallery,Message.FromCamera,"Cancel"} , onComplete)

	
	return true

    end

    end



    function onSendButtonTouch(event)

    	local phase = event.phase

    	if phase=="began" then

    		display.getCurrentStage():setFocus( event.target )

	
    	elseif phase=="ended" then

    	    local validation = false

  	    	native.setKeyboardFocus(nil)

    	    display.getCurrentStage():setFocus( nil )


			if (Message_content.text == "" or Message_content.text == nil) and (feed_url.text == "" or feed_url.text == nil) and (Imagepath == "" or Imagepath == nil) then


					if url_dropdown.text == "YouTube" or url_dropdown.text == "Vimeo" or url_dropdown.text == "Facebook" or url_dropdown.text == "Yahoo" then

					local alert = native.showAlert( Message.ErrorTitle, Message.ErrorMessage, { CommonWords.ok } )

					return false

				    else

			    	--sendMessage("SEND")

			        end

	        end


    	    if url_dropdown.text == "YouTube" then

    	    	local youtube_textentry = feed_url.text

    	    	if youtube_textentry ~= nil and youtube_textentry ~= "" then

    	    		print("youtube selection  ; "..youtube_textentry)

    	    		local Url = "http://www.youtube.com/watch?"
    	    		local Url1 = "https://www.youtube.com/watch?"
    	    		local Url2 = "https://youtu.be/"

    	    		if string.find(youtube_textentry,Url) or string.find(youtube_textentry,Url1) or string.find(youtube_textentry,Url2) then
    	      	    		
    	    			 print("message")

    	    			 sendMessage("SEND")	

    	    			 return false

    	    	    else

    	    	    	print ( "error message")

    	    	    	validation = false

    	    	    	SetError("* "..Message.YoutubeUrlError,feed_url)

    	    	    	return false

    	    	    end

    	    	 else

    	    	 	print("success loop")

    	    	 	 sendMessage("SEND")

    	    end

	
 		elseif url_dropdown.text == "Vimeo" then

    	    	local youtube_textentry = feed_url.text

    	    	if youtube_textentry ~= nil and youtube_textentry ~= "" then

    	    		print("viemo selection  ; "..youtube_textentry)

    	    		local Url = "http://vimeo.com/"
    	    		local Url1 = "https://vimeo.com/"

    	    		if string.find(youtube_textentry,Url) or string.find(youtube_textentry,Url1) then
    	      	    		
    	    			 print("message")

    	    			 sendMessage("SEND")	

    	    			 return false

    	    	    else

    	    	    	print ( "error message")

    	    	    	validation = false

    	    	    	SetError("* "..Message.VimeoUrlError,feed_url)

    	    	    	return false

    	    	    end

    	    	 else

    	    	 	print("success loop")

    	    	 	 sendMessage("SEND")

    	    end

    	elseif url_dropdown.text == "Facebook" then

    	    	local facebook_textentry = feed_url.text

    	    	if facebook_textentry ~= nil and facebook_textentry ~= "" then

    	    		print("facebook selection  ; "..facebook_textentry)

    	    		local Url = "http://www.facebook.com/video"
    	    		local Url1 = "https://www.facebook.com/video"
    	    		local Url2 = "http://www.facebook.com/photo"
    	    		local Url3 = "https://www.facebook.com/photo"

    	    		if string.find(facebook_textentry,Url) or string.find(facebook_textentry,Url1)

    	    		or string.find(facebook_textentry,Url2) or string.find(facebook_textentry,Url3) then
    	      	    		
    	    			 print("message")

    	    			 sendMessage("SEND")	

    	    			 return false

    	    	    else

    	    	    	print ( "error message")

    	    	    	validation = false

    	    	    	SetError("* "..Message.FacebookUrlError,feed_url)

    	    	    	return false

    	    	    end

    	    	 else

    	    	 	print("success loop")

    	    	 	 sendMessage("SEND")

    	    end

    	    elseif url_dropdown.text == "Yahoo" then

    	    	local yahoo_textentry = feed_url.text

    	    	if yahoo_textentry ~= nil and yahoo_textentry ~= "" then

    	    		print("yahoo selection  ; "..yahoo_textentry)

    	    		local Url = "http://video.yahoo.com/watch?"
    	    		local Url1 = "http://comedy.video.yahoo.com"
    	    		local Url2 = "http://animalvideos.yahoo.com"
    	    		local Url3 = "http://video.yahoo.com/watchmojo"
    	    		local Url4 = "http://video.yahoo.com/momentsofmotherhood" 
    	    		local Url5 = "http://video.yahoo.com/tlc"
    	    		local Url6 = "https://video.yahoo.com/watch?"
    	    		local Url7 = "https://comedy.video.yahoo.com"
    	    		local Url8 = "https://animalvideos.yahoo.com"
    	    		local Url9 = "https://video.yahoo.com/watchmojo"
    	    		local Url10 = "https://video.yahoo.com/momentsofmotherhood"
    	    		local Url11 = "https://video.yahoo.com/tlc"
    	    		local Url12 = "https://news.yahoo.com/video"


    	    		if string.find(yahoo_textentry,Url) or string.find(yahoo_textentry,Url1) or string.find(yahoo_textentry,Url2)

    	    		or string.find(yahoo_textentry,Url3) or string.find(yahoo_textentry,Url4) or string.find(yahoo_textentry,Url5) or string.find(yahoo_textentry,Url6) 

    	    		or string.find(yahoo_textentry,Url7) or string.find(yahoo_textentry,Url8) or string.find(yahoo_textentry,Url9) 

    	    		or string.find(yahoo_textentry,Url10) or string.find(yahoo_textentry,Url11) or string.find(yahoo_textentry,Url12) then
    	      	    		
    	    			 print("message")

    	    			 sendMessage("SEND")	

    	    			 return false

    	    	    else

    	    	    	print ( "error message")

    	    	    	validation = false

    	    	    	SetError("* "..Message.YahooUrlError,feed_url)

    	    	    	return false

    	    	    end

    	    	 else

    	    	 	print("success loop")

    	    	 	 sendMessage("SEND")

    	    end

		 end

    	end

    end



	function onCancelButtonTouch(event)

	    local phase = event.phase

		if phase=="began" then

			display.getCurrentStage():setFocus( event.target )

			--native.setKeyboardFocus(nil)

		elseif phase=="ended" then

			display.getCurrentStage():setFocus( nil )

			feed_url.text = ""

		end

	end



	function ImageClose(event)

	    local phase = event.phase

		if phase=="began" then

			display.getCurrentStage():setFocus( event.target )

			--native.setKeyboardFocus(nil)

		elseif phase=="ended" then

			display.getCurrentStage():setFocus( nil )

			image_name_png.text = ""

			upload_button.isVisible = true

			image_content_bg.isVisible = true

			image_name_close.isVisible = false

			upload_text.isVisible = true

			print("imagepath..........................",Imagepath)

			os.remove( Imagepath )

            print("imagepath removal..........................",os.remove( Imagepath ))

		end

	end



	local pushTest = function( event )

	    if notificationFlag == false then

	    	--feed_url.isVisible=true

	    	feed_url_bg.isVisible = true

	    	Message_content_bg.isVisible = false

	    	Message_content.isVisible = true
		
	    elseif notificationFlag == true then

	    	feed_url.isVisible=false

	    	feed_url_bg.isVisible = true

	    	Message_content.isVisible = false

	    	Message_content_bg.isVisible = true
		
	    end
	end


local function onTimer ( event )

	print( "event time completion" )

	BackFlag = false

end


local function onKeyEvent( event )

        local phase = event.phase
        local keyName = event.keyName

        if phase == "up" then

        if keyName=="back" then

        	if BackFlag == false then

        		Utils.SnackBar("Press again to exit")

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

	title = display.newText(sceneGroup,Message.PageTitle,0,0,native.systemFont,18)
	title.anchorX = 0
	title.x=5;title.y = title_bg.y
	title:setFillColor(0)

	--------------textbox for message--------------

	Message_content_bg = display.newRect( sceneGroup, 0,0 , W-19, EditBoxStyle.height+70)
  	Message_content_bg:setStrokeColor(0,0,0,0.4)
  	Message_content_bg.x = title_bg.x-title_bg.contentWidth/2+160
  	Message_content_bg.y =title_bg.y+ title_bg.contentHeight/2+55
  	Message_content_bg.hasBackground = true
	Message_content_bg.strokeWidth = 1


	Message_content = native.newTextBox( 0, 0, W-20, EditBoxStyle.height+70)
	Message_content.placeholder = Message.Message_placeholder 
	Message_content.isEditable = true
	Message_content.size=14
	Message_content.value=""
	Message_content.id = "messagecontent"
	Message_content.hasBackground = true
	Message_content:setReturnKey( "done" )
	Message_content.inputType = "default"
	sceneGroup:insert(Message_content)
	Message_content.x=title_bg.x-title_bg.contentWidth/2+160;Message_content.y=title_bg.y+ title_bg.contentHeight/2+55



	-----------------upload button------------------

	image_content_bg = display.newRect( sceneGroup, 0,0 , W-19, EditBoxStyle.height+15)
  	image_content_bg:setStrokeColor(0,0,0,0.4)
  	image_content_bg.x = Message_content_bg.x
  	image_content_bg.y = Message_content_bg.y + Message_content.contentHeight/2 + 30
  	image_content_bg.hasBackground = true
	image_content_bg.strokeWidth = 1

	upload_button = display.newRect(sceneGroup,0,0,W,25)
	upload_button.x=image_content_bg.x-image_content_bg.contentWidth/2 + 65
	upload_button.y = image_content_bg.y
	upload_button.width = W-210
	upload_button:setFillColor( Utils.convertHexToRGB(color.darkgreen) )
	upload_button.id="upload"

	upload_button_text = display.newText(sceneGroup,Message.UploadButtonText,0,0,native.systemFont,16)
	upload_button_text.x=upload_button.x + 10
	upload_button_text.y=upload_button.y
	Utils.CssforTextView(upload_button_text,sp_primarybutton)

	upload_icon = display.newImageRect("res/assert/upload.png",18,17)
	upload_icon.id = "image upload"
	sceneGroup:insert(upload_icon)
	upload_icon.x= upload_button_text.x - 50
	upload_icon.y=upload_button.y

	upload_text = display.newText(Message.UploadImageText,image_content_bg.x-image_content_bg.contentWidth/2+ 140,image_content_bg.y,native.systemFont,13)
	upload_text.value = "uploadtext"
	upload_text.id="uploadtext"
	--upload_text.alpha=0.8
	upload_text:setFillColor( Utils.convertHexToRGB(sp_commonLabel.textColor))
	upload_text.y=image_content_bg.y
	upload_text.anchorX=0
	upload_text.isVisible = true
	sceneGroup:insert(upload_text)


	--------------image name & image name cancel-------------------------

	image_name_png = display.newText(sceneGroup,"",Message_content_bg.x,Message_content_bg.y + Message_content.contentHeight/2 + 30,native.systemFont,14)
	image_name_png.text = ""
	image_name_png.value = "imagenamepng"
	image_name_png.id="imagenamepng"
	image_name_png:setFillColor( Utils.convertHexToRGB(color.tabBarColor))
	image_name_png.x = Message_content_bg.x - 100
	image_name_png.y=Message_content_bg.y + Message_content.contentHeight/2 +30
	image_name_png.isVisible = false
	--image_name_png.anchorX=0

	image_name_close = display.newImageRect("res/assert/icon-close.png",20,20)
	image_name_close.id = "image close"
	image_name_close.anchorX=0
	sceneGroup:insert(image_name_close)
	image_name_close.x= Message_content_bg.x + 125
	image_name_close.isVisible = false
	image_name_close.y=Message_content_bg.y + Message_content.contentHeight/2 +30


    --------------url dropdown for selection-------

	url_dropdown_bg = display.newRect(sceneGroup,W/2, image_content_bg.y+30, W-20, EditBoxStyle.height+10)
	url_dropdown_bg.id="eventname"
	url_dropdown_bg.x = W/2
	url_dropdown_bg.anchorY=0
	url_dropdown_bg:setStrokeColor(0,0,0,0.4)
	url_dropdown_bg.strokeWidth = 1
	url_dropdown_bg.hasBackground = false
	--sceneGroup:insert(url_dropdown_bg)


    -------------dropdown contents---------------

	url_dropdown = display.newText(sceneGroup,"",url_dropdown_bg.x-url_dropdown_bg.contentWidth/2+10,url_dropdown_bg.y,native.systemFont,14)
	url_dropdown.text = "YouTube"
	url_dropdown.value = "optionname"
	url_dropdown.id="optionname"
	url_dropdown.alpha=0.8
	url_dropdown:setFillColor( Utils.convertHexToRGB(sp_commonLabel.textColor))
	url_dropdown.y=url_dropdown_bg.y+url_dropdown_bg.contentHeight/2
	url_dropdown.anchorX=0
	--sceneGroup:insert(url_dropdown)


	url_dropdown_icon = display.newImageRect(sceneGroup,"res/assert/arrow2.png",14,9 )
	url_dropdown_icon.x=url_dropdown_bg.x+url_dropdown_bg.contentWidth/2-15
	url_dropdown_icon.y=url_dropdown.y


	----------url textfield-------------------

	url_textcontent = display.newText(sceneGroup,Message.UrlHelpText, 0, 0, native.systemFontBold, 10.5)
	url_textcontent.x = display.contentCenterX
	url_textcontent.y = url_dropdown_bg.y + url_dropdown_bg.contentHeight+15
	url_textcontent:setFillColor( 0, 0, 0 )


	feed_url = native.newTextField(0, 0, W-60 , EditBoxStyle.height+10)
	feed_url.id = "video url"
	feed_url.anchorX=0
	feed_url.size=14
	feed_url.value=""
	feed_url.hasBackground = true
	feed_url.inputType = "url"
	feed_url.isVisible = true
	sceneGroup:insert(feed_url)
	feed_url.x=title_bg.x-title_bg.contentWidth/2+10
	feed_url.y=url_textcontent.y+ url_textcontent.contentHeight/2+25

	feed_url_bg = display.newRect( sceneGroup, W/2, feed_url.y, W-60, EditBoxStyle.height+10)
  	feed_url_bg:setStrokeColor(0,0,0,0.2)
  	feed_url_bg.x = display.contentWidth/2- 20
  	feed_url_bg.hasBackground = true
	feed_url_bg.strokeWidth = 1


	----------cancel button------------------

	feed_cancelbutton = display.newImageRect("res/assert/button_cancel_22.png",20,20)
	feed_cancelbutton.id = "url cancel"
	feed_cancelbutton.anchorX=0
	feed_cancelbutton:setFillColor(0,0,0,0.7)
	sceneGroup:insert(feed_cancelbutton)
	feed_cancelbutton.x= feed_url.width+25
	feed_cancelbutton.y=url_textcontent.y+ url_textcontent.contentHeight/2+25

	------------example text for url---------

	urlhelp_text = display.newText(sceneGroup,"Eg.https://www.youtube.com/watch?v=qOmDoZCuFtM", 0, 0,native.systemFontBold, 11)
	urlhelp_text.x = display.contentCenterX
	urlhelp_text.width = W
	urlhelp_text.align = "center"
	urlhelp_text.y = feed_url.y-feed_url.contentHeight/2+ 45 
	urlhelp_text:setFillColor( 0, 0, 0 )


	--------send button----------------------

	send_button = display.newRect(sceneGroup,0,0,W-60,30)
	send_button.x=Message_content.x
	send_button.y = Message_content.y+280
	send_button.width = W-190
	send_button:setFillColor( Utils.convertHexToRGB(color.darkgreen) )
	send_button.id="send"

	send_button_text = display.newText(sceneGroup,Message.SendButton,0,0,native.systemFont,16)
	send_button_text.x=send_button.x
	send_button_text.y=send_button.y
	Utils.CssforTextView(send_button_text,sp_primarybutton)

    MainGroup:insert(sceneGroup)

end




	function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then

  		EventnameTop_bg = display.newRect( VideoUrlGroup, url_dropdown_bg.x , H/2+91.5, url_dropdown_bg.contentWidth, 125)
  		EventnameTop_bg:setFillColor(0,0,0)


  	    VideoTypeList = widget.newTableView
  		{
  		left = 0,
  		top = -50,
  		height = 97,
  		width = url_dropdown_bg.contentWidth-2,
  		onRowRender = VideoType_Render,
  		onRowTouch = VideoType_Touch,
  		noLines=true,
  		hideScrollBar=true,
  		isBounceEnabled=false,

  	}

		VideoTypeList.x=url_dropdown_bg.x
		VideoTypeList.y= image_content_bg.y+image_content_bg.contentHeight+25
	--	VideoTypeList.y=EventnameTop.y+EventnameTop.height/2
		VideoTypeList.height = 150
		VideoTypeList.width = url_dropdown_bg.contentWidth-2
		VideoTypeList.anchorY=0
		VideoUrlGroup.isVisible=false

		VideoUrlGroup:insert(VideoTypeList)

		sceneGroup:insert(VideoUrlGroup)
		

---------------

		for i = 1, #VideoTypeArray do

		    VideoTypeList:insertRow{ rowHeight = 30,

		    -- rowColor = 
		    -- { 
		    -- default={ 1,1,1}, over={ 0, 0, 0, 0.1 } }
		     }
		end


	elseif phase == "did" then

		composer.removeHidden()

	send_button:addEventListener("touch",onSendButtonTouch)	
	upload_button:addEventListener("touch",onImageButtonTouch)
	feed_cancelbutton:addEventListener("touch",onCancelButtonTouch)
	Message_content:addEventListener( "userInput", MessageLimitation )
	--url_dropdown_bg:addEventListener("touch",urlSelection)
	feed_url:addEventListener("userInput",textfield)
	url_dropdown_bg:addEventListener("touch",onTouchAction)
	menuBtn:addEventListener("touch",menuTouch)
    BgText:addEventListener("touch",menuTouch)
    Runtime:addEventListener( "enterFrame", pushTest )
    Background:addEventListener("touch",FocusComplete)
    image_name_close:addEventListener( "touch", ImageClose )

    Runtime:addEventListener( "key", onKeyEvent )

	end	

	MainGroup:insert(sceneGroup)

	end




	function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if event.phase == "will" then

	Runtime:removeEventListener( "enterFrame", pushTest )
	upload_button:removeEventListener("touch",onImageButtonTouch)
	feed_cancelbutton:removeEventListener("touch",onCancelButtonTouch)
	url_dropdown_bg:removeEventListener("touch",onTouchAction)
	menuBtn:removeEventListener("touch",menuTouch)
	BgText:removeEventListener("touch",menuTouch)
	Message_content:removeEventListener( "userInput", MessageLimitation )
	--url_dropdown_bg:removeEventListener("touch",urlSelection)
	feed_url:removeEventListener("userInput",textfield)
	send_button:removeEventListener("touch",onSendButtonTouch)	
	Background:removeEventListener("touch",FocusComplete)
	image_name_close:removeEventListener( "touch", ImageClose )

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







		-- Message_content =  native.newTextField(0, 0, W-20 , EditBoxStyle.height+70)
		-- Message_content.id = "message content"
		-- Message_content.placeholder = Message.Message_placeholder 
		-- Message_content.anchorX=0
		-- Message_content.size=14
		-- Message_content.value=""
		-- Message_content.hasBackground = false
		-- Message_content.inputType = "default"
		-- sceneGroup:insert(Message_content)
		-- Message_content.x=title_bg.x-title_bg.contentWidth/2+10;Message_content.y=title_bg.y+ title_bg.contentHeight/2+55




	-- url_dropdown =  native.newTextField(0, 0, W-20 , EditBoxStyle.height+10)
	-- url_dropdown.id = "video url options"
	-- url_dropdown.anchorX=0
	-- url_dropdown.size=14
	-- url_dropdown.width = W-45
	-- url_dropdown.height = EditBoxStyle.height+10
	-- url_dropdown.isVisible = true
	-- url_dropdown.value=""
	-- url_dropdown.hasBackground = true
	-- url_dropdown.inputType = "url"
	-- sceneGroup:insert(url_dropdown)
	-- url_dropdown.x=title_bg.x-title_bg.contentWidth/2+10;url_dropdown.y=Message_content.y+ Message_content.contentHeight/2+30


 --    -------------dropdown contents---------------

 --    url_options = display.newImage(sceneGroup,"res/assert/arrow2.png", 0, 0, 15,15 )
 --    url_options.x = url_dropdown.width + 20
 --    url_options.y = url_dropdown.y



  		-- EventnameTop = display.newRect(VideoUrlGroup,W/2,H/2-160,200,30)
  		-- EventnameTop:setFillColor(Utils.convertHexToRGB(color.tabBarColor))
  		-- EventnameTop.y=EventnameTop_bg.y-EventnameTop_bg.contentHeight/2+EventnameTop.contentHeight/2

  		-- EventnameText = display.newText(VideoUrlGroup,"Select Video Type",0,0,native.systemFont,16)
  		-- EventnameText.x=EventnameTop.x;EventnameText.y=EventnameTop.y

  		-- EventnameClose = display.newImageRect(VideoUrlGroup,"res/assert/cancel.png",20,20)
  		-- EventnameClose.x=EventnameTop.x+EventnameTop.contentWidth/2-15;EventnameClose.y=EventnameTop.y
  		-- EventnameClose.id="close"

  		-- EventnameClose_bg = display.newRect(VideoUrlGroup,0,0,30,30)
  		-- EventnameClose_bg.x=EventnameTop.x+EventnameTop.contentWidth/2-15
  		-- EventnameClose_bg.y=EventnameTop.y
  		-- EventnameClose_bg.id="close_videotype"
  		-- EventnameClose_bg.alpha=0.01



        	-- print( "target: ", event.target._properties)

        	-- -- local bytearray = json.encode(photo)

        	-- -- print("bytearray ",bytearray)

         --   file_inbytearray = mime.b64(tostring(photo))

         --    --photoencode = json.encode(photo)

         --    print(file_inbytearray)

         --    --file_inbytearray = mime.b64(tostring(photoencode))

        	-- -- length1 = string.len("L1VzZXJzL3NhbmplZXZ0L0xpYnJhcnkvQXBwbGljYXRpb24gU3VwcG9ydC9Db3JvbmEgU2ltdWxhdG9yL015VW5pdEFwcC5Db3JvbmEtMjBFRUE4NURFRjFCRkUyOUZDRTI4QzM4OEQ4RTVEREQvRG9jdW1lbnRzL3Bob3RvLmpwZw==")

         --    --    print(length1)



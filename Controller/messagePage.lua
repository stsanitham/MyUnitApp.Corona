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

local image_send_button,send_icon,cancel_button,cancel_icon,cancel_icon_text

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

local status = ""

local PHOTO_FUNCTION = media.PhotoLibrary 	


local url 
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

           feed_url_bg.isVisible = true

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

        feed_url_bg.isVisible = true

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



local function bgTouch( event )

	if event.phase == "began" then
       display.getCurrentStage():setFocus( event.target )

       elseif event.phase == "ended" then
       display.getCurrentStage():setFocus( nil )

   end

   return true

end




function OnSendAndCancelTouch(event)

local phase = event.phase

if phase=="began" then

  display.getCurrentStage():setFocus( event.target )

  
  elseif phase=="ended" then

  print( "here coming" )

  if event.target.id == "cancel" then

    status = "cancel"

    composer.hideOverlay( )

    elseif event.target.id == "send" then

    local validation = false

    native.setKeyboardFocus(nil)

    display.getCurrentStage():setFocus( nil )


    if url_dropdown.text == "YouTube" then

      local youtube_textentry = feed_url.text

      print("youtube_textentry : "..youtube_textentry)

      if youtube_textentry ~= nil or youtube_textentry ~= "" then

         print("youtube selection  ; "..youtube_textentry)

         local Url = "http://www.youtube.com/watch?"
         local Url1 = "https://www.youtube.com/watch?"
         local Url2 = "https://youtu.be/"

         if string.find(youtube_textentry,Url) or string.find(youtube_textentry,Url1) or string.find(youtube_textentry,Url2) then
          
           print("message")
           status = "send"

           url = youtube_textentry

           composer.hideOverlay()

       else

         print ( "error message")

         validation = false

         SetError("*"..Message.YoutubeUrlError,feed_url)

         return false

     end

 else

    print("success loop")

    

end


elseif url_dropdown.text == "Vimeo" then

  local youtube_textentry = feed_url.text

  if youtube_textentry ~= nil or youtube_textentry ~= "" then

     print("viemo selection  ; "..youtube_textentry)

     local Url = "http://vimeo.com/"
     local Url1 = "https://vimeo.com/"

       if string.find(youtube_textentry,Url) or string.find(youtube_textentry,Url1) then
        
         print("message")

         status = "send"

         url = youtube_textentry

         composer.hideOverlay()

     else

       print ( "error message")

       validation = false

       SetError("*"..Message.VimeoUrlError,feed_url)

       return false

   end

else

    print("success loop")

                	    	 	-- sendMessage("SEND")

                               
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

                	    			 --sendMessage("SEND")	

                                   status = "send"

                                   url = youtube_textentry

                                   composer.hideOverlay()
                                   
                               else

                                 print ( "error message")

                                 validation = false

                                 SetError("*"..Message.FacebookUrlError,feed_url)

                                 return false

                             end

                         else

                            print("success loop")

                	    	 	 --sendMessage("SEND")

                	    	 	 
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
                                     
                                     status = "send"

                                     url = youtube_textentry

                                     composer.hideOverlay()

                                 else

                                     print ( "error message")

                                     validation = false

                                     SetError("*"..Message.YahooUrlError,feed_url)

                                     return false

                                 end

                             else

                                print("success loop")

                	    	 	-- sendMessage("SEND")
                	    	 	
                            end

                            
                        end
                    end

                end
                return true
            end


            local function onCancelButtonTouch( event )
                if event.phase == "began" then
                    display.getCurrentStage():setFocus( event.target )
                    print( "23312" )
                    elseif event.phase == "ended" then
                    display.getCurrentStage():setFocus( nil )
                    print( "sdfsdf sdfds" )
                    feed_url.text = ""
                end

                return true

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



    function scene:create( event )

       local sceneGroup = self.view

       Background = display.newImageRect(sceneGroup,"res/assert/background.jpg",W,H)
       Background.x=W/2;Background.y=H/2
       Background.alpha = 0.5

       

    --------------url dropdown for selection-------


    video_outer_bg = display.newRect( sceneGroup, 0,0 , W-19, EditBoxStyle.height+195)
    video_outer_bg:setStrokeColor(Utils.convertHexToRGB(color.primaryColor))
  	--video_outer_bg:setFillColor(0,0,0,0.2)
  	video_outer_bg.x = W/2
  	video_outer_bg.y = H/2
  	video_outer_bg.hasBackground = true
   video_outer_bg.strokeWidth = 1

   url_dropdown_bg = display.newRect(sceneGroup,W/2, video_outer_bg.y, W-37, EditBoxStyle.height)
   url_dropdown_bg.id="eventname"
   url_dropdown_bg.x = W/2
   url_dropdown_bg.y = video_outer_bg.y- video_outer_bg.contentHeight/2 + 50
   url_dropdown_bg.anchorY=0
   url_dropdown_bg:setStrokeColor(0,0,0,0.2)
   url_dropdown_bg.strokeWidth = 1
   url_dropdown_bg.hasBackground = false
	--sceneGroup:insert(url_dropdown_bg)


    local titleBg = display.newRect(sceneGroup,0,0,video_outer_bg.contentWidth,35)
    titleBg.x = video_outer_bg.x;titleBg.y = video_outer_bg.y-video_outer_bg.contentHeight/2+titleBg.contentHeight/2
    titleBg:setFillColor( Utils.convertHexToRGB(color.primaryColor) )

    local titleBg_text = display.newText(sceneGroup,"Video",0,0,native.systemFont,14)
    titleBg_text.x = titleBg.x-titleBg.contentWidth/2+5;titleBg_text.y = titleBg.y
    titleBg_text.anchorX = 0
    titleBg_text:setTextColor(1)


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

	url_textcontent = display.newText(sceneGroup,Message.UrlHelpText, 0, 0,W-28,0, native.systemFont, 11)
	url_textcontent.x = url_dropdown_bg.x + 5
	url_textcontent.y = url_dropdown_bg.y + url_dropdown_bg.contentHeight+17
	url_textcontent:setFillColor( 0, 0, 0 ,0.8)

	feed_url = native.newTextField(0, 0, W-70 , EditBoxStyle.height)
	feed_url.id = "video url"
	--feed_url.anchorX=0
	feed_url.size=14
	feed_url.value=""
	feed_url.hasBackground = true
	feed_url.inputType = "url"
	feed_url.isVisible = true
	sceneGroup:insert(feed_url)
	feed_url.x=display.contentWidth/2- 15
	feed_url.y=url_textcontent.y+ url_textcontent.contentHeight/2+20

	feed_url_bg = display.newRect( sceneGroup, W/2+10, feed_url.y, W-70, EditBoxStyle.height)
 feed_url_bg:setStrokeColor(0,0,0,0.2)
 feed_url_bg.x = display.contentWidth/2- 15
 feed_url_bg.hasBackground = true
 feed_url_bg.strokeWidth = 1

 video_defaultimg_bg = display.newRect( sceneGroup, 0,0 , 30, EditBoxStyle.height+2)
 video_defaultimg_bg:setStrokeColor(0,0,0,0.15)
 video_defaultimg_bg:setFillColor(0,0,0,0.2)
 video_defaultimg_bg.x = feed_url_bg.x+feed_url_bg.contentWidth/2+15
 video_defaultimg_bg.y = feed_url_bg.y
 video_defaultimg_bg.hasBackground = true
	--video_defaultimg_bg.strokeWidth = 1

	video_defaultimage = display.newImageRect("res/assert/video.png",28,19)
	video_defaultimage.id = "video image"
	video_defaultimage.anchorX=0
	sceneGroup:insert(video_defaultimage)
	video_defaultimage.x= feed_url.width+22
	video_defaultimage.y=video_defaultimg_bg.y




		----------cancel button------------------

       feed_cancelbutton = display.newRect( sceneGroup, 0,0 , 60, EditBoxStyle.height-3)
       feed_cancelbutton:setStrokeColor(0,0,0,0.15)
       feed_cancelbutton:setFillColor(0,0,0,0.45)
       feed_cancelbutton.cornerRadius = 2
       feed_cancelbutton.x = feed_url_bg.x+feed_url_bg.contentWidth/2
       feed_cancelbutton.y =feed_url_bg.y+ feed_url_bg.contentHeight/2+feed_cancelbutton.contentHeight/2+5
       feed_cancelbutton.hasBackground = true
       feed_cancelbutton.strokeWidth = 1

       feed_cancelbutton_text = display.newText(sceneGroup,Message.Clear,0,0,native.systemFont,14)
       feed_cancelbutton_text.x=feed_cancelbutton.x
       feed_cancelbutton_text.y=feed_cancelbutton.y
       Utils.CssforTextView(feed_cancelbutton_text,sp_primarybutton)



------------------------------------- image send button -------------------------------------------   


image_send_button = display.newRect( sceneGroup, 0,0, video_outer_bg.contentWidth/2-1, 45 )
image_send_button.x=video_outer_bg.x-video_outer_bg.contentWidth/2+1;image_send_button.y=video_outer_bg.y+video_outer_bg.contentHeight/2-image_send_button.contentHeight-1
image_send_button.id="send"
image_send_button.anchorX=0;image_send_button.anchorY=0
image_send_button:setFillColor( Utils.convertHexToRGB(color.darkGreen) )

send_icon = display.newImageRect( sceneGroup, "res/assert/audiosend.png",25,20 )
send_icon.id = "send icon"
send_icon.x=image_send_button.x+20;send_icon.y=image_send_button.y+image_send_button.contentHeight/2

send_icon_text = display.newText( sceneGroup, MessagePage.Send, 0,0,native.systemFont,16 )
send_icon_text.x=send_icon.x+25;send_icon_text.y=send_icon.y
send_icon_text.id = "send_icon_text"
send_icon_text.anchorX=0


 ------------------------------------- image cancel button -------------------------------------------  

 cancel_button = display.newRect( sceneGroup, 0,0, video_outer_bg.contentWidth/2-1, 45 )
 cancel_button.x=image_send_button.x+image_send_button.contentWidth+1;cancel_button.y=video_outer_bg.y+video_outer_bg.contentHeight/2-image_send_button.contentHeight-1
 cancel_button.id="cancel"
 cancel_button.anchorX=0;cancel_button.anchorY=0
 cancel_button:setFillColor( Utils.convertHexToRGB(color.Lytred) )

 cancel_icon = display.newImageRect( sceneGroup, "res/assert/audiocancel.png",25,20 )
 cancel_icon.id = "cancel icon"
 cancel_icon.x=cancel_button.x+20;cancel_icon.y=cancel_button.y+cancel_button.contentHeight/2

 cancel_icon_text = display.newText( sceneGroup, CommonWords.cancel, 0,0,native.systemFont,16 )
 cancel_icon_text.x=cancel_icon.x+25;cancel_icon_text.y=cancel_icon.y
 cancel_icon_text.id = "cancel_icon_text"
 cancel_icon_text.anchorX=0

 image_send_button:addEventListener("touch",OnSendAndCancelTouch)
 cancel_button:addEventListener("touch",OnSendAndCancelTouch)

 MainGroup:insert(sceneGroup)

end




function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then

        EventnameTop_bg = display.newRect( VideoUrlGroup, url_dropdown_bg.x , url_dropdown_bg.y+url_dropdown_bg.contentHeight/2, url_dropdown_bg.contentWidth, 125)
        EventnameTop_bg.y = url_dropdown_bg.y+EventnameTop_bg.contentHeight/2+url_dropdown_bg.contentHeight
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
        VideoTypeList.y= EventnameTop_bg.y-EventnameTop_bg.contentHeight/2
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

 

	feed_cancelbutton:addEventListener("touch",onCancelButtonTouch)
	--url_dropdown_bg:addEventListener("touch",urlSelection)
	feed_url:addEventListener("userInput",textfield)
	url_dropdown_bg:addEventListener("touch",onTouchAction)
    Background:addEventListener("touch",bgTouch)
    image_name_close:addEventListener( "touch", ImageClose )

    Runtime:addEventListener( "key", onKeyEvent )

end	

MainGroup:insert(sceneGroup)

end




function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if event.phase == "will" then

       feed_cancelbutton:removeEventListener("touch",onCancelButtonTouch)
       url_dropdown_bg:removeEventListener("touch",onTouchAction)
	--url_dropdown_bg:removeEventListener("touch",urlSelection)
	feed_url:removeEventListener("userInput",textfield)
	Background:removeEventListener("touch",FocusComplete)

	Runtime:removeEventListener( "key", onKeyEvent )

elseif phase == "did" then

    if status == "cancel" then
        event.parent:resumeVideocall(status,"")
    else

        print( url )
        event.parent:resumeVideocall(status,url)

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
  		-- EventnameTop:setFillColor(Utils.convertHexToRGB(color.primaryColor))
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



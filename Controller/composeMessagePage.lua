----------------------------------------------------------------------------------
--
-- instagram Screen
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local Utility = require( "Utils.Utility" )
local widget = require( "widget" )
require( "Webservice.ServiceManager" )
local style = require("res.value.style")
local scheduledMessageGroup = require( "Controller.scheduledMessageGroup" )
local json = require("json")
local path = system.pathForFile( "MyUnitBuzz.db", system.DocumentsDirectory )
local db = sqlite3.open( path )
local timePicker = require( "Controller.timePicker" )
local datePicker = require( "Controller.datePicker" )

local ck_editor = require('Utils.messageCKeditor')


--------------- Initialization -------------------

local W = display.contentWidth;H= display.contentHeight

local Background,BgText

local menuBtn, test

local back_icon_bg, back_icon

local filename ,filename_title, filename_close

local Imagepath = "";Imagename = "";Imagesize = ""

openPage="pushNotificationListPage"

local RecentTab_Topvalue = 70

local sceneevent

local status

local Details={}

local Audiopath=""; Audioname=""; Audiosize=""

local openPagevalue = "addpage"

local PHOTO_FUNCTION = media.PhotoLibrary 

local pWidth = display.pixelWidth 

local pHeight = display.pixelHeight

fieldOffset = 0

local longmsg_textbox

local deviceModel = system.getInfo( "model" )

if isIos then

	if (deviceModel == "iPhone") then	

		 fieldOffset = 80

	end

end

local longMessage = ""

local defalutValue="corona:open"

fieldTrans = 200

local UserId,MemberName

for row in db:nrows("SELECT * FROM logindetails WHERE id=1") do
		UserId = row.UserId
		MemberName = row.MemberName

end

local targetaction = "compose"

--------------------------------------------------


-----------------Function-------------------------

local function closeDetails( event )
	if event.phase == "began" then
			display.getCurrentStage():setFocus( event.target )
	elseif event.phase == "ended" then
			display.getCurrentStage():setFocus( nil )

	end

return true

end







-- function scene:resumeCall(value)

-- 	print( "*********test*********" )

--     if value == "compose" then

-- 				local options = {
-- 					isModal = true,
-- 					effect = "slideLeft",
-- 					time = 100,
-- 			    }

-- 		composer.showOverlay( "Controller.composeMessagePage", options )

--     end

-- end






			 function uploadImage(  )

						    function get_imagemodel(response)

						    	print("get image model called : its response is here ~~~~~~~~~~~~~~~~")

									Imagepath = response.Abspath

									Imagename = response.FileName

									Imagesize = size


									filename_title.isVisible = true

									filename.isVisible = true

									filename_close.isVisible = true

									filename.text = photoname

									schedule_button.y = filename.y + filename.contentHeight +15
									schedule_icon.y= schedule_button.y+schedule_button.contentHeight/2-schedule_icon.contentHeight/2
									schedule_icon_text.y= schedule_icon.y
									schedule_button.height=schedule_icon_text.contentHeight+10

									send_button.y = filename.y + filename.contentHeight +15
									send_icon.y= send_button.y+send_button.contentHeight/2-send_icon.contentHeight/2
									send_icon_text.y= send_icon.y
									send_button.height=send_icon_text.contentHeight+10

									draft_button.y = filename.y + filename.contentHeight +15
									draft_icon.y= draft_button.y+draft_button.contentHeight/2-draft_icon.contentHeight/2
									draft_icon_text.y= draft_icon.y
									draft_button.height=draft_icon_text.contentHeight+10


										    function ImageClose(event)

														filename.text = ""

														filename.isVisible = false

														filename_title.isVisible = false

														filename_close.isVisible = false

														Imagepath = ""

														os.remove( path )

														schedule_button.y = icons_holder_bg.y + icons_holder_bg.contentHeight +15
														schedule_icon.y= schedule_button.y+schedule_button.contentHeight/2-schedule_icon.contentHeight/2
														schedule_icon_text.y= schedule_icon.y

														schedule_button.height=schedule_icon_text.contentHeight+10

														send_button.y = icons_holder_bg.y + icons_holder_bg.contentHeight +15
														send_icon.y= send_button.y+send_button.contentHeight/2-send_icon.contentHeight/2
														send_icon_text.y= send_icon.y

														send_button.height=send_icon_text.contentHeight+10

														draft_button.y = icons_holder_bg.y + icons_holder_bg.contentHeight +15
														draft_icon.y= draft_button.y+draft_button.contentHeight/2-draft_icon.contentHeight/2
														draft_icon_text.y= draft_icon.y

														draft_button.height=draft_icon_text.contentHeight+10

											end


				                    filename_close:addEventListener("touch",ImageClose)

							 end


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


		photowidth1 = photo.width

		photoheight1 = photo.height

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


	    local function onTimer(event)

			uploadImage()

	    end

       timer.performWithDelay(1500, onTimer )

     end

end






	function get_audiomodel1(response)

		print("\n\n\n SuccessMessage : Audio Response : \n\n ", json.encode(response))

		audiolist_values = response

		local options = {

				effect = "slideRight",
				time = 300,
				params = { audiovalues = audiolist_values }
	    }

		composer.gotoScene("Controller.pushNotificationListPage",options)


	end





	function get_messagemodel(response)

		print("\n\n\n SuccessMessage : Response : \n\n ", json.encode(response))

		list_values = response

		if list_values.MessageStatus == "SEND" then

		        Utils.SnackBar(MessagePage.SentSuccess)

				      		 	shortmsg_textbox.text = ""

								shortmsg_textbox.placeholder = MessagePage.ShortMessage_Placeholder		

								longMessage = ""

								longmsg_textbox.placeholder = MessagePage.LongMessage_Placeholder

								short_msg_charlimit.text = MessagePage.ShortMsgLimit

								long_msg_charlimit.text = MessagePage.LongMsgLimit

					local function onTimer ( event )


	                            if openPagevalue == "addpage" then


	                            	photowidth = photowidth1

									photoheight = photoheight1

									
									if targetaction == "compose" then

									sceneevent.parent:resumeCall(list_values)

									spinner.y=H/2-75

									composer.hideOverlay()
									
									end

								--	scrollTo(0)

								elseif openPagevalue ~= "addpage" then

									photowidth = photowidth1

									photoheight = photoheight1

											  local options =
												{
												effect = "slideRight",

												time = 300,
												params = { editpagevalue = list_values, page_val = "editpage", Imagepathname = Imagepath, photowidth, photoheight}
					
												}
                           

									spinner.y=H/2-75

									composer.gotoScene("Controller.pushNotificationListPage",options)

								--	scrollTo(0)

								end


					end

        		timer.performWithDelay(1000, onTimer )

	    end




		if list_values.MessageStatus == "DRAFT" then

		      		 Utils.SnackBar(MessagePage.DraftSuccess)

				      		 	shortmsg_textbox.text = ""

								shortmsg_textbox.placeholder = MessagePage.ShortMessage_Placeholder		

								longMessage = ""

								longmsg_textbox.placeholder = MessagePage.LongMessage_Placeholder

								short_msg_charlimit.text = MessagePage.ShortMsgLimit

								long_msg_charlimit.text = MessagePage.LongMsgLimit

					local function onTimer ( event )

	                            if openPagevalue == "addpage" then

	                            	photowidth = photowidth1

									photoheight = photoheight1

									
									if targetaction == "compose" then

									sceneevent.parent:resumeCall(list_values)

									spinner.y=H/2-75

									composer.hideOverlay()

								   end

								--	scrollTo(0)

								elseif openPagevalue ~= "addpage" then

									  local options =
										{
										effect = "slideRight",

										time = 300,
										params = { editpagevalue = list_values, page_val = "editpage"}

										}

									spinner.y=H/2-75

									composer.gotoScene("Controller.pushNotificationListPage",options)

								--	scrollTo(0)

								end

					end

        		timer.performWithDelay(1000, onTimer )

	    end




	    if list_values.MessageStatus == "SCHEDULE" then

		      		 Utils.SnackBar(MessagePage.ScheduledSuccess)

				      		 	shortmsg_textbox.text = ""

								shortmsg_textbox.placeholder = MessagePage.ShortMessage_Placeholder		

								longMessage = ""

								longmsg_textbox.isVisible = false

								longmsg_textbox.placeholder = MessagePage.LongMessage_Placeholder

								short_msg_charlimit.text = MessagePage.ShortMsgLimit

								long_msg_charlimit.text = MessagePage.LongMsgLimit

					local function onTimer ( event )
						

	                            if openPagevalue == "addpage" then

	                            	photowidth = photowidth1

									photoheight = photoheight1


									if targetaction == "compose" then

									sceneevent.parent:resumeCall(list_values)

									spinner.y=H/2-75

									composer.hideOverlay()

									end

								--	scrollTo(0)

								elseif openPagevalue ~= "addpage" then

									 local options =
										{

										time = 300,
										params = { editpagevalue = list_values, page_val = "editpage"}

										}


									spinner.y=H/2-75

									composer.gotoScene("Controller.pushNotificationListPage",options)

								--	scrollTo(0)

								end


					end

        		     timer.performWithDelay(1000, onTimer )

	    end

	end







    local function sendMessage ( method )

		    if shortmsg_textbox.text == nil  then

		    	shortmsg_textbox.text = ""

		    end


		    if longMessage == nil  then

		    	longMessage = ""

		    end


	    if method == "SCHEDULE" then

	        	ScheduledMessageGroup.isVisible = true

	        	longmsg_textbox.isVisible = false
    	 		shortmsg_textbox.isVisible = false


	function onTimePickerTouch(event)

	    	local function getValue(time)

				Time.text = time

			end


	    	local function getDateValue(time)

				Date.text = time

			end


		if event.target.id == "time" then

			timePicker.getTimeValue(getValue)

		elseif event.target.id == "date" then

			datePicker.getTimeValue(getDateValue)

		end  

    end








    function onScheduleButtonTouch( event )

			if event.phase == "began" then


			elseif event.phase == "ended" then

				native.setKeyboardFocus(nil)

				if event.target.id == "set-time" then

					print("accept icon pressed")

						if Date.text ~= "Date" and Time.text ~= "Time" then

						IsScheduled = tostring(true)


					    if (shortmsg_textbox.text ~= "") and (Imagepath == nil or Imagepath == null or Imagepath == "" or Imagepath == " ") and (Audiopath == nil or Audiopath == null or Audiopath == "" or Audiopath == " ") then
			                
			                 Webservice.SEND_MESSAGE(shortmsg_textbox.text,longMessage,IsScheduled,Date.text,Time.text,"","","","","","","",method,"","","",get_messagemodel)

					    end


			        	if (shortmsg_textbox.text ~= "") and (Imagepath ~= nil and Imagepath ~= null and Imagepath ~= "" and Imagepath ~= " ") then

			        		print("image path send value")

			        	   Webservice.SEND_MESSAGE(shortmsg_textbox.text,longMessage,IsScheduled,Date.text,Time.text,"",Imagepath,Imagename,Imagesize,"","","",method,"","","",get_messagemodel)

			            end




			            if (shortmsg_textbox.text ~= "") and (Audiopath ~= nil and Audiopath ~= null and Audiopath ~= "" and Audiopath ~= " ") then

			            	print("audio path send value")

			            	 Webservice.SEND_MESSAGE(shortmsg_textbox.text,longMessage,IsScheduled,Date.text,Time.text,"","","","",Audiopath,Audioname,Audiosize,method,"","","",get_audiomodel1)

			            end


						ScheduledMessageGroup.isVisible = false

									local function onTimer(event)

									longmsg_textbox.isVisible = true
			    	                shortmsg_textbox.isVisible = true

			    	                end

    	                timer.performWithDelay(500,onTimer)

						end

				elseif event.target.id == "closealert" then

			 			print("close alert")

			 			if datePicker then datePicker.clear() end

						if timePicker then timePicker.clear() end

						ScheduledMessageGroup.isVisible = false

					     		    local function onTimer(event)

									longmsg_textbox.isVisible = true
			    	                shortmsg_textbox.isVisible = true

			    	                end

    	                timer.performWithDelay(500,onTimer)
				end

		    end

	    end

	        Time_bg:addEventListener("touch",onTimePickerTouch)
	        TimeSelect_icon:addEventListener("touch",onTimePickerTouch)
	        Time:addEventListener("touch",onTimePickerTouch)

	        Date_bg:addEventListener("touch",onTimePickerTouch)
	        Date:addEventListener("touch",onTimePickerTouch)
	        DateSelect_icon:addEventListener("touch",onTimePickerTouch)

	 		acceptschedule_button:addEventListener("touch",onScheduleButtonTouch) 	
	        Alertclose_icon:addEventListener("touch",onScheduleButtonTouch)

        else



		    if (shortmsg_textbox.text ~= "") and (Imagepath == nil or Imagepath == null or Imagepath == "" or Imagepath == " ") and (Audiopath == nil or Audiopath == null or Audiopath == "" or Audiopath == " ") then
                
                 Webservice.SEND_MESSAGE(shortmsg_textbox.text,longMessage,"","","","","","","","","","",method,"","","",get_messagemodel)

		    end



        	if (shortmsg_textbox.text ~= "") and (Imagepath ~= nil and Imagepath ~= null and Imagepath ~= "" and Imagepath ~= " ") then

        		print("image path send value")

        	   Webservice.SEND_MESSAGE(shortmsg_textbox.text,longMessage,"","","","",Imagepath,Imagename,Imagesize,"","","",method,"","","",get_messagemodel)

            end




            if (shortmsg_textbox.text ~= "") and (Audiopath ~= nil and Audiopath ~= null and Audiopath ~= "" and Audiopath ~= " ") then

            	print("audio path send value")

            	 Webservice.SEND_MESSAGE(shortmsg_textbox.text,longMessage,"","","","","","","",Audiopath,Audioname,Audiosize,method,"","","",get_audiomodel1)

            end



        end

    end



 

	local function SetError( displaystring, object )

		object.text=displaystring
		object.size=11
		object:setTextColor(1,0,0)

	end




 	 function onSendButtonTouchAction(event)

    	local phase = event.phase

    	if phase=="began" then

    		display.getCurrentStage():setFocus( event.target )

    	elseif phase=="ended" then

    	    local validation = false

    	    defalutValue = "corona:close"

  	    	native.setKeyboardFocus(nil)

    	    display.getCurrentStage():setFocus( nil )

    	    local function senTimerFun( time_event )

	    	    status="normal"

	    	    print( "Length = "..longMessage:len() )

				if (shortmsg_textbox.text == "" or shortmsg_textbox.text == nil) or (longMessage:len() < 62  or longMessage == nil) then

					    if event.target.id == "send" or event.target.id == "send icon" or event.target.id == "send_icon_text" then 

							local alert = native.showAlert( Message.ErrorTitle , MessagePage.ErrorText , { CommonWords.ok } )

						elseif event.target.id == "draft" or event.target.id == "draft icon" or event.target.id == "draft_icon_text" then

							local alert = native.showAlert( MessagePage.SavingFailed , MessagePage.ErrorText , { CommonWords.ok } )

					    elseif event.target.id == "schedule" or event.target.id == "schedule icon" or event.target.id == "schedule_icon_text" then

							local alert = native.showAlert( MessagePage.SchedulingFailed , MessagePage.ErrorText , { CommonWords.ok } )

					    ScheduledMessageGroup.isVisible = false

					    longmsg_textbox.isVisible = true

					    shortmsg_textbox.isVisible = true

					    end

					return false

		        end




		        if (shortmsg_textbox.text ~= "" or shortmsg_textbox.text ~= nil) and (test ~= "" or test ~= nil) then

						    if event.target.id == "send" or event.target.id == "send icon" or event.target.id == "send_icon_text" then


						        sendMessage("SEND")
		                        
							elseif event.target.id == "draft" or event.target.id == "draft icon" or event.target.id == "draft_icon_text" then

							    sendMessage("DRAFT")

							elseif event.target.id == "schedule" or event.target.id == "schedule icon" or event.target.id == "schedule_icon_text" then

		    	    	        GetScheduleMessageAlertPopup()

								ScheduledMessageGroup.isVisible = true

								longmsg_textbox.isVisible = false
								shortmsg_textbox.isVisible = false

								sendMessage("SCHEDULE")
								
							else

						    end

					  return false

		        end




		        if (shortmsg_textbox.text ~= "" or shortmsg_textbox.text ~= nil) and (longMessage == "" or longMessage == nil) then

		        	        validation = false

	    	    	    	SetError("* ".."Enter the Long Message",longmsg_textbox)

	    	    	    	return false


		        end


		        if (test ~= "" or test ~= nil) and (shortmsg_textbox.text == "" or shortmsg_textbox.text == nil) then

		        	        validation = false

	    	    	    	SetError("* ".."Enter the Short Message",shortmsg_textbox)

	    	    	    	return false

		        end


		    end

		    sendTimer = timer.performWithDelay( 1000, senTimerFun )

---------------------------

    	end

    	return true

    end



MainGroup.y = 0

MainGroupY = MainGroup.y


local function moveFieldsDown()
    transition.to( MainGroup, { time=fieldTrans, y=(MainGroupY)} )
end
 
local function moveFieldsUp()
    transition.to( MainGroup, { time=fieldTrans, y=(MainGroupY - fieldOffset)} )
end






function string.urlEncode( str )
	if ( str ) then
		str = string.gsub( str, "\n", "\r\n" )
		str = string.gsub( str, "([^%w ])",
			function (c) return string.format( "%%%02X", string.byte(c) ) end )
		str = string.gsub( str, " ", "+" )
	end
	return str
end



function urlDecode( str )
    assert( type(str)=='string', "urlDecode: input not a string" )
    str = string.gsub (str, "+", " ")
    str = string.gsub (str, "%%(%x%x)",
        function(h) return string.char(tonumber(h,16)) end)
    str = string.gsub (str, "\r\n", "\n")
    return str
end






local function FocusComplete( event )

	if event.phase == "began" then

		native.setKeyboardFocus(nil)
		display.getCurrentStage():setFocus( event.target )

		 if (pHeight <= 960) then

			moveFieldsDown()

		 end


	elseif event.phase == "ended" then

	    display.getCurrentStage():setFocus( nil )

         if (pHeight <= 960) then

   		  moveFieldsDown()

   		 end

	end

	   return true

end 



local function TextLimitation( event )

       if event.phase == "began" then

            print("began")

       elseif event.phase == "submitted" then

            print("submitted")

                    if event.target.id =="longmessage" then

                           native.setKeyboardFocus( nil )

                            if (pHeight <= 960) then

                             moveFieldsDown()

                            end

                   end

                   
                  if (pHeight <= 960) then

                        moveFieldsDown()

                  end




       elseif event.phase == "editing" then

                print("editing")

                    if event.target.id =="shortmessage" then

                            if (string.len(event.target.text) > 250) then

                                event.target.text = event.target.text:sub(1, 250)

                            end


                            if (string.len(event.target.text) <= 250) then

                                      counttext = 250 - string.len(event.target.text).. MessagePage.characters

                                      short_msg_charlimit.text = counttext

                            end


                            if (string.len(event.target.text) <= 0 ) then

                                     short_msg_charlimit.text = "250"..MessagePage.characters

                            end



                            if (event.newCharacters=="\n") then

                                 shortmsg_textbox.text = string.gsub( shortmsg_textbox.text,"%\n","" )

                                      if ( (event.startPosition == 1) and string.find( shortmsg_textbox.text , "", 1 )) then

                                        short_msg_charlimit.text = "250".. MessagePage.characters

                                        native.setKeyboardFocus( longmsg_textbox )

                                    else


                                        if isAndroid then

                                          shortlen = string.len(shortmsg_textbox.text) - 1

                                        short_msg_charlimit.text = 250 - shortlen.. MessagePage.characters

                                        native.setKeyboardFocus( longmsg_textbox )

                                        elseif isIos then

                                        shortlen = string.len(shortmsg_textbox.text)

                                        short_msg_charlimit.text = 250 - shortlen.. MessagePage.characters

                                        native.setKeyboardFocus( longmsg_textbox )

                                        end

                                    end

                            end



                            if page == "edit" then

                                short_msg_charlimit.text = counttext

                            end


                    end





            elseif event.phase == "ended" then

                print("editing")


                   if event.target.id =="longmessage" then

                                    native.setKeyboardFocus( nil )

                  end


                  if (pHeight <= 960) then

                        moveFieldsDown()

                  end

          end

   end



		local function onKeyEventDetail( event )

		        local phase = event.phase
		        local keyName = event.keyName

		        if phase == "up" then

		        if keyName=="back" then

		        	ScheduledMessageGroup.isVisible = false

		        	if datePicker then datePicker.clear() end

		        	if timePicker then timePicker.clear() end

		        	composer.hideOverlay( "slideRight", 300 )

		        	--scrollTo(0)

		        	return true
		            
		        end

		    end

		        return false
		 end






 function formatSizeUnits(event)

      if (event>=1073741824) then 

      	size =(event/1073741824)..' GB'

      print("size of the image11 ",size)


      elseif (event>=1048576) then   

       	size =(event/1048576)..' MB'

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






local function onIconsTouch( event )

	if event.phase == "began" then

	elseif event.phase == "ended" then

		if event.target.id =="camera" then

				if media.hasSource( media.Camera ) then
				timer.performWithDelay( 100, function() media.capturePhoto( { listener = selectionComplete, mediaSource = media.Camera } ) 
				end )

			    else

			    	local image1 = native.showAlert( "Camera Unavailable", "Camera is not supported in this device", { CommonWords.ok } )

				end

		elseif event.target.id == "gallery" then

				if media.hasSource( PHOTO_FUNCTION  ) then
				timer.performWithDelay( 100, function() media.selectPhoto( { listener = selectionComplete, mediaSource = PHOTO_FUNCTION } ) 
				end )
				end

		elseif event.target.id == "audio" then

					for row in db:nrows("SELECT * FROM logindetails WHERE id=1") do
							UserId = row.UserId
							ContactId = row.ContactId
							MemberName = row.MemberName

					end

			    local MessageType=""

			    print("contact id:",ContactId)

			    local options = {

				      		effect = "fromTop",
							time = 200,	
								params = {
								contactId = ContactId,
								MessageType = MessageType,
								page = "compose"
							}

							}

		    composer.gotoScene( "Controller.audioRecordPage",options)

		end

	end

return true
end





local function webListener( event )
    local shouldLoad = true

    local url = event.url

    	print( "here"..url )
    
    if 1 == string.find( url, defalutValue ) then
        -- Close the web popup
        print( "here" )

        shouldLoad = false

       -- print(url)


        updatedresponse = urlDecode(url)


        longMessage = (string.sub( updatedresponse, 13,updatedresponse:len() ))

        print( "updatedresponse : "..longMessage:len() )




        defalutValue="corona:open"

    end

    if event.errorCode then
        -- Error loading page
        print( "Error: " .. tostring( event.errorMessage ) )
        shouldLoad = false
    end

    return false
end






	local function composemsg_scrollListener(event )

		    local phase = event.phase

		    if ( phase == "began" ) then 
		    elseif ( phase == "moved" ) then 

			local x, y = scrollView:getContentPosition()

				-- if filename.isVisible == true then

				-- 		scrollView.bottomPadding = 100

				-- 		print("FileName")

				-- else    

				-- 	    print("not FileName")

				-- 	    scrollView.bottomPadding = 35

				-- end


				if y > -30 then

					shortmsg_textbox.isVisible = true
				else

					shortmsg_textbox.isVisible = false
				end


				if y > -120 then

					longmsg_textbox.isVisible = true
				else

					longmsg_textbox.isVisible = false
				end


		    elseif ( phase == "ended" ) then 

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





	local function closeMessagePage( event )

		if event.phase == "began" then

			display.getCurrentStage():setFocus( event.target )


		elseif event.phase == "ended" then

		    display.getCurrentStage():setFocus( nil )

	            native.setKeyboardFocus(nil)

	            if status == "chat" then

			       composer.hideOverlay("slideRight",300)		

			    else

			       composer.gotoScene("Controller.pushNotificationListPage","slideRight",300)		

			    end

			   -- scrollTo(0)

		end

	return true

	end





local function composeAudioUpdate(audiovalue)

	    local filePath = system.pathForFile( audiovalue, system.DocumentsDirectory )
		            -- Play back the recording
		            local file = io.open( filePath)
		            
		            if file then
		                io.close( file )
		            else
		            	audiovalue="test.wav"
			           	filePath = system.pathForFile( audiovalue, system.DocumentsDirectory )
		            end

				        local size2 = lfs.attributes (filePath, "size")

						local fileHandle = io.open(filePath, "rb")

						local file_inbytearray = mime.b64( fileHandle:read( "*a" ) )

						formatSizeUnits(size2)


					    print("path     : ",path)


									function get_audiomodel( response )

										    composer.removeHidden()

											audiopath = response.Abspath

											audioname = response.FileName

											audiosize = size


											Audiopath = audiopath
											Audioname = audioname
											Audiosize = audiosize


											print(Audiopath.."       ".."\n"..Audioname.."      ".."\n".."        "..Audiosize)


										if audioname ~= nil then


										      filename_title.isVisible = true

										      filename.isVisible = true

											  filename_close.isVisible = true


											  filename_title.text = "Audio Name"

											  filename.text = audioname


											  	schedule_button.y = filename.y + filename.contentHeight +15
												schedule_icon.y= schedule_button.y+schedule_button.contentHeight/2-schedule_icon.contentHeight/2
												schedule_icon_text.y= schedule_icon.y
												schedule_button.height=schedule_icon_text.contentHeight+10

												send_button.y = filename.y + filename.contentHeight +15
												send_icon.y= send_button.y+send_button.contentHeight/2-send_icon.contentHeight/2
												send_icon_text.y= send_icon.y
												send_button.height=send_icon_text.contentHeight+10

												draft_button.y = filename.y + filename.contentHeight +15
												draft_icon.y= draft_button.y+draft_button.contentHeight/2-draft_icon.contentHeight/2
												draft_icon_text.y= draft_icon.y
												draft_button.height=draft_icon_text.contentHeight+10

											--  composeAudioUpdate(filenameval)


										else

										end



											function ImageClose(event)

													filename.text = ""

													filename.isVisible = false

													filename_title.isVisible = false

													filename_close.isVisible = false

													Audiopath = ""

													os.remove( path )

													schedule_button.y = icons_holder_bg.y + icons_holder_bg.contentHeight +15
													schedule_icon.y= schedule_button.y+schedule_button.contentHeight/2-schedule_icon.contentHeight/2
													schedule_icon_text.y= schedule_icon.y

													schedule_button.height=schedule_icon_text.contentHeight+10

													send_button.y = icons_holder_bg.y + icons_holder_bg.contentHeight +15
													send_icon.y= send_button.y+send_button.contentHeight/2-send_icon.contentHeight/2
													send_icon_text.y= send_icon.y

													send_button.height=send_icon_text.contentHeight+10

													draft_button.y = icons_holder_bg.y + icons_holder_bg.contentHeight +15
													draft_icon.y= draft_button.y+draft_button.contentHeight/2-draft_icon.contentHeight/2
													draft_icon_text.y= draft_icon.y

													draft_button.height=draft_icon_text.contentHeight+10

										end


											filename_close:addEventListener("touch",ImageClose)


									end



					Webservice.DOCUMENT_UPLOAD(file_inbytearray,audiovalue,"Audios",get_audiomodel)

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
	title_bg.height = 28
	title_bg.x=W/2;title_bg.y = tabBar.y+tabBar.contentHeight-6.5
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

	title = display.newText(sceneGroup,MessagePage.ComposeMessage,0,0,native.systemFont,18)
	title.anchorX = 0
	title.x=back_icon.x+15;title.y = title_bg.y
	title:setFillColor(0)


MainGroup:insert(sceneGroup)

end



	function scene:show( event )

		local sceneGroup = self.view
		local phase = event.phase
		
		if phase == "will" then

				if event.params and openPagevalue == "addPage" then

				status=event.params.page
				Details = event.params.Details

			    end

			
				sceneevent = event


			if sceneevent.params then

				filenameval = event.params.filename

			    print("********************** : ",filenameval)

			end



			scrollView = widget.newScrollView
			{
			top = RecentTab_Topvalue,
			left = 0,
			width = W,
			height =H-RecentTab_Topvalue,
			hideBackground = true,
			isBounceEnabled=false,
			horizontalScrollDisabled = true,
			bottomPadding = 60,
			friction = .4,
   			listener = composemsg_scrollListener,
		    }

		    sceneGroup:insert( scrollView )


---------------------------------------------- Short Message ----------------------------------------------------------

                shortmsg_star = display.newText("*",0,0,native.systemFont,14)
				shortmsg_star.anchorX = 0
				shortmsg_star.anchorY = 0
				shortmsg_star.x=10
				shortmsg_star.y = tabBar.y+tabBar.contentHeight-45
				shortmsg_star:setFillColor(1,0,0)
				scrollView:insert(shortmsg_star)
				
				shortmsg_title = display.newText(sceneGroup,MessagePage.ShortMessage,0,0,native.systemFont,14)
				shortmsg_title.anchorX = 0
				shortmsg_title.x=shortmsg_star.x + 7
				shortmsg_title.anchorY=0
				shortmsg_title.y = shortmsg_star.y - 3
				shortmsg_title:setFillColor(0)
				scrollView:insert(shortmsg_title)


				shortmsg_textbox = native.newTextBox( 10,shortmsg_title.y+ shortmsg_title.height+7, W - 20, EditBoxStyle.height+25)
				shortmsg_textbox.placeholder = MessagePage.ShortMessage_Placeholder
				shortmsg_textbox.isEditable = true
				shortmsg_textbox.size=14
				shortmsg_textbox.anchorX = 0
				shortmsg_textbox.height = EditBoxStyle.height + 20
				shortmsg_textbox.anchorY=0
				shortmsg_textbox.width = W-20
				shortmsg_textbox.value=""
				shortmsg_textbox.id = "shortmessage"
				shortmsg_textbox.hasBackground = true
				shortmsg_textbox:setReturnKey( "next" )
				shortmsg_textbox.inputType = "default"
				--sceneGroup:insert(shortmsg_textbox)
				scrollView:insert(shortmsg_textbox)
				--shortmsg_textbox.x=10
				--shortmsg_textbox.y=shortmsg_title.y+ shortmsg_title.height+7


				short_msg_charlimit = display.newText(MessagePage.ShortMsgLimit,0,0,native.systemFont,14)
				short_msg_charlimit.anchorX = 0
				short_msg_charlimit.x=W-123
				short_msg_charlimit.anchorY = 0
				short_msg_charlimit.y = shortmsg_textbox.y+shortmsg_textbox.contentHeight+2
				short_msg_charlimit:setFillColor(0)
				scrollView:insert(short_msg_charlimit)

---------------------------------------------- Long Message ----------------------------------------------------------

                longmsg_star = display.newText("*",0,0,native.systemFont,14)
				longmsg_star.anchorX = 0
				longmsg_star.x=10
				longmsg_star.anchorY=0
				longmsg_star.y = short_msg_charlimit.y+short_msg_charlimit.contentHeight+5
				longmsg_star:setFillColor(1,0,0)
				scrollView:insert(longmsg_star)


				longmsg_title = display.newText(MessagePage.LongMessage,0,0,native.systemFont,14)
				longmsg_title.anchorX = 0
				longmsg_title.x=longmsg_star.x + 7
				longmsg_title.anchorY = 0
				longmsg_title.y = longmsg_star.y - 3
				longmsg_title:setFillColor(0)
				scrollView:insert(longmsg_title)


				-- longmsg_textbox = native.newTextBox( 10,longmsg_title.y+ longmsg_title.height+7, W - 20, EditBoxStyle.height+40)
				-- longmsg_textbox.placeholder = MessagePage.LongMessage_Placeholder
				-- longmsg_textbox.isEditable = true
				-- longmsg_textbox.size=14
				-- longmsg_textbox.anchorX = 0
				-- longmsg_textbox.height = EditBoxStyle.height + 40
				-- longmsg_textbox.anchorY=0
				-- longmsg_textbox.width = W-20
				-- longmsg_textbox.value=""
				-- longmsg_textbox.id = "longmessage"
				-- longmsg_textbox.isVisible = true
				-- longmsg_textbox.hasBackground = true
				-- --longmsg_textbox:setReturnKey( "done" )
				-- longmsg_textbox.inputType = "default"
				-- sceneGroup:insert(longmsg_textbox)
				-- --longmsg_textbox.x=10
				-- --longmsg_textbox.y=longmsg_title.y+ longmsg_title.height+7


		        content = "hai hello Where do by H. Rackham."

			    test= string.urlEncode(content)

				local path = system.pathForFile( "messageCKeditor.html",system.DocumentsDirectory )

				local file, errorString = io.open( path, "w+" )

				if not file then

				    print( "File error: " .. errorString )

				else

				    file:write( meggageeditor.htmlContent.."'"..test.."'"..meggageeditor.endHtml.."" )

							 longmsg_textbox = native.newWebView(10,longmsg_title.y+longmsg_title.contentHeight+ 7, W - 15, 185)

							 longmsg_textbox.hasBackground = false

							 longmsg_textbox.anchorX=0;longmsg_textbox.anchorY=0
							 longmsg_textbox:request( "messageCKeditor.html", system.DocumentsDirectory )

							 longmsg_textbox:addEventListener( "urlRequest", webListener )
							 scrollView:insert( longmsg_textbox)




				    file:close()

				end

				file = nil




				long_msg_charlimit = display.newText(MessagePage.LongMsgLimit,0,0,native.systemFont,14)
				long_msg_charlimit.anchorX = 0
				long_msg_charlimit.anchorY = 0
				long_msg_charlimit.x=W-125
				long_msg_charlimit.y = longmsg_textbox.y+longmsg_textbox.contentHeight+5
				long_msg_charlimit:setFillColor(0)
				scrollView:insert(long_msg_charlimit)


				-- if sceneevent.params then

    --                     detailvalues = sceneevent.params.Details
    --                     page = sceneevent.params.value

    --                     print("detailvalues : "..json.encode(detailvalues))

    --                     if page == "edit" then

	   --                      shortmsg_textbox.text = detailvalues.MyUnitBuzzMessage
				-- 		    longMessage = detailvalues.MyUnitBuzzLongMessage


				-- 	   		short_msg_charlimit.text = (250 - shortmsg_textbox.text:len()).." "..MessagePage.characters

				--         	long_msg_charlimit.text = (1000 - longMessage:len()).." "..MessagePage.characters

				-- 			back_icon:addEventListener("touch",closeMessagePage)
				-- 			back_icon_bg:addEventListener("touch",closeMessagePage)
				-- 			title:addEventListener("touch",closeMessagePage)

                       	
    --                     end

			 --    end



------------------------------------------- attachment icon -----------------------------------------


				attachment_icon = display.newImageRect("res/assert/attached.png",20,20)
				attachment_icon.x= longmsg_textbox.width - 20
				attachment_icon.anchorX=0
				attachment_icon.anchorY=0
				attachment_icon.isVisible = false
				attachment_icon.y = long_msg_charlimit.y - 20
				attachment_icon:toFront()


------------------------------------------- Icons Holder --------------------------------------------

				icons_holder_bg = display.newRect(0,0,W-20,EditBoxStyle.height+115)
				icons_holder_bg.x=10
				icons_holder_bg.anchorX=0
				icons_holder_bg.anchorY=0
				icons_holder_bg.strokeWidth = 1
				icons_holder_bg:setStrokeColor( 0,0,0,0.1)
				icons_holder_bg.y = long_msg_charlimit.y+long_msg_charlimit.height+10
				icons_holder_bg:setFillColor( 1,1,1,0.8)
				scrollView:insert(icons_holder_bg)

-------------------------------------------- Camera ---------------------------------------------------


				camera_icon = display.newImageRect("res/assert/camera1.png",40,35)
				camera_icon.x=W/2 - W/3 - 15
				camera_icon.anchorX=0
				camera_icon.id= "camera"
				camera_icon.anchorY=0
				camera_icon.y = icons_holder_bg.y + 7.5
				camera_icon:addEventListener("touch",onIconsTouch)
				scrollView:insert(camera_icon)


				camera_icon_txt = display.newText(MessagePage.Camera,0,0,native.systemFont,14)
				camera_icon_txt.anchorX = 0
				camera_icon_txt.anchorY = 0
				camera_icon_txt.x = camera_icon.x - 7
				camera_icon_txt.y = camera_icon.y+camera_icon.contentHeight+5
				camera_icon_txt:setFillColor(0)
				scrollView:insert(camera_icon_txt)

-------------------------------------------- Video ---------------------------------------------------

				video_icon = display.newImageRect("res/assert/video1.png",40,35)
				video_icon.x= W/2 - 12
				video_icon.anchorX=0
				video_icon.anchorY=0
				video_icon.y = camera_icon.y
				scrollView:insert(video_icon)


				video_icon_txt = display.newText(MessagePage.Video,0,0,native.systemFont,14)
				video_icon_txt.anchorX = 0
				video_icon_txt.anchorY = 0
				video_icon_txt.x = video_icon.x 
				video_icon_txt.y = video_icon.y+video_icon.contentHeight+5
				video_icon_txt:setFillColor(0)
				scrollView:insert(video_icon_txt)

-------------------------------------------- Audio ---------------------------------------------------

                audio_icon = display.newImageRect("res/assert/audio1.png",40,35)
				audio_icon.x= W/2 + W/3 - 15
				audio_icon.anchorX=0
				audio_icon.id = "audio"
				audio_icon.anchorY=0
				audio_icon.y = video_icon.y
				audio_icon:addEventListener("touch",onIconsTouch)
				scrollView:insert(audio_icon)


				audio_icon_txt = display.newText(MessagePage.Audio,0,0,native.systemFont,14)
				audio_icon_txt.anchorX = 0
				audio_icon_txt.anchorY = 0
				audio_icon_txt.x = audio_icon.x 
				audio_icon_txt.y = audio_icon.y+audio_icon.contentHeight+5
				audio_icon_txt:setFillColor(0)
				scrollView:insert(audio_icon_txt)

-------------------------------------------- Gallery ---------------------------------------------------


                gallery_icon = display.newImageRect("res/assert/gallery1.png",40,35)
				gallery_icon.x= W/2 - W/3 - 15
				gallery_icon.anchorX=0
				gallery_icon.anchorY=0
				gallery_icon.id= "gallery"
				gallery_icon.y = camera_icon.y + camera_icon.contentHeight + 35
				gallery_icon:addEventListener("touch",onIconsTouch)
				scrollView:insert(gallery_icon)


				gallery_icon_txt = display.newText(MessagePage.Gallery,0,0,native.systemFont,14)
				gallery_icon_txt.anchorX = 0
				gallery_icon_txt.anchorY = 0
				gallery_icon_txt.x = gallery_icon.x - 5
				gallery_icon_txt.y = gallery_icon.y+gallery_icon.contentHeight+5
				gallery_icon_txt:setFillColor(0)
				scrollView:insert(gallery_icon_txt)


-------------------------------------------- Location ---------------------------------------------------

                Location_icon = display.newImageRect("res/assert/location1.png",40,35)
				Location_icon.x= W/2 - 12
				Location_icon.anchorX=0
				Location_icon.anchorY=0
				Location_icon.y = gallery_icon.y
				scrollView:insert(Location_icon)


				Location_icon_txt = display.newText(MessagePage.Location,0,0,native.systemFont,14)
				Location_icon_txt.anchorX = 0
				Location_icon_txt.anchorY = 0
				Location_icon_txt.x = Location_icon.x - 10
				Location_icon_txt.y = Location_icon.y+Location_icon.contentHeight+5
				Location_icon_txt:setFillColor(0)
				scrollView:insert(Location_icon_txt)


-------------------------------------------- Contact ---------------------------------------------------

                Contact_icon = display.newImageRect("res/assert/user1.png",40,35)
				Contact_icon.x= W/2 + W/3 - 15
				Contact_icon.anchorX=0
				Contact_icon.anchorY=0
				Contact_icon.y = Location_icon.y
				scrollView:insert(Contact_icon)


				Contact_icon_txt = display.newText(MessagePage.Contact,0,0,native.systemFont,14)
				Contact_icon_txt.anchorX = 0
				Contact_icon_txt.anchorY = 0
				Contact_icon_txt.x = Contact_icon.x - 7
				Contact_icon_txt.y = Contact_icon.y+Contact_icon.contentHeight+5
				Contact_icon_txt:setFillColor(0)
				scrollView:insert(Contact_icon_txt)


---------------------------------------- File name and its title ------------------------------------------


				filename_title = display.newText("Image Name",0,0,native.systemFont,14)
				filename_title.anchorX = 0
				filename_title.anchorY = 0
				filename_title.x = 10
				filename_title.isVisible = false
				filename_title.y = icons_holder_bg.y+icons_holder_bg.contentHeight+15
				filename_title:setFillColor(0)
				scrollView:insert(filename_title)


				filename = display.newText(MessagePage.Audio,0,0,native.systemFont,14)
				filename.anchorX = 0
				filename.anchorY = 0
				filename.isVisible = false
				filename.x = filename_title.x 
				filename.y = filename_title.y+filename_title.contentHeight+10
				filename:setFillColor(Utils.convertHexToRGB(color.tabBarColor))
				scrollView:insert(filename)


				filename_close = display.newImageRect("res/assert/icon-close.png",20,20)
				filename_close.anchorX = 0
				filename_close.anchorY = 0
				filename_close.isVisible = false
				filename_close.x = W - 35
				filename_close.y = filename_title.y+filename_title.contentHeight+8
				scrollView:insert(filename_close)


------------------------------------------ Schedule Button -----------------------------------------------

			    schedule_button = display.newRect(0,0,W-50,26)
				schedule_button.x = W/2 - W/3 - 45
				--schedule_button.y = filename.y + filename.contentHeight +15
				schedule_button.y = icons_holder_bg.y + icons_holder_bg.contentHeight +15
				--schedule_button.y = long_msg_charlimit.y+long_msg_charlimit.height+18
				schedule_button.width = W - 210
				schedule_button.anchorX = 0
				schedule_button.anchorY=0
				schedule_button:setFillColor( 0,0.5,0.8 )
				schedule_button.id="schedule"
				scrollView:insert(schedule_button)


				schedule_icon = display.newImageRect("res/assert/schedule.png",16,14)
				schedule_icon.id = "schedule icon"
				scrollView:insert(schedule_icon)
				schedule_icon.anchorY=0
				schedule_icon.anchorX=0
				schedule_icon.x= schedule_button.x + 6
				schedule_icon.y=schedule_button.y+schedule_button.contentHeight/2-schedule_icon.contentHeight/2


				schedule_icon_text = display.newText(MessagePage.ScheduleText,0,0,schedule_button.contentWidth-12,0,native.systemFont,14)
				schedule_icon_text.anchorX=0
				schedule_icon_text.id = "schedule_icon_text"
				schedule_icon_text.anchorY=0
				schedule_icon_text.x=schedule_icon.x+schedule_icon.contentWidth+ 5
				schedule_icon_text.y=schedule_icon.y
				Utils.CssforTextView(schedule_icon_text,sp_primarybutton)
				scrollView:insert(schedule_icon_text)

			    schedule_button.height=schedule_icon_text.contentHeight+10



--------------------------------------------- Send Button ---------------------------------------------------------

			    send_button = display.newRect(0,0,W-50,26)
				send_button.x = W/2 - 35
				--send_button.y = filename.y + filename.contentHeight +15
				send_button.y = icons_holder_bg.y + icons_holder_bg.contentHeight +15
				--send_button.y = long_msg_charlimit.y+long_msg_charlimit.height+18
				send_button.width = W - 235
				send_button.anchorX = 0
				send_button.anchorY=0
				send_button:setFillColor(Utils.convertHexToRGB(color.darkgreen))
				send_button.id="send"
				scrollView:insert(send_button)

				send_icon = display.newImageRect("res/assert/sendmsg.png",16,14)
				send_icon.id = "send icon"
				send_icon.anchorY=0
				send_icon.anchorX=0
				send_icon.x= send_button.x + 6
				send_icon.y=send_button.y+send_button.contentHeight/2-send_icon.contentHeight/2
				scrollView:insert(send_icon)

				send_icon_text = display.newText(MessagePage.Send,0,0,send_button.contentWidth-12,0,native.systemFont,14)
				send_icon_text.anchorX=0
				send_icon_text.anchorY=0
				send_icon_text.id = "send_icon_text"
				send_icon_text.x=send_icon.x+send_icon.contentWidth+ 5
				send_icon_text.y=send_icon.y
				Utils.CssforTextView(send_icon_text,sp_primarybutton)
				scrollView:insert(send_icon_text)

			    send_button.height=send_icon_text.contentHeight+10



--------------------------------------------- Draft Button ---------------------------------------------------------

			    draft_button = display.newRect(0,0,W-50,26)
				draft_button.x = W/2 + W/3 - 50
				--draft_button.y = filename.y + filename.contentHeight +15
				draft_button.y = icons_holder_bg.y + icons_holder_bg.contentHeight +15
				--draft_button.y = long_msg_charlimit.y+long_msg_charlimit.height+18
				draft_button.width = W - 225
				draft_button.anchorX = 0
				draft_button.anchorY=0
				draft_button:setFillColor( 0,0,0,0.7 )
				draft_button.id="draft"
				scrollView:insert(draft_button)


				draft_icon = display.newImageRect("res/assert/drafticon.png",16,14)
				draft_icon.id = "draft icon"
				scrollView:insert(draft_icon)
				draft_icon.anchorY=0
				draft_icon.anchorX=0
				draft_icon.x= draft_button.x + 6
				draft_icon.y= draft_button.y+draft_button.contentHeight/2-draft_icon.contentHeight/2

				draft_icon_text = display.newText(MessagePage.DraftText,0,0,send_button.contentWidth-12,0,native.systemFont,14)
				draft_icon_text.anchorX=0
				draft_icon_text.anchorY=0
				draft_icon_text.id = "draft_icon_text"
				draft_icon_text.x=draft_icon.x+draft_icon.contentWidth+ 5
				draft_icon_text.y=draft_icon.y
				Utils.CssforTextView(draft_icon_text,sp_primarybutton)
				scrollView:insert(draft_icon_text)

			    draft_button.height=draft_icon_text.contentHeight+10




				 if filenameval ~= nil then

				 	targetaction = "audio"


				--       filename_title.isVisible = true

				--       filename.isVisible = true

				-- 	  filename_close.isVisible = true


				-- 	  filename_title.text = "Audio Name"

				-- 	  filename.text = filenameval


				-- 	  	schedule_button.y = filename.y + filename.contentHeight +15
				-- 		schedule_icon.y= schedule_button.y+schedule_button.contentHeight/2-schedule_icon.contentHeight/2
				-- 		schedule_icon_text.y= schedule_icon.y
				-- 		schedule_button.height=schedule_icon_text.contentHeight+10

				-- 		send_button.y = filename.y + filename.contentHeight +15
				-- 		send_icon.y= send_button.y+send_button.contentHeight/2-send_icon.contentHeight/2
				-- 		send_icon_text.y= send_icon.y
				-- 		send_button.height=send_icon_text.contentHeight+10

				-- 		draft_button.y = filename.y + filename.contentHeight +15
				-- 		draft_icon.y= draft_button.y+draft_button.contentHeight/2-draft_icon.contentHeight/2
				-- 		draft_icon_text.y= draft_icon.y
				-- 		draft_button.height=draft_icon_text.contentHeight+10

				 	  composeAudioUpdate(filenameval)


				 else

				 end




		elseif phase == "did" then

			--composer.removeHidden()

			menuBtn:addEventListener("touch",menuTouch)

			back_icon:addEventListener("touch",closeMessagePage)
			back_icon_bg:addEventListener("touch",closeMessagePage)
			title:addEventListener("touch",closeMessagePage)

			shortmsg_textbox:addEventListener( "userInput", TextLimitation )
			--longmsg_textbox:addEventListener( "userInput", TextLimitation )
			Background:addEventListener("touch",FocusComplete)

			

			send_button:addEventListener("touch",onSendButtonTouchAction)
			send_icon:addEventListener("touch",onSendButtonTouchAction)
			send_icon_text:addEventListener("touch",onSendButtonTouchAction)

			draft_button:addEventListener("touch",onSendButtonTouchAction)
			draft_icon:addEventListener("touch",onSendButtonTouchAction)
			draft_icon_text:addEventListener("touch",onSendButtonTouchAction)

			schedule_button:addEventListener("touch",onSendButtonTouchAction)
			schedule_icon:addEventListener("touch",onSendButtonTouchAction)
			schedule_icon_text:addEventListener("touch",onSendButtonTouchAction)

			Runtime:addEventListener( "key", onKeyEventDetail )
			
		end	
		
	MainGroup:insert(sceneGroup)

	end




	function scene:hide( event )

		local sceneGroup = self.view
		local phase = event.phase

		if event.phase == "will" then

			if longmsg_textbox then longmsg_textbox:removeSelf( );longmsg_textbox=nil end

			composer.removeHidden()

				if datePicker then datePicker.clear() end

				if timePicker then timePicker.clear() end


			if DeleteMessageGroup.numChildren ~= nil then

			  	 	for j=DeleteMessageGroup.numChildren, 1, -1 do 
			  			display.remove(DeleteMessageGroup[DeleteMessageGroup.numChildren])
			  			DeleteMessageGroup[DeleteMessageGroup.numChildren] = nil
			  	 	end
            end


			elseif phase == "did" then

				if status == "editpage" then

					event.parent:resumeGame("details",Details,"details")

				end

				back_icon:removeEventListener("touch",closeMessagePage)
			    back_icon_bg:removeEventListener("touch",closeMessagePage)
			    title:removeEventListener("touch",closeMessagePage)

			    shortmsg_textbox:removeEventListener( "userInput", TextLimitation)
				--longmsg_textbox:removeEventListener( "userInput", TextLimitation)
				Background:removeEventListener("touch",FocusComplete)

				send_button:removeEventListener("touch",onSendButtonTouchAction)
				send_icon:removeEventListener("touch",onSendButtonTouchAction)
				send_icon_text:removeEventListener("touch",onSendButtonTouchAction)

				draft_button:removeEventListener("touch",onSendButtonTouchAction)
				draft_icon:removeEventListener("touch",onSendButtonTouchAction)
				draft_icon_text:removeEventListener("touch",onSendButtonTouchAction)

				schedule_button:removeEventListener("touch",onSendButtonTouchAction)
				schedule_icon:removeEventListener("touch",onSendButtonTouchAction)
				schedule_icon_text:removeEventListener("touch",onSendButtonTouchAction)


				Runtime:removeEventListener( "key", onKeyEventDetail )

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
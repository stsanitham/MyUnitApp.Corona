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
local lfs = require ("lfs")
local path = system.pathForFile( "MyUnitBuzz.db", system.DocumentsDirectory )
local db = sqlite3.open( path )
local timePicker = require( "Controller.timePicker" )
local datePicker = require( "Controller.datePicker" )
local mime=require('mime')
local socket=require('socket')
local ck_editor = require('Utils.messageCKeditor')


--------------- Initialization -------------------

local W = display.contentWidth;local H= display.contentHeight

local Background,tabBar,menuBtn,BgText,title_bg,back_icon_bg,back_icon,title,scrollView,shortmsg_star,shortmsg_title,shortmsg_textbox,short_msg_charlimit,longmsg_star
local longmsg_title,long_msg_charlimit,attachment_icon,icons_holder_bg,camera_icon,camera_icon_txt,video_icon,video_icon_txt,audio_icon,audio_icon_txt,gallery_icon,gallery_icon_txt,Location_icon,Location_icon_txt,Contact_icon,Contact_icon_txt,filename_title,filename,filename_close,schedule_button
local schedule_icon,schedule_icon_text,send_button,send_icon,send_icon_text,draft_button,draft_icon,draft_icon_text

local Background,tabBar,menuBtn,BgText,title_bg,back_icon_bg,back_icon,title,scrollView,shortmsg_star,shortmsg_title,shortmsg_textbox,short_msg_charlimit,longmsg_star,longmsg_title,
long_msg_charlimit

local attachment_icon,icons_holder_bg,camera_icon,camera_icon_txt,video_icon,video_icon_txt,audio_icon,audio_icon_txt,gallery_icon,gallery_icon_txt,Location_icon,Location_icon_txt,
Contact_icon,Contact_icon_txt,filename_title,filename,filename_close

local schedule_button,schedule_icon,schedule_icon_textsend_button,send_icon,send_icon_text,draft_button,draft_icon,draft_icon_text

local filename ,filename_title, filename_close

local photowid = "";photoheig = ""

local photowidth1 = "";photoheight1 = ""

local shortmsg_textbox,longmsg_textbox

--local Imagepath = "";Imagename = "";Imagesize = ""

openPage="pushNotificationListPage"

local RecentTab_Topvalue = 70

local sceneevent

local status

local Details={}

local composePage = display.newGroup( )

local Audiopath=""; Audioname=""; Audiosize=""

local openPagevalue = "addpage"

local PHOTO_FUNCTION = media.PhotoLibrary 

local pWidth = display.pixelWidth 

local pHeight = display.pixelHeight

fieldOffset = 0

local AttachmentGroup = display.newGroup( )

local attachment_icon,attachment_icon_bg

local longmsg_textbox


local deviceModel = system.getInfo( "model" )

if isIos then

	if (deviceModel == "iPhone") then	

		 fieldOffset = 80

	end

end

local longMessage = ""

local defalutValue="corona:open"

local fieldTrans = 200

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

	local function attachClose(event)

		if event.phase == "ended" then

				if event.target.valuestring == "image" then

					filename.text = ""

					filename.isVisible = false

					filename_title.isVisible = false

					filename_close.isVisible = false

					os.remove( event.target.filepath )

					composePage.y = composePage.y-45

					if Audio_filename_title.isVisible == true then
						Audio_filename_title.y = tabBar.y+tabBar.contentHeight+15
						Audio_filename.y=Audio_filename_title.y+Audio_filename_title.contentHeight+5
						Audio_filename_close.y=Audio_filename_title.y+Audio_filename_title.contentHeight+5
					end


				elseif event.target.valuestring == "audio" then

					Audio_filename.text = ""

					Audio_filename.isVisible = false

					Audio_filename_title.isVisible = false

					Audio_filename_close.isVisible = false

					os.remove( event.target.filepath )

					composePage.y = composePage.y-45

					if filename_title.isVisible == true then
						filename_title.y = tabBar.y+tabBar.contentHeight+15
						filename.y=filename_title.y+filename_title.contentHeight+5
						filename_close.y=filename_title.y+filename_title.contentHeight+5
					end
							
				end
		end

	return true

	end



local function uploadAudio( )
	-- body
end




local function selectionComplete ( event )
 
        local photo = event.target

        local baseDir = system.DocumentsDirectory

        if photo then

        photo.x = display.contentCenterX
		photo.y = display.contentCenterY
		local w = photo.width
		local h = photo.height

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


        local path = system.pathForFile( photoname, system.DocumentsDirectory)

        local size1 = lfs.attributes (path, "size")

		local fileHandle = io.open(path, "rb")

		file_inbytearray = mime.b64( fileHandle:read( "*a" ) )

		io.close( fileHandle )


          	 formatSizeUnits(size1)

		


			if Audio_filename.isVisible == true then

				if filename_title.isVisiblee == false and Audio_filename.y ==  tabBar.y+tabBar.contentHeight+15  then
					
						filename_title.y=Audio_filename.y+20
						composePage.y = composePage.y+45
					

				end

			
			

			else

				composePage.y = composePage.y+45

				filename_title.y = tabBar.y+tabBar.contentHeight+15

			end



			filename_title.isVisible = true

			filename.isVisible = true

			filename_close.isVisible = true

			filename_close.filepath = path

			filename.text = photoname

				filename.y=filename_title.y+filename_title.contentHeight+5
				filename_close.y=filename_title.y+filename_title.contentHeight+5

			


     end

end






	function get_audiomodel(response)

		audiolist_values = json.encode(response)

		local options = {

				effect = "slideRight",
				time = 300,
				params = { pushlistvalues = audiolist_values,page = "compose"}
	    }

		composer.gotoScene("Controller.pushNotificationListPage",options)


	end







	function get_messagemodel(response)

		local list_values = response

		local listupdationvalues = list_values

		if list_values.MessageStatus == "SEND" then


				      		 	shortmsg_textbox.text = ""

								shortmsg_textbox.placeholder = MessagePage.ShortMessage_Placeholder		

								longMessage = ""

								longmsg_textbox.placeholder = MessagePage.LongMessage_Placeholder

								short_msg_charlimit.text = MessagePage.ShortMsgLimit

								long_msg_charlimit.text = MessagePage.LongMsgLimit

				--	local function onTimer ( event )


	                            if openPagevalue == "addpage" then


	                            	photowidth = photowidth1

									photoheight = photoheight1


                                

                                    reloadlistvalues = json.encode(listupdationvalues)


									  local options =
												{
												effect = "slideRight",
												time = 300,
												params = { pushlistvalues = reloadlistvalues,page = "compose"}
					
									   }


									composer.gotoScene("Controller.pushNotificationListPage",options)

								--	scrollTo(0)

								-- elseif openPagevalue ~= "addpage" then

								-- 	photowidth = photowidth1

								-- 	photoheight = photoheight1

								-- 			  local options =
								-- 				{
								-- 				effect = "slideRight",

								-- 				time = 300,
								-- 				params = { editpagevalue = list_values, page_val = "editpage", Imagepathname = Imagepath, photowidth, photoheight}
					
								-- 				}
                           

								-- 	spinner.y=H/2-75

								-- 	composer.showOverlay("Controller.pushNotificationListPage",options)

								--	scrollTo(0)

								end


					-- end

     --    		timer.performWithDelay(1000, onTimer )

	    end




		if list_values.MessageStatus == "DRAFT" then

		      		

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

									reloadlistvalues = json.encode(listupdationvalues)


									-- sceneevent.parent:resumeCall(list_values)

									-- spinner.y=H/2-75

									-- composer.hideOverlay()

									 spinner.y=H/2-75


									  local options =
												{
												effect = "slideRight",

												time = 300,
												params = { pushlistvalues = reloadlistvalues,page = "compose"}
					
									   }


									composer.gotoScene("Controller.pushNotificationListPage",options)



								-- elseif openPagevalue ~= "addpage" then

								-- 	  local options =
								-- 		{
								-- 		effect = "slideRight",

								-- 		time = 300,
								-- 		params = { editpagevalue = list_values, page_val = "editpage"}

								-- 		}

								-- 	spinner.y=H/2-75

								-- 	composer.showOverlay("Controller.pushNotificationListPage",options)

								--	scrollTo(0)

								end

					end

        		timer.performWithDelay(1000, onTimer )

	    end




	    if list_values.MessageStatus == "SCHEDULE" then

		      		 

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


									 reloadlistvalues = json.encode(listupdationvalues)


									  local options =
												{
												effect = "slideRight",

												time = 300,
												params = { pushlistvalues = reloadlistvalues,page = "compose"}
					
									   }


									composer.gotoScene("Controller.pushNotificationListPage",options)
								

								-- elseif openPagevalue ~= "addpage" then

								-- 	 local options =
								-- 		{

								-- 		time = 300,
								-- 		params = { editpagevalue = list_values, page_val = "editpage"}

								-- 		}


								-- 	spinner.y=H/2-75

								-- 	composer.showOverlay("Controller.pushNotificationListPage",options)

								--	scrollTo(0)

								end


					end

        		     timer.performWithDelay(1000, onTimer )

	    end

	end



local function sendAction( method,IsScheduled,Date,Time )

--IsScheduled,Date.text,Time.text
	  if (shortmsg_textbox.text ~= "") and (filename.text == "" and filename.isVisible == false )  and (Audio_filename.text == "" and Audio_filename.isVisible == false) then
                
                -- Webservice.SEND_MESSAGE(shortmsg_textbox.text,longMessage,"","","","","","","","","","",method,"","","",get_messagemodel)

                

                Webservice.SEND_MESSAGE("","","","","",shortmsg_textbox.text,longMessage,IsScheduled,Date,Time,"","","","","","","",method,"","","",get_messagemodel)

                spinner_show()

                spinner.y=H/2-80

		  elseif (shortmsg_textbox.text ~= "") and (filename.text ~= "" and filename.isVisible == true ) then

		        	local Message_date,isDeleted,Created_TimeStamp,Updated_TimeStamp,ImagePath,AudioPath,VideoPath,MyUnitBuzz_LongMessage,From,To,Message_Type
					
					ImagePath= filename.text or ""
					AudioPath="NULL"
					VideoPath="NULL"
					MyUnitBuzz_LongMessage=longMessage


					local path = system.pathForFile( filename.text, system.DocumentsDirectory)

						        local Imagesize = lfs.attributes (path, "size")

								local fileHandle = io.open(path, "rb")

								local file_inbytearray = mime.b64( fileHandle:read( "*a" ) )

								formatSizeUnits(Imagesize)


						local ConversionFirstName,ConversionLastName,GroupName
						local DocumentUpload = {}

							ConversionFirstName="";ConversionLastName=MemberName;GroupName=""

						
									  DocumentUpload = {
									  		UserId = UserId,
									        File = file_inbytearray,
									        FileName = filename.text,
									        FileType = "Images"
									    }

							
						MessageFileType="Images"

					

					      Webservice.SEND_MESSAGE(ConversionFirstName,ConversionLastName,GroupName,DocumentUpload,MessageFileType,shortmsg_textbox.text,longMessage,IsScheduled,Date,Time,"",filename.text,filename.text,Imagesize,"","","",method,"","","",get_messagemodel)

					      	spinner_show()

					      	spinner.y=H/2-30

        	   --Webservice.SEND_MESSAGE(shortmsg_textbox.text,longMessage,"","","","",Imagepath,Imagename,Imagesize,"","","",method,"","","",get_messagemodel)

           elseif (shortmsg_textbox.text ~= "") and (Audio_filename.text ~= "" and Audio_filename.isVisible == true ) then


            	local Message_date,isDeleted,Created_TimeStamp,Updated_TimeStamp,ImagePath,AudioPath,VideoPath,MyUnitBuzz_LongMessage,From,To,Message_Type
				
			
				ImagePath= ""
				AudioPath=Audio_filename.text or ""
				VideoPath="NULL"
				MyUnitBuzz_LongMessage=longMessage


							local path = system.pathForFile( Audio_filename.text, system.DocumentsDirectory)

						    local Audiosize = lfs.attributes (path, "size")

							local fileHandle = io.open(path, "rb")

							local file_inbytearray = mime.b64( fileHandle:read( "*a" ) )

							formatSizeUnits(Audiosize)
			
				local ConversionFirstName,ConversionLastName,GroupName
				local DocumentUpload = {}


				
					ConversionFirstName="";ConversionLastName=MemberName;GroupName=""

				
							  DocumentUpload = {
							  	UserId = UserId,
							        File = file_inbytearray,
							        FileName = Audio_filename.text,
							        FileType = "Audios"
							    }

			
				MessageFileType="Audios"



				Webservice.SEND_MESSAGE(ConversionFirstName,ConversionLastName,GroupName,DocumentUpload,MessageFileType,shortmsg_textbox.text,longMessage,IsScheduled,Date,Time,"",filename.text,filename.text,Imagesize,"","","",method,"","","",get_audiomodel)

				spinner_show()

				 spinner.y=H/2-20

            	-- Webservice.SEND_MESSAGE(shortmsg_textbox.text,longMessage,"","","","","","","",Audiopath,Audioname,Audiosize,method,"","","",get_audiomodel)

            end

            if Audio_filename.isVisible == true and filename.isVisible == true then

            	 spinner.y=H/2+12

            end

end



    local function sendMessage ( method )

		    if shortmsg_textbox.text == nil  then shortmsg_textbox.text = "" end
		    if longMessage == nil  then longMessage = "" end


	    if method == "SCHEDULE" then


	    		GetScheduleMessageAlertPopup()

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

								if Date.text ~= "Date" and Time.text ~= "Time" then

									IsScheduled = tostring(true)
--IsScheduled,Date.text,Time.text

					 				   
									sendAction(method,IsScheduled,Date.text,Time.text)


										ScheduledMessageGroup.isVisible = false

										local function onTimer(event)

										longmsg_textbox.isVisible = true
				    	                shortmsg_textbox.isVisible = true

				    	                end

    	               					 timer.performWithDelay(500,onTimer)

								end

							elseif event.target.id == "closealert" then


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


		  	sendAction(method,"","","")


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

    		  defalutValue = "corona="

    	    local validation = false
   	    

  	    	native.setKeyboardFocus(nil)

    	    display.getCurrentStage():setFocus( nil )

    	    local function senTimerFun( time_event )

	    	    status="normal"


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

       elseif event.phase == "submitted" then


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

                  native.setKeyboardFocus( nil )


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


      elseif (event>=1048576) then   

       	size =(event/1048576)..' MB'

	  
	  elseif (event > 10485760) then


	    local image = native.showAlert( "Error in Image Upload", "Size of the image cannot be more than 10 MB", { CommonWords.ok } )

	       
      elseif (event>=1024)  then   

      	size = (event/1024)..' KB'


      else      

  	  end


end



function scene:CancelRecordedAudio(data)

	shortmsg_textbox.isVisible = true

	longmsg_textbox.isVisible = true

end




function scene:updateRecordedAudio( dataFileName,audiopagename )

	composer.removeHidden(  )

		local function onTimerRecord( event )

			shortmsg_textbox.isVisible = true

			longmsg_textbox.isVisible = true

		end

		timer.performWithDelay(500,onTimerRecord)


	--local nn = native.showAlert("MUB","HELLO Message" ,{"ok"})


	       dataFileName1 = dataFileName

	       audiopagename = "audiopage"

	       --audio work



		   local filePath = system.pathForFile( dataFileName1, system.DocumentsDirectory )
		            -- Play back the recording
		            local file = io.open( filePath)
		            
			            if file then
			                io.close( file )
			            else
			            	audiovalue="test.wav"
				           	filePath = system.pathForFile( dataFileName1, system.DocumentsDirectory )
			            end


					        local size2 = lfs.attributes(filePath, "size")

							local fileHandle = io.open(filePath, "rb")

							local file_inbytearray = mime.b64( fileHandle:read( "*a" ) )

							formatSizeUnits(size2)



			if filename.isVisible == true then

				if Audio_filename_title.isVisible == false and filename.y == tabBar.y+tabBar.contentHeight+15  then

						Audio_filename_title.y=filename.y+20
						composePage.y = composePage.y+45
				end

			else

				Audio_filename_title.y = tabBar.y+tabBar.contentHeight+15
				composePage.y = composePage.y+45

			end



			Audio_filename_title.isVisible = true

			Audio_filename.isVisible = true

			Audio_filename_close.isVisible = true

			Audio_filename_close.filepath = filePath

			Audio_filename.text = dataFileName1


				Audio_filename.y=Audio_filename_title.y+Audio_filename_title.contentHeight+5
				Audio_filename_close.y=Audio_filename_title.y+Audio_filename_title.contentHeight+5

			

	
end




local function attachAction( event )

	if event.phase == "began" then

	elseif event.phase == "ended" then

			shortmsg_textbox.isVisible=true
				
				AttachmentGroup.alpha=0
				AttachmentGroup:toFront( )

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

			    local options = {

				      		effect = "fromTop",
							time = 200,	
								params = {
								contactId = ContactId,
								MessageType = MessageType,
								page = "compose"
							}

							}

			--if longmsg_textbox then longmsg_textbox:removeSelf( );longmsg_textbox=nil end
			--if shortmsg_textbox then shortmsg_textbox:removeSelf( );shortmsg_textbox=nil end

			longmsg_textbox.isVisible = false
			shortmsg_textbox.isVisible = false

		    composer.showOverlay( "Controller.audioRecordPage",options)

		end

	end

return true

end





local function webListener( event )
    local url = event.url
   
    if 1 == string.find( url, "corona:close" ) then
     
        longmsg_textbox.isVisible=false
       
        updatedresponse = urlDecode(url)


        longMessage = (string.sub( updatedresponse, 13,updatedresponse:len() ))

        local method = ""
 			
 			if string.find( longMessage, "Send" ) then

 				method="SEND"

 				longMessage = string.gsub( longMessage, "Send", "" )

 			elseif string.find( longMessage, "Draft" ) then

 				method="DRAFT"

 				longMessage = string.gsub( longMessage, "Draft", "" )


 			elseif string.find( longMessage, "Schedule" ) then

 				method="SCHEDULE"

 				longMessage = string.gsub( longMessage, "Schedule", "" )



 			end


       if  shortmsg_textbox.text:len() < 1 then

		        local test= string.urlEncode(longMessage)

				local path = system.pathForFile( "messageCKeditor.html",system.DocumentsDirectory )

				local file, errorString = io.open( path, "w+" )

					if not file then

					    print( "File error: " .. errorString )

					else
			
					    file:write( meggageeditor.htmlContent.."'"..test.."'"..meggageeditor.endHtml..""..meggageeditor.buttonHtml )
	 					longmsg_textbox:request( "messageCKeditor.html", system.DocumentsDirectory )
	 					longmsg_textbox.isVisible=true
	 					file:close()
	 				end

 				file=nil

 				local alert = native.showAlert( Message.ErrorTitle , MessagePage.ErrorText , { CommonWords.ok } )

 		else

 			longmsg_textbox:request( "messageCKeditor.html", system.DocumentsDirectory )
 			longmsg_textbox.isVisible=true

 			sendMessage(method)

 		end

    end

    if event.errorCode then
        -- Error loading page
        print( "Error: " .. tostring( event.errorMessage ) )
    end

    return false
end






	local function composemsg_scrollListener(event )

		    local phase = event.phase

		    if ( phase == "began" ) then 

		    	shortmsg_textbox.isVisible = true
		    	longmsg_textbox.isVisible = true


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



local function AttachmentTouch( event )

	if event.phase == "began" then

	elseif event.phase == "ended" then
		if attachment_icon.isVisible == true then

			if AttachmentGroup.alpha <= 0.3 then
				AttachmentGroup.yScale=0.1
				AttachmentGroup.alpha = 1
				shortmsg_textbox.isVisible=false

				transition.from( AttachmentGroup, {time=300,alpha=1} )
				transition.scaleTo( AttachmentGroup, {yScale=1.0, time=300 } )
				
			else
				shortmsg_textbox.isVisible=true
				
				AttachmentGroup.alpha=0	
				AttachmentGroup.yScale = 0.01

				--transition.to( AttachmentGroup, {time=300,alpha=0,yScale=0.01} )

			end

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

				icons_holder_bg.height = icons_holder_bg.height/2

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

-- -------------------------------------------- Video ---------------------------------------------------

-- 				video_icon = display.newImageRect(AttachmentGroup,"res/assert/video1.png",40,35)
-- 				video_icon.x= W/2 - 12
-- 				video_icon.anchorX=0
-- 				video_icon.anchorY=0
-- 				video_icon.y = camera_icon.y
-- 				video_icon.id="video"
-- 				video_icon:addEventListener( "touch", attachAction )


-- 				video_icon_txt = display.newText(AttachmentGroup,MessagePage.Video,0,0,native.systemFont,14)
-- 				video_icon_txt.anchorX = 0
-- 				video_icon_txt.anchorY = 0
-- 				video_icon_txt.x = video_icon.x 
-- 				video_icon_txt.y = video_icon.y+video_icon.contentHeight+5
-- 				video_icon_txt:setFillColor(0)


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




-- -------------------------------------------- Location ---------------------------------------------------

--                 Location_icon = display.newImageRect(AttachmentGroup,"res/assert/location1.png",40,35)
-- 				Location_icon.x= W/2 - 12
-- 				Location_icon.anchorX=0
-- 				Location_icon.anchorY=0
-- 				Location_icon.y = camera_icon.y
-- 				Location_icon.id="location"
-- 				Location_icon:addEventListener( "touch", attachAction )



-- 				Location_icon_txt = display.newText(AttachmentGroup,MessagePage.Location,0,0,native.systemFont,14)
-- 				Location_icon_txt.anchorX = 0
-- 				Location_icon_txt.anchorY = 0
-- 				Location_icon_txt.x = Location_icon.x - 10
-- 				Location_icon_txt.y = Location_icon.y+Location_icon.contentHeight+5
-- 				Location_icon_txt:setFillColor(0)


-- -------------------------------------------- Contact ---------------------------------------------------

--                 Contact_icon = display.newImageRect(AttachmentGroup,"res/assert/user1.png",40,35)
-- 				Contact_icon.x= W/2 + W/3 - 30
-- 				Contact_icon.anchorX=0
-- 				Contact_icon.anchorY=0
-- 				Contact_icon.y = Location_icon.y
-- 				Contact_icon.id="contact"
-- 				Contact_icon:addEventListener( "touch", attachAction )



-- 				Contact_icon_txt = display.newText(AttachmentGroup,MessagePage.Contact,0,0,native.systemFont,14)
-- 				Contact_icon_txt.anchorX = 0
-- 				Contact_icon_txt.anchorY = 0
-- 				Contact_icon_txt.x = Contact_icon.x - 7
-- 				Contact_icon_txt.y = Contact_icon.y+Contact_icon.contentHeight+5
-- 				Contact_icon_txt:setFillColor(0)
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


	attachment_icon = display.newImageRect(sceneGroup,"res/assert/attached.png",20,20)
	attachment_icon.x= W-40;attachment_icon.y = tabBar.y+35
	attachment_icon.isVisible = true
		

	attachment_icon_bg = display.newRect( sceneGroup, W-40, tabBar.y+35, 60, 40 )
	attachment_icon_bg.x=attachment_icon.x
	attachment_icon_bg.y=attachment_icon.y
	attachment_icon_bg:setFillColor( 0.3,0.2,0 )
	attachment_icon_bg.alpha=0.01
	attachment_icon_bg:addEventListener( "touch", AttachmentTouch )


MainGroup:insert(sceneGroup)

end



	function scene:show( event )

		local sceneGroup = self.view
		local phase = event.phase
		
		if phase == "will" then

			


		elseif phase == "did" then

			--composer.removeHidden()

				if event.params and openPagevalue == "addPage" then

					status=event.params.page
					Details = event.params.Details

			    end

			
				sceneevent = event

			--	composer.removeHidden()


			if sceneevent.params then

				filenameval = event.params.filename

			end



			-- scrollView = widget.newScrollView
			-- {
			-- top = RecentTab_Topvalue,
			-- left = 0,
			-- width = W,
			-- height =H-RecentTab_Topvalue,
			-- hideBackground = true,
			-- isBounceEnabled=false,
			-- horizontalScrollDisabled = true,
			-- bottomPadding = 60,
			-- friction = .4,
   -- 			listener = composemsg_scrollListener,
		 --    }

		 --    sceneGroup:insert( scrollView )


---------------------------------------------- Short Message ----------------------------------------------------------

                shortmsg_star = display.newText("*",0,0,native.systemFont,14)
				shortmsg_star.anchorX = 0
				shortmsg_star.anchorY = 0
				shortmsg_star.x=10
				shortmsg_star.y = tabBar.y+tabBar.contentHeight+15
				shortmsg_star:setFillColor(1,0,0)
				composePage:insert(shortmsg_star)
				
				shortmsg_title = display.newText(MessagePage.ShortMessage,0,0,native.systemFont,14)
				shortmsg_title.anchorX = 0
				shortmsg_title.x=shortmsg_star.x + 7
				shortmsg_title.anchorY=0
				shortmsg_title.y = shortmsg_star.y
				shortmsg_title:setFillColor(0)
				composePage:insert(shortmsg_title)


				shortmsg_textbox = native.newTextBox( 10,shortmsg_title.y+ shortmsg_title.height+7, W - 20, EditBoxStyle.height+25)
				shortmsg_textbox.placeholder = MessagePage.ShortMessage_Placeholder
				shortmsg_textbox.isEditable = true
				shortmsg_textbox.size=14
				shortmsg_textbox.anchorX = 0
				shortmsg_textbox.height = EditBoxStyle.height + 20
				shortmsg_textbox.anchorY=0
				shortmsg_textbox.width = W-20
				shortmsg_textbox.value=""
				shortmsg_textbox.isVisible = true
				shortmsg_textbox.id = "shortmessage"
				shortmsg_textbox.hasBackground = true
				shortmsg_textbox:setReturnKey( "next" )
				shortmsg_textbox.inputType = "default"
				--sceneGroup:insert(shortmsg_textbox)
				composePage:insert(shortmsg_textbox)
				--shortmsg_textbox.x=10
				--shortmsg_textbox.y=shortmsg_title.y+ shortmsg_title.height+7


				short_msg_charlimit = display.newText(MessagePage.ShortMsgLimit,0,0,native.systemFont,14)
				short_msg_charlimit.anchorX = 0
				short_msg_charlimit.x=W-123
				short_msg_charlimit.anchorY = 0
				short_msg_charlimit.y = shortmsg_textbox.y+shortmsg_textbox.contentHeight+2
				short_msg_charlimit:setFillColor(0)
				composePage:insert(short_msg_charlimit)

---------------------------------------------- Long Message ----------------------------------------------------------

                longmsg_star = display.newText("*",0,0,native.systemFont,14)
				longmsg_star.anchorX = 0
				longmsg_star.x=10
				longmsg_star.anchorY=0
				longmsg_star.y = short_msg_charlimit.y+short_msg_charlimit.contentHeight
				longmsg_star:setFillColor(1,0,0)
				composePage:insert(longmsg_star)


				longmsg_title = display.newText(MessagePage.LongMessage,0,0,native.systemFont,14)
				longmsg_title.anchorX = 0
				longmsg_title.x=longmsg_star.x + 7
				longmsg_title.anchorY = 0
				longmsg_title.y = longmsg_star.y 
				longmsg_title:setFillColor(0)
				composePage:insert(longmsg_title)


		        content = ""

			    test= string.urlEncode(content)

				local path = system.pathForFile( "messageCKeditor.html",system.DocumentsDirectory )

				local file, errorString = io.open( path, "w+" )

				if not file then

				    print( "File error: " .. errorString )

				else

				     file:write( meggageeditor.htmlContent.."'"..test.."'"..meggageeditor.endHtml..""..meggageeditor.buttonHtml )

							 longmsg_textbox = native.newWebView(10,longmsg_title.y+longmsg_title.contentHeight, W - 12, 310)

							 longmsg_textbox.hasBackground = false

							 longmsg_textbox.isVisible = true

							 longmsg_textbox.anchorX=0;longmsg_textbox.anchorY=0
							 params="test"
							 longmsg_textbox:request( "messageCKeditor.html", system.DocumentsDirectory )

							 longmsg_textbox:addEventListener( "urlRequest", webListener )


							 composePage:insert( longmsg_textbox)




				    file:close()

				end

				file = nil




				long_msg_charlimit = display.newText(MessagePage.LongMsgLimit,0,0,native.systemFont,14)
				long_msg_charlimit.anchorX = 0
				long_msg_charlimit.anchorY = 0
				long_msg_charlimit.x=W-125
				long_msg_charlimit.y = longmsg_textbox.y+longmsg_textbox.contentHeight+5
				long_msg_charlimit:setFillColor(0)
				long_msg_charlimit.isVisible=false
				composePage:insert(long_msg_charlimit)



	

		sceneGroup:insert( composePage )

			createAttachment( )
		AttachmentGroup.anchorX=0;AttachmentGroup.anchorY=0
		AttachmentGroup.alpha=0
		AttachmentGroup.y=AttachmentGroup.y+68
		AttachmentGroup.anchorChildren = true

		sceneGroup:insert( AttachmentGroup )

	

---------------------------------------- File name and its title ------------------------------------------


				filename_title = display.newText("Image Name",0,0,native.systemFont,14)
				filename_title.anchorX = 0
				filename_title.anchorY = 0
				filename_title.x = 10
				filename_title.isVisible = false
				filename_title.y = tabBar.y+tabBar.contentHeight+15
				filename_title:setFillColor(0)
				sceneGroup:insert(filename_title)


				filename = display.newText("",0,0,native.systemFont,14)
				filename.anchorX = 0
				filename.anchorY = 0
				filename.isVisible = false
				filename.x = filename_title.x 
				filename.y = filename_title.y+filename_title.contentHeight+5
				filename:setFillColor(Utils.convertHexToRGB(color.tabBarColor))
				sceneGroup:insert(filename)


				filename_close = display.newImageRect("res/assert/icon-close.png",20,20)
				filename_close.anchorX = 0
				filename_close.anchorY = 0
				filename_close.isVisible = false
				filename_close.x = W - 35
				filename_close.valuestring = "image"
				filename_close.y = filename_title.y+filename_title.contentHeight+8
				sceneGroup:insert(filename_close)

       			 filename_close:addEventListener("touch",attachClose)


---------------------------------------- Audio name and its title ------------------------------------------


				Audio_filename_title = display.newText("Audio Name",0,0,native.systemFont,14)
				Audio_filename_title.anchorX = 0
				Audio_filename_title.anchorY = 0
				Audio_filename_title.x = 10
				Audio_filename_title.isVisible = false
				Audio_filename_title.y = tabBar.y+tabBar.contentHeight+15
				Audio_filename_title:setFillColor(0)
				sceneGroup:insert(Audio_filename_title)


				Audio_filename = display.newText("",0,0,native.systemFont,14)
				Audio_filename.anchorX = 0
				Audio_filename.anchorY = 0
				Audio_filename.isVisible = false
				Audio_filename.x = Audio_filename_title.x 
				Audio_filename.y = Audio_filename_title.y+Audio_filename_title.contentHeight+5
				Audio_filename:setFillColor(Utils.convertHexToRGB(color.tabBarColor))
				sceneGroup:insert(Audio_filename)


				Audio_filename_close = display.newImageRect("res/assert/icon-close.png",20,20)
				Audio_filename_close.anchorX = 0
				Audio_filename_close.anchorY = 0
				Audio_filename_close.isVisible = false
				Audio_filename_close.x = W - 35
				Audio_filename_close.valuestring = "audio"
				Audio_filename_close.y = Audio_filename_title.y+Audio_filename_title.contentHeight+8
				sceneGroup:insert(Audio_filename_close)

        		Audio_filename_close:addEventListener("touch",attachClose)




			menuBtn:addEventListener("touch",menuTouch)

			back_icon:addEventListener("touch",closeMessagePage)
			back_icon_bg:addEventListener("touch",closeMessagePage)
			title:addEventListener("touch",closeMessagePage)

			shortmsg_textbox:addEventListener( "userInput", TextLimitation )
			--longmsg_textbox:addEventListener( "urlRequest", webListener )
			Background:addEventListener("touch",FocusComplete)

	
			Runtime:addEventListener( "key", onKeyEventDetail )
			
		end	
		
	MainGroup:insert(sceneGroup)

	end




	function scene:hide( event )

		local sceneGroup = self.view
		local phase = event.phase

		if event.phase == "will" then

			if longmsg_textbox then longmsg_textbox:removeSelf( );longmsg_textbox=nil end
			-- if shortmsg_textbox then shortmsg_textbox:removeSelf( );shortmsg_textbox=nil end

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


				-- if page == "compose" then

				-- 	event.parent:resumeGame("details",Details,"details")
				-- end


               -- composer.removeHidden()


				back_icon:removeEventListener("touch",closeMessagePage)
			    back_icon_bg:removeEventListener("touch",closeMessagePage)
			    title:removeEventListener("touch",closeMessagePage)

			    shortmsg_textbox:removeEventListener( "userInput", TextLimitation)
				--longmsg_textbox:removeEventListener( "urlRequest", webListener )
				Background:removeEventListener("touch",FocusComplete)

			
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
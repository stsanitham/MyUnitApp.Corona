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
local json = require("json")




--------------- Initialization -------------------

local W = display.contentWidth;H= display.contentHeight

local Background,BgText,title_bg,title

local menuBtn, compose_msg_icon

local messagelist_scrollView

local compose_msg_icon

openPage="pushNotificationListPage"

local RecentTab_Topvalue = 70

local  messageList_array = {}

local sentmessageList_array = {}

local draftmessageList_array = {}

local careerListArray = {}

local sentMessage_list

local BackFlag = false

local tabBarGroup = display.newGroup( )

local pagingvalue = "listpage"



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


		
		local function FocusComplete( event )

		if event.phase == "began" then

		native.setKeyboardFocus(nil)
		display.getCurrentStage():setFocus( event.target )

		display.getCurrentStage():setFocus( event.target )

		elseif event.phase == "ended" then

		display.getCurrentStage():setFocus( nil )

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

		        		timer.performWithDelay( 2000, onTimer )

		                return true

		            elseif BackFlag == true then

					 os.exit() 

		            end
		            
		        end

		    end

		        return false
		 end





		local function composeMessage( event )

			if event.phase == "began" then
					display.getCurrentStage():setFocus( event.target )
			elseif event.phase == "ended" then
					display.getCurrentStage():setFocus( nil )

					local options = {
						effect = "slideLeft",
						time = 300,
						params = {
						         pagevalue = "addpage"
						        }
			            }

					Runtime:removeEventListener( "key", onKeyEvent )

			        composer.gotoScene( "Controller.composeMessagePage", options )

			end

		    return true
			
		end





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






		local function MessageDetailPage(event)


			if event.phase == "began" then
				display.getCurrentStage():setFocus( event.target )
				elseif ( event.phase == "moved" ) then
					local dy = math.abs( ( event.y - event.yStart ) )

					if ( dy > 10 ) then
						display.getCurrentStage():setFocus( nil )
						messagelist_scrollView:takeFocus( event )
					end

					elseif event.phase == "ended" then
					display.getCurrentStage():setFocus( nil )

					local options = {
					isModal = true,
					effect = "slideLeft",
					time = 300,
					params = {
					messagelistvalues = event.target.value
				}
			}

			Runtime:removeEventListener( "key", onKeyEvent )

			composer.showOverlay( "Controller.pushNotificationDetailPage", options )
		    
		    end

		return true

		end




		local function DraftMessageCreation_list( draftmessagelist )

			messagelist_scrollView:scrollToPosition
						{
						    y = 0,
						    time = 100,
						}


			if IsOwner == true then

			compose_msg_icon.isVisible = true
			compose_msg_icon.y = H - 45
			compose_msg_icon.x=W/2+W/3 - 15

			compose_msg_icon:toFront()

		    end


			for j=1, #draftmessageList_array do 
				
				display.remove(draftmessageList_array[#draftmessageList_array])
				draftmessageList_array[#draftmessageList_array] = nil
			end


			for i=1,#draftmessagelist do

		        NoSentMessage.isVisible = false
		        NoScheduleMessage.isVisible = false


				draftmessageList_array[#draftmessageList_array+1] = display.newGroup()

				local tempGroup = draftmessageList_array[#draftmessageList_array]

				local tempHeight = 0

				local background = display.newRect(tempGroup,0,0,W,50)

				if(draftmessageList_array[#draftmessageList_array-1]) ~= nil then
					tempHeight = draftmessageList_array[#draftmessageList_array-1][1].y + draftmessageList_array[#draftmessageList_array-1][1].height+3
				end

				background.anchorY = 0
				background.x=W/2;background.y=tempHeight
				background.alpha=0.01
				background:setFillColor(0,0,0,0.5)
				background.value = draftmessagelist[i]


				
				local timecreated = draftmessagelist[i].MessageDate
				local time = makeTimeStamp(timecreated)



				local Message_time = display.newText(tempGroup,"",0,0,native.systemFont,10)
				Message_time.x=background.x+background.contentWidth/2-65
				Message_time.y=background.y+32
				Message_time.anchorX=0
				Message_time.anchorY = 0
				Utils.CssforTextView(Message_time,sp_labelName)
				Message_time:setFillColor(Utils.convertHexToRGB(color.tabBarColor))
				


					if os.date("%B %d, %Y",time) == os.date("%B %d, %Y",os.time(os.date( "*t" ))) then

					Message_time.text = os.date("%I:%M %p",time)

				    else 


					local t = os.date( "*t" )
					t.day=t.day-1

					if os.date("%B %d, %Y",time) == os.date("%B %d, %Y",os.time(t)) then

						Message_time.text = ChatPage.Yesterday
						Message_time.x = background.x+background.contentWidth/2-70

					else

						Message_time.text = os.date("%B %d, %Y",time)
						Message_time.x = background.x+background.contentWidth/2-75

					end

			     	end


				local Messagedetail_txt = display.newText(tempGroup,draftmessagelist[i].MyUnitBuzzMessage,0,0,W-45,0,native.systemFont,14)
				Messagedetail_txt.x=12
				Messagedetail_txt.y=background.y+7
				Messagedetail_txt.anchorX=0
				Messagedetail_txt.anchorY = 0
				Utils.CssforTextView(Messagedetail_txt,sp_labelName)
				Messagedetail_txt:setFillColor(0,0,0)

				if Messagedetail_txt.text:len() > 60 then

					Messagedetail_txt.text = Messagedetail_txt.text:sub(1,60).."..."
					background.height = 65
					Messagedetail_txt.y=background.y+7

					Message_time.y=background.y+45

				end




     --            print("ImagePath Details : "..imagepath)

                local attachment_img = display.newImageRect(tempGroup,"res/assert/attached.png",20,20)
				attachment_img.anchorX=0
				attachment_img.x = W-35
				attachment_img.isVisible = false
				attachment_img.y=background.y+7
				attachment_img.anchorY = 0
            

               	local attachment_audio = display.newImageRect(tempGroup,"res/assert/record.png",20,20)
				attachment_audio.anchorX=0
				attachment_audio.x = W-35
				attachment_audio.isVisible = false
				attachment_audio.y=background.y+7
				attachment_audio.anchorY = 0
            


                local attachimage , attachaudio
  
---------------------------------image attach--------------------------------------           
         
				if draftmessagelist[i].ImageFilePath == null then

					attachimage = "null"
					
				else

                    attachimage = draftmessagelist[i].ImageFilePath

				end



				if attachimage ~= "null" then

					attachment_img.isVisible = true

				else

					attachment_img.isVisible = false

				end

----------------------------------audio attach--------------------------------------

				if draftmessagelist[i].AudioFilePath == null then

					attachaudio = "null"
					
				else

                    attachaudio = draftmessagelist[i].AudioFilePath

				end



				if attachaudio ~= "null" then

					attachment_audio.isVisible = true

				else

					attachment_audio.isVisible = false

				end




				local line = display.newRect(tempGroup,W/2,background.y,W,1)
				line.y=background.y+background.contentHeight-line.contentHeight
				line:setFillColor(Utility.convertHexToRGB(color.LtyGray))
	

				messagelist_scrollView:insert(tempGroup)

				background:addEventListener( "touch", MessageDetailPage )

			end

		end






		local function SentMessageCreation_list( sentmessagelist )

			messagelist_scrollView:scrollToPosition
						{
						    y = 0,
						    time = 100,
						}


			if IsOwner == true then

			compose_msg_icon.isVisible = true
			compose_msg_icon.y = H - 45
			compose_msg_icon.x=W/2+W/3 - 15

			compose_msg_icon:toFront()

		    end


			for j=1, #sentmessageList_array do 
				
				display.remove(sentmessageList_array[#sentmessageList_array])
				sentmessageList_array[#sentmessageList_array] = nil
			end


			for i=1,#sentmessagelist do

		        NoScheduleMessage.isVisible = false
		        NoDraftMessage.isVisible = false
                 
     --            for j = #draftmessageList_array , 1, -1 do

     --            	display.remove(draftmessageList_array[#draftmessageList_array])
				 --    draftmessageList_array[#draftmessageList_array] = nil

				 -- end


     --            for j = #messageList_array , 1, -1 do

     --            	display.remove(messageList_array[#messageList_array])
				 --    messageList_array[#messageList_array] = nil

     --            end


				sentmessageList_array[#sentmessageList_array+1] = display.newGroup()

				local tempGroup = sentmessageList_array[#sentmessageList_array]

				local tempHeight = 0

				local background = display.newRect(tempGroup,0,0,W,50)

				if(sentmessageList_array[#sentmessageList_array-1]) ~= nil then
					tempHeight = sentmessageList_array[#sentmessageList_array-1][1].y + sentmessageList_array[#sentmessageList_array-1][1].height+3
				end

				background.anchorY = 0
				background.x=W/2;background.y=tempHeight
				background.alpha=0.01
				background:setFillColor(0,0,0,0.5)
				background.value = sentmessagelist[i]
												
				
				local timecreated = sentmessagelist[i].MessageDate
				local time = makeTimeStamp(timecreated)

			--	local timeValue = Utils.getTime(time,"%b-%d-%Y %I:%M %p",TimeZone)



				local Message_time = display.newText(tempGroup,"",0,0,native.systemFont,10)
				Message_time.x=background.x+background.contentWidth/2-65
				Message_time.y=background.y+32
				Message_time.anchorX=0
				Message_time.anchorY = 0
				Utils.CssforTextView(Message_time,sp_labelName)
				Message_time:setFillColor(Utils.convertHexToRGB(color.tabBarColor))
				

					if os.date("%B %d, %Y",time) == os.date("%B %d, %Y",os.time(os.date( "*t" ))) then

					Message_time.text = os.date("%I:%M %p",time)

				    else 


					local t = os.date( "*t" )
					t.day=t.day-1

					if os.date("%B %d, %Y",time) == os.date("%B %d, %Y",os.time(t)) then

						Message_time.text = ChatPage.Yesterday
						Message_time.x = background.x+background.contentWidth/2-70

					else

						Message_time.text = os.date("%B %d, %Y",time)
						Message_time.x = background.x+background.contentWidth/2-75

					end

			     	end



				-- if Message_time.text ~= nil then

				-- parentFlag=true

				-- if parentFlag == true then
				-- parentFlag=false

				-- parentTitle = display.newRect(tempGroup,0,0,W,25)

				-- -- if(messageList_array[#messageList_array-1]) ~= nil then
				-- -- tempHeight = messageList_array[#messageList_array-1][1].y + messageList_array[#messageList_array-1][1].height+3
				-- -- end

				-- parentTitle.anchorY = 0
				-- parentTitle.x=W/2;parentTitle.y=tempHeight+parentTitle.contentHeight/2 - 18
				-- parentTitle:setFillColor(Utility.convertHexToRGB(color.tabBarColor))		


				-- parent_centerText = display.newText(tempGroup,Message_time.text,0,0,native.systemFont,13)
				-- parent_centerText.x=W/2
				-- parent_centerText.anchorX=0
				-- parent_centerText.y=parentTitle.y+parentTitle.contentHeight/2

				-- background.y=parentTitle.y+background.contentHeight/2

				-- end

				-- end


				local Messagedetail_txt = display.newText(tempGroup,sentmessagelist[i].MyUnitBuzzMessage,0,0,W-45,0,native.systemFont,14)
				Messagedetail_txt.x=12
				Messagedetail_txt.y=background.y+7
				Messagedetail_txt.anchorX=0
				Messagedetail_txt.anchorY = 0
				Utils.CssforTextView(Messagedetail_txt,sp_labelName)
				Messagedetail_txt:setFillColor(0,0,0)
				

				if Messagedetail_txt.text:len() > 60 then

					Messagedetail_txt.text = Messagedetail_txt.text:sub(1,60).."..."
					background.height = 65
					Messagedetail_txt.y=background.y+7

					Message_time.y=background.y+45

				end



     --            print("ImagePath Details : "..imagepath)

                local attachment_img = display.newImageRect(tempGroup,"res/assert/attached.png",20,20)
				attachment_img.anchorX=0
				attachment_img.x = W-35
				attachment_img.isVisible = false
				attachment_img.y=background.y+7
				attachment_img.anchorY = 0
            
				local attachment_audio = display.newImageRect(tempGroup,"res/assert/record.png",20,20)
				attachment_audio.anchorX=0
				attachment_audio.x = W-35
				attachment_audio.isVisible = false
				attachment_audio.y=background.y+7
				attachment_audio.anchorY = 0
            


                local attachimage , attachaudio
  
---------------------------------image attach--------------------------------------           
         
				if sentmessagelist[i].ImageFilePath == null then

					attachimage = "null"
					
				else

                    attachimage = sentmessagelist[i].ImageFilePath

				end



				if attachimage ~= "null" then

					attachment_img.isVisible = true

				else

					attachment_img.isVisible = false

				end

----------------------------------audio attach--------------------------------------

				if sentmessagelist[i].AudioFilePath == null then

					attachaudio = "null"
					
				else

                    attachaudio = sentmessagelist[i].AudioFilePath

				end



				if attachaudio ~= "null" then

					attachment_audio.isVisible = true

				else

					attachment_audio.isVisible = false

				end


		

				-- local right_img = display.newImageRect(tempGroup,"res/assert/arrow_1.png",15/2,30/2)
				-- right_img.anchorX=0
				-- right_img.x=background.x+background.contentWidth/2-30;right_img.y=background.y+background.height/2

				local line = display.newRect(tempGroup,W/2,background.y,W,1)
				line.y=background.y+background.contentHeight-line.contentHeight
				line:setFillColor(Utility.convertHexToRGB(color.LtyGray))


				messagelist_scrollView:insert(tempGroup)

				background:addEventListener( "touch", MessageDetailPage )

			end

		end








		local function MessageCreation_list( messagelist )

			messagelist_scrollView:scrollToPosition
						{
						    y = 0,
						    time = 100,
						}

            if IsOwner == true then

			compose_msg_icon.isVisible = true
			compose_msg_icon.y = H - 45
			compose_msg_icon.x=W/2+W/3 - 15

			compose_msg_icon:toFront()

		    end


			for j=1, #messageList_array do 
				
				display.remove(messageList_array[#messageList_array])
				messageList_array[#messageList_array] = nil
			end


			for i=1,#messagelist do
		        NoSentMessage.isVisible = false
		        NoDraftMessage.isVisible = false

		        -- composer.removeHidden()

		  --       for j = #sentmessageList_array , 1, -1 do

    --             	display.remove(sentmessageList_array[#sentmessageList_array])
				--     sentmessageList_array[#sentmessageList_array] = nil

				-- end


    --             for j = #draftmessageList_array , 1, -1 do

    --             	display.remove(draftmessageList_array[#draftmessageList_array])
				--     draftmessageList_array[#draftmessageList_array] = nil

    --             end


				messageList_array[#messageList_array+1] = display.newGroup()

				local tempGroup = messageList_array[#messageList_array]

				local tempHeight = 0

				local background = display.newRect(tempGroup,0,0,W,50)

				if(messageList_array[#messageList_array-1]) ~= nil then
					tempHeight = messageList_array[#messageList_array-1][1].y + messageList_array[#messageList_array-1][1].height+3
				end

				background.anchorY = 0
				background.x=W/2;background.y=tempHeight
				background.alpha=0.01
				background:setFillColor(0,0,0,0.5)
				background.value = messagelist[i]


				local timecreated = messagelist[i].MessageDate
				local time = makeTimeStamp(timecreated)


				local Message_time = display.newText(tempGroup,"",0,0,native.systemFont,10)
				Message_time.x=background.x+background.contentWidth/2-65
				Message_time.y=background.y+32
				Message_time.anchorX=0
				Message_time.anchorY = 0
				Utils.CssforTextView(Message_time,sp_labelName)
				Message_time:setFillColor(Utils.convertHexToRGB(color.tabBarColor))


             --  print(os.date("%B %d, %Y",time) , os.date("%B %d, %Y",os.time(os.date( "*t" ))))

				-- if os.date("%B %d, %Y",time) == os.date("%B %d, %Y",os.time(os.date( "*t" ))) then

				-- Message_time.text = os.date("%I:%M %p",time)
			   
			 --    else

				-- 	local t = os.date( "*t" )
				
				-- 	t.day=t.day-1

				-- 	if os.date("%B %d, %Y",time) == os.date("%B %d, %Y",os.time(os.date( "*t" ))) then

				-- 	Message_time.text = "YESTERDAY"

				-- 	end

			 --    end



					if os.date("%B %d, %Y",time) == os.date("%B %d, %Y",os.time(os.date( "*t" ))) then

					Message_time.text = os.date("%I:%M %p",time)

				    else 


					local t = os.date( "*t" )
					t.day=t.day-1

					if os.date("%B %d, %Y",time) == os.date("%B %d, %Y",os.time(t)) then

						Message_time.text = ChatPage.Yesterday
						Message_time.x = background.x+background.contentWidth/2-70

					else

						Message_time.text = os.date("%B %d, %Y",time)
						Message_time.x = background.x+background.contentWidth/2-75

					end

			     	end



			    --  if Message_time.text ~= nil then

			    --  	parentFlag=true


							-- 	if parentFlag == true then
							-- 	parentFlag=false

							-- 	parentTitle = display.newRect(tempGroup,0,0,W,25)

							-- 		if(messageList_array[#messageList_array-1]) ~= nil then
							-- 		tempHeight = messageList_array[#messageList_array-1][1].y + messageList_array[#messageList_array-1][1].height+3
							-- 		end

							-- 	parentTitle.anchorY = 0
							-- 	parentTitle.x=W/2;parentTitle.y=tempHeight+parentTitle.contentHeight/2
							-- 	parentTitle:setFillColor(Utility.convertHexToRGB(color.tabBarColor))		

								
							-- 	parent_centerText = display.newText(tempGroup,Message_time.text,0,0,native.systemFontBold,14)
								

							-- 	parent_centerText.x=W/2
							-- 	parent_centerText.anchorX=0
							-- 	parent_centerText.y=parentTitle.y+parentTitle.contentHeight/2

							-- 	background.y=parentTitle.y+background.contentHeight/2

						

							-- end


			    --  end


				

				local Messagedetail_txt = display.newText(tempGroup,messagelist[i].MyUnitBuzzMessage,0,0,W-45,0,native.systemFont,14)
				Messagedetail_txt.x=12
				Messagedetail_txt.y=background.y+7
				Messagedetail_txt.anchorX=0
				Messagedetail_txt.anchorY = 0
				Utils.CssforTextView(Messagedetail_txt,sp_labelName)
				Messagedetail_txt:setFillColor(0,0,0)

				if Messagedetail_txt.text:len() > 60 then

					Messagedetail_txt.text = Messagedetail_txt.text:sub(1,60).."..."
					background.height = 65
					Messagedetail_txt.y=background.y+7

					Message_time.y=background.y+45

				end




     --            print("ImagePath Details : "..imagepath)

                local attachment_img = display.newImageRect(tempGroup,"res/assert/attached.png",20,20)
				attachment_img.anchorX=0
				attachment_img.x = W-35
				attachment_img.isVisible = false
				attachment_img.y=background.y+7
				attachment_img.anchorY = 0



				local attachment_audio = display.newImageRect(tempGroup,"res/assert/record.png",20,20)
				attachment_audio.anchorX=0
				attachment_audio.x = W-35
				attachment_audio.isVisible = false
				attachment_audio.y=background.y+7
				attachment_audio.anchorY = 0
            

            

                local attachimage , attachaudio
  
---------------------------------image attach--------------------------------------           
         
				if messagelist[i].ImageFilePath == null then

					attachimage = "null"
					
				else

                    attachimage = messagelist[i].ImageFilePath

				end



				if attachimage ~= "null" then

					attachment_img.isVisible = true

				else

					attachment_img.isVisible = false

				end

----------------------------------audio attach--------------------------------------

				if messagelist[i].AudioFilePath == null then

					attachaudio = "null"
					
				else

                    attachaudio = messagelist[i].AudioFilePath

				end



				if attachaudio ~= "null" then

					attachment_audio.isVisible = true

				else

					attachment_audio.isVisible = false

				end







				-- local right_img = display.newImageRect(tempGroup,"res/assert/arrow_1.png",15/2,30/2)
				-- right_img.anchorX=0
				-- right_img.x=background.x+background.contentWidth/2-30;right_img.y=background.y+background.height/2


				local line = display.newRect(tempGroup,W/2,background.y,W,1)
				line.y=background.y+background.contentHeight-line.contentHeight
				line:setFillColor(Utility.convertHexToRGB(color.LtyGray))
	

				messagelist_scrollView:insert(tempGroup)

				background:addEventListener( "touch", MessageDetailPage )

			end

		end










	-- 	function updateAudioValues(audiovalues)

	-- 		print("ertertet64636265642563452345623")

	-- 			if  audiovalues.MessageStatus == "SCHEDULE" and tab_Group.id =="schedule" then

	-- 				print("schedule coming")

	-- 					tab_Schedule_txt:setFillColor( Utils.convertHexToRGB(color.tabBarColor)  )
	-- 					tab_Sent_txt:setFillColor(0)
	-- 					tab_Draft_txt:setFillColor(0)

	-- 					tab_Group_bottombar.isVisible = true
	-- 					tab_Group_bottombar.y = tabBg.y+29.5
	-- 					tab_Group_bottombar.x = W/2 - W/3


	-- 					for j=1, #messageList_array do 

	-- 						display.remove(messageList_array[#messageList_array])
	-- 						messageList_array[#messageList_array] = nil
	-- 					end

         

	-- 		local function getScheduleMessageList(response)

	-- 			messagelist_response = response

	-- 				if messagelist_response ~= nil and #messagelist_response ~= 0 and messagelist_response ~= "" then
							
	-- 					MessageCreation_list(messagelist_response)
	-- 					NoScheduleMessage.isVisible=false

	-- 					     for j = 1, #sentmessageList_array do

	-- 		                	display.remove(sentmessageList_array[#sentmessageList_array])
	-- 						    sentmessageList_array[#sentmessageList_array] = nil

	-- 				         end


	-- 				         for j = 1, #draftmessageList_array do

	-- 		                	display.remove(draftmessageList_array[#draftmessageList_array])
	-- 						    draftmessageList_array[#draftmessageList_array] = nil

	-- 				         end


	-- 				else

	-- 					NoScheduleMessage.isVisible=true

	-- 						 for j = 1, #sentmessageList_array do

	-- 		                	display.remove(sentmessageList_array[#sentmessageList_array])
	-- 						    sentmessageList_array[#sentmessageList_array] = nil

	-- 				         end


	-- 				         for j = 1, #draftmessageList_array do

	-- 		                	display.remove(draftmessageList_array[#draftmessageList_array])
	-- 						    draftmessageList_array[#draftmessageList_array] = nil

	-- 				         end


	-- 				end

	-- 		   end



	-- 				Webservice.GetMessagessListbyMessageStatus("SCHEDULE",getScheduleMessageList)

                

	-- elseif  audiovalues.MessageStatus == "SEND" and tab_Message.id=="sent" then

	-- 				print("sent coming")


	-- 			tab_Schedule_txt:setFillColor( 0 )
	-- 			tab_Sent_txt:setFillColor( Utils.convertHexToRGB(color.tabBarColor) )
	-- 			tab_Draft_txt:setFillColor(0)

	-- 			tab_Group_bottombar.isVisible = true
	-- 			tab_Group_bottombar.y = tabBg.y+29.5
	-- 			tab_Group_bottombar.x = W/2


	-- 			for j=1, #sentmessageList_array do 

	-- 						display.remove(sentmessageList_array[#sentmessageList_array])
	-- 						sentmessageList_array[#sentmessageList_array] = nil
	-- 			end



	-- 		   local function getSentMessageList(response)

	-- 			  sentmessage_response = response

	-- 				if sentmessage_response ~= nil and #sentmessage_response ~= 0 and sentmessage_response ~= "" then
							
	-- 					SentMessageCreation_list(sentmessage_response)
	-- 					NoSentMessage.isVisible=false

	-- 					    for j = 1, #draftmessageList_array do

	-- 		                	display.remove(draftmessageList_array[#draftmessageList_array])
	-- 						    draftmessageList_array[#draftmessageList_array] = nil

	-- 				         end


	-- 				         for j = 1 , #messageList_array do

	-- 		                	display.remove(messageList_array[#messageList_array])
	-- 						    messageList_array[#messageList_array] = nil

	-- 				         end

	-- 				else

	-- 					NoSentMessage.isVisible=true

	-- 						for j = 1, #draftmessageList_array do

	-- 		                	display.remove(draftmessageList_array[#draftmessageList_array])
	-- 						    draftmessageList_array[#draftmessageList_array] = nil

	-- 				         end


	-- 				         for j = 1, #messageList_array do

	-- 		                	display.remove(messageList_array[#messageList_array])
	-- 						    messageList_array[#messageList_array] = nil

	-- 				         end


	-- 				end


	-- 		    end



	-- 				Webservice.GetMessagessListbyMessageStatus("SENT",getSentMessageList)
			    


 --  elseif  audiovalues.MessageStatus == "DRAFT" and tab_Contact.id == "draft" then

	-- 				print("draft coming")



	-- 			tab_Schedule_txt:setFillColor( 0 )
	-- 			tab_Sent_txt:setFillColor(0)
	-- 			tab_Draft_txt:setFillColor(Utils.convertHexToRGB(color.tabBarColor) )

	-- 			tab_Group_bottombar.isVisible = true
	-- 			tab_Group_bottombar.y = tabBg.y+29.5
	-- 			tab_Group_bottombar.x = W/2 + W/3



	-- 					for j=1, #draftmessageList_array do 

	-- 						display.remove(draftmessageList_array[#draftmessageList_array])
	-- 						draftmessageList_array[#draftmessageList_array] = nil
	-- 					end



	-- 					function getDraftMessageList1(response)


	-- 						draftmessagelist_response = response


	-- 							if draftmessagelist_response ~= nil and #draftmessagelist_response ~= 0 and draftmessagelist_response ~= "" then

	-- 								DraftMessageCreation_list(draftmessagelist_response)
	-- 								NoDraftMessage.isVisible=false
	-- 								NoScheduleMessage.isVisible=false
	-- 								NoSentMessage.isVisible=false

	-- 									for j = 1, #sentmessageList_array do

	-- 									display.remove(sentmessageList_array[#sentmessageList_array])
	-- 									sentmessageList_array[#sentmessageList_array] = nil

	-- 									end


	-- 									for j = 1 , #messageList_array do

	-- 									display.remove(messageList_array[#messageList_array])
	-- 									messageList_array[#messageList_array] = nil

	-- 									end


	-- 							else

	-- 								NoDraftMessage.isVisible=true


	-- 									for j = 1, #sentmessageList_array do

	-- 									display.remove(sentmessageList_array[#sentmessageList_array])
	-- 									sentmessageList_array[#sentmessageList_array] = nil

	-- 									end


	-- 									for j = 1 , #messageList_array do

	-- 									display.remove(messageList_array[#messageList_array])
	-- 									messageList_array[#messageList_array] = nil

	-- 									end



	-- 							end


	-- 					end


	-- 				Webservice.GetMessagessListbyMessageStatus("DRAFT",getDraftMessageList1)
               
				
	-- 			 end

	-- 	end






		local function resumeCallList(listview_values)

	 		print("ertertet64636265642563452345623 : "..listview_values)


	 		listview_values = json.decode( listview_values)


	 		print( "Status : "..listview_values.MessageStatus )

	  			if tab_Message.id=="schedule" then


						tab_Schedule_txt:setFillColor( Utils.convertHexToRGB(color.tabBarColor)  )
						tab_Sent_txt:setFillColor(0)
						tab_Draft_txt:setFillColor(0)

						tab_Group_bottombar.isVisible = true
						tab_Group_bottombar.y = tabBg.y+29.5
						tab_Group_bottombar.x = W/2 - W/3


						for j=1, #messageList_array do 

							display.remove(messageList_array[#messageList_array])
							messageList_array[#messageList_array] = nil
						end

         

			local function getScheduleMessageList(response)

				messagelist_response = response

					if messagelist_response ~= nil and #messagelist_response ~= 0 and messagelist_response ~= "" then
							
						MessageCreation_list(messagelist_response)
						NoScheduleMessage.isVisible=false

						     for j = 1, #sentmessageList_array do

			                	display.remove(sentmessageList_array[#sentmessageList_array])
							    sentmessageList_array[#sentmessageList_array] = nil

					         end


					         for j = 1, #draftmessageList_array do

			                	display.remove(draftmessageList_array[#draftmessageList_array])
							    draftmessageList_array[#draftmessageList_array] = nil

					         end


					else

						NoScheduleMessage.isVisible=true

							 for j = 1, #sentmessageList_array do

			                	display.remove(sentmessageList_array[#sentmessageList_array])
							    sentmessageList_array[#sentmessageList_array] = nil

					         end


					         for j = 1, #draftmessageList_array do

			                	display.remove(draftmessageList_array[#draftmessageList_array])
							    draftmessageList_array[#draftmessageList_array] = nil

					         end


					end

			   end



					Webservice.GetMessagessListbyMessageStatus("SCHEDULE",getScheduleMessageList)

                

	 elseif  tab_Message.id=="sent" then


				tab_Schedule_txt:setFillColor( 0 )
				tab_Sent_txt:setFillColor( Utils.convertHexToRGB(color.tabBarColor) )
				tab_Draft_txt:setFillColor(0)

				tab_Group_bottombar.isVisible = true
				tab_Group_bottombar.y = tabBg.y+29.5
				tab_Group_bottombar.x = W/2


				for j=1, #sentmessageList_array do 

							display.remove(sentmessageList_array[#sentmessageList_array])
							sentmessageList_array[#sentmessageList_array] = nil
				end



			   local function getSentMessageList(response)

				  sentmessage_response = response

					if sentmessage_response ~= nil and #sentmessage_response ~= 0 and sentmessage_response ~= "" then
							
						SentMessageCreation_list(sentmessage_response)
						NoSentMessage.isVisible=false

						    for j = 1, #draftmessageList_array do

			                	display.remove(draftmessageList_array[#draftmessageList_array])
							    draftmessageList_array[#draftmessageList_array] = nil

					         end


					         for j = 1 , #messageList_array do

			                	display.remove(messageList_array[#messageList_array])
							    messageList_array[#messageList_array] = nil

					         end

					else

						NoSentMessage.isVisible=true

							for j = 1, #draftmessageList_array do

			                	display.remove(draftmessageList_array[#draftmessageList_array])
							    draftmessageList_array[#draftmessageList_array] = nil

					         end


					         for j = 1, #messageList_array do

			                	display.remove(messageList_array[#messageList_array])
							    messageList_array[#messageList_array] = nil

					         end


					end


			    end



					Webservice.GetMessagessListbyMessageStatus("SENT",getSentMessageList)
			    


   elseif  tab_Message.id=="draft" then

				tab_Schedule_txt:setFillColor( 0 )
				tab_Sent_txt:setFillColor(0)
				tab_Draft_txt:setFillColor(Utils.convertHexToRGB(color.tabBarColor) )

				tab_Group_bottombar.isVisible = true
				tab_Group_bottombar.y = tabBg.y+29.5
				tab_Group_bottombar.x = W/2 + W/3



						-- for j=1, #draftmessageList_array do 

						-- 	display.remove(draftmessageList_array[#draftmessageList_array])
						-- 	draftmessageList_array[#draftmessageList_array] = nil
						-- end



						function getDraftMessageList1(response)


							draftmessagelist_response = response


								if draftmessagelist_response ~= nil and #draftmessagelist_response ~= 0 and draftmessagelist_response ~= "" then

									DraftMessageCreation_list(draftmessagelist_response)
									NoDraftMessage.isVisible=false
									NoScheduleMessage.isVisible=false
									NoSentMessage.isVisible=false

										for j = 1, #sentmessageList_array do

										display.remove(sentmessageList_array[#sentmessageList_array])
										sentmessageList_array[#sentmessageList_array] = nil

										end


										for j = 1 , #messageList_array do

										display.remove(messageList_array[#messageList_array])
										messageList_array[#messageList_array] = nil

										end


								else

									NoDraftMessage.isVisible=true


										for j = 1, #sentmessageList_array do

										display.remove(sentmessageList_array[#sentmessageList_array])
										sentmessageList_array[#sentmessageList_array] = nil

										end


										for j = 1 , #messageList_array do

										display.remove(messageList_array[#messageList_array])
										messageList_array[#messageList_array] = nil

										end



								end


						end


					Webservice.GetMessagessListbyMessageStatus("DRAFT",getDraftMessageList1)
               
				

				-- elseif status == "back" then

				-- 	print("nothing %%%%%")

				-- 	composer.hideOverlay( "slideRight", 300 )


		 end



		end





       
		function scene:resumeGame(value,messagelistvalue)



			if value == "back" then


	        Runtime:addEventListener( "key", onKeyEvent )

	           	local function waitTimer( event )


				if messagelistvalue.MessageStatus == "SCHEDULE" then


						for j=1, #messageList_array do 

							display.remove(messageList_array[#messageList_array])
							messageList_array[#messageList_array] = nil
						end


					Webservice.GetMessagessListbyMessageStatus("SCHEDULE",getScheduleMessageList)


				elseif messagelistvalue.MessageStatus == "SENT" then

						for j=1, #sentmessageList_array do 

							display.remove(sentmessageList_array[#sentmessageList_array])
							sentmessageList_array[#sentmessageList_array] = nil
						end


					Webservice.GetMessagessListbyMessageStatus("SENT",getSentMessageList)


				elseif messagelistvalue.MessageStatus == "DRAFT" then


						for j=1, #draftmessageList_array do 

							display.remove(draftmessageList_array[#draftmessageList_array])
							draftmessageList_array[#draftmessageList_array] = nil
						end


						function getDraftMessageList1(response)


							draftmessagelist_response = response


								if draftmessagelist_response ~= nil and #draftmessagelist_response ~= 0 and draftmessagelist_response ~= "" then

									DraftMessageCreation_list(draftmessagelist_response)
									NoDraftMessage.isVisible=false

								else

									NoDraftMessage.isVisible=true

								end


						end


					Webservice.GetMessagessListbyMessageStatus("DRAFT",getDraftMessageList1)
               


				 end


				end

				 	timer.performWithDelay( 500, waitTimer )

			end


		end




		



	function scene:resumeGame(value,EditArray,pagevalue)



	    if value == "edit" then


	    	pagevalue = "editpage"

					local options = {
						isModal = true,
						effect = "slideLeft",
						time = 300,
						params = {
						Details = EditArray,
						value = "edit",
						page = pagevalue

					}
				}



				composer.showOverlay( "Controller.composeMessagePage", options )

		elseif value == "details" then

			local function waitTimer( event )

				if openPage == "pushNotificationListPage" then

					local options = {
							isModal = true,
							effect = "slideLeft",
							time = 1,
							params = {
							messagelistvalues = EditArray,
							photowidthval = photowidthvalue,
							photoheightval = photoheightvalue
						}
					}

				composer.showOverlay( "Controller.pushNotificationDetailPage", options )

				end

			end


			timer.performWithDelay( 500, waitTimer )

		elseif value == "back" then

				

	   -- search.isVisible=true

			-- local function waitTimer( event )
			-- 	if openPage=="eventCalenderPage" then
			-- 			local temp = os.date( '*t' )
			-- 			temp.day = temp.day - os.date( "%w" ) 
			-- 			weekViewTouchFlag=true
			-- 			ParentShow=true
			-- 			creatWeek(temp,true)

			-- 	end
			-- end

			 	local function waitTimer( event )


			 		if openPage == "pushNotificationListPage" then

					 		Runtime:addEventListener( "key", onKeyEvent )


						if messagelistvalue.MessageStatus == "SCHEDULE" then


								for j=1, #messageList_array do 

									display.remove(messageList_array[#messageList_array])
									messageList_array[#messageList_array] = nil
								end


							Webservice.GetMessagessListbyMessageStatus("SCHEDULE",getScheduleMessageList)


						elseif messagelistvalue.MessageStatus == "SENT" then

								for j=1, #sentmessageList_array do 

									display.remove(sentmessageList_array[#sentmessageList_array])
									sentmessageList_array[#sentmessageList_array] = nil
								end


							Webservice.GetMessagessListbyMessageStatus("SENT",getSentMessageList)


						elseif messagelistvalue.MessageStatus == "DRAFT" then


								for j=1, #draftmessageList_array do 

									display.remove(draftmessageList_array[#draftmessageList_array])
									draftmessageList_array[#draftmessageList_array] = nil
								end


								function getDraftMessageList1(response)


									draftmessagelist_response = response


										if draftmessagelist_response ~= nil and #draftmessagelist_response ~= 0 and draftmessagelist_response ~= "" then

											DraftMessageCreation_list(draftmessagelist_response)
											NoDraftMessage.isVisible=false

										else

											NoDraftMessage.isVisible=true

										end


								end


							Webservice.GetMessagessListbyMessageStatus("DRAFT",getDraftMessageList1)
		               


						 end

					end


				end


			timer.performWithDelay( 500, waitTimer )

			

	    end

	end







	local function MessageList_scrollListener( event )

		    local phase = event.phase

		    if ( phase == "began" ) then 

		    elseif ( phase == "moved" ) then

		    elseif ( phase == "ended" ) then 

		    end


		    if ( event.limitReached ) then

		        if ( event.direction == "up" ) then print( "Reached bottom limit" )
		        	
		        elseif ( event.direction == "down" ) then print( "Reached top limit" )

		        elseif ( event.direction == "left" ) then print( "Reached right limit" )

		        elseif ( event.direction == "right" ) then print( "Reached left limit" )

		        end

		    end

		    return true
	end






local function TabbarTouch( event )

		if event.phase == "began" then 

		elseif event.phase == "ended" then
			
			if event.target.id == "schedule" then

				tab_Schedule_txt:setFillColor( Utils.convertHexToRGB(color.tabBarColor) )
				tab_Sent_txt:setFillColor(0)
				tab_Draft_txt:setFillColor(0)

				tab_Group_bottombar.isVisible = true
				tab_Group_bottombar.y = tabBg.y+29.5
				tab_Group_bottombar.x = W/2-W/3

				NoSentMessage.isVisible = false
				NoDraftMessage.isVisible = false

				composer.removeHidden()

					local function getScheduleMessageList(response)

					messagelist_response = response

						if messagelist_response ~= nil and #messagelist_response ~= 0 and messagelist_response ~= "" then
								
							MessageCreation_list(messagelist_response)
							NoScheduleMessage.isVisible=false

							     for j = 1, #sentmessageList_array do

				                	display.remove(sentmessageList_array[#sentmessageList_array])
								    sentmessageList_array[#sentmessageList_array] = nil

						         end


						         for j = 1, #draftmessageList_array do

				                	display.remove(draftmessageList_array[#draftmessageList_array])
								    draftmessageList_array[#draftmessageList_array] = nil

						         end


						else

							NoScheduleMessage.isVisible=true

								 for j = 1, #sentmessageList_array do

				                	display.remove(sentmessageList_array[#sentmessageList_array])
								    sentmessageList_array[#sentmessageList_array] = nil

						         end


						         for j = 1, #draftmessageList_array do

				                	display.remove(draftmessageList_array[#draftmessageList_array])
								    draftmessageList_array[#draftmessageList_array] = nil

						         end


						end

				   end


				Webservice.GetMessagessListbyMessageStatus("SCHEDULE",getScheduleMessageList)

			elseif event.target.id == "sent" then

				tab_Sent_txt:setFillColor( Utils.convertHexToRGB(color.tabBarColor) )
				tab_Draft_txt:setFillColor(0)
				tab_Schedule_txt:setFillColor(0)

				tab_Group_bottombar.isVisible = true
				tab_Group_bottombar.y = tabBg.y+29.5
				tab_Group_bottombar.x = W/2

				NoScheduleMessage.isVisible = false
				NoDraftMessage.isVisible = false

				composer.removeHidden()


				local function getSentMessageList(response)

				sentmessage_response = response

					if sentmessage_response ~= nil and #sentmessage_response ~= 0 and sentmessage_response ~= "" then
							
						SentMessageCreation_list(sentmessage_response)
						NoSentMessage.isVisible=false

						    for j = 1, #draftmessageList_array do

			                	display.remove(draftmessageList_array[#draftmessageList_array])
							    draftmessageList_array[#draftmessageList_array] = nil

					         end


					         for j = 1 , #messageList_array do

			                	display.remove(messageList_array[#messageList_array])
							    messageList_array[#messageList_array] = nil

					         end

					else

						NoSentMessage.isVisible=true

							for j = 1, #draftmessageList_array do

			                	display.remove(draftmessageList_array[#draftmessageList_array])
							    draftmessageList_array[#draftmessageList_array] = nil

					         end


					         for j = 1, #messageList_array do

			                	display.remove(messageList_array[#messageList_array])
							    messageList_array[#messageList_array] = nil

					         end


					end


			    end


				Webservice.GetMessagessListbyMessageStatus("SENT",getSentMessageList)
				
			elseif event.target.id == "draft" then

				tab_Draft_txt:setFillColor( Utils.convertHexToRGB(color.tabBarColor) )
				tab_Sent_txt:setFillColor(0)
				tab_Schedule_txt:setFillColor(0)

				tab_Group_bottombar.isVisible = true
				tab_Group_bottombar.y = tabBg.y+29.5
				tab_Group_bottombar.x = W/2+W/3


				composer.removeHidden()

				NoSentMessage.isVisible = false
				NoScheduleMessage.isVisible = false


				local function getDraftMessageList(response)

				draftmessage_response = response

					if draftmessage_response ~= nil and #draftmessage_response ~= 0 and draftmessage_response ~= "" then
							
						DraftMessageCreation_list(draftmessage_response)
						NoDraftMessage.isVisible=false


							for j = 1, #sentmessageList_array do

			                	display.remove(sentmessageList_array[#sentmessageList_array])
							    sentmessageList_array[#sentmessageList_array] = nil

					         end


					         for j = 1, #messageList_array do

			                	display.remove(messageList_array[#messageList_array])
							    messageList_array[#messageList_array] = nil

					         end

					else

						NoDraftMessage.isVisible=true

							for j = 1, #sentmessageList_array do

			                	display.remove(sentmessageList_array[#sentmessageList_array])
							    sentmessageList_array[#sentmessageList_array] = nil

					         end


					         for j = 1, #messageList_array  do

			                	display.remove(messageList_array[#messageList_array])
							    messageList_array[#messageList_array] = nil

					         end


					end


			     end



				Webservice.GetMessagessListbyMessageStatus("DRAFT",getDraftMessageList)

			    
			end

	    end

    return true 

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

	if IsOwner == true then

	title_bg = display.newRect(sceneGroup,0,0,W,30)
	title_bg.x=W/2;title_bg.y = tabBar.y+tabBar.contentHeight-5
	title_bg:setFillColor(1,1,1,0.3)

    else

    title_bg = display.newRect(sceneGroup,0,0,W,30)
	title_bg.x=W/2;title_bg.y = tabBar.y+tabBar.contentHeight-5
	title_bg:setFillColor(0,0,0,0.3)

	end 


	title = display.newText(sceneGroup,Message.PageTitle,0,0,native.systemFont,18)
	title.anchorX = 0
	title.x=12;title.y = title_bg.y
	title:setFillColor(0)

	compose_msg_icon = display.newImageRect(sceneGroup,"res/assert/addevent.png", 66/1.6,66/1.8)
	compose_msg_icon.anchorX = 0
	compose_msg_icon.isVisible = false
	compose_msg_icon.x=W/2+W/3+12
	compose_msg_icon.y = title_bg.y+3


	Background:addEventListener("touch",FocusComplete)


MainGroup:insert(sceneGroup)

end





	function scene:show( event )

		local sceneGroup = self.view
		local phase = event.phase
		
		if phase == "will" then


			if event.params then

				list_values = event.params.pushlistvalues
				pagingvalue = event.params.page

			end

			totalvalues = list_values


			
			NoScheduleMessage = display.newText( sceneGroup,MessagePage.NoMessage, 0,0,0,0,native.systemFontBold,16)
			NoScheduleMessage.x=W/2;NoScheduleMessage.y=H/2
			NoScheduleMessage.isVisible=false
			NoScheduleMessage:setFillColor( Utils.convertHexToRGB(color.Black) )

			NoSentMessage = display.newText( sceneGroup,MessagePage.NoMessage , 0,0,0,0,native.systemFontBold,16)
			NoSentMessage.x=W/2;NoSentMessage.y=H/2
			NoSentMessage.isVisible=false
			NoSentMessage:setFillColor( Utils.convertHexToRGB(color.Black) )

			NoDraftMessage = display.newText( sceneGroup,MessagePage.NoMessage, 0,0,0,0,native.systemFontBold,16)
			NoDraftMessage.x=W/2;NoDraftMessage.y=H/2
			NoDraftMessage.isVisible=false
			NoDraftMessage:setFillColor( Utils.convertHexToRGB(color.Black) )


			if IsOwner == true then

			compose_msg_icon.isVisible = true
			compose_msg_icon.y = H - 45
			compose_msg_icon.x=W/2+W/3 - 15


			tabBg = display.newRect( tabBarGroup, W/2,title_bg.y+title_bg.height/2+3, W, 40 )
			tabBg.anchorY=0
			tabBg.height = 33
			tabBg.y = title_bg.y+title_bg.height/2+3
			tabBg:setFillColor( Utils.convertHexToRGB(color.LtyGray) )
			--tabBg.strokeWidth = 1
			--tabBg:setStrokeColor( 0,0,0,0.7)
			--sceneGroup:insert(tabBg)

			tab_Group = display.newRect(tabBarGroup,0,0,97,33)
			tab_Group.x=W/2-W/3;tab_Group.y=tabBg.y
			tab_Group.anchorY=0
			tab_Group.alpha=1
			tab_Group.id="schedule"
			tab_Group:setFillColor( Utils.convertHexToRGB(color.LtyGray) )
			--tab_Group:setStrokeColor(0)
			--tab_Group.strokeWidth = 1
			--sceneGroup:insert(tab_Group)


			tab_Message = display.newRect(tabBarGroup,0,0,103.33,33)
			tab_Message.x=W/2;tab_Message.y=tabBg.y
			tab_Message.anchorY=0
			tab_Message.alpha=1
			tab_Message.id="sent"
			--tab_Message:setStrokeColor(0,0,0,0.7)
			--tab_Message.strokeWidth = 1
			tab_Message:setFillColor(  Utils.convertHexToRGB(color.LtyGray) )
			--sceneGroup:insert(tab_Message)


			tab_Contact = display.newRect(tabBarGroup,0,0,97,33)
			tab_Contact.x=W/2+W/3;tab_Contact.y=tabBg.y
			tab_Contact.anchorY=0
			tab_Contact.alpha=1
			tab_Contact.id="draft"
			--tab_Contact:setStrokeColor(0)
			--tab_Contact.strokeWidth = 1
			tab_Contact:setFillColor(  Utils.convertHexToRGB(color.LtyGray) )
			--sceneGroup:insert(tab_Contact)


			tab_Schedule_txt = display.newText( tabBarGroup, MessagePage.ScheduleText,0,0,native.systemFont,14 )
			tab_Schedule_txt.x=tab_Group.x;
			tab_Schedule_txt.y=tab_Group.y+tab_Group.contentHeight/2-2
			tab_Schedule_txt:setFillColor( Utils.convertHexToRGB(color.tabBarColor) )
			--sceneGroup:insert(tab_Schedule_txt)

			tab_Sent_txt = display.newText( tabBarGroup, MessagePage.SentText,0,0,native.systemFont,14 )
			tab_Sent_txt.x=tab_Message.x;
			tab_Sent_txt.y=tab_Message.y+tab_Message.contentHeight/2-2
			tab_Sent_txt:setFillColor( 0 )
			--sceneGroup:insert(tab_Sent_txt)

			tab_Draft_txt = display.newText( tabBarGroup, MessagePage.DraftText,0,0,native.systemFont,14 )
			tab_Draft_txt.x=tab_Contact.x;
			tab_Draft_txt.y=tab_Contact.y+tab_Contact.contentHeight/2-2
			tab_Draft_txt:setFillColor( 0 )
			--sceneGroup:insert(tab_Draft_txt)


			tab_Group_bottombar = display.newRect(tabBarGroup,0,0,107.33,3)
			tab_Group_bottombar.x= W/2 - W/3
			tab_Group_bottombar.y=tabBg.y+29.5
			tab_Group_bottombar.anchorY = 0
			tab_Group_bottombar.alpha=1
			tab_Group_bottombar:setFillColor(Utility.convertHexToRGB(color.tabBarColor))
			tab_Group_bottombar.isVisible = true


			sceneGroup:insert(tabBarGroup)


			tab_Group:addEventListener( "touch", TabbarTouch )
			tab_Message:addEventListener( "touch", TabbarTouch )
			tab_Contact:addEventListener( "touch", TabbarTouch )


			messagelist_scrollView = widget.newScrollView
						{
							top = RecentTab_Topvalue+tabBg.height+5,
							left = 0,
							width = W,
							height =H-RecentTab_Topvalue-tabBg.height-5,
							bottomPadding = 50,
							hideBackground = true,
							isBounceEnabled=false,
							horizontalScrollingDisabled = true,
							verticalScrollingDisabled = false,
							--listener = MessageList_scrollListener,
						}


		    sceneGroup:insert(messagelist_scrollView)


		    else

			messagelist_scrollView = widget.newScrollView
						{
							top = RecentTab_Topvalue,
							left = 0,
							width = W,
							height =H-RecentTab_Topvalue,
							bottomPadding = 50,
							hideBackground = true,
							isBounceEnabled=false,
							horizontalScrollingDisabled = true,
							verticalScrollingDisabled = false,
							--listener = MessageList_scrollListener,
						}

		    sceneGroup:insert(messagelist_scrollView)

			end


			-- if event.params then

			-- 	audiopathvalues = event.params.audiovalues

			-- 	print(json.encode(audiopathvalues))


			-- 	updateAudioValues(audiopathvalues)

			-- end




		elseif phase == "did" then

			composer.removeHidden()

			compose_msg_icon:toFront()






			function getScheduleMessageList(response)

				messagelist_response = response

					if messagelist_response ~= nil and #messagelist_response ~= 0 and messagelist_response ~= "" then
							
						MessageCreation_list(messagelist_response)
						NoScheduleMessage.isVisible=false

					else

						NoScheduleMessage.isVisible=true

					end

			end



			function getSentMessageList(response)


				sentmessage_response = response

					if sentmessage_response ~= nil and #sentmessage_response ~= 0 and sentmessage_response ~= "" then
							
						SentMessageCreation_list(sentmessage_response)
						NoSentMessage.isVisible=false

					else

						NoSentMessage.isVisible=true

					end


			end




			if pagingvalue == "listpage" then	


			-- 	page_value_name = event.params.page_val

			-- 	editpagevalues = event.params.editpagevalue

			-- 	Imagepath = event.params.Imagepathname

			-- 	-- photowidthvalue = event.params.photowidth

			-- 	-- photoheightvalue = event.params.photoheight

			-- 	-- print(photowidthvalue.."                          "..photoheightvalue)

			-- 	if page_value_name == "editpage" then

			-- 		scene:resumeCall(editpagevalues)

			-- 	end

			-- else

	            if IsOwner == true then

				Webservice.GetMessagessListbyMessageStatus("SCHEDULE",getScheduleMessageList)

			    else

			    Webservice.GetMessagessListbyMessageStatus("SENT",getSentMessageList)

			    end

			elseif pagingvalue == "compose" then

				resumeCallList(totalvalues)

		    end



			menuBtn:addEventListener("touch",menuTouch)
			compose_msg_icon:addEventListener("touch",composeMessage)

            Runtime:addEventListener( "key", onKeyEvent )

			
		end	
		
	MainGroup:insert(sceneGroup)

	end





		function scene:hide( event )

			local sceneGroup = self.view
			local phase = event.phase

			if event.phase == "will" then

					-- for j=MainGroup.numChildren, 1, -1 do 
					-- display.remove(MainGroup[MainGroup.numChildren])
					-- MainGroup[MainGroup.numChildren] = nil
					-- end

					menuBtn:removeEventListener("touch",menuTouch)
					compose_msg_icon:removeEventListener("touch",composeMessage)
					Runtime:removeEventListener( "key", onKeyEvent )
					Background:removeEventListener("touch",FocusComplete)


			elseif phase == "did" then

					-- for j=1,#messageList_array do 
					-- 	if messageList_array[j] then messageList_array[j]:removeSelf();messageList_array[j] = nil	end
					-- end

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
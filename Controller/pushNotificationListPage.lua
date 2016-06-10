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

local photow = "";photoh = ""

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

local listType = ""

local pageCount = 0
local totalListCount = 0
local notifyFlag = false

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
			messagelistvalues = event.target.value,
			photowidthval = widthv,
			photoheightval = heightv
		}
	}

	Runtime:removeEventListener( "key", onKeyEvent )

	composer.showOverlay( "Controller.pushNotificationDetailPage", options )
    
    end

return true

end




local function DraftMessageCreation_list( draftmessagelist )




	if IsOwner == true then
		compose_msg_icon.isVisible = true
		compose_msg_icon.y = H - 45
		compose_msg_icon.x=W/2+W/3 - 15
		compose_msg_icon:toFront()
    end

    if notifyFlag == true then

		for j=1, #draftmessageList_array do 
			display.remove(draftmessageList_array[#draftmessageList_array])
			draftmessageList_array[#draftmessageList_array] = nil
		end
			messagelist_scrollView:scrollToPosition
				{
				    y = 0,
				    time = 100,
				}
	end


	for i=1,#draftmessagelist do

        NoSentMessage.isVisible = false
        NoScheduleMessage.isVisible = false
        NoDraftMessage.isVisible = false

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


        local attachment_img = display.newImageRect(tempGroup,"res/assert/imagesave1.png",20,20)
		attachment_img.anchorX=0
		attachment_img.x = W-35
		attachment_img.isVisible = false
		attachment_img.y=background.y+7
		attachment_img.anchorY = 0
    

       	local attachment_audio = display.newImageRect(tempGroup,"res/assert/audiorecorded.png",20,20)
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


		if draftmessagelist[i].ImageFilePath ~= null and draftmessagelist[i].AudioFilePath ~= null then
		   attachimage = draftmessagelist[i].ImageFilePath
		   attachaudio = draftmessagelist[i].AudioFilePath
		else
		   attachimage = "null"
		   attachaudio = "null"	
		end


		if attachimage ~= "null" and attachaudio ~= "null" then
	 
			attachment_img.x = W-70
			attachment_img.isVisible = true

			attachment_audio.x = W-35
			attachment_audio.isVisible = true
				
		end


		local line = display.newRect(tempGroup,W/2,background.y,W,1)
		line.y=background.y+background.contentHeight-line.contentHeight
		line:setFillColor(Utility.convertHexToRGB(color.LtyGray))


		messagelist_scrollView:insert(tempGroup)

		background:addEventListener( "touch", MessageDetailPage )

	end

end






local function SentMessageCreation_list( sentmessagelist )



	if IsOwner == true then
		compose_msg_icon.isVisible = true
		compose_msg_icon.y = H - 45
		compose_msg_icon.x=W/2+W/3 - 15
		compose_msg_icon:toFront()
    end

    if notifyFlag == true then

		for j=1, #sentmessageList_array do	
			display.remove(sentmessageList_array[#sentmessageList_array])
			sentmessageList_array[#sentmessageList_array] = nil
		end


	messagelist_scrollView:scrollToPosition
	{
	    y = 0,
	    time = 100,
	}

	end


	for i=1,#sentmessagelist do

        NoScheduleMessage.isVisible = false
        NoDraftMessage.isVisible = false
        NoSentMessage.isVisible = false
         
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


        local attachment_img = display.newImageRect(tempGroup,"res/assert/imagesave1.png",20,20)
		attachment_img.anchorX=0
		attachment_img.x = W-35
		attachment_img.isVisible = false
		attachment_img.y=background.y+7
		attachment_img.anchorY = 0
    
		local attachment_audio = display.newImageRect(tempGroup,"res/assert/audiorecorded.png",20,20)
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


	
		if sentmessagelist[i].ImageFilePath ~= null and sentmessagelist[i].AudioFilePath ~= null then
		   attachimage = sentmessagelist[i].ImageFilePath
		   attachaudio = sentmessagelist[i].AudioFilePath
		else
		   attachimage = "null"
		   attachaudio = "null"	
		end


		if attachimage ~= "null" and attachaudio ~= "null" then
	 
			attachment_img.x = W-70
			attachment_img.isVisible = true

			attachment_audio.x = W-35
			attachment_audio.isVisible = true
				
		end



		local line = display.newRect(tempGroup,W/2,background.y,W,1)
		line.y=background.y+background.contentHeight-line.contentHeight
		line:setFillColor(Utility.convertHexToRGB(color.LtyGray))

		messagelist_scrollView:insert(tempGroup)

		background:addEventListener( "touch", MessageDetailPage )

	end

end






local function MessageCreation_list( messagelist )

	

        if IsOwner == true then

			compose_msg_icon.isVisible = true
			compose_msg_icon.y = H - 45
			compose_msg_icon.x=W/2+W/3 - 15
			compose_msg_icon:toFront()

	    end

	      if notifyFlag == true then

				for j=1, #messageList_array do 
					display.remove(messageList_array[#messageList_array])
					messageList_array[#messageList_array] = nil
				end
					messagelist_scrollView:scrollToPosition
					{
					y = 0,
					time = 100,
					}
			end


		for i=1,#messagelist do

	        NoSentMessage.isVisible = false
	        NoDraftMessage.isVisible = false
	        NoScheduleMessage.isVisible = false

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


            local attachment_img = display.newImageRect(tempGroup,"res/assert/imagesave1.png",20,20)
			attachment_img.anchorX=0
			attachment_img.x = W-35
			attachment_img.isVisible = false
			attachment_img.y=background.y+7
			attachment_img.anchorY = 0


			local attachment_audio = display.newImageRect(tempGroup,"res/assert/audiorecorded.png",22,22)
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



				if messagelist[i].ImageFilePath ~= null and messagelist[i].AudioFilePath ~= null then
					attachimage = messagelist[i].ImageFilePath
					attachaudio = messagelist[i].AudioFilePath
				else
					attachimage = "null"
					attachaudio = "null"	
				end


				if attachimage ~= "null" and attachaudio ~= "null" then

						attachment_img.x = W-70
						attachment_img.isVisible = true
						attachment_audio.x = W-35
						attachment_audio.isVisible = true

				end


				local line = display.newRect(tempGroup,W/2,background.y,W,1)
				line.y=background.y+background.contentHeight-line.contentHeight
				line:setFillColor(Utility.convertHexToRGB(color.LtyGray))
	

				messagelist_scrollView:insert(tempGroup)

				background:addEventListener( "touch", MessageDetailPage )

			end

		end





--------------------------------- schedule message list creation ----------------------------------------------------------


function getScheduleMessageList(response)

		listType = "SCHEDULE"

		messagelist_response = response.ChatMessageList

		if messagelist_response ~= nil and #messagelist_response ~= 0 and messagelist_response ~= "" then

				  NoSentMessage.isVisible=false
			      NoScheduleMessage.isVisible = false
			      NoDraftMessage.isVisible = false

				     for j = 1, #sentmessageList_array do
		               	display.remove(sentmessageList_array[#sentmessageList_array])
					    sentmessageList_array[#sentmessageList_array] = nil
			         end


			         for j = 1, #draftmessageList_array do
		               	display.remove(draftmessageList_array[#draftmessageList_array])
					    draftmessageList_array[#draftmessageList_array] = nil
			         end

				 MessageCreation_list(messagelist_response)
				
		else
	                 local function onTimer( event )

	          			print( "#messageList_array " ..#messageList_array)
	                 	if #messageList_array <= 0 then
					    	NoScheduleMessage.isVisible=true
					    end
					 end
					 timer.performWithDelay(200,onTimer)

					 NoSentMessage.isVisible=false
					 NoDraftMessage.isVisible = false


				     for j = 1, #sentmessageList_array do
		               	display.remove(sentmessageList_array[#sentmessageList_array])
					    sentmessageList_array[#sentmessageList_array] = nil
			         end


			         for j = 1, #draftmessageList_array do
		               	display.remove(draftmessageList_array[#draftmessageList_array])
					    draftmessageList_array[#draftmessageList_array] = nil
			         end

		end

	timer.performWithDelay(200,onTimer) 

end



--------------------------------- sent message list creation ----------------------------------------------------------

function getSentMessageList(response)

		listType = "SENT"

		print( "send @#$" )

	    sentmessage_response = response.ChatMessageList

		if sentmessage_response ~= nil and #sentmessage_response ~= 0 and sentmessage_response ~= "" then

			 NoSentMessage.isVisible=false
			 NoScheduleMessage.isVisible = false
			 NoDraftMessage.isVisible = false

			     for j = 1, #draftmessageList_array do
	               	display.remove(draftmessageList_array[#draftmessageList_array])
				    draftmessageList_array[#draftmessageList_array] = nil
		         end


		         for j = 1 , #messageList_array do
	               	display.remove(messageList_array[#messageList_array])
				    messageList_array[#messageList_array] = nil
		         end

				
			SentMessageCreation_list(sentmessage_response)
			

		else

			    local function onTimer( event )

			    	


					if  #sentmessageList_array <= 0 then
						NoSentMessage.isVisible=true
					end
				end
				timer.performWithDelay(200,onTimer)


				NoScheduleMessage.isVisible = false
				NoDraftMessage.isVisible = false


				  for j = 1, #draftmessageList_array do
	               	display.remove(draftmessageList_array[#draftmessageList_array])
				    draftmessageList_array[#draftmessageList_array] = nil
		         end


		         for j = 1 , #messageList_array do
	               	display.remove(messageList_array[#messageList_array])
				    messageList_array[#messageList_array] = nil
		         end


		end

end



--------------------------------- draft message list creation ----------------------------------------------------------

 function getDraftMessageList(response)

 	listType = "DRAFT"

       draftmessage_response = response.ChatMessageList

	   if draftmessage_response ~= nil and #draftmessage_response ~= 0 and draftmessage_response ~= "" then

			NoDraftMessage.isVisible=false
			NoScheduleMessage.isVisible=false
			NoSentMessage.isVisible=false

				for j = 1, #sentmessageList_array do
	            	display.remove(sentmessageList_array[#sentmessageList_array])
				    sentmessageList_array[#sentmessageList_array] = nil
		        end


		        for j = 1, #messageList_array do
	            	display.remove(messageList_array[#messageList_array])
				    messageList_array[#messageList_array] = nil
		        end


		    DraftMessageCreation_list(draftmessage_response)

	else

			    local function onTimer( event )
			    		if #draftmessageList_array <= 0 then 
					    	NoDraftMessage.isVisible=true
					    end
				end
				timer.performWithDelay(200,onTimer)


			    NoScheduleMessage.isVisible=false
				NoSentMessage.isVisible=false


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





function updateAudioValues(audiovalues)

	print("ertertet64636265642563452345623")

		audiovalues = json.decode(audiovalues)

	if  audiovalues.MessageStatus == "SCHEDULE" and tab_Group.id =="schedule" then

			print("schedule coming")
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
       

	      --  getScheduleMessageList()
				pageCount = pageCount+1

				Webservice.GetMessagessListbyMessageStatus("SCHEDULE",10,pageCount,getScheduleMessageList)

                
	elseif  audiovalues.MessageStatus == "SEND" and tab_Message.id=="sent" then

		    print("sent coming")
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


           -- getSentMessageList()
			
			pageCount = pageCount+1
			Webservice.GetMessagessListbyMessageStatus("SENT",10,pageCount,getSentMessageList)
			     

     elseif  audiovalues.MessageStatus == "DRAFT" and tab_Contact.id == "draft" then

			print("draft coming")

			tab_Schedule_txt:setFillColor( 0 )
			tab_Sent_txt:setFillColor(0)
			tab_Draft_txt:setFillColor(Utils.convertHexToRGB(color.tabBarColor) )
			tab_Group_bottombar.isVisible = true
			tab_Group_bottombar.y = tabBg.y+29.5
			tab_Group_bottombar.x = W/2 + W/3


			for j=1, #draftmessageList_array do 
				display.remove(draftmessageList_array[#draftmessageList_array])
				draftmessageList_array[#draftmessageList_array] = nil
			end


		--	getDraftMessageList()			
			
			pageCount = pageCount+1
			Webservice.GetMessagessListbyMessageStatus("DRAFT",10,pageCount,getDraftMessageList1)
                              
				
	end

end







local function resumeCallList(listview_values)


	  if listview_values== "SCHEDULE" then

				

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


			--getScheduleMessageList()

			pageCount = pageCount+1
			Webservice.GetMessagessListbyMessageStatus("SCHEDULE",10,pageCount,getScheduleMessageList)
                  

	  elseif  listview_values == "SEND" then

		 		

				-- tab_Schedule_txt:setFillColor( 0 )
				-- tab_Sent_txt:setFillColor( Utils.convertHexToRGB(color.tabBarColor) )
				-- tab_Draft_txt:setFillColor(0)
				-- tab_Group_bottombar.isVisible = true
				-- tab_Group_bottombar.y = tabBg.y+29.5
				-- tab_Group_bottombar.x = W/2


				-- for j=1, #sentmessageList_array do 
				-- 			display.remove(sentmessageList_array[#sentmessageList_array])
				-- 			sentmessageList_array[#sentmessageList_array] = nil
				-- end


    --        -- getSentMessageList()
			  
				  	pageCount = pageCount+1
				   Webservice.GetMessagessListbyMessageStatus("SENT",10,pageCount,getSentMessageList)

      elseif  listview_values == "DRAFT" then

   			

				tab_Schedule_txt:setFillColor( 0 )
				tab_Sent_txt:setFillColor(0)
				tab_Draft_txt:setFillColor(Utils.convertHexToRGB(color.tabBarColor) )
				tab_Group_bottombar.isVisible = true
				tab_Group_bottombar.y = tabBg.y+29.5
				tab_Group_bottombar.x = W/2 + W/3


				for j=1, #draftmessageList_array do 
					display.remove(draftmessageList_array[#draftmessageList_array])
					draftmessageList_array[#draftmessageList_array] = nil
				end

            --getDraftMessageList()

            pageCount = pageCount+1

			Webservice.GetMessagessListbyMessageStatus("DRAFT",10,pageCount,getDraftMessageList1)
               

      end

end





function ListLoad(messagelistvalue)

	if messagelistvalue.MessageStatus == "SCHEDULE" then

			for j=1, #messageList_array do 

				display.remove(messageList_array[#messageList_array])
				messageList_array[#messageList_array] = nil
			end

			pageCount = pageCount+1
		    Webservice.GetMessagessListbyMessageStatus("SCHEDULE",10,pageCount,getScheduleMessageList)


	elseif messagelistvalue.MessageStatus == "SENT" then

			for j=1, #sentmessageList_array do 

				display.remove(sentmessageList_array[#sentmessageList_array])
				sentmessageList_array[#sentmessageList_array] = nil
			end
			pageCount = pageCount +1 
		    Webservice.GetMessagessListbyMessageStatus("SENT",10,pageCount,getSentMessageList)


	elseif messagelistvalue.MessageStatus == "DRAFT" then

			for j=1, #draftmessageList_array do 

				display.remove(draftmessageList_array[#draftmessageList_array])
				draftmessageList_array[#draftmessageList_array] = nil
			end
			pageCount = pageCount+1
		    Webservice.GetMessagessListbyMessageStatus("DRAFT",10,pageCount,getDraftMessageList)
 
	end

end




       
function scene:resumeGame(value,messagelistvalue)
		
		notifyFlag = false

		

    if value == "back" then

	    Runtime:addEventListener( "key", onKeyEvent )

	        local function waitTimer( event )

				ListLoad(messagelistvalue)

			end

		timer.performWithDelay( 500, waitTimer )

	end

end





function scene:resumeGame(value,EditArray,pagevalue)
			
			notifyFlag = false
	    if value == "edit" then

	    	pagevalue = "editpage"

				local options = 
				{
					isModal = true,
					effect = "slideLeft",
					time = 300,
					params = 
					{
						Details = EditArray,
						value = "edit",
						page = pagevalue

					}
				}

		print("\n\n\n Edit Detail Values : \n\n ", json.encode(EditArray))


				composer.showOverlay( "Controller.composeMessagePage", options )

		elseif value == "details" then

				local function waitTimer( event )

					if openPage == "pushNotificationListPage" then

						local options = 
						{
							isModal = true,
							effect = "slideLeft",
							time = 1,
							params = 
							{
								messagelistvalues = EditArray
							}
						}

					composer.showOverlay( "Controller.pushNotificationDetailPage", options )

					end

				end

		        timer.performWithDelay( 500, waitTimer )

	   elseif value == "back" then
			
			 	local function waitTimer( event )

			 		if openPage == "pushNotificationListPage" then

					 		Runtime:addEventListener( "key", onKeyEvent )

                         --   ListLoad(messagelistvalue)
				
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

		        			
						notifyFlag = false

		        		pageCount = pageCount+1
		   			
						if listType == "DRAFT" then

							Webservice.GetMessagessListbyMessageStatus(listType,10,pageCount,getDraftMessageList)

						elseif listType == "SENT" then

							print( "Hello" )
							
							Webservice.GetMessagessListbyMessageStatus("SENT",10,pageCount,getSentMessageList)
						
						elseif listType == "SCHEDULE" then

							Webservice.GetMessagessListbyMessageStatus("SCHEDULE",10,pageCount,getScheduleMessageList)

						end


		        	
		        elseif ( event.direction == "down" ) then print( "Reached top limit" )


		        	notifyFlag = true

		        		pageCount = 1
						
						if listType == "DRAFT" then

							Webservice.GetMessagessListbyMessageStatus(listType,10,pageCount,getDraftMessageList)

						elseif listType == "SENT" then
							
							Webservice.GetMessagessListbyMessageStatus("SENT",10,pageCount,getSentMessageList)
						
						elseif listType == "SCHEDULE" then

							Webservice.GetMessagessListbyMessageStatus("SCHEDULE",10,pageCount,getScheduleMessageList)

						end

		        elseif ( event.direction == "left" ) then print( "Reached right limit" )

		        elseif ( event.direction == "right" ) then print( "Reached left limit" )

		        end

		    end

		  
		    return true
	end







local function TabbarTouch( event )

		if event.phase == "began" then 

		elseif event.phase == "ended" then

		pageCount = 0
		messagelist_scrollView:scrollTo( "top", { time=1000 } )
			
			if event.target.id == "schedule" then

					tab_Schedule_txt:setFillColor( Utils.convertHexToRGB(color.tabBarColor) )
					tab_Sent_txt:setFillColor(0)
					tab_Draft_txt:setFillColor(0)

					tab_Group_bottombar.isVisible = true
					tab_Group_bottombar.y = tabBg.y+29.5
					tab_Group_bottombar.x = W/2-W/3

					NoSentMessage.isVisible = false
					NoDraftMessage.isVisible = false
					NoScheduleMessage.isVisible = false

					composer.removeHidden()

				--getScheduleMessageList()

				pageCount = pageCount + 1
				Webservice.GetMessagessListbyMessageStatus("SCHEDULE",10,pageCount,getScheduleMessageList)


			elseif event.target.id == "sent" then

					tab_Sent_txt:setFillColor( Utils.convertHexToRGB(color.tabBarColor) )
					tab_Draft_txt:setFillColor(0)
					tab_Schedule_txt:setFillColor(0)

					tab_Group_bottombar.isVisible = true
					tab_Group_bottombar.y = tabBg.y+29.5
					tab_Group_bottombar.x = W/2

					NoScheduleMessage.isVisible = false
					NoDraftMessage.isVisible = false
					NoSentMessage.isVisible = false

					composer.removeHidden()

			--	getSentMessageList()

				pageCount = pageCount+1
				Webservice.GetMessagessListbyMessageStatus("SENT",10,pageCount,getSentMessageList)
				
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
					NoDraftMessage.isVisible = false

				--getDraftMessageList()

				pageCount = pageCount+1
				Webservice.GetMessagessListbyMessageStatus("DRAFT",10,pageCount,getDraftMessageList)

			    
			end

	    end

    return true 

end


	function get_messagemodel(response)



	    local listener = {}
			function listener:timer( event )
			    			if response.MessageStatus == "SEND" then
				Utils.SnackBar(MessagePage.SentSuccess)
			elseif response.MessageStatus == "DRAFT" then
				Utils.SnackBar(MessagePage.DraftSuccess)
			elseif response.MessageStatus == "SCHEDULE" then
				
				Utils.SnackBar(MessagePage.ScheduledSuccess)

			end
			-- -- print( "********************** retrun from send action ***************" )


						pageCount=0
		            	listType = "SCHEDULE"
		            	pageCount = pageCount+1 
						Webservice.GetMessagessListbyMessageStatus("SCHEDULE",10,pageCount,getScheduleMessageList)
				 
			end

			timer.performWithDelay( 1500, listener )

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

			composer.removeHidden()
	         
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

			tab_Group = display.newRect(tabBarGroup,0,0,97,33)
			tab_Group.x=W/2-W/3;tab_Group.y=tabBg.y
			tab_Group.anchorY=0
			tab_Group.alpha=1
			tab_Group.id="schedule"
			tab_Group:setFillColor( Utils.convertHexToRGB(color.LtyGray) )

			tab_Message = display.newRect(tabBarGroup,0,0,103.33,33)
			tab_Message.x=W/2;tab_Message.y=tabBg.y
			tab_Message.anchorY=0
			tab_Message.alpha=1
			tab_Message.id="sent"
			tab_Message:setFillColor(  Utils.convertHexToRGB(color.LtyGray) )


			tab_Contact = display.newRect(tabBarGroup,0,0,97,33)
			tab_Contact.x=W/2+W/3;tab_Contact.y=tabBg.y
			tab_Contact.anchorY=0
			tab_Contact.alpha=1
			tab_Contact.id="draft"
			tab_Contact:setFillColor(  Utils.convertHexToRGB(color.LtyGray) )


			tab_Schedule_txt = display.newText( tabBarGroup, MessagePage.ScheduleText,0,0,native.systemFont,14 )
			tab_Schedule_txt.x=tab_Group.x;
			tab_Schedule_txt.y=tab_Group.y+tab_Group.contentHeight/2-2
			tab_Schedule_txt:setFillColor( Utils.convertHexToRGB(color.tabBarColor) )


			tab_Sent_txt = display.newText( tabBarGroup, MessagePage.SentText,0,0,native.systemFont,14 )
			tab_Sent_txt.x=tab_Message.x;
			tab_Sent_txt.y=tab_Message.y+tab_Message.contentHeight/2-2
			tab_Sent_txt:setFillColor( 0 )


			tab_Draft_txt = display.newText( tabBarGroup, MessagePage.DraftText,0,0,native.systemFont,14 )
			tab_Draft_txt.x=tab_Contact.x;
			tab_Draft_txt.y=tab_Contact.y+tab_Contact.contentHeight/2-2
			tab_Draft_txt:setFillColor( 0 )


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
							listener = MessageList_scrollListener,
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
							listener = MessageList_scrollListener,
						}

		    sceneGroup:insert(messagelist_scrollView)

			end



elseif phase == "did" then

			composer.removeHidden()
			compose_msg_icon:toFront()
				
			if pagingvalue == "listpage" then	

		            if IsOwner == true then
		            	listType = "SCHEDULE"
		            	pageCount = pageCount+1 
						Webservice.GetMessagessListbyMessageStatus("SCHEDULE",10,pageCount,getScheduleMessageList)
				    else
				    	listType = "SENT"
				    	pageCount = pageCount+1
				    	Webservice.GetMessagessListbyMessageStatus("SENT",10,pageCount,getSentMessageList)
				    end

			elseif pagingvalue == "compose" then

					

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

			menuBtn:removeEventListener("touch",menuTouch)
			compose_msg_icon:removeEventListener("touch",composeMessage)
			Runtime:removeEventListener( "key", onKeyEvent )
			Background:removeEventListener("touch",FocusComplete)

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
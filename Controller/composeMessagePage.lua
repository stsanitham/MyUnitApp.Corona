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

local Background,BgText

local menuBtn

local back_icon_bg, back_icon

openPage="pushNotificationListPage"

local RecentTab_Topvalue = 70

local sceneevent



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

	elseif event.phase == "ended" then

	end
	
end 






	function get_messagemodel(response)

		print("\n\n\n SuccessMessage : Response : \n\n ", json.encode(response))

		list_values = response

		if list_values.MessageStatus == "SEND" then

		      		 Utils.SnackBar("Your message has been sent successfully")

				      		 	shortmsg_textbox.text = ""

								shortmsg_textbox.placeholder = MessagePage.ShortMessage_Placeholder		

								longmsg_textbox.text = ""

								longmsg_textbox.placeholder = MessagePage.LongMessage_Placeholder

					local function onTimer ( event )


						    options =
							{
							effect = "slideRight",
							time = 500,
							}
                            

							sceneevent.parent:resumeCall(list_values)

							spinner.y=H/2-60

							composer.hideOverlay()


					end

        		     timer.performWithDelay(1000, onTimer )

	    end




		if list_values.MessageStatus == "DRAFT" then

		      		 Utils.SnackBar("Your message has been saved successfully")

				      		 	shortmsg_textbox.text = ""

								shortmsg_textbox.placeholder = MessagePage.ShortMessage_Placeholder		

								longmsg_textbox.text = ""

								longmsg_textbox.placeholder = MessagePage.LongMessage_Placeholder

					local function onTimer ( event )


							sceneevent.parent:resumeCall(list_values)

							spinner.y=H/2-60

							composer.hideOverlay()


					end

        		     timer.performWithDelay(1000, onTimer )

	    end

	
	end




    local function sendMessage ( method )

		    if shortmsg_textbox.text == nil  then

		    	shortmsg_textbox.text = ""

		    end


		    if longmsg_textbox.text == nil  then

		    	longmsg_textbox.text = ""

		    end


		Webservice.SEND_MESSAGE(shortmsg_textbox.text,longmsg_textbox.text,"","","","",method,"","","",get_messagemodel)

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

  	    	native.setKeyboardFocus(nil)

    	    display.getCurrentStage():setFocus( nil )



			if (shortmsg_textbox.text == "" or shortmsg_textbox.text == nil) or (longmsg_textbox.text == "" or longmsg_textbox.text == nil) then

				    if event.target.id == "send" then

					local alert = native.showAlert( Message.ErrorTitle, "Enter the short/long message in the respective field and proceed further", { CommonWords.ok } )

					elseif event.target.id == "draft" then

					local alert = native.showAlert( "Saving Failed", "Enter the short/long message in the respective field and proceed further", { CommonWords.ok } )

				    end

					return false

	        end



	        if (shortmsg_textbox.text ~= "" or shortmsg_textbox.text ~= nil) and (longmsg_textbox.text ~= "" or longmsg_textbox.text ~= nil) then

				    if event.target.id == "send" then

				        sendMessage("SEND")
                        
					elseif event.target.id == "draft" then

					    sendMessage("DRAFT")

					else

				    end

				    return false

	        end

---------------------------

	        if (shortmsg_textbox.text ~= "" or shortmsg_textbox.text ~= nil) and (longmsg_textbox.text == "" or longmsg_textbox.text == nil) then

	        	        validation = false

    	    	    	SetError("* ".."Enter the Long Message",longmsg_textbox)

    	    	    	return false


	        end


	        if (longmsg_textbox.text ~= "" or longmsg_textbox.text ~= nil) and (shortmsg_textbox.text == "" or shortmsg_textbox.text == nil) then

	        	        validation = false

    	    	    	SetError("* ".."Enter the Short Message",shortmsg_textbox)

    	    	    	return false

	        end

---------------------------

    	end

    	return true

    end





local function TextLimitation( event )

	   if event.phase == "began" then


	   elseif event.phase == "submitted" then

				    if event.target.id =="longmessage" then

				   		native.setKeyboardFocus( nil )

				   end


	   elseif event.phase == "editing" then


					if event.target.id =="shortmessage" then

							if (string.len(event.target.text) > 250) then

							event.target.text = event.target.text:sub(1, 250)

							end

					end



					if event.target.id =="longmessage" then

							if (string.len(event.target.text) > 1000) then

							event.target.text = event.target.text:sub(1, 1000)

							end


							--print( event.newCharacters )

							if (event.newCharacters=="\n") then

							longmsg_textbox.text = string.gsub( longmsg_textbox.text,"%\n","" )

							native.setKeyboardFocus( nil )

							end

					end

		  end

   end




		local function onKeyEventDetail( event )

		        local phase = event.phase
		        local keyName = event.keyName

		        if phase == "up" then

		        if keyName=="back" then

		        	composer.hideOverlay( "slideRight", 300 )

		        	return true
		            
		        end

		    end

		        return false
		 end





		local function closeMessagePage( event )

			if event.phase == "began" then

				display.getCurrentStage():setFocus( event.target )

			elseif event.phase == "ended" then

			    display.getCurrentStage():setFocus( nil )

			    print("345345345345")

					 composer.hideOverlay("slideRight",300)		 

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

	title_bg = display.newRect(sceneGroup,0,0,W,30)
	title_bg.height = 30
	title_bg.x=W/2;title_bg.y = tabBar.y+tabBar.contentHeight-5
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

			sceneevent = event

       
---------------------------------------------- Short Message ----------------------------------------------------------

                shortmsg_star = display.newText(sceneGroup,"*",0,0,native.systemFont,14)
				shortmsg_star.anchorX = 0
				shortmsg_star.x=10
				shortmsg_star.anchorY=0
				shortmsg_star.y = title_bg.y+title_bg.contentHeight/2+8
				shortmsg_star:setFillColor(1,0,0)
				
				shortmsg_title = display.newText(sceneGroup,MessagePage.ShortMessage,0,0,native.systemFont,14)
				shortmsg_title.anchorX = 0
				shortmsg_title.x=shortmsg_star.x + 7
				shortmsg_title.anchorY=0
				shortmsg_title.y = shortmsg_star.y - 3
				shortmsg_title:setFillColor(0)


				shortmsg_textbox = native.newTextBox( 0,0, W - 20, EditBoxStyle.height+20)
				shortmsg_textbox.placeholder = MessagePage.ShortMessage_Placeholder
				shortmsg_textbox.isEditable = true
				shortmsg_textbox.size=14
				shortmsg_textbox.anchorX = 0
				shortmsg_textbox.anchorY=0
				shortmsg_textbox.value=""
				shortmsg_textbox.id = "shortmessage"
				shortmsg_textbox.hasBackground = true
				shortmsg_textbox:setReturnKey( "next" )
				shortmsg_textbox.inputType = "default"
				sceneGroup:insert(shortmsg_textbox)
				shortmsg_textbox.x=10
				shortmsg_textbox.y=shortmsg_title.y+ shortmsg_title.height+7


				short_msg_charlimit = display.newText(sceneGroup,MessagePage.ShortMsgLimit,0,0,native.systemFont,14)
				short_msg_charlimit.anchorX = 0
				short_msg_charlimit.x=W-105
				short_msg_charlimit.anchorY = 0
				short_msg_charlimit.y = shortmsg_textbox.y+shortmsg_textbox.contentHeight+2
				short_msg_charlimit:setFillColor(0)

---------------------------------------------- Long Message ----------------------------------------------------------

                longmsg_star = display.newText(sceneGroup,"*",0,0,native.systemFont,14)
				longmsg_star.anchorX = 0
				longmsg_star.x=10
				longmsg_star.anchorY=0
				longmsg_star.y = short_msg_charlimit.y+short_msg_charlimit.contentHeight+2
				longmsg_star:setFillColor(1,0,0)


				longmsg_title = display.newText(sceneGroup,MessagePage.LongMessage,0,0,native.systemFont,14)
				longmsg_title.anchorX = 0
				longmsg_title.x=longmsg_star.x + 7
				longmsg_title.anchorY = 0
				longmsg_title.y = longmsg_star.y - 3
				longmsg_title:setFillColor(0)


				longmsg_textbox = native.newTextBox( 0,0, W - 20, EditBoxStyle.height+40)
				longmsg_textbox.placeholder = MessagePage.LongMessage_Placeholder
				longmsg_textbox.isEditable = true
				longmsg_textbox.size=14
				longmsg_textbox.anchorX = 0
				longmsg_textbox.anchorY=0
				longmsg_textbox.value=""
				longmsg_textbox.id = "longmessage"
				longmsg_textbox.hasBackground = true
				longmsg_textbox:setReturnKey( "done" )
				longmsg_textbox.inputType = "default"
				sceneGroup:insert(longmsg_textbox)
				longmsg_textbox.x=10
				longmsg_textbox.y=longmsg_title.y+ longmsg_title.height+7


				long_msg_charlimit = display.newText(sceneGroup,MessagePage.LongMsgLimit,0,0,native.systemFont,14)
				long_msg_charlimit.anchorX = 0
				long_msg_charlimit.anchorY = 0
				long_msg_charlimit.x=W-110
				long_msg_charlimit.y = longmsg_textbox.y+longmsg_textbox.contentHeight+2
				long_msg_charlimit:setFillColor(0)

------------------------------------------- Icons Holder --------------------------------------------

				icons_holder_bg = display.newRect(sceneGroup,0,0,W-20,EditBoxStyle.height+115)
				icons_holder_bg.x=10
				icons_holder_bg.anchorX=0
				icons_holder_bg.anchorY=0
				icons_holder_bg.strokeWidth = 1
				icons_holder_bg:setStrokeColor( 0,0,0,0.1)
				icons_holder_bg.y = long_msg_charlimit.y+long_msg_charlimit.height+10
				icons_holder_bg:setFillColor( 1,1,1,0.8)

-------------------------------------------- Camera ---------------------------------------------------

				camera_icon = display.newImageRect(sceneGroup,"res/assert/camera1.png",40,35)
				camera_icon.x=W/2 - W/3 - 15
				camera_icon.anchorX=0
				camera_icon.anchorY=0
				camera_icon.y = icons_holder_bg.y + 7.5


				camera_icon_txt = display.newText(sceneGroup,MessagePage.Camera,0,0,native.systemFont,14)
				camera_icon_txt.anchorX = 0
				camera_icon_txt.anchorY = 0
				camera_icon_txt.x = camera_icon.x - 7
				camera_icon_txt.y = camera_icon.y+camera_icon.contentHeight+5
				camera_icon_txt:setFillColor(0)

-------------------------------------------- Video ---------------------------------------------------

				video_icon = display.newImageRect(sceneGroup,"res/assert/video1.png",40,35)
				video_icon.x= W/2 - 12
				video_icon.anchorX=0
				video_icon.anchorY=0
				video_icon.y = camera_icon.y


				video_icon_txt = display.newText(sceneGroup,MessagePage.Video,0,0,native.systemFont,14)
				video_icon_txt.anchorX = 0
				video_icon_txt.anchorY = 0
				video_icon_txt.x = video_icon.x 
				video_icon_txt.y = video_icon.y+video_icon.contentHeight+5
				video_icon_txt:setFillColor(0)

-------------------------------------------- Audio ---------------------------------------------------

                audio_icon = display.newImageRect(sceneGroup,"res/assert/audio1.png",40,35)
				audio_icon.x= W/2 + W/3 - 15
				audio_icon.anchorX=0
				audio_icon.anchorY=0
				audio_icon.y = video_icon.y


				audio_icon_txt = display.newText(sceneGroup,MessagePage.Audio,0,0,native.systemFont,14)
				audio_icon_txt.anchorX = 0
				audio_icon_txt.anchorY = 0
				audio_icon_txt.x = audio_icon.x 
				audio_icon_txt.y = audio_icon.y+audio_icon.contentHeight+5
				audio_icon_txt:setFillColor(0)

-------------------------------------------- Gallery ---------------------------------------------------

                gallery_icon = display.newImageRect(sceneGroup,"res/assert/gallery1.png",40,35)
				gallery_icon.x= W/2 - W/3 - 15
				gallery_icon.anchorX=0
				gallery_icon.anchorY=0
				gallery_icon.y = camera_icon.y + camera_icon.contentHeight + 35


				gallery_icon_txt = display.newText(sceneGroup,MessagePage.Gallery,0,0,native.systemFont,14)
				gallery_icon_txt.anchorX = 0
				gallery_icon_txt.anchorY = 0
				gallery_icon_txt.x = gallery_icon.x - 5
				gallery_icon_txt.y = gallery_icon.y+gallery_icon.contentHeight+5
				gallery_icon_txt:setFillColor(0)


-------------------------------------------- Location ---------------------------------------------------

                Location_icon = display.newImageRect(sceneGroup,"res/assert/location1.png",40,35)
				Location_icon.x= W/2 - 12
				Location_icon.anchorX=0
				Location_icon.anchorY=0
				Location_icon.y = gallery_icon.y


				Location_icon_txt = display.newText(sceneGroup,MessagePage.Location,0,0,native.systemFont,14)
				Location_icon_txt.anchorX = 0
				Location_icon_txt.anchorY = 0
				Location_icon_txt.x = Location_icon.x - 10
				Location_icon_txt.y = Location_icon.y+Location_icon.contentHeight+5
				Location_icon_txt:setFillColor(0)


-------------------------------------------- Contact ---------------------------------------------------

                Contact_icon = display.newImageRect(sceneGroup,"res/assert/user1.png",40,35)
				Contact_icon.x= W/2 + W/3 - 15
				Contact_icon.anchorX=0
				Contact_icon.anchorY=0
				Contact_icon.y = Location_icon.y


				Contact_icon_txt = display.newText(sceneGroup,MessagePage.Contact,0,0,native.systemFont,14)
				Contact_icon_txt.anchorX = 0
				Contact_icon_txt.anchorY = 0
				Contact_icon_txt.x = Contact_icon.x - 7
				Contact_icon_txt.y = Contact_icon.y+Contact_icon.contentHeight+5
				Contact_icon_txt:setFillColor(0)


------------------------------------------ Schedule Button -----------------------------------------------

			    schedule_button = display.newRect(sceneGroup,0,0,W-50,26)
				schedule_button.x = W/2 - W/3 - 40
				schedule_button.y = icons_holder_bg.y + icons_holder_bg.contentHeight +15
				schedule_button.width = W - 220
				schedule_button.anchorX = 0
				schedule_button.anchorY=0
				schedule_button:setFillColor( 0,0.5,0.8 )
				schedule_button.id="schedule"


				schedule_icon = display.newImageRect("res/assert/schedule.png",16,14)
				schedule_icon.id = "schedule icon"
				sceneGroup:insert(schedule_icon)
				schedule_icon.anchorY=0
				schedule_icon.anchorX=0
				schedule_icon.x= schedule_button.x + 6
				schedule_icon.y=schedule_button.y+schedule_button.contentHeight/2-schedule_icon.contentHeight/2

				schedule_icon_text = display.newText(sceneGroup,MessagePage.ScheduleText,0,0,schedule_button.contentWidth-12,0,native.systemFont,14)
				schedule_icon_text.anchorX=0
				schedule_icon_text.anchorY=0
				schedule_icon_text.x=schedule_icon.x+schedule_icon.contentWidth+ 5
				schedule_icon_text.y=schedule_icon.y
				Utils.CssforTextView(schedule_icon_text,sp_primarybutton)

			    schedule_button.height=schedule_icon_text.contentHeight+10



--------------------------------------------- Send Button ---------------------------------------------------------

			    send_button = display.newRect(sceneGroup,0,0,W-50,26)
				send_button.x = W/2 - 38
				send_button.y = icons_holder_bg.y + icons_holder_bg.contentHeight +15
				send_button.width = W - 240
				send_button.anchorX = 0
				send_button.anchorY=0
				send_button:setFillColor(Utils.convertHexToRGB(color.darkgreen))
				send_button.id="send"

				send_icon = display.newImageRect("res/assert/sendmsg.png",16,14)
				send_icon.id = "send icon"
				sceneGroup:insert(send_icon)
				send_icon.anchorY=0
				send_icon.anchorX=0
				send_icon.x= send_button.x + 6
				send_icon.y=send_button.y+send_button.contentHeight/2-send_icon.contentHeight/2

				send_icon_text = display.newText(sceneGroup,MessagePage.Send,0,0,send_button.contentWidth-12,0,native.systemFont,14)
				send_icon_text.anchorX=0
				send_icon_text.anchorY=0
				send_icon_text.x=send_icon.x+send_icon.contentWidth+ 5
				send_icon_text.y=send_icon.y
				Utils.CssforTextView(send_icon_text,sp_primarybutton)

			    send_button.height=send_icon_text.contentHeight+10



--------------------------------------------- Draft Button ---------------------------------------------------------

			    draft_button = display.newRect(sceneGroup,0,0,W-50,26)
				draft_button.x = W/2 + W/3 - 55
				draft_button.y = icons_holder_bg.y + icons_holder_bg.contentHeight +15
				draft_button.width = W - 225
				draft_button.anchorX = 0
				draft_button.anchorY=0
				draft_button:setFillColor( 0,0,0,0.7 )
				draft_button.id="draft"

				draft_icon = display.newImageRect("res/assert/drafticon.png",16,14)
				draft_icon.id = "draft icon"
				sceneGroup:insert(draft_icon)
				draft_icon.anchorY=0
				draft_icon.anchorX=0
				draft_icon.x= draft_button.x + 6
				draft_icon.y= draft_button.y+draft_button.contentHeight/2-draft_icon.contentHeight/2

				draft_icon_text = display.newText(sceneGroup,MessagePage.DraftText,0,0,send_button.contentWidth-12,0,native.systemFont,14)
				draft_icon_text.anchorX=0
				draft_icon_text.anchorY=0
				draft_icon_text.x=draft_icon.x+draft_icon.contentWidth+ 5
				draft_icon_text.y=draft_icon.y
				Utils.CssforTextView(draft_icon_text,sp_primarybutton)

			    draft_button.height=draft_icon_text.contentHeight+10



		elseif phase == "did" then

			--composer.removeHidden()

			menuBtn:addEventListener("touch",menuTouch)

			back_icon:addEventListener("touch",closeMessagePage)
			back_icon_bg:addEventListener("touch",closeMessagePage)
			title:addEventListener("touch",closeMessagePage)

			shortmsg_textbox:addEventListener( "userInput", TextLimitation )
			longmsg_textbox:addEventListener( "userInput", TextLimitation )
			Background:addEventListener("touch",FocusComplete)

			send_button:addEventListener("touch",onSendButtonTouchAction)
			draft_button:addEventListener("touch",onSendButtonTouchAction)

			 Runtime:addEventListener( "key", onKeyEventDetail )
			
		end	
		
	MainGroup:insert(sceneGroup)

	end




	function scene:hide( event )

		local sceneGroup = self.view
		local phase = event.phase

		if event.phase == "will" then

			composer.removeHidden()

			elseif phase == "did" then

				--event.parent:resumeCall(list_values)
				

				back_icon:removeEventListener("touch",closeMessagePage)
			    back_icon_bg:removeEventListener("touch",closeMessagePage)
			    title:removeEventListener("touch",closeMessagePage)

			    shortmsg_textbox:removeEventListener( "userInput", TextLimitation )
				longmsg_textbox:removeEventListener( "userInput", TextLimitation )
				Background:removeEventListener("touch",FocusComplete)

				send_button:removeEventListener("touch",onSendButtonTouchAction)
				draft_button:removeEventListener("touch",onSendButtonTouchAction)


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
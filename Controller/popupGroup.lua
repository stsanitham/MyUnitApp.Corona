----------------------------------------------------------------------------------
--
-- careerPathDetailPage.lua
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local Utility = require( "Utils.Utility" )
local widget = require( "widget" )
local json = require("json")



--------------- Initialization -------------------

local W = display.contentWidth;H= display.contentHeight

local BgText,pageTitle,changeList_order_icon

local menuBtn,contactId

openPage="PopUpGroup"

local Career_Username , id_value , popupevnt_value

local leftPadding = 10

local phoneNum = ""

local RecentTab_Topvalue

local ProfileImage,popup_scroll

--------------------------------------------------

isSentMail = true
isSentText = true

local function onKeyEventDetail( event )

        local phase = event.phase
        local keyName = event.keyName

        if phase == "up" then

        if keyName=="back" then

      --	composer.hideOverlay( "slideRight", 300 )

        	 return true
            
        end

    end

        return false
 end



local function onCloseTouch( event )
    if event.phase == "began" then
        display.getCurrentStage():setFocus( event.target )
        elseif event.phase == "ended" then
        display.getCurrentStage():setFocus( nil )

        print("close",popUpGroup.numChildren)
       for j=popUpGroup.numChildren, 1, -1 do 
						display.remove(popUpGroup[popUpGroup.numChildren])
						popUpGroup[popUpGroup.numChildren] = nil
	 	end

    end

    return true

end



local function touchBg( event )
		if event.phase == "began" then

		elseif event.phase == "ended" then

				native.setKeyboardFocus(nil)

		end
		return true
end




	local function createField()

		print("hello")

		input = native.newTextField(W/2,PhoneDetail_bottom.y+PhoneDetail_bottom.contentHeight-15, W-40, 25)

		return input
	end



	local function SetError( displaystring, object )

		object.text=displaystring
		object.size=10
		object:setTextColor(1,0,0)
	end


	function onCompletionEvent(event)

            if "clicked"==event.action then

            	print("#####################################################################################")

            	native.setKeyboardFocus(EmailDetailValue)

	       end

	end


	function getemailexistresponse(response)
 
        email_response = response

	    print("************************Request_response email initial*************************** ",json.encode(email_response))

	    if email_response == true then

	    elseif email_response == false then

	    	 existalert = native.showAlert("Email Already Exist", "A Contact with same email address already exist", { CommonWords.ok} , onCompletionEvent)

	    end

    end


		function textField( event )

					if ( event.phase == "began" ) then


							event.target:setTextColor(color.black)

							current_textField = nil

							current_textField = event.target;


							current_textField.size=14

							if "*" == event.target.text:sub(1,1) then
								event.target.text=""
								current_textField.text = ""
							end


					elseif ( event.phase == "submitted" ) then

							if(current_textField.id =="Password") then

	                               native.setKeyboardFocus(nil)
							end

							if(current_textField.id =="Email Detail") then

	                              -- native.setKeyboardFocus(nil)
	                              Webservice.CheckExistsRequestStatus(EmailDetailValue.text,getemailexistresponse)

	                              native.setKeyboardFocus(nil)

							end

					elseif event.phase == "ended" then
										
                         	event.target:setSelection(event.target.text:len(),event.target.text:len())

        			elseif ( event.phase == "editing" ) then

						 if(current_textField.id =="Phone Detail") then

						 	--PhoneDetailValue

						 	if event.target.text:len() > 15 then

								event.target.text = event.target.text:sub(1,15)


							end

							if event.target.text:len() > event.startPosition then

								event.target.text = event.target.text:sub(1,event.startPosition )

							end


							local maskingValue =Utils.PhoneMasking(tostring(event.target.text))

											

									native.setKeyboardFocus(nil)

									event.target.text=maskingValue

									event.target = PhoneDetailValue

									native.setKeyboardFocus(PhoneDetailValue)

								
						
        				end
        ------------------------------------------for password ---------------------------------------------------

						if(current_textField.id == "Password") then

							print( event.newCharacters )

							if (event.newCharacters==" ") then

								event.target.text = event.target.text:sub(1,event.target.text:len()-1)

							end

        					if event.target.text:len() > 12 then

								event.target.text = event.target.text:sub(1,12)

							end

						end

        -----------------------------------------------------------------------------------------------------------

		end
	     end



		 function onSwitchPress( event )

		    local switch = event.target

		    if (switch.id == "email_Checkbox" ) then

		    	isSentMail = tostring(switch.isOn)

		    end

		    if (switch.id == "text_Checkbox" ) then

		    	isSentText = tostring(switch.isOn)

		    	
		    end
		 end



        function getGeneratedPassword( response )

         	generatedPassword = response


         	if PasswordValue.text == "* Password is required" or PasswordValue.text == "* Password should contain atleast 6 characters" then

         	    PasswordValue.text = generatedPassword
         	    PasswordValue.size=14
		        PasswordValue:setTextColor(0,0,0)

		    else

		    	PasswordValue.text = generatedPassword

            end


            if (PasswordValue.newCharacters==" ") then

				PasswordValue.text = PasswordValue.text:sub(1,PasswordValue.text:len()-1)

			end

        end



	   local function OnPasswordGeneration(event)

		 	 if event.phase == "began" then

	         elseif event.phase == "ended" then

	         Webservice.GeneratePassword(getGeneratedPassword)

	         end

	        return true

	   end



	   function onGrantButtonTouch( event )

            if event.phase == "began" then

            elseif event.phase == "ended" then

                local validation = true

                native.setKeyboardFocus(nil)

			if (EmailDetailValue.text == "") or (EmailDetailValue.text == EmailDetailValue.id) or (not Utils.emailValidation(EmailDetailValue.text)) then
			  
			     validation=false
			     SetError("* ".."Email Address is required",EmailDetailValue)

			     emailnotifybox.isVisible = false
			     emailnotifytext.isVisible = false


	              PhoneDetail_bg.y =  EmailDetail_bottom.y + 10
				  PhoneDetail_titlestar.y= PhoneDetail_bg.y
				  PhoneDetail_titletext.y=  PhoneDetail_bg.y
				  PhoneDetailValue.y = PhoneDetail_titletext.y+PhoneDetail_titletext.contentHeight+9
				  PhoneDetail_bottom.y= PhoneDetailValue.y+10
				  textnotifytext.y= PhoneDetail_bottom.y +PhoneDetail_bottom.contentHeight +12
				  textnotifybox.y = PhoneDetail_bottom.y +PhoneDetail_bottom.contentHeight +13

	              MKRankDetail_bg.y =  PhoneDetail_bottom.y+PhoneDetail_bottom.contentHeight+30
				  MKRankDetail_title.y= MKRankDetail_bg.y+15
				  MKRankDetailValue.y= MKRankDetail_title.y+MKRankDetail_title.contentHeight+10
				  MKRankDetail_bottom.y= MKRankDetailValue.y+9

				  Requesteddate_bg.y =  MKRankDetailValue.y+MKRankDetailValue.height+7
				  Requesteddate_title.y= MKRankDetailValue.y+MKRankDetailValue.height+15
				  RequesteddateValue.y= Requesteddate_title.y+Requesteddate_title.height+8
				  Requesteddate_bottom.y= RequesteddateValue.y+9

				  Password_bg.y =  Requesteddate_bg.y+Requesteddate_bg.height+7
				  Password_titlestar.y= RequesteddateValue.y+RequesteddateValue.height+15
				  Password_titletext.y= RequesteddateValue.y+RequesteddateValue.height+15
				  Password_bottom.y= Password_titletext.y+Password_titletext.height+15
				  PasswordValue.y =Password_titletext.y+Password_titletext.height+5
				  PasswordHelptext.y= Password_bottom.y + 12
				  GeneratePasstext.y= PasswordHelptext.y + 20
				  processbutton.y = GeneratePasstext.y+GeneratePasstext.contentHeight+22
		          processbutton_text.y=processbutton.y

		    else 

				emailnotifybox.isVisible = true
				emailnotifytext.isVisible = true

				emailnotifybox.y = EmailDetail_bottom.y + 15
				emailnotifytext.y = EmailDetail_bottom.y + 15

	            PhoneDetail_bg.y =  emailnotifybox.y+emailnotifybox.contentHeight+5
				PhoneDetail_titlestar.y= PhoneDetail_bg.y
				PhoneDetail_titletext.y= PhoneDetail_bg.y
				PhoneDetailValue.y =PhoneDetail_titletext.y+PhoneDetail_titletext.contentHeight+9
				PhoneDetail_bottom.y= PhoneDetailValue.y+10
				textnotifytext.y=  PhoneDetail_bottom.y + 15
				textnotifybox.y = PhoneDetail_bottom.y + 15

				MKRankDetail_bg.y =  textnotifytext.y+textnotifytext.contentHeight+5
				MKRankDetail_title.y= MKRankDetail_bg.y+5
				MKRankDetailValue.y= MKRankDetail_title.y+MKRankDetail_title.contentHeight+7
			    MKRankDetail_bottom.y= MKRankDetailValue.y+9

				Requesteddate_bg.y = MKRankDetail_bottom.y+MKRankDetail_bottom.height+7
			    Requesteddate_title.y= Requesteddate_bg.y + 5
			    RequesteddateValue.y= Requesteddate_title.y+Requesteddate_title.height+8
			    Requesteddate_bottom.y= RequesteddateValue.y+9

				Password_bg.y =  Requesteddate_bg.y+Requesteddate_bg.height+7
			    Password_titlestar.y= RequesteddateValue.y+RequesteddateValue.height+15
			    Password_titletext.y= RequesteddateValue.y+RequesteddateValue.height+15
			    Password_bottom.y= Password_titletext.y+Password_titletext.height+15
			    PasswordValue.y =Password_titletext.y+Password_titletext.height+5
			    PasswordHelptext.y= Password_bottom.y + 12
			    GeneratePasstext.y= PasswordHelptext.y + 20
			    processbutton.y = GeneratePasstext.y+GeneratePasstext.contentHeight+22
				processbutton_text.y=processbutton.y

		end



		if  PhoneDetailValue.text == "" or PhoneDetailValue.text == PhoneDetailValue.id or PhoneDetailValue.text:len()<14 or PhoneDetailValue.text == "* Phone number is required" then
			validation=false

		     SetError("* ".."Phone number is required",PhoneDetailValue)

		     textnotifybox.isVisible = false
		     textnotifytext.isVisible = false

             MKRankDetail_bg.y =  PhoneDetail_bottom.y + PhoneDetail_bottom.contentHeight+10
		     MKRankDetail_title.y= MKRankDetail_bg.y
		     MKRankDetailValue.y= MKRankDetail_title.y+MKRankDetail_title.contentHeight+8
			 MKRankDetail_bottom.y= MKRankDetailValue.y+9

			 Requesteddate_bg.y =  MKRankDetail_bottom.y+10
			 Requesteddate_title.y= Requesteddate_bg.y +7
		     RequesteddateValue.y= Requesteddate_title.y+Requesteddate_title.contentHeight+8
		     Requesteddate_bottom.y= RequesteddateValue.y+9

		   --    Password_bg.y =  Requesteddate_bottom.y+Requesteddate_bottom.contentHeight+7
		   --    Password_titlestar.y= Password_bg.y+7
		   --    Password_titletext.y= Password_bg.y+7
		   --    PasswordValue.y =Password_titletext.y+Password_titletext.contentHeight+8
		   --    Password_bottom.y= PasswordValue.y +9.5
		   --    PasswordHelptext.y= Password_bottom.y + 12
		   --    GeneratePasstext.y= PasswordHelptext.y + 20
		   --    processbutton.y = GeneratePasstext.y+GeneratePasstext.contentHeight+22
		   --    processbutton_text.y=processbutton.y


			  if popupText.text == "Deny Access" then


		      Password_bg.isVisible = false
		      Password_titlestar.isVisible = false
		      Password_titletext.isVisible = false
		      Password_bottom.isVisible = false
		      PasswordValue.isVisible = false
		      PasswordHelptext.isVisible = false
		      GeneratePasstext.isVisible = false
		      processbutton.y = GeneratePasstext.y+GeneratePasstext.contentHeight+22
			  processbutton_text.y=processbutton.y

			  deny_bg.y = Requesteddate_bottom.y + 45
			  deny_Value.y=deny_bg.y
			  processbutton.y = deny_Value.y+deny_Value.contentHeight - 10
			  processbutton_text.y=processbutton.y

			 elseif popupText.text == "Provide Access" then


			 	Requesteddate_bg.isVisible = false
			 	RequesteddateValue.isVisible = false
			 	Requesteddate_title.isVisible = false
			 	Requesteddate_bottom.isVisible = false

			  Password_bg.y =  MKRankDetail_bottom.y+MKRankDetail_bottom.contentHeight+7
		      Password_titlestar.y= Password_bg.y+7
		      Password_titletext.y= Password_bg.y+7
		      PasswordValue.y =Password_titletext.y+Password_titletext.contentHeight+8
		      Password_bottom.y= PasswordValue.y +9.5
		      PasswordHelptext.y= Password_bottom.y + 12
		      GeneratePasstext.y= PasswordHelptext.y + 20
		      processbutton.y = GeneratePasstext.y+GeneratePasstext.contentHeight+22
			  processbutton_text.y=processbutton.y


		     else


		      Password_bg.y =  Requesteddate_bottom.y+Requesteddate_bottom.contentHeight+7
		      Password_titlestar.y= Password_bg.y+7
		      Password_titletext.y= Password_bg.y+7
		      PasswordValue.y =Password_titletext.y+Password_titletext.contentHeight+8
		      Password_bottom.y= PasswordValue.y +9.5
		      PasswordHelptext.y= Password_bottom.y + 12
		      GeneratePasstext.y= PasswordHelptext.y + 20
		      processbutton.y = GeneratePasstext.y+GeneratePasstext.contentHeight+22
			  processbutton_text.y=processbutton.y

			 end


		    else 

			 textnotifybox.isVisible = true
			 textnotifytext.isVisible = true

	         PhoneDetail_titlestar.y= PhoneDetail_bg.y
			 PhoneDetail_titletext.y= PhoneDetail_bg.y
			 PhoneDetail_bottom.y= PhoneDetailValue.y+10
			 PhoneDetailValue.y =PhoneDetail_titletext.y+PhoneDetail_titletext.contentHeight+9

			 textnotifybox.y = PhoneDetail_bottom.y + 15
			 textnotifytext.y = PhoneDetail_bottom.y + 15

			 MKRankDetail_bg.y =  textnotifytext.y+textnotifytext.contentHeight+5
			 MKRankDetail_title.y= MKRankDetail_bg.y+7
			 MKRankDetailValue.y= MKRankDetail_title.y+MKRankDetail_title.contentHeight+7
		     MKRankDetail_bottom.y= MKRankDetailValue.y+9

		     Requesteddate_bg.y = MKRankDetail_bottom.y+MKRankDetail_bottom.height+7
		     Requesteddate_title.y= Requesteddate_bg.y + 7
		     RequesteddateValue.y= Requesteddate_title.y+Requesteddate_title.height+8
		     Requesteddate_bottom.y= RequesteddateValue.y+9


		     if popupText.text == "Deny Access" then


		      Password_bg.isVisible = false
		      Password_titlestar.isVisible = false
		      Password_titletext.isVisible = false
		      Password_bottom.isVisible = false
		      PasswordValue.isVisible = false
		      PasswordHelptext.isVisible = false
		      GeneratePasstext.isVisible = false
		      processbutton.y = GeneratePasstext.y+GeneratePasstext.contentHeight+22
			  processbutton_text.y=processbutton.y

			  deny_bg.y = Requesteddate_bottom.y + 45
			  deny_Value.y=deny_bg.y
			  processbutton.y = deny_Value.y+deny_Value.contentHeight-10
			  processbutton_text.y=processbutton.y

			  phonenumber = PhoneDetailValue.text
			  email = EmailDetailValue.text
			  denyreason = deny_Value.text
			  isSentMailValue = isSentMail
			  isSendTextValue = isSentText


			  RequestGrantProcess()

			 elseif popupText.text == "Provide Access" then


			 	Requesteddate_bg.isVisible = false
			 	RequesteddateValue.isVisible = false
			 	Requesteddate_title.isVisible = false
			 	Requesteddate_bottom.isVisible = false

			  Password_bg.y =  MKRankDetail_bottom.y+MKRankDetail_bottom.contentHeight+7
		      Password_titlestar.y= Password_bg.y+7
		      Password_titletext.y= Password_bg.y+7
		      PasswordValue.y =Password_titletext.y+Password_titletext.contentHeight+8
		      Password_bottom.y= PasswordValue.y +9.5
		      PasswordHelptext.y= Password_bottom.y + 12
		      GeneratePasstext.y= PasswordHelptext.y + 20
		      processbutton.y = GeneratePasstext.y+GeneratePasstext.contentHeight+22
			  processbutton_text.y=processbutton.y


		     else


		      Password_bg.y =  Requesteddate_bg.y+Requesteddate_bg.height+7
		      Password_titlestar.y= RequesteddateValue.y+RequesteddateValue.height+15
		      Password_titletext.y= RequesteddateValue.y+RequesteddateValue.height+15
		      Password_bottom.y= Password_titletext.y+Password_titletext.height+16
		      PasswordValue.y =Password_titletext.y+Password_titletext.height+5
		      PasswordHelptext.y= Password_bottom.y + 12
		      GeneratePasstext.y= PasswordHelptext.y + 20
		      processbutton.y = GeneratePasstext.y+GeneratePasstext.contentHeight+22
			  processbutton_text.y=processbutton.y

			 end

	    end


		if PasswordValue.text == "" or PasswordValue.text == PasswordValue.id or PasswordValue.text == "* Password is required" then

			validation = false

		SetError("* ".."Password is required",PasswordValue)

	    elseif PasswordValue.text:len() < 6 then

	    	validation = false

	    SetError("* ".."Password should contain atleast 6 characters",PasswordValue)

		end


  --      if popupText.text == " Deny Access" then

		-- if deny_Value.text == "" or deny_Value.text.placeholder == "Reason for deny" then

		-- 	validation = false

		-- 	SetError("* ".."Reason is required",deny_Value)
		-- end

	 --  end


						
			if(validation == true) then

				 isSentMailValue = isSentMail
   	             isSendTextValue = isSentText
   	             PhoneNo=PhoneDetailValue.text
   	             EmailAddress = EmailDetailValue.text


   	             --denyreason = deny_Value.text


				  RequestGrantProcess()

			end


    end

    return true

end


local function popup_scrollListener(event )

		    local phase = event.phase
		 if ( phase == "began" ) then 
		 elseif ( phase == "moved" ) then 

			local x, y = popup_scroll:getContentPosition()

			if y > -80 then

				EmailDetailValue.isVisible = true

			else

				EmailDetailValue.isVisible = false
			end

			-- if y > -10 and y < 30 then

			-- 	print("value of y " ,y)

			-- 	deny_bg.isVisible = false
			-- 	deny_Value.isVisible = false
			-- end

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





function GetPopUp(email,mobile,homenum,worknum,othernum,id_value)

		if popUpGroup.numChildren ~= nil then
			 for j=popUpGroup.numChildren, 1, -1 do 
								display.remove(popUpGroup[popUpGroup.numChildren])
								popUpGroup[popUpGroup.numChildren] = nil
			 end
		end


	popupTop_bg = display.newRect(leftPadding_value + 140, H/2+ 10, W-20, 385 )
	popupTop_bg.x = leftPadding_value + 140
    popupTop_bg:setFillColor(0,0,0)
    popupTop_bg:addEventListener("touch",touchBg)
    popUpGroup:insert(popupTop_bg)

    popupTop = display.newRect(W/2,H/2-195,298,30)
    popupTop:setStrokeColor(0,0,0)
    popupTop.strokeWidth=1
    popupTop:setFillColor(Utils.convertHexToRGB(color.LtyGray))
    popUpGroup:insert(popupTop)

    popupText = display.newText("",0,0,native.systemFont,18)
    popupText.anchorX = 0
    popupText.x=20
    popupText.y=popupTop.y
    popupText:setTextColor(0,0,0)
    popUpGroup:insert(popupText)

    popupClose_bg = display.newRect(0,0,30,30)
    popupClose_bg.x=popupTop.x+popupTop.contentWidth/2-15
    popupClose_bg.y=popupTop.y
    popupClose_bg.id="close"
    popupClose_bg.alpha=0.01
    popUpGroup:insert(popupClose_bg)
    popupClose_bg:addEventListener("touch",onCloseTouch)

	popupClose = display.newImageRect("res/assert/cancel.png",19,19)
    popupClose.x=popupClose_bg.x
    popupClose.y=popupClose_bg.y
    popupClose:setFillColor(0,0,0)
    popupClose.id="close"
    popUpGroup:insert(popupClose)
    --popupClose:addEventListener("touch",onCloseTouch)




   -- popUpGroup.isVisible = true


--------------------------------popup details--------------------------------------

	popup_scroll = widget.newScrollView
	{
	top = 61,
	left = 0,
	width = W-5,
	height = popupTop_bg.contentHeight-4,
	hideBackground = true,
	isBounceEnabled=false,
	horizontalScrollDisabled = true,
	verticalScrollDisabled = false,
	friction = .6,
   	listener = popup_scrollListener,
    }


    popupList = display.newRect(leftPadding_value + 140, 0, W-22, popupTop_bg.contentHeight+78 )
    popupList.anchorY=0
    popup_scroll:insert(popupList)


--------------------------------------name field--------------------------------------

        NameDetail_bg = display.newRect(W/2, popupList.y+5, W-40, 25)
		NameDetail_bg.isVisible = true
		NameDetail_bg.alpha = 0.01
		NameDetail_bg:setFillColor(0,0,0)
		NameDetail_bg.y = popupList.y+20
		popup_scroll:insert(NameDetail_bg)

	    NameDetail_title = display.newText("Name ",0,0,native.systemFontBold,14)
	    NameDetail_title.x= 44
	    NameDetail_title:setFillColor(0,0,0)
	    NameDetail_title.y= NameDetail_bg.y
	    popup_scroll:insert(NameDetail_title)

	    NameDetailValue = display.newText("",0,0,native.systemFont,14)
	    NameDetailValue.x=  NameDetail_title.x - 20
	    NameDetailValue.anchorX = 0
	    NameDetailValue:setFillColor(0,0,0)
	    NameDetailValue.y= NameDetail_title.y+NameDetail_title.contentHeight+7
	    popup_scroll:insert(NameDetailValue)


	    NameDetail_bottom = display.newImageRect("res/assert/line-large.png",W-40,5)
		NameDetail_bottom.x=W/2
		NameDetail_bottom.y= NameDetailValue.y+8.5
		popup_scroll:insert(NameDetail_bottom)


--------------------------------------email field--------------------------------------

        EmailDetail_bg = display.newRect(W/2,NameDetail_bg.y+15, W-40, 25)
		EmailDetail_bg.isVisible = true
		EmailDetail_bg.alpha = 0.01
		EmailDetail_bg.y = NameDetail_bottom.y+NameDetail_bottom.contentHeight+15
		popup_scroll:insert(EmailDetail_bg)

		EmailDetail_titlestar = display.newText("*",0,0,native.systemFontBold,14)
	    EmailDetail_titlestar.x= 20
	    EmailDetail_titlestar:setFillColor(1,0,0)
	    EmailDetail_titlestar.y= EmailDetail_bg.y
	    popup_scroll:insert(EmailDetail_titlestar)

		EmailDetail_titletext = display.newText("Email ",0,0,native.systemFontBold,14)
	    EmailDetail_titletext.x= 44
	    EmailDetail_titletext:setFillColor(0,0,0)
	    EmailDetail_titletext.y= EmailDetail_bg.y
	    popup_scroll:insert(EmailDetail_titletext)

		EmailDetailValue = native.newTextField(W/2,NameDetail_bg.y+28, W-40, 25)
		EmailDetailValue.id="Email Detail"
		EmailDetailValue.size=14	
		EmailDetailValue.y = EmailDetail_titletext.y+ EmailDetail_titletext.contentHeight+9
		EmailDetailValue.hasBackground = false
		EmailDetailValue.isVisible = true
		EmailDetailValue:setReturnKey( "next" )
		EmailDetailValue.placeholder="Email"
		popup_scroll:insert(EmailDetailValue)


		EmailDetail_bottom = display.newImageRect("res/assert/line-large.png",W-40,5)
		EmailDetail_bottom.x=W/2
		EmailDetail_bottom.y= EmailDetailValue.y+11.5
		popup_scroll:insert(EmailDetail_bottom)


---------------------------------send email notification checkbox-----------------------

    emailnotifybox = widget.newSwitch(
    {
        left = 15,
        top = EmailDetail_bottom.y,
        style = "checkbox",
        id = "email_Checkbox",
        initialSwitchState = true,
        onPress = onSwitchPress
    })
    emailnotifybox.width= 20
    emailnotifybox.height = 20

    popup_scroll:insert(emailnotifybox)


    emailnotifytext = display.newText("Send email notification",0,0,native.systemFont,14)
    emailnotifytext.x= 50
    emailnotifytext.anchorX=0
    emailnotifytext:setFillColor(0,0,0)
    emailnotifytext.y= EmailDetail_bottom.y + 15
    popup_scroll:insert(emailnotifytext)


--------------------------------------PHONE NUMBER--------------------------------------------

        PhoneDetail_bg = display.newRect(W/2,emailnotifytext.y+15, W-40, 25)
		PhoneDetail_bg.isVisible = true
		PhoneDetail_bg.alpha = 0.01
		PhoneDetail_bg.y =  emailnotifybox.y+emailnotifybox.contentHeight+5
		popup_scroll:insert(PhoneDetail_bg)


		PhoneDetail_titlestar = display.newText("*",0,0,native.systemFontBold,14)
	    PhoneDetail_titlestar.x= 20
	    PhoneDetail_titlestar:setFillColor(1,0,0)
	    PhoneDetail_titlestar.y= PhoneDetail_bg.y
	    popup_scroll:insert(PhoneDetail_titlestar)

		PhoneDetail_titletext = display.newText("Phone ",0,0,native.systemFontBold,14)
	    PhoneDetail_titletext.x= 47
	    PhoneDetail_titletext:setFillColor(0,0,0)
	    PhoneDetail_titletext.y= PhoneDetail_bg.y
	    popup_scroll:insert(PhoneDetail_titletext)


		PhoneDetailValue = native.newTextField(W/2,emailnotifytext.y+28, W-40, 25)
		PhoneDetailValue.id="Phone Detail"
		PhoneDetailValue.size=14	
		PhoneDetailValue.inputType = "number"
		PhoneDetailValue.y = PhoneDetail_titletext.y+PhoneDetail_titletext.contentHeight+9
		PhoneDetailValue.hasBackground = false
		PhoneDetailValue.isVisible = true
		PhoneDetailValue:setReturnKey( "next" )
		PhoneDetailValue.placeholder="Phone"
		popup_scroll:insert(PhoneDetailValue)

		PhoneDetail_bottom = display.newImageRect("res/assert/line-large.png",W-40,5)
		PhoneDetail_bottom.x=W/2
		PhoneDetail_bottom.y= PhoneDetailValue.y+10
		popup_scroll:insert(PhoneDetail_bottom)


------------------------------------text notification checkbox----------------------------------

   textnotifybox = widget.newSwitch(
    {
        left =  15,
        top = PhoneDetail_bottom.y,
        style = "checkbox",
        id = "text_Checkbox",
        initialSwitchState = true,
        onPress = onSwitchPress
    })
    textnotifybox.width= 20
    textnotifybox.height = 20

    popup_scroll:insert(textnotifybox)

    textnotifytext = display.newText("Send text notification",0,0,native.systemFont,14)
    textnotifytext.x= 50
    textnotifytext:setFillColor(0,0,0)
    textnotifytext.anchorX=0
    textnotifytext.y= PhoneDetail_bottom.y + 15
    popup_scroll:insert(textnotifytext)

-----------------------------------MKRank detail-------------------------------------------------

        MKRankDetail_bg = display.newRect(W/2,textnotifytext.y+30, W-40, 25)
		MKRankDetail_bg.isVisible = true
		MKRankDetail_bg.alpha = 0.01
		MKRankDetail_bg.y =  textnotifytext.y+textnotifytext.contentHeight+5
		popup_scroll:insert(MKRankDetail_bg)

		-- MKRankDetail_bottom = display.newImageRect(popUpGroup,"res/assert/line-large.png",W-45,5)
		-- MKRankDetail_bottom.x=W/2
		-- MKRankDetail_bottom.y= textnotifytext.y+textnotifytext.height+15

		-- MKRankDetailValue = native.newTextField(W/2,textnotifytext.y+28, W-45, 25)
		-- MKRankDetailValue.id="MKRank Detail"
		-- MKRankDetailValue.size=14	
		-- MKRankDetailValue.y =textnotifytext.y+textnotifytext.height+5
		-- MKRankDetailValue.hasBackground = false
		-- MKRankDetailValue.isVisible = true
		-- MKRankDetailValue:setReturnKey( "next" )
		-- MKRankDetailValue.placeholder="MK Rank"
		-- popUpGroup:insert(MKRankDetailValue)


		MKRankDetail_title = display.newText("MK Rank ",0,0,native.systemFontBold,14)
	    MKRankDetail_title.x= 22
	    MKRankDetail_title.anchorX = 0
	    MKRankDetail_title:setFillColor(0,0,0)
	    MKRankDetail_title.y= MKRankDetail_bg.y+15
	    popup_scroll:insert(MKRankDetail_title)

	    MKRankDetailValue = display.newText("",0,0,native.systemFont,14)
	    MKRankDetailValue.x= 25
	    MKRankDetailValue:setFillColor(0,0,0)
	    MKRankDetailValue.anchorX = 0
	    MKRankDetailValue.y= MKRankDetail_title.y+MKRankDetail_title.height+7
	    popup_scroll:insert(MKRankDetailValue)

	    MKRankDetail_bottom = display.newImageRect("res/assert/line-large.png",W-40,5)
		MKRankDetail_bottom.x=W/2
		MKRankDetail_bottom.y= MKRankDetailValue.y+8.5
		popup_scroll:insert(MKRankDetail_bottom)


-----------------------------------Requested_on detail-------------------------------------------------

        Requesteddate_bg = display.newRect(W/2,MKRankDetailValue.y+15, W-40, 25)
		Requesteddate_bg.isVisible = true
		Requesteddate_bg.alpha = 0.01
		Requesteddate_bg.y =  MKRankDetail_bottom.y+MKRankDetail_bottom.height+7
		popup_scroll:insert(Requesteddate_bg)

		-- Requesteddate_bottom = display.newImageRect(popUpGroup,"res/assert/line-large.png",W-45,5)
		-- Requesteddate_bottom.x=W/2
		-- Requesteddate_bottom.y= MKRankDetail_bg.y+MKRankDetail_bg.height+17

		-- RequesteddateValue = native.newTextField(W/2,textnotifytext.y+28, W-45, 25)
		-- RequesteddateValue.id="Requested Detail"
		-- RequesteddateValue.size=14	
		-- RequesteddateValue.y =MKRankDetail_bg.y+MKRankDetail_bg.height+7
		-- RequesteddateValue.hasBackground = false
		-- RequesteddateValue.isVisible = true
		-- RequesteddateValue:setReturnKey( "next" )
		-- RequesteddateValue.placeholder="Requested On"
		-- popUpGroup:insert(RequesteddateValue)

		Requesteddate_title = display.newText("Requested On ",0,0,native.systemFontBold,14)
	    Requesteddate_title.x= 22
	    Requesteddate_title:setFillColor(0,0,0)
	    Requesteddate_title.anchorX = 0
	    Requesteddate_title.y= Requesteddate_bg.y + 7
	    popup_scroll:insert(Requesteddate_title)

	    RequesteddateValue = display.newText("",0,0,native.systemFont,14)
	    RequesteddateValue.x= 25
	    RequesteddateValue:setFillColor(0,0,0)
	    RequesteddateValue.anchorX = 0
	    RequesteddateValue.y= Requesteddate_title.y+Requesteddate_title.height+7
	    popup_scroll:insert(RequesteddateValue)


	    Requesteddate_bottom = display.newImageRect("res/assert/line-large.png",W-40,5)
		Requesteddate_bottom.x=W/2
		Requesteddate_bottom.y= RequesteddateValue.y+8.5
		popup_scroll:insert(Requesteddate_bottom)


--------------------------------------reason for deny---------------------------------------------

    deny_bg = display.newRect( 0,0 , W-40, EditBoxStyle.height+40)
  	deny_bg:setStrokeColor(0,0,0,0.4)
  	deny_bg.x = W/2
  	deny_bg.isVisible = false
  	deny_bg.y = Requesteddate_bottom.y + 40
  	deny_bg.hasBackground = true
	deny_bg.strokeWidth = 1
	popup_scroll:insert(deny_bg)


	deny_Value = native.newTextBox( deny_bg.width,deny_bg.height,W-40, EditBoxStyle.height+40)
	deny_Value.placeholder = "Reason for deny"
	deny_Value.isEditable = true
	deny_Value.size=14
	deny_Value.isVisible = false
	deny_Value.value=""
	deny_Value.id = "deny"
	deny_Value.hasBackground = true
	deny_Value:setReturnKey( "done" )
	deny_Value.inputType = "default"
	deny_Value.x=W/2
	deny_Value.y=deny_bg.y
	popup_scroll:insert(deny_Value)





-----------------------------------password detail-------------------------------------------------

        Password_bg = display.newRect(W/2,Requesteddate_bg.y+15, W-40, 25)
		Password_bg.isVisible = true
		Password_bg.alpha = 0.01
		Password_bg.y =  Requesteddate_bg.y+Requesteddate_bg.height+7
		popup_scroll:insert(Password_bg)

		Password_titlestar = display.newText("*",0,0,native.systemFontBold,14)
	    Password_titlestar.x= 19
	    Password_titlestar:setFillColor(1,0,0)
	    Password_titlestar.y= RequesteddateValue.y+RequesteddateValue.height+15
	    popup_scroll:insert(Password_titlestar)

		Password_titletext = display.newText("Password ",0,0,native.systemFontBold,14)
	    Password_titletext.x= 57
	    Password_titletext:setFillColor(0,0,0)
	    Password_titletext.y= RequesteddateValue.y+RequesteddateValue.height+15
	    popup_scroll:insert(Password_titletext)

		PasswordValue = native.newTextField(22,textnotifytext.y+28, W-40, 25)
		PasswordValue.id="Password"
		PasswordValue.size=14	
		PasswordValue.anchorX = 0
		PasswordValue.x = 18
		PasswordValue.y =Password_titletext.y+Password_titletext.height+7
		PasswordValue.hasBackground = false
		PasswordValue.isVisible = true
		PasswordValue:setReturnKey( "done" )
		PasswordValue.placeholder="Password"
		popup_scroll:insert(PasswordValue)

		Password_bottom = display.newImageRect("res/assert/line-large.png",W-40,5)
		Password_bottom.x=W/2
		Password_bottom.y= PasswordValue.y+10
		popup_scroll:insert(Password_bottom)

-----------------------------------password helptext detail-------------------------------------------------

    PasswordHelptext = display.newText("Password must be between 6 and 12 characters in length",0,0,W-30,0,native.systemFont,10.5)
    PasswordHelptext.x= popupTop_bg.x+5
    PasswordHelptext:setFillColor(0,0,0)
    PasswordHelptext.y= Password_bottom.y + 12
    popup_scroll:insert(PasswordHelptext)

 -----------------------------------generate password detail-------------------------------------------------

    GeneratePasstext = display.newText("Generate Password",0,0,W-30,0,native.systemFontBold,14.5)
    GeneratePasstext.x= W - 15
    GeneratePasstext:setFillColor(0,0,0.5)
    GeneratePasstext.y= PasswordHelptext.y + 20
    popup_scroll:insert(GeneratePasstext)
    GeneratePasstext:addEventListener("touch",OnPasswordGeneration)


-------------------------------------process button----------------------------------------------------------

    processbutton = display.newRect( 0,0 ,120, EditBoxStyle.height-3)
  	processbutton:setStrokeColor(0,0,0,0.7)
  	processbutton:setFillColor(0,0,0,0.3)
  	processbutton.cornerRadius = 2
  	processbutton.x = Password_bg.x
  	processbutton.y = GeneratePasstext.y+GeneratePasstext.contentHeight+22
  	processbutton.hasBackground = true
	processbutton.strokeWidth = 1
	popup_scroll:insert(processbutton)
	--processbutton:addEventListener("touch",onProcessButtonTouch)

	processbutton_text = display.newText("",0,0,native.systemFont,14)
	processbutton_text.x=processbutton.x
	processbutton_text.y=processbutton.y
	processbutton_text:setFillColor(0,0,0)
	popup_scroll:insert(processbutton_text)




    if email ~= nil or email ~= "" or email ~= "* Email Address is required" then
	EmailDetailValue.text = email
	emailnotifytext.isVisible = true
    emailnotifybox.isVisible = true
    else
    EmailDetailValue.text = nil
    emailnotifytext.isVisible = false
    emailnotifybox.isVisible = false
    end


    if mobile ~= nil or mobile ~= "" then
    	PhoneDetailValue.text = mobile
    	--textnotifybox.isVisible = true
    	--textnotifytext.isVisible = true

    	MKRankDetail_bg.y =  textnotifytext.y+textnotifytext.contentHeight+15
    elseif homenum ~= nil or homenum ~= "" then
    	PhoneDetailValue.text = homenum
    	--textnotifybox.isVisible = true
    	--textnotifytext.isVisible = true

    	MKRankDetail_bg.y =  textnotifytext.y+textnotifytext.contentHeight+15
    elseif othernum ~= nil or othernum ~= "" then
    	PhoneDetailValue.text = othernum
    	--textnotifybox.isVisible = true
    	--textnotifytext.isVisible = true

    	MKRankDetail_bg.y =  textnotifytext.y+textnotifytext.contentHeight+15
    elseif worknum  ~= nil or worknum ~= "" then
    	PhoneDetailValue.text = worknum
    	--textnotifybox.isVisible = true
    	--textnotifytext.isVisible = true

    	MKRankDetail_bg.y =  textnotifytext.y+textnotifytext.contentHeight+15
    else
    	PhoneDetailValue.text = nil
    	--textnotifybox.isVisible = false
    	--textnotifytext.isVisible = false

    	MKRankDetail_bg.y =  textnotifytext.y+textnotifytext.contentHeight+5
    end


    popUpGroup:insert(popup_scroll)

    MainGroup:insert(popUpGroup)


end

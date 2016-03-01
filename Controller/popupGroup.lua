----------------------------------------------------------------------------------
--
-- careerPathDetailPage.lua
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local Utility = require( "Utils.Utility" )
local widget = require( "widget" )



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


	local function createField()

		print("hello")

		input = native.newTextField(W/2+28,PhoneDetail_titletext.y, W-112, 25)

		return input
	end



	local function SetError( displaystring, object )

		object.text=displaystring
		object.size=10
		object:setTextColor(1,0,0)
	end





		function textField( event )

					if ( event.phase == "began" ) then


							event.target:setTextColor(color.black)

							current_textField = nil

							current_textField = event.target;


							current_textField.size=14

							if "*" == event.target.text:sub(1,1) then
								event.target.text=""
							end


					elseif ( event.phase == "submitted" ) then

					elseif event.phase == "ended" then
										


        			elseif ( event.phase == "editing" ) then

						 if(current_textField.id =="Phone Detail") then

							print(event.target.text)

							local tempvalue = event.target.text:sub(1,1)

							if (event.target.text:len() == 3) then

								if (tempvalue ~= "(") then

									local previousText=event.target.text

									event.target:removeSelf( );event.target.text=nil

									PhoneDetailValue = createField()
									PhoneDetailValue.id="Phone Detail"
									PhoneDetailValue.size=14	
									PhoneDetailValue:setReturnKey( "next" )
									PhoneDetailValue.hasBackground = false
								
									PhoneDetailValue.placeholder="Phone"
									PhoneDetailValue.inputType = "number"
									popUpGroup:insert( PhoneDetailValue )

									PhoneDetailValue.text="("..previousText..") "

									PhoneDetailValue:addEventListener( "userInput", textField )

									native.setKeyboardFocus(PhoneDetailValue)
							
								else

									event.target.text = event.target.text:sub(2,event.target.text:len())

								end

							elseif event.target.text:len() == 5 and (tempvalue == "(") then

								if event.target.text:sub(5,5) ~= ")" then

									event.target.text = event.text:sub(1,4)..") "..event.target.text:sub(5,5)
				
								end


							elseif event.target.text:len() == 9 and not string.find(event.target.text,"-") then

									local previousText=event.target.text

									event.target:removeSelf( );event.target.text=nil

									PhoneDetailValue = createField()
									PhoneDetailValue.id="Phone Detail"
									PhoneDetailValue.size=14	
									PhoneDetailValue:setReturnKey( "next" )
									PhoneDetailValue.hasBackground = false
									PhoneDetailValue.placeholder="Phone"

									PhoneDetailValue.inputType = "number"
									popUpGroup:insert( PhoneDetailValue )

									PhoneDetailValue.text=previousText.."- "

									PhoneDetailValue:addEventListener( "userInput", textField )

									native.setKeyboardFocus(PhoneDetailValue)


							elseif event.target.text:len() == 10 then

								if string.find(event.target.text,"-") then

									event.target.text = event.target.text:sub(1,9)
								else

									event.target.text = event.target.text:sub(1,9).."- "..event.target.text:sub(10,10)
								end

							end

							if event.target.text:len() > 15 then

								print("greater value")

								event.target.text = event.target.text:sub(1,15)

							end
						end

		  end

---------------------for password -------------------------------------------------------------------------------
							if(current_textField.id == "Password") then

        					if event.target.text:len() > 12 then

								event.target.text = event.target.text:sub(1,12)

							end
						end
-------------------------------------------------------------------------------------------------------------------
        	
	end



 function onSwitchPress( event )
    local switch = event.target
    if (switch.id == "email_Checkbox" ) then

    	isSentMail = tostring(switch.isOn)

    	print("Sent mail switch",isSentMail)
    end

    if (switch.id == "text_Checkbox" ) then

    	isSentText = tostring(switch.isOn)

    	print("Sent text switch",isSentText)
    	
    end
 end






	function onGrantButtonTouch( event )

    if event.phase == "began" then



        if Details.Mobile ~= nil then
        	 PhoneDetailValue.text=Details.Mobile
					textnotifybox.isVisible = true
		 		    textnotifytext.isVisible = true
        elseif Details.HomePhoneNumber ~= nil  then
        	 PhoneDetailValue.text=Details.HomePhoneNumber
            		textnotifybox.isVisible = true
		 		    textnotifytext.isVisible = true
        elseif Details.WorkPhoneNumber ~= nil  then
             PhoneDetailValue.text = Details.WorkPhoneNumber
                    textnotifybox.isVisible = true
		 		    textnotifytext.isVisible = true
        elseif Details.OtherPhoneNumber ~= nil then
             PhoneDetailValue.text = Details.OtherPhoneNumber
                    textnotifybox.isVisible = true
		 		    textnotifytext.isVisible = true      
        else
          	 PhoneDetailValue.text = ""
          		--    textnotifybox.isVisible = true
		 		 --   textnotifytext.isVisible = true
        end

        PhoneNum = PhoneDetailValue.text

        print("Phone for grant access: "..PhoneNum)



        if Details.EmailAddress ~= nil then
    	EmailDetailValue.text = Details.EmailAddress
        else
    	EmailDetailValue.text  = ""
        end

        Email = EmailDetailValue.text
        print("Email for grant access: "..Email)


    elseif event.phase == "ended" then

        local validation = true

        native.setKeyboardFocus(nil)

			if (EmailDetailValue.text == "") or (EmailDetailValue.text == EmailDetailValue.id) or (not Utils.emailValidation(EmailDetailValue.text)) then
			validation=false
			SetError("* ".."Email Address is required",EmailDetailValue)

			  emailnotifybox.isVisible = false
			  emailnotifytext.isVisible = false


			  PhoneDetail_titlestar.y= EmailDetail_bg.y+EmailDetail_bg.height+5
			  PhoneDetail_titletext.y= EmailDetail_bg.y+EmailDetail_bg.height+5
			  PhoneDetail_bottom.y= emailnotifytext.y+emailnotifytext.height+7
			  PhoneDetailValue.y =emailnotifytext.y+emailnotifytext.height-2
			  textnotifytext.y= PhoneDetail_bottom.y +12
			  textnotifybox.y = PhoneDetail_bottom.y +13

			  MKRankDetail_title.y= PhoneDetail_titletext.y+PhoneDetail_titletext.height+32
			  MKRankDetailValue.y= MKRankDetail_title.y+MKRankDetail_title.height+8
			  MKRankDetail_bottom.y= MKRankDetailValue.y+9

			  Requesteddate_bg.y =  MKRankDetailValue.y+MKRankDetailValue.height+7
			  Requesteddate_title.y= MKRankDetailValue.y+MKRankDetailValue.height+12
			  RequesteddateValue.y= Requesteddate_title.y+Requesteddate_title.height+8
			  Requesteddate_bottom.y= RequesteddateValue.y+9

			  Password_bg.y =  Requesteddate_bg.y+Requesteddate_bg.height+7
			  Password_titlestar.y= RequesteddateValue.y+RequesteddateValue.height+12
			  Password_titletext.y= RequesteddateValue.y+RequesteddateValue.height+12
			  Password_bottom.y= Password_titletext.y+Password_titletext.height+15
			  PasswordValue.y =Password_titletext.y+Password_titletext.height+5
			  PasswordHelptext.y= Password_bottom.y + 12
			  GeneratePasstext.y= PasswordHelptext.y + 20
			  processbutton.y = GeneratePasstext.y+GeneratePasstext.contentHeight+22
	          processbutton_text.y=processbutton.y

		    else 
				emailnotifybox.isVisible = true
			    emailnotifytext.isVisible = true

			    PhoneDetail_titlestar.y= EmailDetail_bg.y+EmailDetail_bg.height+20
			    PhoneDetail_titletext.y= EmailDetail_bg.y+EmailDetail_bg.height+20
			    PhoneDetail_bottom.y= emailnotifytext.y+emailnotifytext.height+22
			    PhoneDetailValue.y =emailnotifytext.y+emailnotifytext.height+12
			    textnotifytext.y= PhoneDetail_bottom.y + 15
			    textnotifybox.y = PhoneDetail_bottom.y+15

		    MKRankDetail_title.y= PhoneDetail_titletext.y+PhoneDetail_titletext.height+32
		    MKRankDetailValue.y= MKRankDetail_title.y+MKRankDetail_title.height+8
		    MKRankDetail_bottom.y= MKRankDetailValue.y+9

		     Requesteddate_bg.y =  MKRankDetailValue.y+MKRankDetailValue.height+7
		     Requesteddate_title.y= MKRankDetailValue.y+MKRankDetailValue.height+12
		     RequesteddateValue.y= Requesteddate_title.y+Requesteddate_title.height+8
		     Requesteddate_bottom.y= RequesteddateValue.y+9

		      Password_bg.y =  Requesteddate_bg.y+Requesteddate_bg.height+7
		      Password_titlestar.y= RequesteddateValue.y+RequesteddateValue.height-2
		      Password_titletext.y= RequesteddateValue.y+RequesteddateValue.height+12
		      Password_bottom.y= Password_titletext.y+Password_titletext.height+15
		      PasswordValue.y =Password_titletext.y+Password_titletext.height+5
		      PasswordHelptext.y= Password_bottom.y + 12
		      GeneratePasstext.y= PasswordHelptext.y + 20
		      processbutton.y = GeneratePasstext.y+GeneratePasstext.contentHeight+22
			  processbutton_text.y=processbutton.y

		end



		if PhoneDetailValue.text == "" or PhoneDetailValue.text == PhoneDetailValue.id or PhoneDetailValue.text:len()<14 or PhoneDetailValue.text == "* Phone number is required" then
			validation=false
			--print(PhoneDetailValue.text)
			--print(PhoneDetailValue.text:len())
		    SetError("* ".."Phone number is required",PhoneDetailValue)

		    textnotifybox.isVisible = false
		    textnotifytext.isVisible = false


		     MKRankDetail_title.y= PhoneDetail_titletext.y+PhoneDetail_titletext.height+18
		     MKRankDetailValue.y= MKRankDetail_title.y+MKRankDetail_title.height+8
			 MKRankDetail_bottom.y= MKRankDetailValue.y+9

			 Requesteddate_bg.y =  MKRankDetailValue.y+MKRankDetailValue.height+7
			 Requesteddate_title.y= MKRankDetailValue.y+MKRankDetailValue.height+12
		     RequesteddateValue.y= Requesteddate_title.y+Requesteddate_title.height+8
		     Requesteddate_bottom.y= RequesteddateValue.y+9

		      Password_bg.y =  Requesteddate_bg.y+Requesteddate_bg.height+7
		      Password_titlestar.y= RequesteddateValue.y+RequesteddateValue.height+12
		      Password_titletext.y= RequesteddateValue.y+RequesteddateValue.height+12
		      Password_bottom.y= Password_titletext.y+Password_titletext.height+15
		      PasswordValue.y =Password_titletext.y+Password_titletext.height+5
		      PasswordHelptext.y= Password_bottom.y + 12
		      GeneratePasstext.y= PasswordHelptext.y + 20
		      processbutton.y = GeneratePasstext.y+GeneratePasstext.contentHeight+22
			  processbutton_text.y=processbutton.y
		else 


			textnotifybox.isVisible = true
			textnotifytext.isVisible = true

			 MKRankDetail_title.y= PhoneDetail_titletext.y+PhoneDetail_titletext.height+32
			 MKRankDetailValue.y= MKRankDetail_title.y+MKRankDetail_title.height+8
		     MKRankDetail_bottom.y= MKRankDetailValue.y+9

		     Requesteddate_bg.y =  MKRankDetailValue.y+MKRankDetailValue.height+7
		     Requesteddate_title.y= MKRankDetailValue.y+MKRankDetailValue.height+12
		     RequesteddateValue.y= Requesteddate_title.y+Requesteddate_title.height+8
		     Requesteddate_bottom.y= RequesteddateValue.y+9

		      Password_bg.y =  Requesteddate_bg.y+Requesteddate_bg.height+7
		      Password_titlestar.y= RequesteddateValue.y+RequesteddateValue.height+12
		      Password_titletext.y= RequesteddateValue.y+RequesteddateValue.height+12
		      Password_bottom.y= Password_titletext.y+Password_titletext.height+15
		      PasswordValue.y =Password_titletext.y+Password_titletext.height+5
		      PasswordHelptext.y= Password_bottom.y + 12
		      GeneratePasstext.y= PasswordHelptext.y + 20
		      processbutton.y = GeneratePasstext.y+GeneratePasstext.contentHeight+22
			  processbutton_text.y=processbutton.y
	    end


		if PasswordValue.text == "" or PasswordValue.text == PasswordValue.id or PasswordValue.text == "* Password is required"then

			validation = false

		SetError("* ".."Password is required",PasswordValue)

	    elseif PasswordValue.text:len() < 6 then

	    	validation = false

	    SetError("* ".."Password should contain atleast 6 characters",PasswordValue)

		end

						
			if(validation == true) then

				print("here [][[][][][][][][]]]")
				 isSentMailValue = isSentMail
				 print(isSentMailValue)
   	             isSendTextValue = isSentText
   	             print(isSendTextValue)
   	             PhoneNo=PhoneNum
   	             print("{{{{{{{{{{",PhoneNo)
   	             EmailAddress = Email
   	             print("{{{{{{{{{{",EmailAddress)


				RequestGrantProcess()

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




function GetPopUp(email,mobile,homenum,worknum,othernum)

		if popUpGroup.numChildren ~= nil then
			 for j=popUpGroup.numChildren, 1, -1 do 
								display.remove(popUpGroup[popUpGroup.numChildren])
								popUpGroup[popUpGroup.numChildren] = nil
			 end
		end

		-- 	if popup_scroll.numChildren ~= nil then
		-- 	 for j=popup_scroll.numChildren, 1, -1 do 
		-- 						display.remove(popup_scroll[popup_scroll.numChildren])
		-- 						popup_scroll[popup_scroll.numChildren] = nil
		-- 	 end
		-- end



	popupTop_bg = display.newRect(leftPadding_value + 140, H/2+ 10, W-20, 382 )
	popupTop_bg.x = leftPadding_value + 140
    popupTop_bg:setFillColor(0,0,0)
    popupTop_bg:addEventListener("touch",touchBg)
    popUpGroup:insert(popupTop_bg)

    popupTop = display.newRect(W/2,H/2-195,298,30)
    popupTop:setStrokeColor(0,0,0)
    popupTop.strokeWidth=1
    popupTop:setFillColor(Utils.convertHexToRGB(color.LtyGray))
    popUpGroup:insert(popupTop_bg)

    popupText = display.newText("",0,0,native.systemFont,18)
    popupText.anchorX = 0
    popupText.x=20
    popupText.y=popupTop.y
    popupText:setTextColor(0,0,0)
    popUpGroup:insert(popupTop_bg)

    popupClose = display.newImageRect("res/assert/cancel.png",19,19)
    popupClose.x=popupTop.x+popupTop.contentWidth/2-15
    popupClose.y=popupText.y 
    popupClose.id="close"
    popUpGroup:insert(popupClose)
    popupClose:addEventListener("touch",onCloseTouch)

    popupClose_bg = display.newRect(0,0,30,30)
    popupClose_bg.x=popupTop.x+popupTop.contentWidth/2-15;popupClose_bg.y=popupTop.y
    popupClose_bg.id="close"
    popupClose_bg.alpha=0.01
    popUpGroup:insert(popupClose_bg)
    popupClose_bg:addEventListener("touch",onCloseTouch)

   -- popUpGroup.isVisible = true


--------------------------------popup details--------------------------------------

	popup_scroll = widget.newScrollView
	{
	top = 0,
	left = 0,
	width = W-5,
	height = popupTop_bg.contentHeight+60,
	hideBackground = true,
	isBounceEnabled=false,
	horizontalScrollingDisabled = true,
	verticalScrollingDisabled = false,
    }


    popupList = display.newRect(leftPadding_value + 140, H/2+ 10, W-22, 381 )
    popup_scroll:insert(popupList)


--------------------------------------name field--------------------------------------

        NameDetail_bg = display.newRect(W/2, popupText.y+popupText.height+16, W-40, 25)
		NameDetail_bg.isVisible = true
		NameDetail_bg.alpha = 0.01
		NameDetail_bg:setFillColor(0,0,0)
		NameDetail_bg.y = popupTop.y+popupTop.contentHeight
		popup_scroll:insert(NameDetail_bg)

	    NameDetail_title = display.newText("Name ",0,0,native.systemFontBold,14)
	    NameDetail_title.x= 40
	    NameDetail_title:setFillColor(0,0,0)
	    NameDetail_title.y= NameDetail_bg.y
	    popup_scroll:insert(NameDetail_title)

	    NameDetailValue = display.newText("name value ",0,0,native.systemFont,14)
	    NameDetailValue.x=  NameDetail_title.x - 15
	    NameDetailValue.anchorX = 0
	    NameDetailValue:setFillColor(0,0,0)
	    NameDetailValue.y= NameDetail_title.y+NameDetail_title.contentHeight+7
	    popup_scroll:insert(NameDetailValue)

	 --    NameDetailValue = native.newTextField(W/2,popupText.y+popupText.height+16, W-45, 25)
		-- NameDetailValue.id="Name Detail"
		-- NameDetailValue.size=14	
		-- NameDetailValue.anchorX = 0
		-- NameDetailValue.y = popupText.y+popupText.height+20
		-- NameDetailValue.hasBackground = false
		-- NameDetailValue.isVisible = true
		-- NameDetailValue:setReturnKey( "next" )
		-- NameDetailValue.placeholder="Name"
		-- popup_scroll:insert(NameDetailValue)


	    NameDetail_bottom = display.newImageRect("res/assert/line-large.png",W-40,5)
		NameDetail_bottom.x=W/2
		NameDetail_bottom.y= NameDetailValue.y+8.5
		popup_scroll:insert(NameDetail_bottom)


		-- NameDetail_bottom = display.newImageRect(popUpGroup,"res/assert/line-large.png",W-45,5)
		-- NameDetail_bottom.x=W/2
		-- NameDetail_bottom.y= popupText.y+popupText.height+30

		-- NameDetailValue = native.newTextField(W/2,popupText.y+popupText.height+16, W-45, 25)
		-- NameDetailValue.id="Name Detail"
		-- NameDetailValue.size=14	
		-- NameDetailValue.y = popupText.y+popupText.height+20
		-- NameDetailValue.hasBackground = false
		-- NameDetailValue.isVisible = true
		-- NameDetailValue:setReturnKey( "next" )
		-- NameDetailValue.placeholder="Name"
		-- popUpGroup:insert(NameDetailValue)

--------------------------------------email field--------------------------------------

        EmailDetail_bg = display.newRect(W/2,NameDetail_bg.y+15, W-40, 25)
		EmailDetail_bg.isVisible = true
		EmailDetail_bg.alpha = 0.01
		EmailDetail_bg.y = NameDetail_bottom.y+NameDetail_bottom.contentHeight+12
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

        MKRankDetail_bg = display.newRect(W/2,textnotifytext.y+15, W-40, 25)
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
	    MKRankDetail_title.x= 20
	    MKRankDetail_title.anchorX = 0
	    MKRankDetail_title:setFillColor(0,0,0)
	    MKRankDetail_title.y= MKRankDetail_bg.y+5
	    popup_scroll:insert(MKRankDetail_title)

	    MKRankDetailValue = display.newText("name value ",0,0,native.systemFont,14)
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
		Requesteddate_bg.y =  MKRankDetailValue.y+MKRankDetailValue.height+7
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
	    Requesteddate_title.x= MKRankDetail_bg.x - 88
	    Requesteddate_title:setFillColor(0,0,0)
	    Requesteddate_title.y= MKRankDetailValue.y+MKRankDetailValue.height+12
	    popup_scroll:insert(Requesteddate_title)

	    RequesteddateValue = display.newText("name value ",0,0,native.systemFont,14)
	    RequesteddateValue.x= 25
	    RequesteddateValue:setFillColor(0,0,0)
	    RequesteddateValue.anchorX = 0
	    RequesteddateValue.y= Requesteddate_title.y+Requesteddate_title.height+7
	    popup_scroll:insert(RequesteddateValue)


	    Requesteddate_bottom = display.newImageRect(popup_scroll,"res/assert/line-large.png",W-40,5)
		Requesteddate_bottom.x=W/2
		Requesteddate_bottom.y= RequesteddateValue.y+8.5




-----------------------------------password detail-------------------------------------------------

        Password_bg = display.newRect(W/2,Requesteddate_bg.y+15, W-45, 25)
		Password_bg.isVisible = true
		Password_bg.alpha = 0.01
		Password_bg.y =  Requesteddate_bg.y+Requesteddate_bg.height+7
		popup_scroll:insert(Password_bg)

		Password_titlestar = display.newText("*",0,0,native.systemFontBold,14)
	    Password_titlestar.x= NameDetail_bg.x - 139
	    Password_titlestar:setFillColor(1,0,0)
	    Password_titlestar.y= RequesteddateValue.y+RequesteddateValue.height+12
	    popup_scroll:insert(Password_titlestar)

		Password_titletext = display.newText("Password ",0,0,native.systemFontBold,14)
	    Password_titletext.x= NameDetail_bg.x - 99
	    Password_titletext:setFillColor(0,0,0)
	    Password_titletext.y= RequesteddateValue.y+RequesteddateValue.height+12
	    popup_scroll:insert(Password_titletext)

		Password_bottom = display.newImageRect("res/assert/line-large.png",W-40,5)
		Password_bottom.x=W/2
		Password_bottom.y= Password_titletext.y+Password_titletext.height+15
		popup_scroll:insert(Password_bottom)

		PasswordValue = native.newTextField(22,textnotifytext.y+28, W-40, 25)
		PasswordValue.id="Password"
		PasswordValue.size=14	
		PasswordValue.anchorX = 0
		PasswordValue.y =Password_titletext.y+Password_titletext.height+7
		PasswordValue.hasBackground = false
		PasswordValue.isVisible = true
		PasswordValue:setReturnKey( "next" )
		PasswordValue.placeholder="Password"
		popup_scroll:insert(PasswordValue)

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


    if email ~= nil or email ~= "" then
	EmailDetailValue.text = email
	print("88888888888888888888888",email)
    else
    EmailDetailValue.text = ""
    end


    if mobile ~= nil or mobile ~= "" then
    	PhoneDetailValue.text = mobile
    elseif homenum ~= nil or homenum ~= "" then
    	PhoneDetailValue.text = homenum
    elseif othernum ~= nil or othernum ~= "" then
    	PhoneDetailValue.text = othernum
    elseif worknum  ~= nil or worknum ~= "" then
    	PhoneDetailValue.text = worknum
    else
    	PhoneDetailValue.text = ""
    end
    print("88888888888888888888888",mobile)


    popUpGroup:insert(popup_scroll)

    MainGroup:insert(popUpGroup)


end

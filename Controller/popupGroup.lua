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

local pagevaluename

local Career_Username , id_value , popupevnt_value

local leftPadding = 10

local IsRequestTeamMember

local phoneNum = ""

local Details = {}

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

					native.setKeyboardFocus( nil )

			 elseif ( event.phase == "moved" ) then
		        
		        local dy = math.abs( ( event.y - event.yStart ) )
		        -- If the touch on the button has moved more than 10 pixels,
		        -- pass focus back to the scroll view so it can continue scrolling

				    if ( dy > 10 ) then
				        	display.getCurrentStage():setFocus( nil )
				            popup_scroll:takeFocus( event )
				    end
				    

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




	local function touchPopupBg( event )

			if event.phase == "began" then
				display.getCurrentStage():setFocus( event.target )

				native.setKeyboardFocus( nil )

		 elseif ( event.phase == "moved" ) then
	        local dy = math.abs( ( event.y - event.yStart ) )
	        -- If the touch on the button has moved more than 10 pixels,
	        -- pass focus back to the scroll view so it can continue scrolling

	        if ( dy > 10 ) then
	        	display.getCurrentStage():setFocus( nil )
	            popup_scroll:takeFocus( event )
	        end
	    

			elseif event.phase == "ended" then

			    if event.target.id == "popuplist" then

			    	print("touch the background")

					scrollTo(0)

					display.getCurrentStage():setFocus( event.target )

					native.setKeyboardFocus( nil )

				end

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

            	native.setKeyboardFocus(EmailDetailValue)

	       end

	end



	function getemailexistresponse(response)
 
        email_response = response

	    print("************************Request_response email initial*************************** ",json.encode(email_response))

	    if email_response == true then

	    elseif email_response == false then

	    	 existalert = native.showAlert(PopupGroup.EmailExist, PopupGroup.EmailExistText, { CommonWords.ok} , onCompletionEvent)

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

							if (current_textField.id =="deny") then

								current_textField.text=""

 								scrollTo( -120)

							end
							



					elseif ( event.phase == "submitted" ) then

						 scrollTo(0)

							if(current_textField.id =="Password") then

	                               native.setKeyboardFocus(nil)
							end


							if (current_textField.id =="deny") then

							print("event.target.id", event.target.id)

							--popupList_white:addEventListener("touch",touchPopupBg)
							--popup_Backgeound:addEventListener("touch",touchPopupBg)

							 scrollTo(0)

						    end


							if(current_textField.id =="Email Detail") then

								print("invitedetail_value.MyUnitBuzzRequestAccessId ", Contactid_value)

	                              -- native.setKeyboardFocus(nil)

	                              if EmailDetailValue.text ~= nil and EmailDetailValue.text~= "" then

	                              Webservice.CheckExistsRequestStatus(Contactid_value,EmailDetailValue.text,getemailexistresponse)

	                              native.setKeyboardFocus(nil)

	                              end

							end

					elseif event.phase == "ended" then
										
                         	event.target:setSelection(event.target.text:len(),event.target.text:len())

                         	scrollTo( 0 )

        			elseif ( event.phase == "editing" ) then


						 if(current_textField.id =="Phone Detail") then

						 	local text = event.target.text

							if event.target.text:len() > event.startPosition then

								text = event.target.text:sub(1,event.startPosition )

							end


							local maskingValue =Utils.PhoneMasking(tostring(text))

											
									event.target.text=maskingValue

									 event.target:setSelection(maskingValue:len()+1,maskingValue:len()+1)

						
        				end



        				 if (current_textField.id =="deny") then

        				 	if event.target.text:len() > 160 then

								event.target.text = event.target.text:sub(1,160)

								native.setKeyboardFocus(nil)

							end


        				 	if (event.newCharacters=="\n") then 

	                               native.setKeyboardFocus(nil)

							end

        				 	print("scrolling top")

        				 	--scrollTo(0)

                           -- popupList_white:addEventListener("touch",touchPopupBg)
                           -- popup_Backgeound:addEventListener("touch",touchPopupBg)

        				 end

        ------------------------------------------for password ---------------------------------------------------

						if(current_textField.id == "Password") then

							print( event.newCharacters )

							if (event.newCharacters==" ") then

								if string.find( current_textField.text," " ) ~= nil then
							        current_textField.text=string.gsub(current_textField.text," ","")
							    end

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


	if PasswordValue.text == PopupGroup.PasswordRequired or PasswordValue.text == PopupGroup.PasswordLimit then

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




function RequestGrantProcess( Details )

	if processbutton_text.text == CommonWords.GrantAccessText then

		   	    PhoneNumber=PhoneDetailValue.text
		   	    Email = EmailDetailValue.text
		   	    MkRankId = Details.CareerProgressId
		        MyUnitBuzzRequestAccessId = Details.MyUnitBuzzRequestAccessId
		        print("value for access id : ",MyUnitBuzzRequestAccessId)


		   	    if MyUnitBuzzRequestAccessId == 0 then
		            isaddedToContact = true  
		            MyUnitBuzzRequestAccessId = Details.ContactId
		        else
		        	isaddedToContact = false
		        end


	   	        print("value for isaddedToContact : ",isaddedToContact)
	     
		   	    GetRquestAccessFrom = Details.GetRquestAccessFrom
		   	    MailTemplate = "GRANT"
		   	    Status = "GRANT"

		   	    if Details.ContactId ~= nil and Details.ContactId ~= 0 then
		   	    	ContactId = Details.ContactId
		   	    else
		   	    	ContactId=""
		   	    end


		   	    isSentMail = isSentMailValue
		   	    print("value 1 ",isSentMailValue)
		   	    isSendText= isSentMailValue
		   	    print("value 2 ",isSendTextValue)
		   	    password = PasswordValue.text

		   	    idvalue = processbutton_text.text
		   	    print(idvalue)

	   	    	Webservice.AccessPermissionDetails(idvalue,Email,PhoneNumber,MkRankId,GetRquestAccessFrom,MailTemplate,Status,isSentMail,isSentText,ContactId,isaddedToContact,MyUnitBuzzRequestAccessId,password,get_removeorblockDetails)

	end




	if processbutton_text.text == CommonWords.ProvideAccessText then


	   	    PhoneNumber=PhoneDetailValue.text
	   	    Email = EmailDetailValue.text


	   	    if Details.CareerProgressId ~= nil then
	   	   		 MkRankId = Details.CareerProgressId
	   	   	else
	   	   		MkRankId=""
	   	   	end


	   	    GetRquestAccessFrom = Details.GetRquestAccessFrom
	   	    MyUnitBuzzRequestAccessId = Details.MyUnitBuzzRequestAccessId


	   	    if MyUnitBuzzRequestAccessId == 0 then
	            isaddedToContact = true  
	            MyUnitBuzzRequestAccessId = Details.ContactId
	        else
	        	isaddedToContact = false
	        end

	    
	   	    MailTemplate = "ADDREQUEST"
	   	    Status = "GRANT"


		    if Details.ContactId ~= nil and Details.ContactId ~= 0 then
	   	    	ContactId = Details.ContactId
	   	    else
	   	    	ContactId=""
	   	    end   	    


	   	    isSentMail = isSentMailValue
	   	    isSendText= isSentMailValue
	   	    password = PasswordValue.text
	   	    idvalue = processbutton_text.text


	   	    	Webservice.AccessPermissionDetails(idvalue,Email,PhoneNumber,MkRankId,GetRquestAccessFrom,MailTemplate,Status,isSentMail,isSentText,ContactId,isaddedToContact,MyUnitBuzzRequestAccessId,password,get_removeorblockDetails)

	end




	if processbutton_text.text == CommonWords.DenyAccessText then

	        		print("service of deny access")


	        		if PhoneDetailValue.text ~= "" then

	        			textnotifytext.isVisible = false
		            	textnotifybox.isVisible = false

					 MKRankDetail_bg.y =  PhoneDetail_bottom.y + PhoneDetail_bottom.contentHeight+10
					 MKRankDetail_title.y= MKRankDetail_bg.y
					 MKRankDetailValue.y= MKRankDetail_title.y+MKRankDetail_title.contentHeight+8
					 MKRankDetail_bottom.y= MKRankDetailValue.y+9

					 Requesteddate_bg.y = MKRankDetail_bottom.y+MKRankDetail_bottom.height+7
				     Requesteddate_title.y= Requesteddate_bg.y + 7
				     RequesteddateValue.y= Requesteddate_title.y+Requesteddate_title.height+8
				     Requesteddate_bottom.y= RequesteddateValue.y+9

					deny_bg.y = Requesteddate_bottom.y + 45
					deny_Value.y=deny_bg.y
					processbutton.y = deny_Value.y+deny_Value.contentHeight-10
					processbutton_text.y=processbutton.y

	        		end

		  
			   	    PhoneNumber=PhoneDetailValue.text
			   	    Email = EmailDetailValue.text
			   	    MkRankId = Details.CareerProgressId
			   	    GetRquestAccessFrom = Details.GetRquestAccessFrom
			   	    MyUnitBuzzRequestAccessId = Details.MyUnitBuzzRequestAccessId


			   	    if MyUnitBuzzRequestAccessId == 0 then
			            isaddedToContact = true  
			            MyUnitBuzzRequestAccessId = Details.ContactId
			        else
			        	isaddedToContact = false
			        end

			     
			   	    MailTemplate = "DENY"
			   	    Status = "DENY"

				    if Details.ContactId ~= nil and Details.ContactId ~= 0 then
			   	    	ContactId = Details.ContactId
			   	    else
			   	    	ContactId=""
			   	    end   	 

			   	    isSentMail = isSentMailValue
			   	    isSendText= false
			   	    reasonfordeny = deny_Value.text

			   	    idvalue = processbutton_text.text

	   	    	    
	   	    	    Webservice.AccessPermissionDetails(idvalue,Email,PhoneNumber,MkRankId,GetRquestAccessFrom,MailTemplate,Status,isSentMail,isSentText,ContactId,isaddedToContact,MyUnitBuzzRequestAccessId,reasonfordeny,get_removeorblockDetails)


	end

end






	   function onGrantButtonTouch( event )

            if event.phase == "began" then

            elseif event.phase == "ended" then

                local validation = true

                Details = event.target.value

                native.setKeyboardFocus(nil)

		if (EmailDetailValue.text == "") or (EmailDetailValue.text == "null") or (EmailDetailValue.text == EmailDetailValue.id) or (not Utils.emailValidation(EmailDetailValue.text)) or (EmailDetailValue.text == PopupGroup.EmailRequired)  then
			  
			       validation=false
			       SetError(PopupGroup.EmailRequired,EmailDetailValue)

			       emailnotifybox.isVisible = false
			       emailnotifytext.isVisible = false

	               PhoneDetail_bg.y =  EmailDetail_bottom.y + 20
				   PhoneDetail_titlestar.y= PhoneDetail_bg.y
				   PhoneDetail_titletext.y=  PhoneDetail_bg.y
				   PhoneDetailValue.y = PhoneDetail_titletext.y+PhoneDetail_titletext.contentHeight+9
				   PhoneDetail_bottom.y= PhoneDetailValue.y+10
				   textnotifytext.y= PhoneDetail_bottom.y +PhoneDetail_bottom.contentHeight +12
				   textnotifybox.y = PhoneDetail_bottom.y +PhoneDetail_bottom.contentHeight +13

	     --          MKRankDetail_bg.y =  PhoneDetail_bottom.y+PhoneDetail_bottom.contentHeight+30
				  -- MKRankDetail_title.y= MKRankDetail_bg.y+15
				  -- MKRankDetailValue.y= MKRankDetail_title.y+MKRankDetail_title.contentHeight+10
				  -- MKRankDetail_bottom.y= MKRankDetailValue.y+9

				  -- Requesteddate_bg.y =  MKRankDetailValue.y+MKRankDetailValue.height+7
				  -- Requesteddate_title.y= MKRankDetailValue.y+MKRankDetailValue.height+15
				  -- RequesteddateValue.y= Requesteddate_title.y+Requesteddate_title.height+8
				  -- Requesteddate_bottom.y= RequesteddateValue.y+9

				  -- Password_bg.y =  Requesteddate_bg.y+Requesteddate_bg.height+7
				  -- Password_titlestar.y= RequesteddateValue.y+RequesteddateValue.height+15
				  -- Password_titletext.y= RequesteddateValue.y+RequesteddateValue.height+15
				  -- Password_bottom.y= Password_titletext.y+Password_titletext.height+15
				  -- PasswordValue.y =Password_titletext.y+Password_titletext.height+5
				  -- PasswordHelptext.y= Password_bottom.y + 12
				  -- GeneratePasstext.y= PasswordHelptext.y + 20
				  -- processbutton.y = GeneratePasstext.y+GeneratePasstext.contentHeight+22
		    --       processbutton_text.y=processbutton.y


			    if popupText.text == CommonWords.DenyAccessText then

			  	           textnotifytext.isVisible = false
			  	           textnotifybox.isVisible = false

						   MKRankDetail_bg.y =  PhoneDetail_bottom.y + PhoneDetail_bottom.contentHeight+10
						   MKRankDetail_title.y= MKRankDetail_bg.y
						   MKRankDetailValue.y= MKRankDetail_title.y+MKRankDetail_title.contentHeight+8
						   MKRankDetail_bottom.y= MKRankDetailValue.y+9

						   Requesteddate_bg.y = MKRankDetail_bottom.y+MKRankDetail_bottom.height+7
					       Requesteddate_title.y= Requesteddate_bg.y + 7
					       RequesteddateValue.y= Requesteddate_title.y+Requesteddate_title.height+8
					       Requesteddate_bottom.y= RequesteddateValue.y+9

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

				elseif popupText.text == CommonWords.ProvideAccessText then

					print("email not null in PA")

						   MKRankDetail_bg.y =  PhoneDetail_bottom.y + PhoneDetail_bottom.contentHeight+10
						   MKRankDetail_title.y= MKRankDetail_bg.y
						   MKRankDetailValue.y= MKRankDetail_title.y+MKRankDetail_title.contentHeight+8
						   MKRankDetail_bottom.y= MKRankDetailValue.y+9

						   Requesteddate_bg.y = MKRankDetail_bottom.y+MKRankDetail_bottom.height+7
					       Requesteddate_title.y= Requesteddate_bg.y + 7
					       RequesteddateValue.y= Requesteddate_title.y+Requesteddate_title.height+8
					       Requesteddate_bottom.y= RequesteddateValue.y+9

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


				elseif popupText.text == CommonWords.GrantAccessText and id_name == "Grant Access From Deny" and IsRequestTeamMember == true then

	            			print("haiiiiiiiiiiiiiiii")

	            			MKRankDetail_bg.isVisible = false
	            			MKRankDetail_title.isVisible = false
	            			MKRankDetailValue.isVisible = false
	            			MKRankDetail_bottom.isVisible = false
	            			Requesteddate_bg.isVisible = true
	            			Requesteddate_title.isVisible = true
	            			RequesteddateValue.isVisible = true
	            			Requesteddate_bottom.isVisible = true

                            Requesteddate_bg.y =  textnotifytext.y+textnotifytext.contentHeight+7
							Requesteddate_title.y= Requesteddate_bg.y + 5
							RequesteddateValue.y= Requesteddate_title.y+Requesteddate_title.height+8
							Requesteddate_bottom.y= RequesteddateValue.y+9


							Password_bg.y =  Requesteddate_bg.y+Requesteddate_bg.contentHeight+17
	            			--Password_bg.y =  textnotifytext.y+textnotifytext.contentHeight+5
							Password_titlestar.y= Password_bg.y + 5
							Password_titletext.y= Password_bg.y+ 5
							PasswordValue.y =Password_titletext.y+Password_titletext.height+7
							Password_bottom.y= PasswordValue.y+10
							PasswordHelptext.y= Password_bottom.y + 12
							GeneratePasstext.y= PasswordHelptext.y + 20
							processbutton.y = GeneratePasstext.y+GeneratePasstext.contentHeight+22
							processbutton_text.y=processbutton.y


				    elseif popupText.text == CommonWords.GrantAccessText and id_name == "Grant Access From Deny" and IsRequestTeamMember == false then

	            			print("haiiiiiiiiiiiiiiii 123123")

	            			MKRankDetail_bg.isVisible = true
	            			MKRankDetail_title.isVisible = true
	            			MKRankDetailValue.isVisible = true
	            			MKRankDetail_bottom.isVisible = true
	            			-- Requesteddate_bg.isVisible = false
	            			-- Requesteddate_title.isVisible = false
	            			-- RequesteddateValue.isVisible = false
	            			-- Requesteddate_bottom.isVisible = false



                            MKRankDetail_bg.y =  textnotifytext.y+textnotifytext.contentHeight+7
							MKRankDetail_title.y= MKRankDetail_bg.y 
							MKRankDetailValue.y= MKRankDetail_title.y+MKRankDetail_title.height+8
							MKRankDetail_bottom.y= MKRankDetailValue.y+9


							Password_bg.y =  MKRankDetail_bottom.y+MKRankDetail_bottom.contentHeight+17


	            			--Password_bg.y =  textnotifytext.y+textnotifytext.contentHeight+5
							Password_titlestar.y= Password_bg.y + 5
							Password_titletext.y= Password_bg.y+ 5
							PasswordValue.y =Password_titletext.y+Password_titletext.height+7
							Password_bottom.y= PasswordValue.y+10
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

					    	print("email present @@@@@@@@@@")

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


							print(IsRequestTeamMember)


							if popupText.text == CommonWords.GrantAccessText and id_name == "Grant Access From Deny" and IsRequestTeamMember == true then

								print("request true haaaaaaaaaaaaaaaa")

			            			-- MKRankDetail_bg.isVisible = false
			            			-- MKRankDetail_title.isVisible = false
			            			-- MKRankDetailValue.isVisible = false
			            			-- MKRankDetail_bottom.isVisible = false
			            			Requesteddate_bg.isVisible = true
			            			Requesteddate_title.isVisible = true
			            			RequesteddateValue.isVisible = true
			            			Requesteddate_bottom.isVisible = true

			            			Requesteddate_bg.y =  textnotifytext.y+textnotifytext.contentHeight+7
								    Requesteddate_title.y= Requesteddate_bg.y + 5
								    RequesteddateValue.y= Requesteddate_title.y+Requesteddate_title.height+8
								    Requesteddate_bottom.y= RequesteddateValue.y+9


									Password_bg.y =  Requesteddate_bg.y+Requesteddate_bg.contentHeight+17

			            		--	Password_bg.y =  textnotifytext.y+textnotifytext.contentHeight+5
									Password_titlestar.y= Password_bg.y + 5
									Password_titletext.y= Password_bg.y+ 5
									PasswordValue.y =Password_titletext.y+Password_titletext.height+7
									Password_bottom.y= PasswordValue.y+10
									PasswordHelptext.y= Password_bottom.y + 12
									GeneratePasstext.y= PasswordHelptext.y + 20
									processbutton.y = GeneratePasstext.y+GeneratePasstext.contentHeight+22
									processbutton_text.y=processbutton.y

							elseif popupText.text == CommonWords.GrantAccessText and id_name == "Grant Access From Deny" and IsRequestTeamMember == false then

								print("request true haaaaaaaaaaaaaaaa false request")

			            			
				        			MKRankDetail_bg.isVisible = true
				        			MKRankDetail_title.isVisible = true
				        			MKRankDetailValue.isVisible = true
				        			MKRankDetail_bottom.isVisible = true

									MKRankDetail_bg.y =  textnotifytext.y+textnotifytext.contentHeight+7
									MKRankDetail_title.y= MKRankDetail_bg.y 
									MKRankDetailValue.y= MKRankDetail_title.y+MKRankDetail_title.height+8
									MKRankDetail_bottom.y= RequesteddateValue.y+9


									Password_bg.y =  MKRankDetail_bg.y+MKRankDetail_bg.contentHeight+17
			            		--	Password_bg.y =  textnotifytext.y+textnotifytext.contentHeight+5
									Password_titlestar.y= Password_bg.y + 5
									Password_titletext.y= Password_bg.y+ 5
									PasswordValue.y =Password_titletext.y+Password_titletext.height+7
									Password_bottom.y= PasswordValue.y+10
									PasswordHelptext.y= Password_bottom.y + 12
									GeneratePasstext.y= PasswordHelptext.y + 20
									processbutton.y = GeneratePasstext.y+GeneratePasstext.contentHeight+22
									processbutton_text.y=processbutton.y


							else


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
 

			            if popupText.text == CommonWords.DenyAccessText then

			            	textnotifytext.isVisible = false
			            	textnotifybox.isVisible = false

							 MKRankDetail_bg.y =  PhoneDetail_bottom.y + PhoneDetail_bottom.contentHeight+10
							 MKRankDetail_title.y= MKRankDetail_bg.y
							 MKRankDetailValue.y= MKRankDetail_title.y+MKRankDetail_title.contentHeight+8
							 MKRankDetail_bottom.y= MKRankDetailValue.y+9

							 Requesteddate_bg.y = MKRankDetail_bottom.y+MKRankDetail_bottom.height+7
						     Requesteddate_title.y= Requesteddate_bg.y + 7
						     RequesteddateValue.y= Requesteddate_title.y+Requesteddate_title.height+8
						     Requesteddate_bottom.y= RequesteddateValue.y+9

					    end


				end





if  PhoneDetailValue.text == "" or PhoneDetailValue.text == "null" or PhoneDetailValue.text == PhoneDetailValue.id or PhoneDetailValue.text:len()<14 or PhoneDetailValue.text == PopupGroup.PhoneRequired then

	print("phone null so here (((((((((((((((((((")

		validation = false

                SetError(PopupGroup.PhoneRequired,PhoneDetailValue)

                    textnotifybox.isVisible = false
	                textnotifytext.isVisible = false


			 if popupText.text == CommonWords.DenyAccessText then

				  textnotifytext.isVisible = false
				  textnotifybox.isVisible = false

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

			 elseif popupText.text == CommonWords.ProvideAccessText then


				  Requesteddate_bg.isVisible = false
				  RequesteddateValue.isVisible = false
				  Requesteddate_title.isVisible = false
				  Requesteddate_bottom.isVisible = false


			      MKRankDetail_bg.y =  PhoneDetail_bottom.y + PhoneDetail_bottom.contentHeight+10
			      MKRankDetail_title.y= MKRankDetail_bg.y
			      MKRankDetailValue.y= MKRankDetail_title.y+MKRankDetail_title.contentHeight+8
				  MKRankDetail_bottom.y= MKRankDetailValue.y+9


				  Password_bg.y =  MKRankDetail_bottom.y+MKRankDetail_bottom.contentHeight+7
			      Password_titlestar.y= Password_bg.y+7
			      Password_titletext.y= Password_bg.y+7
			      PasswordValue.y =Password_titletext.y+Password_titletext.contentHeight+8
			      Password_bottom.y= PasswordValue.y +9.5
			      PasswordHelptext.y= Password_bottom.y + 12
			      GeneratePasstext.y= PasswordHelptext.y + 20
			      processbutton.y = GeneratePasstext.y+GeneratePasstext.contentHeight+22
				  processbutton_text.y=processbutton.y



			 elseif popupText.text == CommonWords.GrantAccessText and id_name == "Grant Access From Deny" and IsRequestTeamMember == true then

        			print("haiiiiiiiiiiiiiiii in phone")

        			MKRankDetail_bg.isVisible = false
        			MKRankDetail_title.isVisible = false
        			MKRankDetailValue.isVisible = false
        			MKRankDetail_bottom.isVisible = false
        			Requesteddate_bg.isVisible = true
        			Requesteddate_title.isVisible = true
        			RequesteddateValue.isVisible = true
        			Requesteddate_bottom.isVisible = true

					Requesteddate_bg.y = PhoneDetail_bottom.y+PhoneDetail_bottom.contentHeight+10
					Requesteddate_title.y= Requesteddate_bg.y + 5
					RequesteddateValue.y= Requesteddate_title.y+Requesteddate_title.height+8
					Requesteddate_bottom.y= RequesteddateValue.y+9


					Password_bg.y =  Requesteddate_bg.y+Requesteddate_bg.contentHeight+20

        			--Password_bg.y =  PhoneDetail_bottom.y+PhoneDetail_bottom.contentHeight+7
					Password_titlestar.y= Password_bg.y + 7
					Password_titletext.y= Password_bg.y+7
					PasswordValue.y =Password_titletext.y+Password_titletext.height+7
					Password_bottom.y= PasswordValue.y+10
					PasswordHelptext.y= Password_bottom.y + 12
					GeneratePasstext.y= PasswordHelptext.y + 20
					processbutton.y = GeneratePasstext.y+GeneratePasstext.contentHeight+22
					processbutton_text.y=processbutton.y


			 elseif popupText.text == CommonWords.GrantAccessText and id_name == "Grant Access From Deny" and IsRequestTeamMember == false then

        			print("haiiiiiiiiiiiiiiii in phone false request")

        			MKRankDetail_bg.isVisible = true
        			MKRankDetail_title.isVisible = true
        			MKRankDetailValue.isVisible = true
        			MKRankDetail_bottom.isVisible = true
        			Requesteddate_bg.isVisible = false
        			Requesteddate_title.isVisible = false
        			RequesteddateValue.isVisible = false
        			Requesteddate_bottom.isVisible = false

					MKRankDetail_bg.y = PhoneDetail_bottom.y+PhoneDetail_bottom.contentHeight+10
					MKRankDetail_title.y= MKRankDetail_bg.y 
					MKRankDetailValue.y= MKRankDetail_title.y+MKRankDetail_title.height+8
					MKRankDetail_bottom.y= MKRankDetailValue.y+9


					Password_bg.y =  MKRankDetail_bg.y+MKRankDetail_bg.contentHeight+22
        			--Password_bg.y =  PhoneDetail_bottom.y+PhoneDetail_bottom.contentHeight+7
					Password_titlestar.y= Password_bg.y + 7
					Password_titletext.y= Password_bg.y+7
					PasswordValue.y =Password_titletext.y+Password_titletext.height+7
					Password_bottom.y= PasswordValue.y+10
					PasswordHelptext.y= Password_bottom.y + 12
					GeneratePasstext.y= PasswordHelptext.y + 20
					processbutton.y = GeneratePasstext.y+GeneratePasstext.contentHeight+22
					processbutton_text.y=processbutton.y

		     else

			       MKRankDetail_bg.y =  PhoneDetail_bottom.y + PhoneDetail_bottom.contentHeight+10
			       MKRankDetail_title.y= MKRankDetail_bg.y
			       MKRankDetailValue.y= MKRankDetail_title.y+MKRankDetail_title.contentHeight+8
				   MKRankDetail_bottom.y= MKRankDetailValue.y+9

				   Requesteddate_bg.y =  MKRankDetail_bottom.y+10
				   Requesteddate_title.y= Requesteddate_bg.y +7
			       RequesteddateValue.y= Requesteddate_title.y+Requesteddate_title.contentHeight+8
			       Requesteddate_bottom.y= RequesteddateValue.y+9

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

		     if popupText.text == CommonWords.DenyAccessText then

				      textnotifytext.isVisible = false
					  textnotifybox.isVisible = false

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
					  isSendTextValue = ""


			 -- RequestGrantProcess(Details)

			 elseif popupText.text == CommonWords.ProvideAccessText then


					  Requesteddate_bg.isVisible = false
					  RequesteddateValue.isVisible = false
					  Requesteddate_title.isVisible = false
					  Requesteddate_bottom.isVisible = false

					  MKRankDetail_bg.y =  textnotifytext.y+textnotifytext.contentHeight+5
					  MKRankDetail_title.y= MKRankDetail_bg.y+5
					  MKRankDetailValue.y= MKRankDetail_title.y+MKRankDetail_title.contentHeight+7
					  MKRankDetail_bottom.y= MKRankDetailValue.y+9

					  Password_bg.y =  MKRankDetail_bottom.y+MKRankDetail_bottom.contentHeight+7
				      Password_titlestar.y= Password_bg.y+7
				      Password_titletext.y= Password_bg.y+7
				      PasswordValue.y =Password_titletext.y+Password_titletext.contentHeight+8
				      Password_bottom.y= PasswordValue.y +9.5
				      PasswordHelptext.y= Password_bottom.y + 12
				      GeneratePasstext.y= PasswordHelptext.y + 20
				      processbutton.y = GeneratePasstext.y+GeneratePasstext.contentHeight+22
					  processbutton_text.y=processbutton.y


		      elseif popupText.text == CommonWords.GrantAccessText and id_name == "Grant Access From Deny" and IsRequestTeamMember == true then

					print("haaaaaaaaaaaaaaaa phone")

				        --   MKRankDetail_bg.isVisible = false
				        --   MKRankDetail_title.isVisible = false
				        --   MKRankDetailValue.isVisible = false
				        --   MKRankDetail_bottom.isVisible = false
				        --   Requesteddate_bg.isVisible = false
				        --   Requesteddate_title.isVisible = false
				        --   RequesteddateValue.isVisible = false
				        --   Requesteddate_bottom.isVisible = false


						-- print("request true haaaaaaaaaaaaaaaa")

            			-- MKRankDetail_bg.isVisible = false
            			-- MKRankDetail_title.isVisible = false
            			-- MKRankDetailValue.isVisible = false
            			-- MKRankDetail_bottom.isVisible = false
            			Requesteddate_bg.isVisible = true
            			Requesteddate_title.isVisible = true
            			RequesteddateValue.isVisible = true
            			Requesteddate_bottom.isVisible = true

            			Requesteddate_bg.y =  textnotifytext.y+textnotifytext.contentHeight+7
					    Requesteddate_title.y= Requesteddate_bg.y + 5
					    RequesteddateValue.y= Requesteddate_title.y+Requesteddate_title.height+8
					    Requesteddate_bottom.y= RequesteddateValue.y+9


						Password_bg.y =  Requesteddate_bg.y+Requesteddate_bg.contentHeight+22

                		-- Password_bg.y =  textnotifytext.y+textnotifytext.contentHeight+5
						-- Password_titlestar.y= Password_bg.y + 5
						-- Password_titletext.y= Password_bg.y+ 5
						-- PasswordValue.y =Password_titletext.y+Password_titletext.height+7
						-- Password_bottom.y= PasswordValue.y+10
						-- PasswordHelptext.y= Password_bottom.y + 12
						-- GeneratePasstext.y= PasswordHelptext.y + 20
						-- processbutton.y = GeneratePasstext.y+GeneratePasstext.contentHeight+22
						-- processbutton_text.y=processbutton.y


                        -- Password_bg.y =  textnotifytext.y+textnotifytext.contentHeight+5
						Password_titlestar.y= Password_bg.y + 9
						Password_titletext.y= Password_bg.y+ 9
						PasswordValue.y =Password_titletext.y+Password_titletext.height+7
						Password_bottom.y= PasswordValue.y+10
						PasswordHelptext.y= Password_bottom.y + 12
						GeneratePasstext.y= PasswordHelptext.y + 20
						processbutton.y = GeneratePasstext.y+GeneratePasstext.contentHeight+22
						processbutton_text.y=processbutton.y


			    elseif popupText.text == CommonWords.GrantAccessText and id_name == "Grant Access From Deny" and IsRequestTeamMember == false then

					print("haaaaaaaaaaaaaaaa phone false request")

				        -- MKRankDetail_bg.isVisible = false
				        -- MKRankDetail_title.isVisible = false
				        -- MKRankDetailValue.isVisible = false
				        -- MKRankDetail_bottom.isVisible = false
				        -- Requesteddate_bg.isVisible = false
				        -- Requesteddate_title.isVisible = false
				        -- RequesteddateValue.isVisible = false
				        -- Requesteddate_bottom.isVisible = false


					    -- print("request true haaaaaaaaaaaaaaaa")

            			MKRankDetail_bg.isVisible = true
            			MKRankDetail_title.isVisible = true
            			MKRankDetailValue.isVisible = true
            			MKRankDetail_bottom.isVisible = true
            			-- Requesteddate_bg.isVisible = true
            			-- Requesteddate_title.isVisible = true
            			-- RequesteddateValue.isVisible = true
            			-- Requesteddate_bottom.isVisible = true

            			MKRankDetail_bg.y =  textnotifytext.y+textnotifytext.contentHeight+7
					    MKRankDetail_title.y= MKRankDetail_bg.y 
					    MKRankDetailValue.y= MKRankDetail_title.y+MKRankDetail_title.height+8
					    MKRankDetail_bottom.y= MKRankDetailValue.y+9


						Password_bg.y =  MKRankDetail_bottom.y+MKRankDetail_bottom.contentHeight+7
                		--Password_bg.y =  textnotifytext.y+textnotifytext.contentHeight+5
						-- Password_titlestar.y= Password_bg.y + 5
						-- Password_titletext.y= Password_bg.y+ 5
						-- PasswordValue.y =Password_titletext.y+Password_titletext.height+7
						-- Password_bottom.y= PasswordValue.y+10
						-- PasswordHelptext.y= Password_bottom.y + 12
						-- GeneratePasstext.y= PasswordHelptext.y + 20
						-- processbutton.y = GeneratePasstext.y+GeneratePasstext.contentHeight+22
						-- processbutton_text.y=processbutton.y

             			--Password_bg.y =  textnotifytext.y+textnotifytext.contentHeight+5
						Password_titlestar.y= Password_bg.y + 9
						Password_titletext.y= Password_bg.y+ 9
						PasswordValue.y =Password_titletext.y+Password_titletext.height+7
						Password_bottom.y= PasswordValue.y+10
						PasswordHelptext.y= Password_bottom.y + 12
						GeneratePasstext.y= PasswordHelptext.y + 20
						processbutton.y = GeneratePasstext.y+GeneratePasstext.contentHeight+22
						processbutton_text.y=processbutton.y



			     else

			     	print("grant provide access")


						textnotifybox.isVisible = true
						textnotifytext.isVisible = true

				        PhoneDetail_titlestar.y= PhoneDetail_bg.y
						PhoneDetail_titletext.y= PhoneDetail_bg.y
						PhoneDetail_bottom.y= PhoneDetailValue.y+10
						PhoneDetailValue.y =PhoneDetail_titletext.y+PhoneDetail_titletext.contentHeight+9

						textnotifybox.y = PhoneDetail_bottom.y + 15
						textnotifytext.y = PhoneDetail_bottom.y + 15

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
 
 end




		if processbutton_text.text ~= CommonWords.DenyAccessText then

				if PasswordValue.text == "" or PasswordValue.text == PasswordValue.id or PasswordValue.text == PopupGroup.PasswordRequired then

					validation = false

				    SetError(PopupGroup.PasswordRequired,PasswordValue) 

			    elseif PasswordValue.text:len() < 6 or PasswordValue.text == PopupGroup.PasswordLimit then

			    	validation = false

			        SetError(PopupGroup.PasswordLimit,PasswordValue)

				end

		end



						
		if(validation == true) then

			     isSentMailValue = isSentMail
	             isSendTextValue = isSentText
	             PhoneNo=PhoneDetailValue.text
	             EmailAddress = EmailDetailValue.text

	             print("validation true : process continued")

			  RequestGrantProcess(Details)

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





function GetPopUp(contactid_value,email,mobile,homenum,worknum,othernum,id_value,details,pagevalue)

	id_name = id_value

		if popUpGroup.numChildren ~= nil then
			 for j=popUpGroup.numChildren, 1, -1 do 
								display.remove(popUpGroup[popUpGroup.numChildren])
								popUpGroup[popUpGroup.numChildren] = nil
			 end
		end

		Contactid_value = contactid_value

		Details = details

		pagevaluename= pagevalue

	            print( "match : "..json.encode(Details) )
	            print("pagevaluename"..pagevaluename)


		popUpGroup = display.newGroup()

		popup_Backgeound = display.newRect(W/2, H/2, W, H )
		--popup_Backgeound:addEventListener( "touch", touchPopupBg )
		--popup_Backgeound.id= "popuplist"
		popup_Backgeound.alpha=0.01
		popUpGroup:insert(popup_Backgeound)


		popupTop_bg = display.newRect(leftPadding_value + 140, H/2+ 10, W-20, 385 )
		popupTop_bg.x = leftPadding_value + 140
	    popupTop_bg:setFillColor(0,0,0)
	    popUpGroup:insert(popupTop_bg)

	    popupTop = display.newRect(W/2,H/2-195,298,30)
	    --  popupTop:setStrokeColor(0,0,0,0.2)
	    --  popupTop.strokeWidth=1
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
	

	    popupList = display.newRect(leftPadding_value + 140, popupTop_bg.y+popupTop_bg.contentHeight/2, W-22, popupTop_bg.contentHeight+20 )
	    popupList.anchorY=0
	    popupList.y=60	
	    popupList.id= "popuplist"
	    popupList.strokeWidth=1
	    popupList.isVisible=true
	    popupList:setStrokeColor(Utils.convertHexToRGB(color.LtyGray))
	    popUpGroup:insert(popupList)

	    popupList:addEventListener( "touch", touchPopupBg )

		popup_scroll = widget.newScrollView
		{
		top = 90,
		left = 0,
		width = W-24,
		height = popupTop_bg.contentHeight+20,
		hideBackground = true,
		isBounceEnabled=false,
		horizontalScrollDisabled = true,
		verticalScrollDisabled = false,
		friction = .6,
	   	listener = popup_scrollListener,
	   	hideScrollBar=true
	    }


	    -- popupList_white = display.newRect(leftPadding_value + 140, 0, W-22, popupTop_bg.contentHeight+78 )
	    -- popupList_white.anchorY=0
	    -- popupList_white:setFillColor(0)
	    -- popupList_white.id = "popuplist"
	    -- popup_scroll:insert(popupList_white)

	    popup_scroll.y=60
	    popup_scroll.anchorY=0

--------------------------------------name field--------------------------------------

        NameDetail_bg = display.newRect(W/2, popupTop_bg.contentHeight+83, W-50, 25)
		NameDetail_bg.isVisible = true
		NameDetail_bg.alpha = 0.01
		NameDetail_bg:setFillColor(0,0,0)
		NameDetail_bg.y = 10
		popup_scroll:insert(NameDetail_bg)

	    NameDetail_title = display.newText(PopupGroup.NameDetail_title,0,0,native.systemFontBold,14)
	    NameDetail_title.x= 20
	    NameDetail_title.anchorX = 0
	    NameDetail_title:setFillColor(0,0,0)
	    NameDetail_title.y= NameDetail_bg.y
	    popup_scroll:insert(NameDetail_title)

	    NameDetailValue = display.newText("",0,0,native.systemFont,14)
	    NameDetailValue.x= 25
	    NameDetailValue.anchorX = 0
	    NameDetailValue:setFillColor(0,0,0)
	    NameDetailValue.y= NameDetail_title.y+NameDetail_title.contentHeight+7
	    popup_scroll:insert(NameDetailValue)


	    NameDetail_bottom = display.newImageRect("res/assert/line-large.png",W-50,5)
		NameDetail_bottom.x=W/2-5
		NameDetail_bottom.y= NameDetailValue.y+8.5
		popup_scroll:insert(NameDetail_bottom)


--------------------------------------email field--------------------------------------

        EmailDetail_bg = display.newRect(W/2,NameDetail_bg.y+15, W-50, 25)
		EmailDetail_bg.isVisible = true
		EmailDetail_bg.alpha = 0.01
		EmailDetail_bg.y = NameDetail_bottom.y+NameDetail_bottom.contentHeight+15
		popup_scroll:insert(EmailDetail_bg)

		EmailDetail_titlestar = display.newText("*",0,0,native.systemFontBold,14)
	    EmailDetail_titlestar.x= 20
	    EmailDetail_titlestar:setFillColor(1,0,0)
	    EmailDetail_titlestar.y= EmailDetail_bg.y
	    popup_scroll:insert(EmailDetail_titlestar)

		EmailDetail_titletext = display.newText(PopupGroup.EmailDetail_titletext,0,0,native.systemFontBold,14)
	    EmailDetail_titletext.x= 44
	    EmailDetail_titletext:setFillColor(0,0,0)
	    EmailDetail_titletext.y= EmailDetail_bg.y
	    popup_scroll:insert(EmailDetail_titletext)

		EmailDetailValue = native.newTextField(W/2,NameDetail_bg.y+28, W-50, 25)
		EmailDetailValue.id="Email Detail"
		EmailDetailValue.size=14	
		EmailDetailValue.x=22
		EmailDetailValue.anchorX=0
		EmailDetailValue.y = EmailDetail_titletext.y+ EmailDetail_titletext.contentHeight+9
		EmailDetailValue.hasBackground = false
		EmailDetailValue.isVisible = true
		EmailDetailValue:setReturnKey( "next" )
		EmailDetailValue.placeholder= PopupGroup.EmailDetailValue_placeholder
		popup_scroll:insert(EmailDetailValue)


		EmailDetail_bottom = display.newImageRect("res/assert/line-large.png",W-50,5)
		EmailDetail_bottom.x=W/2-5
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


	    emailnotifytext = display.newText(PopupGroup.emailnotifytext,0,0,native.systemFont,14)
	    emailnotifytext.x= 50
	    emailnotifytext.anchorX=0
	    emailnotifytext:setFillColor(0,0,0)
	    emailnotifytext.y= EmailDetail_bottom.y + 15
	    popup_scroll:insert(emailnotifytext)


--------------------------------------PHONE NUMBER--------------------------------------------

        PhoneDetail_bg = display.newRect(W/2,emailnotifytext.y+15, W-50, 25)
		PhoneDetail_bg.isVisible = true
		PhoneDetail_bg.alpha = 0.01
		PhoneDetail_bg.y =  emailnotifybox.y+emailnotifybox.contentHeight+5
		popup_scroll:insert(PhoneDetail_bg)


		PhoneDetail_titlestar = display.newText("*",0,0,native.systemFontBold,14)
	    PhoneDetail_titlestar.x= 20
	    PhoneDetail_titlestar:setFillColor(1,0,0)
	    PhoneDetail_titlestar.y= PhoneDetail_bg.y
	    popup_scroll:insert(PhoneDetail_titlestar)

		PhoneDetail_titletext = display.newText(PopupGroup.PhoneDetail_titletext,0,0,native.systemFontBold,14)
	    PhoneDetail_titletext.x= PhoneDetail_titlestar.x+3
	    PhoneDetail_titletext.anchorX=0
	    PhoneDetail_titletext:setFillColor(0,0,0)
	    PhoneDetail_titletext.y= PhoneDetail_bg.y
	    popup_scroll:insert(PhoneDetail_titletext)


		PhoneDetailValue = native.newTextField(W/2,emailnotifytext.y+28, W-50, 25)
		PhoneDetailValue.id="Phone Detail"
		PhoneDetailValue.size=14	
		PhoneDetailValue.inputType = "number"
		PhoneDetailValue.x=22
		PhoneDetailValue.anchorX=0
		PhoneDetailValue.y = PhoneDetail_titletext.y+PhoneDetail_titletext.contentHeight+9
		PhoneDetailValue.hasBackground = false
		PhoneDetailValue.isVisible = true
		PhoneDetailValue:setReturnKey( "next" )
		PhoneDetailValue.placeholder=PopupGroup.PhoneDetailValue_placeholder
		popup_scroll:insert(PhoneDetailValue)

		PhoneDetail_bottom = display.newImageRect("res/assert/line-large.png",W-50,5)
		PhoneDetail_bottom.x=W/2-5
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

	    textnotifytext = display.newText(PopupGroup.textnotifytext,0,0,native.systemFont,14)
	    textnotifytext.x= 50
	    textnotifytext:setFillColor(0,0,0)
	    textnotifytext.anchorX=0
	    textnotifytext.y= PhoneDetail_bottom.y + 15
	    popup_scroll:insert(textnotifytext)

-----------------------------------MKRank detail-------------------------------------------------





        MKRankDetail_bg = display.newRect(W/2,textnotifytext.y+30, W-50, 25)
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


		MKRankDetail_title = display.newText(PopupGroup.MKRankDetail_title,0,0,native.systemFontBold,14)
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

	    MKRankDetail_bottom = display.newImageRect("res/assert/line-large.png",W-50,5)
		MKRankDetail_bottom.x=W/2-5
		MKRankDetail_bottom.y= MKRankDetailValue.y+8.5
		popup_scroll:insert(MKRankDetail_bottom)


-----------------------------------Requested_on detail-------------------------------------------------

        Requesteddate_bg = display.newRect(W/2,MKRankDetailValue.y+15, W-50, 25)
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

		Requesteddate_title = display.newText(PopupGroup.Requesteddate_title,0,0,native.systemFontBold,14)
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


	    Requesteddate_bottom = display.newImageRect("res/assert/line-large.png",W-50,5)
		Requesteddate_bottom.x=W/2-5
		Requesteddate_bottom.y= RequesteddateValue.y+8.5
		popup_scroll:insert(Requesteddate_bottom)


--------------------------------------reason for deny---------------------------------------------

	    deny_bg = display.newRect( 0,0 , W-50, EditBoxStyle.height+40)
	  	deny_bg:setStrokeColor(0,0,0,0.4)
	  	deny_bg.x = W/2-5
	  	deny_bg.isVisible = false
	  	deny_bg.y = Requesteddate_bottom.y + 40
	  	deny_bg.hasBackground = true
		deny_bg.strokeWidth = 1
		popup_scroll:insert(deny_bg)


		deny_Value = native.newTextBox( deny_bg.width,deny_bg.height,W-50, EditBoxStyle.height+40)
		deny_Value.placeholder = PopupGroup.deny_Value_placeholder
		deny_Value.isEditable = true
		deny_Value.size=14
		deny_Value.isVisible = false
		deny_Value.value=""
		deny_Value.id = "deny"
		deny_Value.hasBackground = true
		deny_Value:setReturnKey( "done" )
		deny_Value.inputType = "default"
		deny_Value.x=W/2-5
		deny_Value.y=deny_bg.y
		popup_scroll:insert(deny_Value)





-----------------------------------password detail-------------------------------------------------

        Password_bg = display.newRect(W/2,Requesteddate_bg.y+15, W-50, 25)
		Password_bg.isVisible = true
		Password_bg.alpha = 0.01
		Password_bg.y =  Requesteddate_bg.y+Requesteddate_bg.height+7
		popup_scroll:insert(Password_bg)

		Password_titlestar = display.newText("*",0,0,native.systemFontBold,14)
	    Password_titlestar.x= 19
	    Password_titlestar:setFillColor(1,0,0)
	    Password_titlestar.y= RequesteddateValue.y+RequesteddateValue.height+15
	    popup_scroll:insert(Password_titlestar)

		Password_titletext = display.newText(PopupGroup.Password_titletext,0,0,native.systemFontBold,14)
	    Password_titletext.x= Password_titlestar.x+3
	    Password_titletext.anchorX = 0
	    Password_titletext:setFillColor(0,0,0)
	    Password_titletext.y= RequesteddateValue.y+RequesteddateValue.height+15
	    popup_scroll:insert(Password_titletext)

		PasswordValue = native.newTextField(22,textnotifytext.y+28, W-50, 25)
		PasswordValue.id="Password"
		PasswordValue.size=14	
		PasswordValue.anchorX = 0
		PasswordValue.x = 18
		PasswordValue.y =Password_titletext.y+Password_titletext.height+7
		PasswordValue.hasBackground = false
		PasswordValue.isVisible = true
		PasswordValue:setReturnKey( "done" )
		PasswordValue.placeholder= PopupGroup.PasswordValue_placeholder 
		popup_scroll:insert(PasswordValue)

		Password_bottom = display.newImageRect("res/assert/line-large.png",W-50,5)
		Password_bottom.x=W/2-5
		Password_bottom.y= PasswordValue.y+10
		popup_scroll:insert(Password_bottom)

-----------------------------------password helptext detail-------------------------------------------------

    PasswordHelptext = display.newText(PopupGroup.PasswordHelptext,0,0,W-30,0,native.systemFont,10.5)
    PasswordHelptext.x= popupTop_bg.x+5
    PasswordHelptext:setFillColor(0,0,0)
    PasswordHelptext.y= Password_bottom.y + 12
    popup_scroll:insert(PasswordHelptext)

 -----------------------------------generate password detail-------------------------------------------------

    GeneratePasstext = display.newText(PopupGroup.GeneratePasstext,0,0,W-30,0,native.systemFontBold,14.5)
    GeneratePasstext.x= W - 25
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
	processbutton.value=Details
	popup_scroll:insert(processbutton)
	--processbutton:addEventListener("touch",onProcessButtonTouch)

	processbutton_text = display.newText("",0,0,native.systemFont,14)
	processbutton_text.x=processbutton.x
	processbutton_text.y=processbutton.y
	processbutton_text:setFillColor(0,0,0)
	popup_scroll:insert(processbutton_text)





    function get_GetMyUnitBuzzRequestAccessPermissionsDetail(response )

    	Details = response

    			processbutton.value=Details

			   if email ~= nil or email ~= "null" or email ~= PopupGroup.EmailRequired then
					EmailDetailValue.text = email
					emailnotifytext.isVisible = true
				    emailnotifybox.isVisible = true
			    else
				    EmailDetailValue.text = nil
				    emailnotifytext.isVisible = false
				    emailnotifybox.isVisible = false
			    end


			    if mobile ~= nil  or mobile ~= "null" then
			    	PhoneDetailValue.text = mobile
			    	--textnotifybox.isVisible = true
			    	--textnotifytext.isVisible = true

			    	MKRankDetail_bg.y =  textnotifytext.y+textnotifytext.contentHeight+15
			    elseif homenum ~= nil  or homenum ~= "null" then
			    	PhoneDetailValue.text = homenum
			    	--textnotifybox.isVisible = true
			    	--textnotifytext.isVisible = true

			    	MKRankDetail_bg.y =  textnotifytext.y+textnotifytext.contentHeight+15
			    elseif othernum ~= nil or othernum ~= "null" then
			    	PhoneDetailValue.text = othernum
			    	--textnotifybox.isVisible = true
			    	--textnotifytext.isVisible = true

			    	MKRankDetail_bg.y =  textnotifytext.y+textnotifytext.contentHeight+15
			    elseif worknum  ~= nil or worknum ~= "" or worknum ~= "null" then
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


-----------------------------------------Details of Grant Access fron Open-------------------------------------------------------------



 if id_value == "Grant Access From Open" then

	 	      idname = "Grant Access From Open"


	          processbutton_text.text = CommonWords.GrantAccessText
	          popupText.text = CommonWords.GrantAccessText


	          if Details.FirstName ~= nil and Details.LastName ~= nil then
	             NameDetailValue.text = Details.FirstName.." "..Details.LastName
	             native.setKeyboardFocus( nil )
	          elseif  Details.FirstName  ~= nil then
	             NameDetailValue.text = Details.FirstName
	             native.setKeyboardFocus( nil )
	          elseif Details.LastName ~= nil  then
	             NameDetailValue.text = Details.LastName
	             native.setKeyboardFocus( nil )
			  else
			     NameDetailValue.text = nil
	          end
	          print("print the value of name ",NameDetailValue.text)



	          if Details.EmailAddress ~= nil or Details.EmailAddress ~= "null" then
		           EmailDetailValue.text = Details.EmailAddress
		           print("step 1 email address"..EmailDetailValue.text)
		        --  native.setKeyboardFocus(PhoneDetailValue)
		            emailnotifybox.isVisible = true
				    emailnotifytext.isVisible = true
	          else
		           EmailDetailValue.text = nil
				   emailnotifybox.isVisible = false
				   emailnotifytext.isVisible = false
	          end
	           print("print the value of email ",EmailDetailValue.text)



	         if EmailDetailValue.text == "null" or EmailDetailValue.text == popUpGroup.EmailRequired then

	          	 emailnotifybox.isVisible = false
	          	 emailnotifytext.isVisible = false

	          	 print("step 1 grant email check no")

	          	 PhoneDetail_bg.y =  EmailDetail_bottom.y+EmailDetail_bottom.contentHeight+5
	          	 PhoneDetail_titlestar.y= PhoneDetail_bg.y
	          	 PhoneDetail_titletext.y= PhoneDetail_bg.y
	          	 PhoneDetailValue.y = PhoneDetail_titletext.y+PhoneDetail_titletext.contentHeight+9
				 PhoneDetail_bottom.y= PhoneDetailValue.y+10
				 textnotifybox.y = PhoneDetail_bottom.y+15
				 textnotifytext.y= PhoneDetail_bottom.y + 15
				 MKRankDetail_bg.y =  textnotifytext.y+textnotifytext.contentHeight+5
				 MKRankDetail_title.y= MKRankDetail_bg.y+7
				 MKRankDetailValue.y= MKRankDetail_title.y+MKRankDetail_title.contentHeight+7
			     MKRankDetail_bottom.y= MKRankDetailValue.y+9

			     Requesteddate_bg.y = MKRankDetail_bottom.y+MKRankDetail_bottom.height+7
			     Requesteddate_title.y= Requesteddate_bg.y + 7
			     RequesteddateValue.y= Requesteddate_title.y+Requesteddate_title.height+8
			     Requesteddate_bottom.y= RequesteddateValue.y+9

			else

			   	print("step 1 grant email check yes")

			   	 emailnotifybox.isVisible = true
	          	 emailnotifytext.isVisible = true

			   	 PhoneDetail_bg.y =  emailnotifybox.y+emailnotifybox.contentHeight+5
			   	 PhoneDetail_titlestar.y= PhoneDetail_bg.y
			   	 PhoneDetail_titlestar.y= PhoneDetail_bg.y
			   	 PhoneDetailValue.y = PhoneDetail_titletext.y+PhoneDetail_titletext.contentHeight+9
				 PhoneDetail_bottom.y= PhoneDetailValue.y+10
				 textnotifybox.y = PhoneDetail_bottom.y+15
				 textnotifytext.y= PhoneDetail_bottom.y + 15
				 MKRankDetail_bg.y =  textnotifytext.y+textnotifytext.contentHeight+5
				 MKRankDetail_title.y= MKRankDetail_bg.y+7
				 MKRankDetailValue.y= MKRankDetail_title.y+MKRankDetail_title.contentHeight+7
			     MKRankDetail_bottom.y= MKRankDetailValue.y+9

			     Requesteddate_bg.y = MKRankDetail_bottom.y+MKRankDetail_bottom.height+7
			     Requesteddate_title.y= Requesteddate_bg.y + 7
			     RequesteddateValue.y= Requesteddate_title.y+Requesteddate_title.height+8
			     Requesteddate_bottom.y= RequesteddateValue.y+9

	          end




		        if pagevaluename == "careerPathPage" then

		        	print("***carrer")

			        if Details.Mobile ~= nil or Details.Mobile ~= "null" then
			             PhoneDetailValue.text = Details.Mobile
			          			textnotifybox.isVisible = true
					 		    textnotifytext.isVisible = true
			          elseif Details.HomePhoneNumber ~= nil or Details.HomePhoneNumber ~= "null" then
			             PhoneDetailValue.text = Details.HomePhoneNumber
			          			textnotifybox.isVisible = true
								textnotifytext.isVisible = true
			          elseif Details.WorkPhoneNumber ~= nil or Details.WorkPhoneNumber ~= "null" then
			             PhoneDetailValue.text = Details.WorkPhoneNumber
			          			textnotifybox.isVisible = true
								textnotifytext.isVisible = true
			          elseif Details.OtherPhoneNumber ~= nil or Details.OtherPhoneNumber ~= "null" then
			             PhoneDetailValue.text = Details.OtherPhoneNumber
			                    textnotifybox.isVisible = true
								textnotifytext.isVisible = true
			          else
			          	PhoneDetailValue.text = nil
			          	       textnotifybox.isVisible = false
						       textnotifytext.isVisible = false
			          end

		            print("print the value of phone ",PhoneDetailValue.text)

		            print("step 1 phone number"..PhoneDetailValue.text)

		        elseif pagevaluename == "inviteAndaccessPage" then

		        	print("***invite")


			          if Details.PhoneNumber ~= nil or Details.PhoneNumber ~= "null" or Details.PhoneNumber ~= PopUpGroup.PhoneRequired then
			             PhoneDetailValue.text = Details.PhoneNumber
			          			textnotifybox.isVisible = true
					 		    textnotifytext.isVisible = true
			          else
			          		PhoneDetailValue.text = nil
			          	        textnotifybox.isVisible = false
								textnotifytext.isVisible = false

			          end

			           print("step 11 PhoneNumber"..PhoneDetailValue.text)
		        end




          if  PhoneDetailValue.text == nil or PhoneDetailValue.text == "null" then

          	    textnotifybox.isVisible = false
			    textnotifytext.isVisible = false
			    print("here12345")

			    MKRankDetail_bg.y =  PhoneDetail_bottom.y+8
			    MKRankDetail_title.y= MKRankDetail_bg.y+8
			    MKRankDetailValue.y= MKRankDetail_title.y+MKRankDetail_title.height+7
			    MKRankDetail_bottom.y= MKRankDetailValue.y+8.5
			    Requesteddate_bg.y =  MKRankDetail_bottom.y+MKRankDetail_bottom.height+7
			    Requesteddate_title.y= Requesteddate_bg.y + 7
			    RequesteddateValue.y= Requesteddate_title.y+Requesteddate_title.height+7
			    Requesteddate_bottom.y= RequesteddateValue.y+8.5
			    Password_bg.y =  Requesteddate_bg.y+Requesteddate_bg.height+7
				Password_titlestar.y= RequesteddateValue.y+RequesteddateValue.height+15
				Password_titletext.y= RequesteddateValue.y+RequesteddateValue.height+15
				PasswordValue.y =Password_titletext.y+Password_titletext.height+7
				Password_bottom.y= PasswordValue.y+10
				PasswordHelptext.y= Password_bottom.y + 12
				GeneratePasstext.y= PasswordHelptext.y + 20
				processbutton.y = GeneratePasstext.y+GeneratePasstext.contentHeight+22
				processbutton_text.y=processbutton.y
		  else

		  	    print("val not null")

		  	    textnotifybox.isVisible = true
			    textnotifytext.isVisible = true

			    MKRankDetail_bg.y =  textnotifytext.y+textnotifytext.height+5
			    MKRankDetail_title.y= MKRankDetail_bg.y+8
			    MKRankDetailValue.y= MKRankDetail_title.y+MKRankDetail_title.height+7
			    MKRankDetail_bottom.y= MKRankDetailValue.y+8.5
			    Requesteddate_bg.y =  MKRankDetail_bottom.y+MKRankDetail_bottom.height+7
			    Requesteddate_title.y= Requesteddate_bg.y + 7
			    RequesteddateValue.y= Requesteddate_title.y+Requesteddate_title.height+7
			    Requesteddate_bottom.y= RequesteddateValue.y+8.5
				Password_bg.y =  Requesteddate_bg.y+Requesteddate_bg.height+7
				Password_titlestar.y= RequesteddateValue.y+RequesteddateValue.height+15
				Password_titletext.y= RequesteddateValue.y+RequesteddateValue.height+15
				PasswordValue.y =Password_titletext.y+Password_titletext.height+7
				Password_bottom.y= PasswordValue.y+10
				PasswordHelptext.y= Password_bottom.y + 12
				GeneratePasstext.y= PasswordHelptext.y + 20
				processbutton.y = GeneratePasstext.y+GeneratePasstext.contentHeight+22
				processbutton_text.y=processbutton.y
		   end




	          if Details.MkRankLevel ~= nil then
	          MKRankDetailValue.text = Details.MkRankLevel
	          native.setKeyboardFocus( nil )
	          else
			  MKRankDetailValue.text = "-"
			   MKRankDetail_bottom.isVisible = false
	          end



	          if Details.CreateTimeStamp ~= nil then
	          local time = Utils.makeTimeStamp(Details.CreateTimeStamp)
	          print("time stamp ",time)
	          RequesteddateValue.text =  tostring(os.date("%m/%d/%Y %I:%M %p",time))
	          native.setKeyboardFocus( nil )
	          else
	          RequesteddateValue.text = ""
	          end


	      print("values event ",EmailDetailValue.text)

	      EmailDetailValue:addEventListener("userInput",textField)
		  PhoneDetailValue:addEventListener("userInput",textField)
		  PasswordValue:addEventListener("userInput",textField)
		 --popupList:addEventListener("touch",touchPopupBg)


	      processbutton:addEventListener("touch",onGrantButtonTouch)



-----------------------------------------Details of Grant Access fron Deny-------------------------------------------------------------


elseif id_value == "Grant Access From Deny" and Details.IsRequestTeamMember == true then

	print("COMING HERE ONLY Request")


	    idname = "Grant Access From Deny"

	    IsRequestTeamMember = Details.IsRequestTeamMember


          processbutton_text.text = CommonWords.GrantAccessText
          popupText.text = CommonWords.GrantAccessText


          if Details.FirstName ~= nil and Details.LastName ~= nil then
             NameDetailValue.text = Details.FirstName.." "..Details.LastName
             native.setKeyboardFocus( nil )
          elseif  Details.FirstName  ~= nil then
             NameDetailValue.text = Details.FirstName
             native.setKeyboardFocus( nil )
          elseif Details.LastName ~= nil  then
             NameDetailValue.text = Details.LastName
             native.setKeyboardFocus( nil )
		  else
		     NameDetailValue.text = nil
          end
          print("print the value of name Request",NameDetailValue.text)



          if Details.EmailAddress ~= nil or Details.EmailAddress ~= "null" then
                
                EmailDetailValue.text = Details.EmailAddress

	            print("step 1 email address Request"..EmailDetailValue.text)
	            --  native.setKeyboardFocus(PhoneDetailValue)
	            emailnotifybox.isVisible = true
			    emailnotifytext.isVisible = true
          else
	          	EmailDetailValue.text = nil
			    emailnotifybox.isVisible = false
			    emailnotifytext.isVisible = false
          end
           print("print the value of email Request ",EmailDetailValue.text)



         if EmailDetailValue.text == "null" or EmailDetailValue.text == popUpGroup.EmailRequired then

          	 emailnotifybox.isVisible = false
          	 emailnotifytext.isVisible = false
 
          	 print("step 1 grant email check no Request")

          	 PhoneDetail_bg.y =  EmailDetail_bottom.y+EmailDetail_bottom.contentHeight+5
          	 PhoneDetail_titlestar.y= PhoneDetail_bg.y
          	 PhoneDetail_titletext.y= PhoneDetail_bg.y
          	 PhoneDetailValue.y = PhoneDetail_titletext.y+PhoneDetail_titletext.contentHeight+9
			 PhoneDetail_bottom.y= PhoneDetailValue.y+10
			 textnotifybox.y = PhoneDetail_bottom.y+15
			 textnotifytext.y= PhoneDetail_bottom.y + 15
			 MKRankDetail_bg.y =  textnotifytext.y+textnotifytext.contentHeight+5
			 MKRankDetail_title.y= MKRankDetail_bg.y+7
			 MKRankDetailValue.y= MKRankDetail_title.y+MKRankDetail_title.contentHeight+7
		     MKRankDetail_bottom.y= MKRankDetailValue.y+9

		     Requesteddate_bg.y = MKRankDetail_bottom.y+MKRankDetail_bottom.height+7
		     Requesteddate_title.y= Requesteddate_bg.y + 7
		     RequesteddateValue.y= Requesteddate_title.y+Requesteddate_title.height+8
		     Requesteddate_bottom.y= RequesteddateValue.y+9

		   else

		   	print("step 1 grant email check yes Request")

		   	 emailnotifybox.isVisible = true
          	 emailnotifytext.isVisible = true

		   	 PhoneDetail_bg.y =  emailnotifybox.y+emailnotifybox.contentHeight+5
		   	 PhoneDetail_titlestar.y= PhoneDetail_bg.y
		   	 PhoneDetail_titlestar.y= PhoneDetail_bg.y
		   	 PhoneDetailValue.y = PhoneDetail_titletext.y+PhoneDetail_titletext.contentHeight+9
			 PhoneDetail_bottom.y= PhoneDetailValue.y+10
			 textnotifybox.y = PhoneDetail_bottom.y+15
			 textnotifytext.y= PhoneDetail_bottom.y + 15
			 MKRankDetail_bg.y =  textnotifytext.y+textnotifytext.contentHeight+5
			 MKRankDetail_title.y= MKRankDetail_bg.y+7
			 MKRankDetailValue.y= MKRankDetail_title.y+MKRankDetail_title.contentHeight+7
		     MKRankDetail_bottom.y= MKRankDetailValue.y+9

		     Requesteddate_bg.y = MKRankDetail_bottom.y+MKRankDetail_bottom.height+7
		     Requesteddate_title.y= Requesteddate_bg.y + 7
		     RequesteddateValue.y= Requesteddate_title.y+Requesteddate_title.height+8
		     Requesteddate_bottom.y= RequesteddateValue.y+9

          end




        if pagevaluename == "careerPathPage" then

        	print("***carrer")

	        if Details.Mobile ~= nil or Details.Mobile ~= "null" then
	             PhoneDetailValue.text = Details.Mobile
	          			textnotifybox.isVisible = true
			 		    textnotifytext.isVisible = true
	          elseif Details.HomePhoneNumber ~= nil or Details.HomePhoneNumber ~= "null" then
	             PhoneDetailValue.text = Details.HomePhoneNumber
	          			textnotifybox.isVisible = true
						textnotifytext.isVisible = true
	          elseif Details.WorkPhoneNumber ~= nil or Details.WorkPhoneNumber ~= "null" then
	             PhoneDetailValue.text = Details.WorkPhoneNumber
	          			textnotifybox.isVisible = true
						textnotifytext.isVisible = true
	          elseif Details.OtherPhoneNumber ~= nil or Details.OtherPhoneNumber ~= "null" then
	             PhoneDetailValue.text = Details.OtherPhoneNumber
	                    textnotifybox.isVisible = true
						textnotifytext.isVisible = true
	          else
	          	PhoneDetailValue.text = nil
	          	       textnotifybox.isVisible = false
				       textnotifytext.isVisible = false
	          end

            print("print the value of phone ",PhoneDetailValue.text)

            print("step 1 phone number"..PhoneDetailValue.text)

        elseif pagevaluename == "inviteAndaccessPage" then

        	print("***invite")


	          if Details.PhoneNumber ~= nil or Details.PhoneNumber ~= "null" or Details.PhoneNumber ~= PopUpGroup.PhoneRequired then
	             PhoneDetailValue.text = Details.PhoneNumber
	          			textnotifybox.isVisible = true
			 		    textnotifytext.isVisible = true
	          else
	          		PhoneDetailValue.text = nil
	          	        textnotifybox.isVisible = false
						textnotifytext.isVisible = false

	          end

	           print("step 11 PhoneNumber Request"..PhoneDetailValue.text)
        end




           if  PhoneDetailValue.text == nil or PhoneDetailValue.text == "null" then

          	    textnotifybox.isVisible = false
			    textnotifytext.isVisible = false
			    print("here12345 Request")

			    MKRankDetail_bg.y =  PhoneDetail_bottom.y+8
			    MKRankDetail_title.y= MKRankDetail_bg.y+8
			    MKRankDetailValue.y= MKRankDetail_title.y+MKRankDetail_title.height+7
			    MKRankDetail_bottom.y= MKRankDetailValue.y+8.5
			    Requesteddate_bg.y =  MKRankDetail_bottom.y+MKRankDetail_bottom.height+7
			    Requesteddate_title.y= Requesteddate_bg.y + 7
			    RequesteddateValue.y= Requesteddate_title.y+Requesteddate_title.height+7
			    Requesteddate_bottom.y= RequesteddateValue.y+8.5
			    Password_bg.y =  Requesteddate_bg.y+Requesteddate_bg.height+7
				Password_titlestar.y= RequesteddateValue.y+RequesteddateValue.height+15
				Password_titletext.y= RequesteddateValue.y+RequesteddateValue.height+15
				PasswordValue.y =Password_titletext.y+Password_titletext.height+7
				Password_bottom.y= PasswordValue.y+10
				PasswordHelptext.y= Password_bottom.y + 12
				GeneratePasstext.y= PasswordHelptext.y + 20
				processbutton.y = GeneratePasstext.y+GeneratePasstext.contentHeight+22
				processbutton_text.y=processbutton.y
		  else

		    	print("val not null Request")

		  	    textnotifybox.isVisible = true
			    textnotifytext.isVisible = true

			    MKRankDetail_bg.y =  textnotifytext.y+textnotifytext.height+5
			    MKRankDetail_title.y= MKRankDetail_bg.y+8
			    MKRankDetailValue.y= MKRankDetail_title.y+MKRankDetail_title.height+7
			    MKRankDetail_bottom.y= MKRankDetailValue.y+8.5
			    Requesteddate_bg.y =  MKRankDetail_bottom.y+MKRankDetail_bottom.height+7
			    Requesteddate_title.y= Requesteddate_bg.y + 7
			    RequesteddateValue.y= Requesteddate_title.y+Requesteddate_title.height+7
			    Requesteddate_bottom.y= RequesteddateValue.y+8.5
				Password_bg.y =  Requesteddate_bg.y+Requesteddate_bg.height+7
				Password_titlestar.y= RequesteddateValue.y+RequesteddateValue.height+15
				Password_titletext.y= RequesteddateValue.y+RequesteddateValue.height+15
				PasswordValue.y =Password_titletext.y+Password_titletext.height+7
				Password_bottom.y= PasswordValue.y+10
				PasswordHelptext.y= Password_bottom.y + 12
				GeneratePasstext.y= PasswordHelptext.y + 20
				processbutton.y = GeneratePasstext.y+GeneratePasstext.contentHeight+22
				processbutton_text.y=processbutton.y
		   end



	          if Details.MkRankLevel ~= nil then
	           MKRankDetailValue.text = Details.MkRankLevel
	           native.setKeyboardFocus( nil )
	          else
			   MKRankDetailValue.text = "-"
			   MKRankDetail_bottom.isVisible = false
	          end


	          if Details.CreateTimeStamp ~= nil then
	          local time = Utils.makeTimeStamp(Details.CreateTimeStamp)
	          print("time stamp ",time)
	          RequesteddateValue.text =  tostring(os.date("%m/%d/%Y %I:%M %p",time))
	          native.setKeyboardFocus( nil )
	          else
	          RequesteddateValue.text = ""
	          end

		      print("values event ",EmailDetailValue.text)


	           MKRankDetail_bg.isVisible = false
			   MKRankDetail_title.isVisible = false
			   MKRankDetailValue.isVisible = false
		       MKRankDetail_bottom.isVisible = false
		       -- Requesteddate_bg.isVisible = false
		       -- Requesteddate_title.isVisible = false
		       -- RequesteddateValue.isVisible = false
		       -- Requesteddate_bottom.isVisible = false
		       Requesteddate_bg.isVisible = true
		       Requesteddate_title.isVisible = true
		       RequesteddateValue.isVisible = true
		       Requesteddate_bottom.isVisible = true

		       Requesteddate_bg.y =  textnotifytext.y+textnotifytext.contentHeight+5
		       Requesteddate_title.y= textnotifytext.y+textnotifytext.contentHeight+15
		       RequesteddateValue.y= Requesteddate_title.y+Requesteddate_title.contentHeight+7
		       Requesteddate_bottom.y= RequesteddateValue.y+10

	           Password_bg.y =  Requesteddate_bg.y+Requesteddate_bg.height+5
			   Password_titlestar.y= RequesteddateValue.y+RequesteddateValue.height+15
			   Password_titletext.y= RequesteddateValue.y+RequesteddateValue.height+15

	           -- Password_bg.y =  textnotifytext.y+textnotifytext.contentHeight+5
			   -- Password_titlestar.y= textnotifytext.y+textnotifytext.contentHeight+15
			   -- Password_titletext.y= textnotifytext.y+textnotifytext.contentHeight+15
			   PasswordValue.y =Password_titletext.y+Password_titletext.height+7
			   Password_bottom.y= PasswordValue.y+10
			   PasswordHelptext.y= Password_bottom.y + 12
			   GeneratePasstext.y= PasswordHelptext.y + 20
			   processbutton.y = GeneratePasstext.y+GeneratePasstext.contentHeight+22
			   processbutton_text.y=processbutton.y


		       EmailDetailValue:addEventListener("userInput",textField)
			   PhoneDetailValue:addEventListener("userInput",textField)
			   PasswordValue:addEventListener("userInput",textField)
			   --popupList:addEventListener("touch",touchPopupBg)


	           processbutton:addEventListener("touch",onGrantButtonTouch)




-----------------------------------------Details of Grant Access fron Deny-------------------------------------------------------------


elseif id_value == "Grant Access From Deny" and Details.IsRequestTeamMember == false then

	print("COMING HERE ONLY")


	     idname = "Grant Access From Deny"

	     IsRequestTeamMember = Details.IsRequestTeamMember


          processbutton_text.text = CommonWords.GrantAccessText
          popupText.text = CommonWords.GrantAccessText


          if Details.FirstName ~= nil and Details.LastName ~= nil then
             NameDetailValue.text = Details.FirstName.." "..Details.LastName
             native.setKeyboardFocus( nil )
          elseif  Details.FirstName  ~= nil then
             NameDetailValue.text = Details.FirstName
             native.setKeyboardFocus( nil )
          elseif Details.LastName ~= nil  then
             NameDetailValue.text = Details.LastName
             native.setKeyboardFocus( nil )
		  else
		     NameDetailValue.text = nil
          end
          print("print the value of name OPEN",NameDetailValue.text)



          if Details.EmailAddress ~= nil or Details.EmailAddress ~= "null" then
           EmailDetailValue.text = Details.EmailAddress

           print("step 1 email address OPEN"..EmailDetailValue.text)
        --  native.setKeyboardFocus(PhoneDetailValue)
            emailnotifybox.isVisible = true
		    emailnotifytext.isVisible = true
          else
          	EmailDetailValue.text = nil
		   emailnotifybox.isVisible = false
		   emailnotifytext.isVisible = false
          end
           print("print the value of email OPEN ",EmailDetailValue.text)



         if EmailDetailValue.text == "null" or EmailDetailValue.text == popUpGroup.EmailRequired then

          	emailnotifybox.isVisible = false
          	emailnotifytext.isVisible = false

          	print("step 1 grant email check no")

          	PhoneDetail_bg.y =  EmailDetail_bottom.y+EmailDetail_bottom.contentHeight+5
          	PhoneDetail_titlestar.y= PhoneDetail_bg.y
          	PhoneDetail_titletext.y= PhoneDetail_bg.y
          	PhoneDetailValue.y = PhoneDetail_titletext.y+PhoneDetail_titletext.contentHeight+9
			PhoneDetail_bottom.y= PhoneDetailValue.y+10
			textnotifybox.y = PhoneDetail_bottom.y+15
			textnotifytext.y= PhoneDetail_bottom.y + 15
			 MKRankDetail_bg.y =  textnotifytext.y+textnotifytext.contentHeight+5
			 MKRankDetail_title.y= MKRankDetail_bg.y+7
			 MKRankDetailValue.y= MKRankDetail_title.y+MKRankDetail_title.contentHeight+7
		     MKRankDetail_bottom.y= MKRankDetailValue.y+9

		     Requesteddate_bg.y = MKRankDetail_bottom.y+MKRankDetail_bottom.height+7
		     Requesteddate_title.y= Requesteddate_bg.y + 7
		     RequesteddateValue.y= Requesteddate_title.y+Requesteddate_title.height+8
		     Requesteddate_bottom.y= RequesteddateValue.y+9

		   else

		   	print("step 1 grant email check yes")

		   	emailnotifybox.isVisible = true
          	emailnotifytext.isVisible = true

		   	PhoneDetail_bg.y =  emailnotifybox.y+emailnotifybox.contentHeight+5
		   	PhoneDetail_titlestar.y= PhoneDetail_bg.y
		   	PhoneDetail_titlestar.y= PhoneDetail_bg.y
		   	PhoneDetailValue.y = PhoneDetail_titletext.y+PhoneDetail_titletext.contentHeight+9
			PhoneDetail_bottom.y= PhoneDetailValue.y+10
			textnotifybox.y = PhoneDetail_bottom.y+15
			textnotifytext.y= PhoneDetail_bottom.y + 15
			 MKRankDetail_bg.y =  textnotifytext.y+textnotifytext.contentHeight+5
			 MKRankDetail_title.y= MKRankDetail_bg.y+7
			 MKRankDetailValue.y= MKRankDetail_title.y+MKRankDetail_title.contentHeight+7
		     MKRankDetail_bottom.y= MKRankDetailValue.y+9

		     Requesteddate_bg.y = MKRankDetail_bottom.y+MKRankDetail_bottom.height+7
		     Requesteddate_title.y= Requesteddate_bg.y + 7
		     RequesteddateValue.y= Requesteddate_title.y+Requesteddate_title.height+8
		     Requesteddate_bottom.y= RequesteddateValue.y+9

          end




        if pagevaluename == "careerPathPage" then

        	print("***carrer")

	        if Details.Mobile ~= nil or Details.Mobile ~= "null" then
	             PhoneDetailValue.text = Details.Mobile
	          			textnotifybox.isVisible = true
			 		    textnotifytext.isVisible = true
	          elseif Details.HomePhoneNumber ~= nil or Details.HomePhoneNumber ~= "null" then
	             PhoneDetailValue.text = Details.HomePhoneNumber
	          			textnotifybox.isVisible = true
						textnotifytext.isVisible = true
	          elseif Details.WorkPhoneNumber ~= nil or Details.WorkPhoneNumber ~= "null" then
	             PhoneDetailValue.text = Details.WorkPhoneNumber
	          			textnotifybox.isVisible = true
						textnotifytext.isVisible = true
	          elseif Details.OtherPhoneNumber ~= nil or Details.OtherPhoneNumber ~= "null" then
	             PhoneDetailValue.text = Details.OtherPhoneNumber
	                    textnotifybox.isVisible = true
						textnotifytext.isVisible = true
	          else
	          	PhoneDetailValue.text = nil
	          	       textnotifybox.isVisible = false
				       textnotifytext.isVisible = false
	          end

            print("print the value of phone ",PhoneDetailValue.text)

            print("step 1 phone number"..PhoneDetailValue.text)

        elseif pagevaluename == "inviteAndaccessPage" then

        	print("***invite")


	          if Details.PhoneNumber ~= nil or Details.PhoneNumber ~= "null" or Details.PhoneNumber ~= PopUpGroup.PhoneRequired then
	             PhoneDetailValue.text = Details.PhoneNumber
	          			textnotifybox.isVisible = true
			 		    textnotifytext.isVisible = true
	          else
	          		PhoneDetailValue.text = nil
	          	        textnotifybox.isVisible = false
						textnotifytext.isVisible = false

	          end

	           print("step 11 PhoneNumber"..PhoneDetailValue.text)
        end



           if  PhoneDetailValue.text == nil or PhoneDetailValue.text == "null" then

          	    textnotifybox.isVisible = false
			    textnotifytext.isVisible = false
			    print("here12345")

			    MKRankDetail_bg.y =  PhoneDetail_bottom.y+8
			    MKRankDetail_title.y= MKRankDetail_bg.y+8
			    MKRankDetailValue.y= MKRankDetail_title.y+MKRankDetail_title.height+7
			    MKRankDetail_bottom.y= MKRankDetailValue.y+8.5
			    Requesteddate_bg.y =  MKRankDetail_bottom.y+MKRankDetail_bottom.height+7
			    Requesteddate_title.y= Requesteddate_bg.y + 7
			    RequesteddateValue.y= Requesteddate_title.y+Requesteddate_title.height+7
			    Requesteddate_bottom.y= RequesteddateValue.y+8.5
			    Password_bg.y =  Requesteddate_bg.y+Requesteddate_bg.height+7
				Password_titlestar.y= RequesteddateValue.y+RequesteddateValue.height+15
				Password_titletext.y= RequesteddateValue.y+RequesteddateValue.height+15
				PasswordValue.y =Password_titletext.y+Password_titletext.height+7
				Password_bottom.y= PasswordValue.y+10
				PasswordHelptext.y= Password_bottom.y + 12
				GeneratePasstext.y= PasswordHelptext.y + 20
				processbutton.y = GeneratePasstext.y+GeneratePasstext.contentHeight+22
				processbutton_text.y=processbutton.y
		  else

		    	print("val not null")

		  	    textnotifybox.isVisible = true
			    textnotifytext.isVisible = true

			    MKRankDetail_bg.y =  textnotifytext.y+textnotifytext.height+5
			    MKRankDetail_title.y= MKRankDetail_bg.y+8
			    MKRankDetailValue.y= MKRankDetail_title.y+MKRankDetail_title.height+7
			    MKRankDetail_bottom.y= MKRankDetailValue.y+8.5
			    Requesteddate_bg.y =  MKRankDetail_bottom.y+MKRankDetail_bottom.height+7
			    Requesteddate_title.y= Requesteddate_bg.y + 7
			    RequesteddateValue.y= Requesteddate_title.y+Requesteddate_title.height+7
			    Requesteddate_bottom.y= RequesteddateValue.y+8.5
				Password_bg.y =  Requesteddate_bg.y+Requesteddate_bg.height+7
				Password_titlestar.y= RequesteddateValue.y+RequesteddateValue.height+15
				Password_titletext.y= RequesteddateValue.y+RequesteddateValue.height+15
				PasswordValue.y =Password_titletext.y+Password_titletext.height+7
				Password_bottom.y= PasswordValue.y+10
				PasswordHelptext.y= Password_bottom.y + 12
				GeneratePasstext.y= PasswordHelptext.y + 20
				processbutton.y = GeneratePasstext.y+GeneratePasstext.contentHeight+22
				processbutton_text.y=processbutton.y
		   end




	          if Details.MkRankLevel ~= nil then
	          MKRankDetailValue.text = Details.MkRankLevel
	          native.setKeyboardFocus( nil )
	          else
			  MKRankDetailValue.text = "-"
			   MKRankDetail_bottom.isVisible = false
	          end


	          if Details.CreateTimeStamp ~= nil then
	          local time = Utils.makeTimeStamp(Details.CreateTimeStamp)
	          print("time stamp ",time)
	          RequesteddateValue.text =  tostring(os.date("%m/%d/%Y %I:%M %p",time))
	          native.setKeyboardFocus( nil )
	          else
	          RequesteddateValue.text = ""
	          end

		      print("values event ",EmailDetailValue.text)


	   --       MKRankDetail_bg.isVisible = false
			 -- MKRankDetail_title.isVisible = false
			 -- MKRankDetailValue.isVisible = false
		  --    MKRankDetail_bottom.isVisible = false

		     MKRankDetail_bg.isVisible = true
			 MKRankDetail_title.isVisible = true
			 MKRankDetailValue.isVisible = true
		     MKRankDetail_bottom.isVisible = true

		     Requesteddate_bg.isVisible = false
		     Requesteddate_title.isVisible = false
		     RequesteddateValue.isVisible = false
		     Requesteddate_bottom.isVisible = false
		    --    Requesteddate_bg.isVisible = true
		    --    Requesteddate_title.isVisible = true
		    --    RequesteddateValue.isVisible = true
		    --    Requesteddate_bottom.isVisible = true

		    --    Requesteddate_bg.y =  textnotifytext.y+textnotifytext.contentHeight+5
		    --    Requesteddate_title.y= textnotifytext.y+textnotifytext.contentHeight+15
		    --    RequesteddateValue.y= Requesteddate_title.y+Requesteddate_title.contentHeight+7
		    --    Requesteddate_bottom.y= RequesteddateValue.y+10

	        --  Password_bg.y =  Requesteddate_bg.y+Requesteddate_bg.height+5
			-- Password_titlestar.y= RequesteddateValue.y+RequesteddateValue.height+15
			-- Password_titletext.y= RequesteddateValue.y+RequesteddateValue.height+15

			    MKRankDetail_bg.y =  textnotifytext.y+textnotifytext.height+5
			    MKRankDetail_title.y= MKRankDetail_bg.y+8
			    MKRankDetailValue.y= MKRankDetail_title.y+MKRankDetail_title.height+7
			    MKRankDetail_bottom.y= MKRankDetailValue.y+8.5


	  --       Password_bg.y =  textnotifytext.y+textnotifytext.contentHeight+5
			-- Password_titlestar.y= textnotifytext.y+textnotifytext.contentHeight+15
			-- Password_titletext.y= textnotifytext.y+textnotifytext.contentHeight+15

			    Password_titlestar.y= MKRankDetail_bottom.y+MKRankDetail_bottom.height+15
				Password_titletext.y= MKRankDetail_bottom.y+MKRankDetail_bottom.height+15
				PasswordValue.y =Password_titletext.y+Password_titletext.height+7
				Password_bottom.y= PasswordValue.y+10
				PasswordHelptext.y= Password_bottom.y + 12

			PasswordValue.y =Password_titletext.y+Password_titletext.height+7
			Password_bottom.y= PasswordValue.y+10
			PasswordHelptext.y= Password_bottom.y + 12
			GeneratePasstext.y= PasswordHelptext.y + 20
			processbutton.y = GeneratePasstext.y+GeneratePasstext.contentHeight+22
			processbutton_text.y=processbutton.y



	      EmailDetailValue:addEventListener("userInput",textField)
		  PhoneDetailValue:addEventListener("userInput",textField)
		  PasswordValue:addEventListener("userInput",textField)
		 --popupList:addEventListener("touch",touchPopupBg)


	      processbutton:addEventListener("touch",onGrantButtonTouch)



-------------------------------------------------Details of Provide Access------------------------------------------------------------------------------------    



elseif id_value == "Provide Access" then

		 	processbutton_text.text = CommonWords.ProvideAccessText
            popupText.text = CommonWords.ProvideAccessText

                Requesteddate_bg.isVisible = false
			 	RequesteddateValue.isVisible = false
			 	Requesteddate_title.isVisible = false
			 	Requesteddate_bottom.isVisible = false

       
	          if Details.FirstName ~= nil and Details.LastName ~= nil then
	             NameDetailValue.text = Details.FirstName.." "..Details.LastName
	             native.setKeyboardFocus( nil )
	          elseif  Details.FirstName  ~= nil then
	             NameDetailValue.text = Details.FirstName
	             native.setKeyboardFocus( nil )
	          elseif Details.LastName ~= nil  then
	            NameDetailValue.text = Details.LastName
	             native.setKeyboardFocus( nil )
			  else
			    NameDetailValue.text = nil
	          end



	          if Details.EmailAddress ~= nil  or Details.EmailAddress ~= "null" then
	            EmailDetailValue.text = Details.EmailAddress

	            print("step 1 provide access email address"..EmailDetailValue.text)

	          --native.setKeyboardFocus(PhoneDetailValue)
	            emailnotifybox.isVisible = true
			    emailnotifytext.isVisible = true
	          else
	          	EmailDetailValue.text = nil
			    emailnotifybox.isVisible = false
			    emailnotifytext.isVisible = false
	          end




	          if EmailDetailValue.text == "null" or EmailDetailValue.text == popUpGroup.EmailRequired then

			          	print("step 1 provide access email check no "..EmailDetailValue.text)

			          	 emailnotifybox.isVisible = false
			          	 emailnotifytext.isVisible = false

			          	 PhoneDetail_bg.y =  EmailDetail_bottom.y+EmailDetail_bottom.contentHeight+5
			          	 PhoneDetail_titlestar.y= PhoneDetail_bg.y
			           	 PhoneDetail_titletext.y= PhoneDetail_bg.y
			             PhoneDetailValue.y = PhoneDetail_titletext.y+PhoneDetail_titletext.contentHeight+9
						 PhoneDetail_bottom.y= PhoneDetailValue.y+10
						 textnotifybox.y = PhoneDetail_bottom.y+15
						 textnotifytext.y= PhoneDetail_bottom.y + 15
						 MKRankDetail_bg.y =  textnotifytext.y+textnotifytext.contentHeight+5
						 MKRankDetail_title.y= MKRankDetail_bg.y+7
						 MKRankDetailValue.y= MKRankDetail_title.y+MKRankDetail_title.contentHeight+7
					     MKRankDetail_bottom.y= MKRankDetailValue.y+9

					     Requesteddate_bg.y = MKRankDetail_bottom.y+MKRankDetail_bottom.height+7
					     Requesteddate_title.y= Requesteddate_bg.y + 7
					     RequesteddateValue.y= Requesteddate_title.y+Requesteddate_title.height+8
					     Requesteddate_bottom.y= RequesteddateValue.y+9

			   else

				   		print("step 1 provide access email check yes "..EmailDetailValue.text)

					     emailnotifybox.isVisible = true
			          	 emailnotifytext.isVisible = true

					     PhoneDetail_bg.y =  emailnotifybox.y+emailnotifybox.contentHeight+5
					   	 PhoneDetail_titlestar.y= PhoneDetail_bg.y
					   	 PhoneDetail_titlestar.y= PhoneDetail_bg.y
					   	 PhoneDetailValue.y = PhoneDetail_titletext.y+PhoneDetail_titletext.contentHeight+9
						 PhoneDetail_bottom.y= PhoneDetailValue.y+10
						 textnotifybox.y = PhoneDetail_bottom.y+15
						 textnotifytext.y= PhoneDetail_bottom.y + 15
						 MKRankDetail_bg.y =  textnotifytext.y+textnotifytext.contentHeight+5
						 MKRankDetail_title.y= MKRankDetail_bg.y+7
						 MKRankDetailValue.y= MKRankDetail_title.y+MKRankDetail_title.contentHeight+7
					     MKRankDetail_bottom.y= MKRankDetailValue.y+9

					     Requesteddate_bg.y = MKRankDetail_bottom.y+MKRankDetail_bottom.height+7
					     Requesteddate_title.y= Requesteddate_bg.y + 7
					     RequesteddateValue.y= Requesteddate_title.y+Requesteddate_title.height+8
					     Requesteddate_bottom.y= RequesteddateValue.y+9

	          end



	        if pagevaluename == "careerPathPage" then

		          if Details.Mobile ~= nil or Details.Mobile ~= "null" then
		             PhoneDetailValue.text = Details.Mobile
		          			textnotifybox.isVisible = true
				 		    textnotifytext.isVisible = true
		          elseif Details.HomePhoneNumber ~= nil or Details.HomePhoneNumber ~= "null" then
		             PhoneDetailValue.text = Details.HomePhoneNumber
		          			textnotifybox.isVisible = true
							textnotifytext.isVisible = true
		          elseif Details.WorkPhoneNumber ~= nil or Details.WorkPhoneNumber ~= "null" then
		             PhoneDetailValue.text = Details.WorkPhoneNumber
		          			textnotifybox.isVisible = true
							textnotifytext.isVisible = true
		          elseif Details.OtherPhoneNumber ~= nil or Details.OtherPhoneNumber ~= "null" then
		             PhoneDetailValue.text = Details.OtherPhoneNumber
		                    textnotifybox.isVisible = true
							textnotifytext.isVisible = true
		          else
		          	PhoneDetailValue.text = nil
		          	       textnotifybox.isVisible = false
					       textnotifytext.isVisible = false
		          end

	            print("step 1 provide access phone number"..PhoneDetailValue.text)

	        elseif pagevaluename == "inviteAndaccessPage" then


		          if Details.PhoneNumber ~= nil  or Details.PhoneNumber ~= PopUpGroup.PhoneRequired or Details.PhoneNumber ~= "null" then
		             PhoneDetailValue.text = Details.PhoneNumber
		          			textnotifybox.isVisible = true
				 		    textnotifytext.isVisible = true
		          else
		          	PhoneDetailValue.text = nil
		          	        textnotifybox.isVisible = false
							textnotifytext.isVisible = false
		          end

		          print("step 11 provide access PhoneNumber"..PhoneDetailValue.text)


	        end




          if  PhoneDetailValue.text == nil  or PhoneDetailValue.text == "null" or PhoneDetailValue.text == popUpGroup.PhoneRequired then

          	    textnotifybox.isVisible = false
			    textnotifytext.isVisible = false

			    MKRankDetail_bg.y =  PhoneDetail_bottom.y+8
			    MKRankDetail_title.y= MKRankDetail_bg.y+8
			    MKRankDetailValue.y= MKRankDetail_title.y+MKRankDetail_title.height+7
			    MKRankDetail_bottom.y= MKRankDetailValue.y+8.5
			   -- Requesteddate_bg.y =  MKRankDetail_bottom.y+MKRankDetail_bottom.height+7
			   --  Requesteddate_title.y= Requesteddate_bg.y + 7
			   --  RequesteddateValue.y= Requesteddate_title.y+Requesteddate_title.height+7
			   -- Requesteddate_bottom.y= RequesteddateValue.y+8.5
			    Password_bg.y =  MKRankDetail_bottom.y+MKRankDetail_bottom.height+7
				Password_titlestar.y= Password_bg.y+7
				Password_titletext.y= Password_bg.y+7
				PasswordValue.y =Password_titletext.y+Password_titletext.height+8
				Password_bottom.y= PasswordValue.y+10
				PasswordHelptext.y= Password_bottom.y + 12
				GeneratePasstext.y= PasswordHelptext.y + 20
				processbutton.y = GeneratePasstext.y+GeneratePasstext.contentHeight+22
				processbutton_text.y=processbutton.y
		  else


		  	    textnotifybox.isVisible = false
			    textnotifytext.isVisible = false

			    MKRankDetail_bg.y =  PhoneDetail_bottom.y+PhoneDetail_bottom.contentHeight+5
			    MKRankDetail_title.y= MKRankDetail_bg.y+8
			    MKRankDetailValue.y= MKRankDetail_title.y+MKRankDetail_title.height+7
			    MKRankDetail_bottom.y= MKRankDetailValue.y+8.5
			   --Requesteddate_bg.y =  MKRankDetail_bottom.y+MKRankDetail_bottom.height+7
			   -- Requesteddate_title.y= Requesteddate_bg.y + 7
			   -- RequesteddateValue.y= Requesteddate_title.y+Requesteddate_title.height+7
			   -- Requesteddate_bottom.y= RequesteddateValue.y+8.5
				Password_bg.y =  MKRankDetail_bottom.y+MKRankDetail_bottom.height+7
				Password_titlestar.y= Password_bg.y+7
				Password_titletext.y= Password_bg.y+7
				PasswordValue.y =Password_titletext.y+Password_titletext.height+7
				Password_bottom.y= PasswordValue.y+10
				PasswordHelptext.y= Password_bottom.y + 12
				GeneratePasstext.y= PasswordHelptext.y + 20
				processbutton.y = GeneratePasstext.y+GeneratePasstext.contentHeight+22
				processbutton_text.y=processbutton.y
		   end



	          if Details.MkRankLevel ~= nil then
	          MKRankDetailValue.text = Details.MkRankLevel
	          native.setKeyboardFocus( nil )
	          else
			  MKRankDetailValue.text = "-"
			  MKRankDetail_bottom.isVisible = false
	          end

	          if Details.CreateTimeStamp ~= nil then
	          local time = Utils.makeTimeStamp(Details.CreateTimeStamp)
	          print("time stamp ",time)
	          RequesteddateValue.text =  tostring(os.date("%m/%d/%Y %I:%M %p",time))
	          native.setKeyboardFocus( nil )
	          else
	          RequesteddateValue.text = ""
	          end


		      EmailDetailValue:addEventListener("userInput",textField)
			  PhoneDetailValue:addEventListener("userInput",textField)
			  PasswordValue:addEventListener("userInput",textField)
			 -- popupList:addEventListener("touch",touchPopupBg)

			  --GeneratePasstext:addEventListener("touch",OnPasswordGeneration)

		      processbutton:addEventListener("touch",onGrantButtonTouch)


-------------------------------------------------Details of Deny Access--------------------------------------------------------------------------------------


elseif id_value == "Deny Access" then


	      	processbutton_text.text = CommonWords.DenyAccessText
            popupText.text = CommonWords.DenyAccessText

	        PasswordValue.isVisible = false
	        Password_bg.isVisible = false
	        Password_titlestar.isVisible = false
	        Password_titletext.isVisible = false
	        Password_bottom.isVisible = false
	        PasswordHelptext.isVisible = false
	        GeneratePasstext.isVisible = false

	        deny_bg.isVisible = true
	        deny_Value.isVisible = true

	        Requesteddate_bottom.y= RequesteddateValue.y+8.5
	        deny_bg.y = Requesteddate_bottom.y + Requesteddate_bottom.contentHeight +35
	        deny_Value.y=deny_bg.y
	        processbutton.y = deny_Value.y+deny_Value.contentHeight


	       
	          if Details.FirstName ~= nil and Details.LastName ~= nil then
	             NameDetailValue.text = Details.FirstName.." "..Details.LastName
	             native.setKeyboardFocus( nil )
	          elseif  Details.FirstName  ~= nil then
	             NameDetailValue.text = Details.FirstName
	             native.setKeyboardFocus( nil )
	          elseif Details.LastName ~= nil  then
	            NameDetailValue.text = Details.LastName
	             native.setKeyboardFocus( nil )
			  else
			    NameDetailValue.text = nil
	          end
	          print(NameDetailValue.text)


	          if Details.EmailAddress ~= nil  or Details.EmailAddress ~= "null" then
	          EmailDetailValue.text = Details.EmailAddress

	          print("step 1 deny access email address"..EmailDetailValue.text)
	        --  native.setKeyboardFocus(PhoneDetailValue)
	            emailnotifybox.isVisible = true
			    emailnotifytext.isVisible = true
	          else

	          	EmailDetailValue.text = nil
			   emailnotifybox.isVisible = false
			   emailnotifytext.isVisible = false
	          end




	       if pagevaluename == "careerPathPage" then

		        if Details.Mobile ~= nil  or Details.Mobile ~= "null" then
		             PhoneDetailValue.text = Details.Mobile
		          			textnotifybox.isVisible = true
				 		    textnotifytext.isVisible = true
		          elseif Details.HomePhoneNumber ~= nil or Details.HomePhoneNumber ~= "null" then
		             PhoneDetailValue.text = Details.HomePhoneNumber
		          			textnotifybox.isVisible = true
							textnotifytext.isVisible = true
		          elseif Details.WorkPhoneNumber ~= nil or Details.WorkPhoneNumber ~= "null" then
		             PhoneDetailValue.text = Details.WorkPhoneNumber
		          			textnotifybox.isVisible = true
							textnotifytext.isVisible = true
		          elseif Details.OtherPhoneNumber ~= nil or Details.OtherPhoneNumber ~= "null" then
		             PhoneDetailValue.text = Details.OtherPhoneNumber
		                    textnotifybox.isVisible = true
							textnotifytext.isVisible = true
		          else

		          	PhoneDetailValue.text = nil
		          	       textnotifybox.isVisible = false
					       textnotifytext.isVisible = false
		          end

	            print("***** print the value of deny phone ",PhoneDetailValue.text)

	        elseif pagevaluename == "inviteAndaccessPage" then


		          if Details.PhoneNumber ~= nil or Details.PhoneNumber ~= PopUpGroup.PhoneRequired or Details.PhoneNumber ~= "null" then
		             PhoneDetailValue.text = Details.PhoneNumber
		          			textnotifybox.isVisible = false
				 		    textnotifytext.isVisible = false
		          else

		          	 PhoneDetailValue.text = nil
		          	        textnotifybox.isVisible = false
							textnotifytext.isVisible = false
		          end

		          print("step 1 deny access phone number "..PhoneDetailValue.text)


	        end




          if PhoneDetailValue.text == nil or PhoneDetailValue.text == "null" or PhoneDetailValue.text == popUpGroup.PhoneRequired then

          	   textnotifybox.isVisible = false
			   textnotifytext.isVisible = false
			   print("here12345")

			    MKRankDetail_bg.y =  PhoneDetail_bottom.y+8
			    MKRankDetail_title.y= MKRankDetail_bg.y+8
			    MKRankDetailValue.y= MKRankDetail_title.y+MKRankDetail_title.height+7
			    MKRankDetail_bottom.y= MKRankDetailValue.y+8.5
			    Requesteddate_bg.y =  MKRankDetail_bottom.y+MKRankDetail_bottom.height+7
			    Requesteddate_title.y= Requesteddate_bg.y + 7
			    RequesteddateValue.y= Requesteddate_title.y+Requesteddate_title.height+7
			    Requesteddate_bottom.y= RequesteddateValue.y+8.5
			    Password_bg.y =  Requesteddate_bg.y+Requesteddate_bg.height+7
				Password_titlestar.y= RequesteddateValue.y+RequesteddateValue.height+15
				Password_titletext.y= RequesteddateValue.y+RequesteddateValue.height+15
				PasswordValue.y =Password_titletext.y+Password_titletext.height+7
				Password_bottom.y= PasswordValue.y+10
				PasswordHelptext.y= Password_bottom.y + 12
				GeneratePasstext.y= PasswordHelptext.y + 20
				processbutton.y = GeneratePasstext.y+GeneratePasstext.contentHeight+22
				processbutton_text.y=processbutton.y
		  else

		  	    textnotifybox.isVisible = false
			    textnotifytext.isVisible = false

			    MKRankDetail_bg.y =  PhoneDetail_bottom.y+8
			    MKRankDetail_title.y= MKRankDetail_bg.y+8
			    MKRankDetailValue.y= MKRankDetail_title.y+MKRankDetail_title.height+7
			    MKRankDetail_bottom.y= MKRankDetailValue.y+8.5
			    Requesteddate_bg.y =  MKRankDetail_bottom.y+MKRankDetail_bottom.height+7
			    Requesteddate_title.y= Requesteddate_bg.y + 7
			    RequesteddateValue.y= Requesteddate_title.y+Requesteddate_title.height+7
			    Requesteddate_bottom.y= RequesteddateValue.y+8.5
				Password_bg.y =  Requesteddate_bg.y+Requesteddate_bg.height+7
				Password_titlestar.y= RequesteddateValue.y+RequesteddateValue.height+15
				Password_titletext.y= RequesteddateValue.y+RequesteddateValue.height+15
				PasswordValue.y =Password_titletext.y+Password_titletext.height+7
				Password_bottom.y= PasswordValue.y+10
				PasswordHelptext.y= Password_bottom.y + 12
				GeneratePasstext.y= PasswordHelptext.y + 20
				processbutton.y = GeneratePasstext.y+GeneratePasstext.contentHeight+22
				processbutton_text.y=processbutton.y

				deny_bg.isVisible = true
				deny_Value.isVisible = true

				deny_bg.y = Requesteddate_bottom.y + Requesteddate_bottom.contentHeight +40
				deny_Value.y=deny_bg.y
				processbutton.y = deny_Value.y+deny_Value.contentHeight
				processbutton_text.y=processbutton.y

		   end




          if Details.MkRankLevel ~= nil then
          MKRankDetailValue.text = Details.MkRankLevel
          native.setKeyboardFocus( nil )
          else
		   MKRankDetailValue.text = "-"
		   MKRankDetail_bottom.isVisible = false
          end

          if Details.CreateTimeStamp ~= nil then
          local time = Utils.makeTimeStamp(Details.CreateTimeStamp)
          print("time stamp ",time)
          RequesteddateValue.text =  tostring(os.date("%m/%d/%Y %I:%M %p",time))
          native.setKeyboardFocus( nil )
          else
          RequesteddateValue.text = ""
          end

	      print("values event ",EmailDetailValue.text)

	      EmailDetailValue:addEventListener("userInput",textField)
		  PhoneDetailValue:addEventListener("userInput",textField)
		  PasswordValue:addEventListener("userInput",textField)
		  deny_Value:addEventListener("userInput",textField)
	     -- popupList:addEventListener("touch",touchPopupBg)


	      processbutton:addEventListener("touch",onGrantButtonTouch)

		  end

    end



    local requestId,RequestFrom,Status,IsRequestTeamMember

    if Details.MyUnitBuzzRequestAccessId ~= nil and Details.MyUnitBuzzRequestAccessId ~= 0 then

    	requestId=Details.MyUnitBuzzRequestAccessId
    else

    	requestId=Details.ContactId

    end



    if Details.GetRquestAccessFrom ~= nil then

    	RequestFrom=Details.GetRquestAccessFrom

    else

    	RequestFrom="Contacts"
    end



    if Details.IsRequestTeamMember ~= nil then

    	IsRequestTeamMember = Details.IsRequestTeamMember

    	print("**************************************************** "..tostring(IsRequestTeamMember))

    end

    

	if id_value == "Grant Access From Open" or id_value == "Grant Access From Deny" or id_value == "Provide Access" and Details.IsRequestTeamMember == false then

		Status="GRANT"

        IsRequestTeamMember = "false"

	elseif id_value == "Grant Access From Deny" and Details.IsRequestTeamMember == true  then

		Status="GRANT"

		IsRequestTeamMember = "true"

	elseif id_value == "Deny Access" then

		Status="DENY"

	else

		Status=""

	end



print( "#####################" )

    Webservice.GetMyUnitBuzzRequestAccessPermissionsDetail(requestId,RequestFrom,Status,get_GetMyUnitBuzzRequestAccessPermissionsDetail)


    popUpGroup:insert(popup_scroll)

    MainGroup:insert(popUpGroup)


end

----------------------------------------------------------------------------------
--
-- request access
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local widget = require( "widget" )
require( "Webservice.ServiceManager" )
local scene = composer.newScene()
require( "Utils.Utility" )
local style = require("res.value.style")
local List_array = {}
local json = require("json")
local mkRank_id=0
local current_textField,defalut
local rankGroup = display.newGroup()
local RequestFromStatus = ""
local unitnumberflag = false
local BackFlag = false
local path = system.pathForFile( "MyUnitBuzz.db", system.DocumentsDirectory )
local db = sqlite3.open( path )


--https://play.google.com/store/apps/details?id=com.orgware.PregnancyWorkoutAdvisor

--------------- Initialization -------------------

local W = display.contentWidth;
local H= display.contentHeight

--Display Object
local Background,BgText,tabBar,backBtn,page_title,MKRank,rankText_icon,sumbitBtn_lbl

--EditText Background
local FirstName_bg,Name_bg,Email_bg,Phone_bg,MKRank_bg,Comment_bg,DirectorName_bg,DirectorEmail_bg

--EditText
local FirstName,Name,Email,Phone,UnitNumber,Comment,DirectorName,DirectorEmail, radiobutton_id

--Spinner
local submit_spinner

openPage="addNewAccessPage"

switchtype = "Contacts"

local leftPadding = 15

local RecentTab_Topvalue = 70

--Button
local sumbitBtn,scrollView

--Rank group
local rankList,rankTop,rankClose,rankText

--Bollean
local listFlag= false

isSentMail = true
isSentText = true

--------------------------------------------------


-----------------Function-------------------------

local function rankToptouch( event )
	if event.phase == "began" then
		display.getCurrentStage():setFocus( event.target )
		elseif event.phase == "ended" then
		display.getCurrentStage():setFocus( nil )

		if event.target.id == "close" then
			rankGroup.isVisible=false

			FirstName.isVisible=true
			Name.isVisible=true
			Email.isVisible=true
			Phone.isVisible=true
			Comment.isVisible=true
			Password.isVisible = true
		end

	end

	return true
end




local function radioSwitchListener( event )

		local switch = event.target

		local switchid = event.target.id 

		radiobutton_id = switchid

		if tostring(switch.isOn) == "true" and switchid == "contact" then

			print("contact from switch with 1")

			contact_switch.y = GeneratePasstext.y+GeneratePasstext.contentHeight/2 +18
	 		contact_txt.y = contact_switch.y

	 		teammember_switch.y = GeneratePasstext.y+GeneratePasstext.contentHeight/2 +18
	 		teammember_txt.y = teammember_switch.y


			MKRank_bg.isVisible = false
			MKRank.isVisible = false
		    rankText_icon.isVisible = false

		    Comment_bg.y=teammember_txt.y+teammember_txt.height+Comment_bg.height/2 +5
			Comment.y = Comment_bg.y

			sumbitBtn.y = Comment.y+Comment.height/2+20
	 		sumbitBtn_lbl.y=sumbitBtn.y

	 		sumbitBtn.width = sumbitBtn_lbl.contentWidth+35
	 		sumbitBtn.x=W/2-sumbitBtn.contentWidth/2
	 		sumbitBtn_lbl.x = sumbitBtn.x+16

	 		switchtype = "Contacts"

		elseif tostring(switch.isOn) == "true" and switchid == "teammember" then 

			print("teammember from switch with 0")

			contact_switch.y = GeneratePasstext.y+GeneratePasstext.contentHeight/2 +18
	 		contact_txt.y = contact_switch.y

	 		teammember_switch.y = GeneratePasstext.y+GeneratePasstext.contentHeight/2 +18
	 		teammember_txt.y = teammember_switch.y

			MKRank_bg.isVisible = true
			MKRank.isVisible = true
			rankText_icon.isVisible = true

			--MKRank_bg.y = GeneratePasstext.y+GeneratePasstext.contentHeight+15
			MKRank_bg.y = teammember_txt.y+teammember_txt.contentHeight+15
			MKRank.y=MKRank_bg.y+5
			rankText_icon.y=MKRank_bg.y
			Comment_bg.y=MKRank_bg.y+MKRank_bg.height+Comment_bg.height/2 - 5
			Comment.y = Comment_bg.y

			sumbitBtn.y = Comment.y+Comment.height/2+20
	 		sumbitBtn_lbl.y=sumbitBtn.y

	 		sumbitBtn.width = sumbitBtn_lbl.contentWidth+35
	 		sumbitBtn.x=W/2-sumbitBtn.contentWidth/2
	 		sumbitBtn_lbl.x = sumbitBtn.x+16

	 		switchtype = "Team Member"

		end

	end






local function touchBg( event )
	if event.phase == "began" then

		elseif event.phase == "ended" then

				-- 	if Phone.text ~= nil and Phone.text ~= "" and Utils.PhoneMasking(tostring(text)) then

				-- 					textnotifybox.isVisible = true
				-- 					textnotifytext.isVisible = true

				-- 					textnotifybox.y = Phone_bottom.y + 15
				-- 					textnotifytext.y= Phone_bottom.y + 15

				-- 					Password_bg.y = textnotifytext.y+textnotifytext.contentHeight+12
				-- 					Password.y = textnotifytext.y+textnotifytext.contentHeight+15
				-- 					Password_bottom.y = Password.y+10

				-- 					PasswordHelptext.y= Password_bottom.y + 18
				-- 					GeneratePasstext.y= PasswordHelptext.y + 20

				-- 					contact_switch.y = GeneratePasstext.y+GeneratePasstext.contentHeight/2+18
				-- 			 		contact_txt.y = contact_switch.y

				-- 			 		teammember_switch.y = GeneratePasstext.y+GeneratePasstext.contentHeight/2 +18
				-- 			 		teammember_txt.y = teammember_switch.y


				-- 					   if radiobutton_id == "teammember" then

				-- 					    	print("67567656756∂2323 phone email not null")

																
				-- 								MKRank_bg.isVisible = true
				-- 								MKRank.isVisible = true
				-- 								rankText_icon.isVisible = true

				-- 								--MKRank_bg.y = GeneratePasstext.y+GeneratePasstext.contentHeight+15
				-- 								MKRank_bg.y = teammember_txt.y+teammember_txt.contentHeight+15
				-- 								MKRank.y=MKRank_bg.y+5
				-- 								rankText_icon.y=MKRank_bg.y
				-- 								Comment_bg.y=MKRank_bg.y+MKRank_bg.height+Comment_bg.height/2 - 5
				-- 								Comment.y = Comment_bg.y
											
				-- 					    else

				-- 						 	MKRank_bg.isVisible = false
				-- 					 		MKRank.isVisible = false
				-- 					 		rankText_icon.isVisible = false


				-- 					 		Comment_bg.y=teammember_txt.y+teammember_txt.height+Comment_bg.height/2+12
				-- 							Comment.y = Comment_bg.y

				-- 				 	    end



				-- 			 		sumbitBtn.y = Comment.y+Comment.height/2+20
				-- 			 		sumbitBtn_lbl.y=sumbitBtn.y

				-- 			 		sumbitBtn.width = sumbitBtn_lbl.contentWidth+35
				-- 			 		sumbitBtn.x=W/2-sumbitBtn.contentWidth/2
				-- 			 		sumbitBtn_lbl.x = sumbitBtn.x+16

				-- 					native.setKeyboardFocus(Password)

				-- elseif Phone.text == nil or Phone.text == ""  or Phone.text == Phone_placeholder then

				-- 				textnotifybox.isVisible = false
				-- 				textnotifytext.isVisible = false

				-- 				 Password_bg.y = Phone_bg.y+Phone_bg.height+7
				-- 				 Password.y = Phone_bg.y+Phone_bg.height+13
				-- 				 Password_bottom.y = Password.y+10

				-- 				 PasswordHelptext.y= Password_bottom.y + 18
				-- 				 GeneratePasstext.y= PasswordHelptext.y + 20

				-- 		 		contact_switch.y = GeneratePasstext.y+GeneratePasstext.contentHeight/2+15
				-- 		 		contact_txt.y = contact_switch.y

				-- 		 		teammember_switch.y = GeneratePasstext.y+GeneratePasstext.contentHeight/2+15
				-- 		 		teammember_txt.y = teammember_switch.y


				-- 				    if radiobutton_id == "teammember" then

				-- 				    	print("67567656756∂2323")

				-- 						MKRank_bg.isVisible = true
				-- 						MKRank.isVisible = true
				-- 						rankText_icon.isVisible = true

				-- 						MKRank_bg.y = teammember_txt.y+teammember_txt.contentHeight+15
				-- 						MKRank.y=MKRank_bg.y+5
				-- 						rankText_icon.y=MKRank_bg.y
				-- 						Comment_bg.y=MKRank_bg.y+MKRank_bg.height+Comment_bg.height/2 - 5
				-- 						Comment.y = Comment_bg.y

									
				-- 				    else

				-- 					 	MKRank_bg.isVisible = false
				-- 				 		MKRank.isVisible = false
				-- 				 		rankText_icon.isVisible = false

				-- 				 		Comment_bg.y=teammember_txt.y+teammember_txt.height+Comment_bg.height/2+12
				-- 						Comment.y = Comment_bg.y

				-- 			 	    end

							 	
				-- 			 		sumbitBtn.y = Comment.y+Comment.height/2+20
				-- 			 		sumbitBtn_lbl.y=sumbitBtn.y

				-- 			 		sumbitBtn.width = sumbitBtn_lbl.contentWidth+35
				-- 			 		sumbitBtn.x=W/2-sumbitBtn.contentWidth/2
				-- 			 		sumbitBtn_lbl.x = sumbitBtn.x+16



				-- 				 native.setKeyboardFocus(Password)

				-- end

			native.setKeyboardFocus(nil)

	end

	return true
end





local function SetError( displaystring, object )

	if object.id == "Password" then
		object.isSecure = false
	end
	object.text=displaystring
	object.size=10
	object:setTextColor(1,0,0)

end



function onComplete(event)

	if "clicked"==event.action then

		print("on complete action done [[[[[[980890890890]]]]]]")

		radiobutton_id = "contact"

		-- if (Phone.text == "" or Phone.text == Phone_placeholder) then

		-- 	print("hhhh")

		-- 	Background:removeEventListener("touch",touchBg)

		-- end


		--Background:removeEventListener("touch",touchBg)

	end

end





local function RequestProcess()

	print( "here !!!!!" )

	if  submit_spinner.isVisible == false then

		submit_spinner.isVisible=true
		sumbitBtn.width = sumbitBtn.contentWidth+30
		sumbitBtn_lbl.x=sumbitBtn.x-sumbitBtn.contentWidth/2+15
		submit_spinner.x=sumbitBtn_lbl.x+sumbitBtn_lbl.contentWidth+15
		submit_spinner.y = sumbitBtn_lbl.y

		sumbitBtn.width = sumbitBtn_lbl.contentWidth+50
		sumbitBtn.x=W/2-sumbitBtn.contentWidth/2
		sumbitBtn_lbl.x = sumbitBtn.x+16
		submit_spinner.x=sumbitBtn_lbl.x+sumbitBtn_lbl.contentWidth+15

		submit_spinner:start( )

		local isSentMailvalue = isSentMail

		local isSentTextvalue = isSentText

		function get_requestAccess(response)

			Request_response = response

			submit_spinner.isVisible=false
			sumbitBtn.width = sumbitBtn_lbl.width+30
			sumbitBtn_lbl.x=sumbitBtn.x-sumbitBtn.contentWidth/2+15
			submit_spinner.x=sumbitBtn_lbl.x+sumbitBtn_lbl.contentWidth+35
			sumbitBtn.width = sumbitBtn_lbl.contentWidth+35
			sumbitBtn.x=W/2-sumbitBtn.contentWidth/2
			sumbitBtn_lbl.x = sumbitBtn.x+16

			submit_spinner:stop( )

			FirstName.text = ""
			Name.text = ""
			Email.text = ""
			Phone.text = ""
			Password.text = ""
			MKRank.text = "-Select MK Rank-"
			MKRank.value = "-Select MK Rank-"
			Comment.text = ""
			emailnotifybox.isVisible = false
			textnotifybox.isVisible = false
			emailnotifytext.isVisible = false
			textnotifytext.isVisible = false

			Phone_bg.y = Email_bg.y+Email_bg.height+9
			Phone.y = Email_bg.y+Email_bg.height+9
			Phone_bottom.y= Phone.y+12
			Password_bg.y = Phone_bg.y+Phone_bg.height+9
			Password.y = Phone_bg.y+Phone_bg.height+9
			Password_bottom.y=Password.y+12
			PasswordHelptext.y= Password_bottom.y + 19
			GeneratePasstext.y= PasswordHelptext.y + 22
			contact_switch.y = GeneratePasstext.y+GeneratePasstext.contentHeight/2 + 18
			contact_txt.y = contact_switch.y
			teammember_switch.y = GeneratePasstext.y+GeneratePasstext.contentHeight/2 +18
			teammember_txt.y = teammember_switch.y


	 		if switchtype == "Team Member" then

	 			contact_switch.isOn = true
	 			teammember_switch.isOn = false

	 			contact_switch:setState( { isOn=true})

	 			MKRank_bg.isVisible = false
		 		MKRank.isVisible = false
		 		rankText_icon.isVisible = false

				Comment_bg.y=teammember_txt.y + teammember_txt.contentHeight+Comment_bg.height/2 +5
				Comment.y = Comment_bg.y

				Comment.placeholder=RequestAccess.Comment_placeholder

				sumbitBtn.y = Comment.y+Comment.height/2+20
				sumbitBtn_lbl.y=sumbitBtn.y
		 		sumbitBtn.width = sumbitBtn_lbl.contentWidth+35
		 		sumbitBtn.x=W/2-sumbitBtn.contentWidth/2
		 		sumbitBtn_lbl.x = sumbitBtn.x+16

	 		else
	 			contact_switch.isOn = true
	 			teammember_switch.isOn = false

	 			contact_switch:setState( { isOn=true})

	 			MKRank_bg.isVisible = false
		 		MKRank.isVisible = false
		 		rankText_icon.isVisible = false

		 		Comment_bg.y = teammember_txt.y + teammember_txt.contentHeight+Comment_bg.height/2 +5
				Comment.y = Comment_bg.y

				Comment.placeholder=RequestAccess.Comment_placeholder

				sumbitBtn.y = Comment.y+Comment.height/2+20
				sumbitBtn_lbl.y=sumbitBtn.y
		 		sumbitBtn.width = sumbitBtn_lbl.contentWidth+35
		 		sumbitBtn.x=W/2-sumbitBtn.contentWidth/2
		 		sumbitBtn_lbl.x = sumbitBtn.x+16
	 		end


			-- emailnotifybox.isOn = true
			-- textnotifybox.isOn = true

			if Request_response == "SUCCESS" then

					if switchtype == "Contacts" then

							alert = native.showAlert( "Add New Contact" , "Contact added successfully!", { CommonWords.ok }, onComplete )

					elseif switchtype == "Team Member" then

							alert = native.showAlert( "Add New Team Member" , "Team Member added successfully!" , { CommonWords.ok }, onComplete )

					end

			elseif Request_response == "GRANT" then

				granted = native.showAlert(CareerPath.AlreadyGranted, CareerPath.AlreadyGrantedText, { CommonWords.ok} , onComplete)

			elseif Request_response == "REMOVE" then

				Removed = native.showAlert(CareerPath.AlreadyRemoved, CareerPath.AlreadyRemovedText, { CommonWords.ok} , onComplete)
				
			elseif Request_response == "ADDREQUEST" then

				addrequest = native.showAlert(CareerPath.AddRequest, CareerPath.AddRequestText, { CommonWords.ok} , onComplete)

			elseif Request_response == "BLOCK" then

				block = native.showAlert(CareerPath.AlreadyBlocked, CareerPath.AlreadyBlockedText, { CommonWords.ok} , onComplete)
				
			end

		end

		print(switchtype)

		Webservice.REQUEST_ACCESS(openPage,"WEB",isSentMailvalue,isSentTextvalue,"","",FirstName.text,Name.text,Email.text,Phone.text,"",Password.text,mkRank_id,Comment.text,switchtype,get_requestAccess)
		
	end

end





function onCompletionEvent(event)

	if "clicked"==event.action then

		native.setKeyboardFocus(Email)

	end

end




local function addevent_scrollListener(event )

	local phase = event.phase

			if ( phase == "began" ) then 

			elseif ( phase == "moved" ) then 

			    local x, y = addNewAccess_scrollview:getContentPosition()


				if y > -30 then

					FirstName.isVisible = true
					FirstName_bottom.isVisible = true
				else

					FirstName.isVisible = false
					FirstName_bottom.isVisible = false
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





function getemailexistresponse(response)
	
	email_response = response

	print("************************Request_response email initial*************************** ",json.encode(email_response))

	if email_response == true then

	elseif email_response == false then

		native.setKeyboardFocus(Email)

		existalert = native.showAlert(PopupGroup.EmailExist, PopupGroup.EmailExistText, { CommonWords.ok} , onCompletionEvent)

	end
	
end




local function textfield( event )

	if ( event.phase == "began" ) then

		testflag = true

		event.target:setTextColor(color.black)

		current_textField = event.target;

		current_textField.size=14

		if "*" == event.target.text:sub(1,1) then
			event.target.text=""
		end

		if(event.target.id == "Comments") then
			scrollTo( -80 )
			event.target.text = ""

		end
		

	elseif ( event.phase == "submitted" ) then

		if current_textField then

			if(event.target.id == "Comments") then

				scrollTo( 0 )

				native.setKeyboardFocus( nil )

			elseif(event.target.id == "First Name") then

				native.setKeyboardFocus(Name)

			elseif(event.target.id == "Last Name") then

				native.setKeyboardFocus(Email)

			elseif(event.target.id == "Email") then

				native.setKeyboardFocus(Phone)

			elseif(event.target.id == "Phone") then

				native.setKeyboardFocus(Password)

			elseif(event.target.id == "Password") then

				scrollTo(-80)

				native.setKeyboardFocus(Comment)

			end

		end

						--scrollTo( 0 )


		elseif event.phase == "ended" then

--------------------------------- for email in ended ----------------------------------------------------------------------

		            if event.target.id == "Email" then


							             if Email.text ~= nil and Email.text ~= "" and Utils.emailValidation(Email.text) then

							             
								             	print("haiiiiiiiiii")

								             	if (Phone.text ~= nil and Phone.text ~= "" and Phone.text:len() == 14 and Utils.PhoneMasking(tostring(text))) then

								             		print("helllloooooooo")

										             		   textnotifytext.isVisible = true
										             		   textnotifybox.isVisible = true

										             	       emailnotifytext.isVisible = true
										             	       emailnotifybox.isVisible = true

									             	            Phone_bg.y = emailnotifytext.y+emailnotifytext.height+7
														 		Phone.y = emailnotifytext.y+emailnotifytext.height+16
														 		Phone_bottom.y= Phone.y+10

								 	    					 --    Phone_bg.y = textnotifytext.y+2
													 		    -- Phone.y = textnotifytext.y+2
													 		    -- Phone_bottom.y= Phone.y+10

													 		    textnotifybox.y = Phone_bottom.y + 15
																textnotifytext.y= Phone_bottom.y + 15

													 		    Password_bg.y = textnotifytext.y+textnotifytext.height+12
													 		    Password.y = textnotifytext.y+textnotifytext.height+12
													 		    Password_bottom.y = Password.y+10

													 		    PasswordHelptext.y= Password_bottom.y + 18
														 		GeneratePasstext.y= PasswordHelptext.y + 20

														 		contact_switch.y = GeneratePasstext.y+GeneratePasstext.contentHeight/2 +18
														 		contact_txt.y = contact_switch.y

														 		teammember_switch.y = GeneratePasstext.y+GeneratePasstext.contentHeight/2 +18
														 		teammember_txt.y = teammember_switch.y


															 		   if radiobutton_id == "teammember" then
																								
																					MKRank_bg.isVisible = true
																					MKRank.isVisible = true
																					rankText_icon.isVisible = true

																					MKRank_bg.y = teammember_txt.y+teammember_txt.contentHeight+15
																					MKRank.y=MKRank_bg.y+5
																					rankText_icon.y=MKRank_bg.y
																					Comment_bg.y=MKRank_bg.y+MKRank_bg.height+Comment_bg.height/2 - 5
																					Comment.y = Comment_bg.y
																				
																		else

																				 	MKRank_bg.isVisible = false
																			 		MKRank.isVisible = false
																			 		rankText_icon.isVisible = false


																			 		Password_bg.y = textnotifytext.y+textnotifytext.height+12
																					Password.y = textnotifytext.y+textnotifytext.height+12
																					Password_bottom.y = Password.y+10

																			 		Comment_bg.y=teammember_txt.y+teammember_txt.height+Comment_bg.height/2+12
																					Comment.y = Comment_bg.y

																	 	end

														else


 print("not helllloooooooo")

											             		 textnotifytext.isVisible = false
											             		 textnotifybox.isVisible = false

											             	     emailnotifytext.isVisible = true
											             	     emailnotifybox.isVisible = true

										             	            Phone_bg.y = emailnotifytext.y+emailnotifytext.height+7
															 		Phone.y = emailnotifytext.y+emailnotifytext.height+16
															 		Phone_bottom.y= Phone.y+10

									 	    					 --    Phone_bg.y = textnotifytext.y+2
														 		    -- Phone.y = textnotifytext.y+2
														 		    -- Phone_bottom.y= Phone.y+10

														 		    Password_bg.y = Phone_bg.y+Phone_bg.height+12
														 		    Password.y = Phone_bg.y+Phone_bg.height+12
														 		    Password_bottom.y = Password.y+10

														 		    PasswordHelptext.y= Password_bottom.y + 18
															 		GeneratePasstext.y= PasswordHelptext.y + 20

															 		contact_switch.y = GeneratePasstext.y+GeneratePasstext.contentHeight/2 +18
															 		contact_txt.y = contact_switch.y

															 		teammember_switch.y = GeneratePasstext.y+GeneratePasstext.contentHeight/2 +18
															 		teammember_txt.y = teammember_switch.y


																 		   if radiobutton_id == "teammember" then
																									
																						MKRank_bg.isVisible = true
																						MKRank.isVisible = true
																						rankText_icon.isVisible = true

																						MKRank_bg.y = teammember_txt.y+teammember_txt.contentHeight+15
																						MKRank.y=MKRank_bg.y+5
																						rankText_icon.y=MKRank_bg.y
																						Comment_bg.y=MKRank_bg.y+MKRank_bg.height+Comment_bg.height/2 - 5
																						Comment.y = Comment_bg.y
																					
																			else

																					 	MKRank_bg.isVisible = false
																				 		MKRank.isVisible = false
																				 		rankText_icon.isVisible = false


																				 		Password_bg.y = Phone_bg.y+Phone_bg.height+12
																						Password.y = Phone_bg.y+Phone_bg.height+12
																						Password_bottom.y = Password.y+10

																				 		Comment_bg.y=teammember_txt.y+teammember_txt.height+Comment_bg.height/2+12
																						Comment.y = Comment_bg.y

																		 	end



														end


													 		sumbitBtn.y = Comment.y+Comment.height/2+20
													 		sumbitBtn_lbl.y=sumbitBtn.y

													 		sumbitBtn.width = sumbitBtn_lbl.contentWidth+35
													 		sumbitBtn.x=W/2-sumbitBtn.contentWidth/2
													 		sumbitBtn_lbl.x = sumbitBtn.x+16


								             	      --native.setKeyboardFocus(Phone)

								             	     Webservice.CheckExistsRequestStatus(0,Email.text,getemailexistresponse)



							             elseif  (Email.text ~= nil and Email.text ~= "" and not Utils.emailValidation(Email.text)) then


							             	if (Phone.text ~= nil and Phone.text ~= "" and Phone.text:len() == 14 and Utils.PhoneMasking(tostring(text))) then

							             		print("email not null and phone not null")

							             		  SetError("*".."Enter the valid Email",Email)

							             		  textnotifytext.isVisible = true
							             		  textnotifybox.isVisible = true

							             	else

							             		print("email not null and phone null")

								            	--print("email not valid")

							             	    SetError("*".."Enter the valid Email",Email)

							             	    emailnotifytext.isVisible = false
								             	emailnotifybox.isVisible = false

								             	textnotifytext.isVisible = false
							             		textnotifybox.isVisible = false


								             	        Phone_bg.y = Email_bg.y+Email_bg.height+7
														Phone.y = Email_bg.y+Email_bg.height+7
														Phone_bottom.y= Phone.y+10

											 		    -- Password_bg.y = Phone_bg.y+Phone_bg.height+7
											 		    -- Password.y = Phone_bg.y+Phone_bg.contentHeight+7
											 		    -- Password_bottom.y = Password.y+10

											 		    Password_bg.y = Phone_bg.y+Phone_bg.height+9
														Password.y = Phone_bg.y+Phone_bg.height+9
														Password_bottom.y = Password.y+10

											 		    print("RTRTYYT")

											 		    PasswordHelptext.y= Password_bottom.y + 18
												 		GeneratePasstext.y= PasswordHelptext.y + 20

												 		contact_switch.y = GeneratePasstext.y+GeneratePasstext.contentHeight/2 +18
												 		contact_txt.y = contact_switch.y

												 		teammember_switch.y = GeneratePasstext.y+GeneratePasstext.contentHeight/2 +18
												 		teammember_txt.y = teammember_switch.y


													 		   if radiobutton_id == "teammember" then
																						
																			MKRank_bg.isVisible = true
																			MKRank.isVisible = true
																			rankText_icon.isVisible = true

																			MKRank_bg.y = teammember_txt.y+teammember_txt.contentHeight+15
																			MKRank.y=MKRank_bg.y+5
																			rankText_icon.y=MKRank_bg.y
																			Comment_bg.y=MKRank_bg.y+MKRank_bg.height+Comment_bg.height/2 - 5
																			Comment.y = Comment_bg.y
																		
																else

																		 	MKRank_bg.isVisible = false
																	 		MKRank.isVisible = false
																	 		rankText_icon.isVisible = false


																	 		Password_bg.y = Phone_bg.y+Phone_bg.height+12
																			Password.y = Phone_bg.y+Phone_bg.height+9
																			Password_bottom.y = Password.y+10

																	 		Comment_bg.y=teammember_txt.y+teammember_txt.height+Comment_bg.height/2+12
																			Comment.y = Comment_bg.y

															 	end


													 		sumbitBtn.y = Comment.y+Comment.height/2+20
													 		sumbitBtn_lbl.y=sumbitBtn.y

													 		sumbitBtn.width = sumbitBtn_lbl.contentWidth+35
													 		sumbitBtn.x=W/2-sumbitBtn.contentWidth/2
													 		sumbitBtn_lbl.x = sumbitBtn.x+16

												end


								             	      --native.setKeyboardFocus(Phone)

							    elseif (Email.text == "" or Email.text == Email.id or Email.text == PopupGroup.EmailIdRequired)  then

								         	   -- SetError("*"..RequestAccess.Email_error,Email)

								         	   print("email is null")


										         	    emailnotifytext.isVisible = false
										             	emailnotifybox.isVisible = false


								             	        Phone_bg.y = Email_bg.y+Email_bg.height+7
														Phone.y = Email_bg.y+Email_bg.height+7
														Phone_bottom.y= Phone.y+10

											 		    -- Password_bg.y = Phone_bg.y+Phone_bg.height+7
											 		    -- Password.y = Phone_bg.y+Phone_bg.contentHeight+7
											 		    -- Password_bottom.y = Password.y+10

											 		    Password_bg.y = Phone_bg.y+Phone_bg.height+9
														Password.y = Phone_bg.y+Phone_bg.height+9
														Password_bottom.y = Password.y+10

											 		    print("RTRTYYT")

											 		    PasswordHelptext.y= Password_bottom.y + 18
												 		GeneratePasstext.y= PasswordHelptext.y + 20

												 		contact_switch.y = GeneratePasstext.y+GeneratePasstext.contentHeight/2 +18
												 		contact_txt.y = contact_switch.y

												 		teammember_switch.y = GeneratePasstext.y+GeneratePasstext.contentHeight/2 +18
												 		teammember_txt.y = teammember_switch.y


													 		   if radiobutton_id == "teammember" then
																						
																			MKRank_bg.isVisible = true
																			MKRank.isVisible = true
																			rankText_icon.isVisible = true

																			MKRank_bg.y = teammember_txt.y+teammember_txt.contentHeight+15
																			MKRank.y=MKRank_bg.y+5
																			rankText_icon.y=MKRank_bg.y
																			Comment_bg.y=MKRank_bg.y+MKRank_bg.height+Comment_bg.height/2 - 5
																			Comment.y = Comment_bg.y
																		
																else

																		 	MKRank_bg.isVisible = false
																	 		MKRank.isVisible = false
																	 		rankText_icon.isVisible = false


																	 		Password_bg.y = Phone_bg.y+Phone_bg.height+12
																			Password.y = Phone_bg.y+Phone_bg.height+9
																			Password_bottom.y = Password.y+10

																	 		Comment_bg.y=teammember_txt.y+teammember_txt.height+Comment_bg.height/2+12
																			Comment.y = Comment_bg.y

															 	end


													 		sumbitBtn.y = Comment.y+Comment.height/2+20
													 		sumbitBtn_lbl.y=sumbitBtn.y

													 		sumbitBtn.width = sumbitBtn_lbl.contentWidth+35
													 		sumbitBtn.x=W/2-sumbitBtn.contentWidth/2
													 		sumbitBtn_lbl.x = sumbitBtn.x+16


													 		if (Phone.text ~= nil and Phone.text ~= "" and Phone.text:len() == 14 and Utils.PhoneMasking(tostring(text))) then


													 			     print("phone not null email null")


																			textnotifybox.isVisible = true
																			textnotifytext.isVisible = true

																			textnotifybox.y = Phone_bottom.y + 15
																			textnotifytext.y= Phone_bottom.y + 15

																			Password_bg.y = textnotifytext.y+textnotifytext.height+12
																			Password.y = textnotifytext.y+textnotifytext.height+15
																			Password_bottom.y = Password.y+10

																			PasswordHelptext.y= Password_bottom.y + 18
																			GeneratePasstext.y= PasswordHelptext.y + 20

																			contact_switch.y = GeneratePasstext.y+GeneratePasstext.contentHeight/2+18
																	 		contact_txt.y = contact_switch.y

																	 		teammember_switch.y = GeneratePasstext.y+GeneratePasstext.contentHeight/2 +18
																	 		teammember_txt.y = teammember_switch.y


																			   if radiobutton_id == "teammember" then

																			    	print("67567656756∂2323 phone email not null")

																										
																						MKRank_bg.isVisible = true
																						MKRank.isVisible = true
																						rankText_icon.isVisible = true

																						--MKRank_bg.y = GeneratePasstext.y+GeneratePasstext.contentHeight+15
																						MKRank_bg.y = teammember_txt.y+teammember_txt.contentHeight+15
																						MKRank.y=MKRank_bg.y+5
																						rankText_icon.y=MKRank_bg.y
																						Comment_bg.y=MKRank_bg.y+MKRank_bg.height+Comment_bg.height/2 - 5
																						Comment.y = Comment_bg.y
																					
																			    else

																				 	MKRank_bg.isVisible = false
																			 		MKRank.isVisible = false
																			 		rankText_icon.isVisible = false

																			 		Password_bg.y = textnotifytext.y+textnotifytext.height+12
																					Password.y = textnotifytext.y+textnotifytext.height+15
																					Password_bottom.y = Password.y+10


																			 		Comment_bg.y=teammember_txt.y+teammember_txt.height+Comment_bg.height/2+12
																					Comment.y = Comment_bg.y

																		 	    end



																	 		sumbitBtn.y = Comment.y+Comment.height/2+20
																	 		sumbitBtn_lbl.y=sumbitBtn.y

																	 		sumbitBtn.width = sumbitBtn_lbl.contentWidth+35
																	 		sumbitBtn.x=W/2-sumbitBtn.contentWidth/2
																	 		sumbitBtn_lbl.x = sumbitBtn.x+16

														    else             

														    	        print("phone null email present")


																			textnotifybox.isVisible = false
																			textnotifytext.isVisible = false

																			 Password_bg.y = Phone_bg.y+Phone_bg.height+12
																			 Password.y = Phone_bg.y+Phone_bg.height+9
																			 Password_bottom.y = Password.y+10

																			 PasswordHelptext.y= Password_bottom.y + 18
																			 GeneratePasstext.y= PasswordHelptext.y + 20

																	 		contact_switch.y = GeneratePasstext.y+GeneratePasstext.contentHeight/2+15
																	 		contact_txt.y = contact_switch.y

																	 		teammember_switch.y = GeneratePasstext.y+GeneratePasstext.contentHeight/2+15
																	 		teammember_txt.y = teammember_switch.y


																			    if radiobutton_id == "teammember" then

																			    	print("67567656756∂2323")

																					MKRank_bg.isVisible = true
																					MKRank.isVisible = true
																					rankText_icon.isVisible = true

																					MKRank_bg.y = teammember_txt.y+teammember_txt.contentHeight+15
																					MKRank.y=MKRank_bg.y+5
																					rankText_icon.y=MKRank_bg.y
																					Comment_bg.y=MKRank_bg.y+MKRank_bg.height+Comment_bg.height/2 - 5
																					Comment.y = Comment_bg.y

																				
																			    else

																				 	MKRank_bg.isVisible = false
																			 		MKRank.isVisible = false
																			 		rankText_icon.isVisible = false

																			 		Password_bg.y = Phone_bg.y+Phone_bg.height+12
																					Password.y = Phone_bg.y+Phone_bg.height+9
																					Password_bottom.y = Password.y+10

																			 		Comment_bg.y=teammember_txt.y+teammember_txt.height+Comment_bg.height/2+12
																					Comment.y = Comment_bg.y

																		 	    end

																		 	
																		 		sumbitBtn.y = Comment.y+Comment.height/2+20
																		 		sumbitBtn_lbl.y=sumbitBtn.y

																		 		sumbitBtn.width = sumbitBtn_lbl.contentWidth+35
																		 		sumbitBtn.x=W/2-sumbitBtn.contentWidth/2
																		 		sumbitBtn_lbl.x = sumbitBtn.x+16


													 		end


							             end

		            end

--------------------------------- end of email in ended ----------------------------------------------------------------------



--------------------------------- for phone in ended ----------------------------------------------------------------------


					if event.target.id == "Phone" then

                      		if Phone.text ~= nil and Phone.text ~= "" and Phone.text:len() == 14 and Utils.PhoneMasking(tostring(text)) then

                      			print("phone not null")

											textnotifybox.isVisible = true
											textnotifytext.isVisible = true

											textnotifybox.y = Phone_bottom.y + 15
											textnotifytext.y= Phone_bottom.y + 15

											Password_bg.y = textnotifytext.y+textnotifytext.height+12
											Password.y = textnotifytext.y+textnotifytext.height+15
											Password_bottom.y = Password.y+10

											PasswordHelptext.y= Password_bottom.y + 18
											GeneratePasstext.y= PasswordHelptext.y + 20

											contact_switch.y = GeneratePasstext.y+GeneratePasstext.contentHeight/2+18
									 		contact_txt.y = contact_switch.y

									 		teammember_switch.y = GeneratePasstext.y+GeneratePasstext.contentHeight/2 +18
									 		teammember_txt.y = teammember_switch.y


											   if radiobutton_id == "teammember" then

											    	print("67567656756∂2323 phone email not null")

																		
														MKRank_bg.isVisible = true
														MKRank.isVisible = true
														rankText_icon.isVisible = true

														--MKRank_bg.y = GeneratePasstext.y+GeneratePasstext.contentHeight+15
														MKRank_bg.y = teammember_txt.y+teammember_txt.contentHeight+15
														MKRank.y=MKRank_bg.y+5
														rankText_icon.y=MKRank_bg.y
														Comment_bg.y=MKRank_bg.y+MKRank_bg.height+Comment_bg.height/2 - 5
														Comment.y = Comment_bg.y
													
											    else

												 	MKRank_bg.isVisible = false
											 		MKRank.isVisible = false
											 		rankText_icon.isVisible = false

											 		Password_bg.y = textnotifytext.y+textnotifytext.height+12
													Password.y = textnotifytext.y+textnotifytext.height+15
													Password_bottom.y = Password.y+10


											 		Comment_bg.y=teammember_txt.y+teammember_txt.height+Comment_bg.height/2+12
													Comment.y = Comment_bg.y

										 	    end



									 		sumbitBtn.y = Comment.y+Comment.height/2+20
									 		sumbitBtn_lbl.y=sumbitBtn.y

									 		sumbitBtn.width = sumbitBtn_lbl.contentWidth+35
									 		sumbitBtn.x=W/2-sumbitBtn.contentWidth/2
									 		sumbitBtn_lbl.x = sumbitBtn.x+16

									--native.setKeyboardFocus(Password)

				elseif Phone.text ~= nil and Phone.text ~= "" and Phone.text:len() < 14 or not Utils.PhoneMasking(tostring(text)) then

					print("not valid phone")

					            SetError("*".."Phone number you have entered is invalid",Phone)

								textnotifybox.isVisible = false
								textnotifytext.isVisible = false

								 Password_bg.y = Phone_bg.y+Phone_bg.height+12
								 Password.y = Phone_bg.y+Phone_bg.height+9
								 Password_bottom.y = Password.y+10

								 PasswordHelptext.y= Password_bottom.y + 18
								 GeneratePasstext.y= PasswordHelptext.y + 20

						 		contact_switch.y = GeneratePasstext.y+GeneratePasstext.contentHeight/2+15
						 		contact_txt.y = contact_switch.y

						 		teammember_switch.y = GeneratePasstext.y+GeneratePasstext.contentHeight/2+15
						 		teammember_txt.y = teammember_switch.y


								    if radiobutton_id == "teammember" then

								    	print("67567656756∂2323")

										MKRank_bg.isVisible = true
										MKRank.isVisible = true
										rankText_icon.isVisible = true

										MKRank_bg.y = teammember_txt.y+teammember_txt.contentHeight+15
										MKRank.y=MKRank_bg.y+5
										rankText_icon.y=MKRank_bg.y
										Comment_bg.y=MKRank_bg.y+MKRank_bg.height+Comment_bg.height/2 - 5
										Comment.y = Comment_bg.y

									
								    else

									 	MKRank_bg.isVisible = false
								 		MKRank.isVisible = false
								 		rankText_icon.isVisible = false

								 		Password_bg.y = Phone_bg.y+Phone_bg.height+12
										Password.y = Phone_bg.y+Phone_bg.height+9
										Password_bottom.y = Password.y+10

								 		Comment_bg.y=teammember_txt.y+teammember_txt.height+Comment_bg.height/2+12
										Comment.y = Comment_bg.y

							 	    end

							 	
							 		sumbitBtn.y = Comment.y+Comment.height/2+20
							 		sumbitBtn_lbl.y=sumbitBtn.y

							 		sumbitBtn.width = sumbitBtn_lbl.contentWidth+35
							 		sumbitBtn.x=W/2-sumbitBtn.contentWidth/2
							 		sumbitBtn_lbl.x = sumbitBtn.x+16



								-- native.setKeyboardFocus(Password)

				elseif Phone.text == nil or Phone.text == "" or Phone.text:len() == 0 then

	                         print("length 0")

	                         textnotifybox.isVisible = false
	                         textnotifytext.isVisible = false

                             Password_bg.y = Phone_bg.y+Phone_bg.height+12
							 Password.y = Phone_bg.y+Phone_bg.height+12
							 Password_bottom.y = Password.y+10

							 PasswordHelptext.y= Password_bottom.y + 18
							 GeneratePasstext.y= PasswordHelptext.y + 20

					 		 contact_switch.y = GeneratePasstext.y+GeneratePasstext.contentHeight/2+15
					 		 contact_txt.y = contact_switch.y

					 		 teammember_switch.y = GeneratePasstext.y+GeneratePasstext.contentHeight/2+15
					 		 teammember_txt.y = teammember_switch.y


							    if radiobutton_id == "teammember" then

							    	print("67567656756∂2323")

									MKRank_bg.isVisible = true
									MKRank.isVisible = true
									rankText_icon.isVisible = true

									MKRank_bg.y = teammember_txt.y+teammember_txt.contentHeight+15
									MKRank.y=MKRank_bg.y+5
									rankText_icon.y=MKRank_bg.y
									Comment_bg.y=MKRank_bg.y+MKRank_bg.height+Comment_bg.height/2 - 5
									Comment.y = Comment_bg.y

								
							    else

								 	MKRank_bg.isVisible = false
							 		MKRank.isVisible = false
							 		rankText_icon.isVisible = false

							 		Password_bg.y = Phone_bg.y+Phone_bg.height+12
									Password.y = Phone_bg.y+Phone_bg.height+12
									Password_bottom.y = Password.y+10

							 		Comment_bg.y=teammember_txt.y+teammember_txt.height+Comment_bg.height/2+12
									Comment.y = Comment_bg.y

						 	    end

						 	
						 		sumbitBtn.y = Comment.y+Comment.height/2+20
						 		sumbitBtn_lbl.y=sumbitBtn.y

						 		sumbitBtn.width = sumbitBtn_lbl.contentWidth+35
						 		sumbitBtn.x=W/2-sumbitBtn.contentWidth/2
						 		sumbitBtn_lbl.x = sumbitBtn.x+16
			
				end

        end



--------------------------------- end of phone in ended ----------------------------------------------------------------------

						scrollTo( 0 )
						
						event.target:setSelection(event.target.text:len(),event.target.text:len())

						if isIos then


							if (event.target.id == "Phone") then

								 Background:addEventListener("touch",touchBg)

							elseif (event.target.id ~= "Phone") then

								 scrollTo(0)

								 Background:removeEventListener("touch",touchBg)

								 native.setKeyboardFocus(nil)
							end

						
						end


						if(event.target.id == "Comments") then

							scrollTo( 0 )
							
							native.setKeyboardFocus( nil )
							
						end


						
		elseif ( event.phase == "editing" ) then

						if event.target.id == "Comments" then

							if event.text:len() > 160 then

								event.target.text = event.target.text:sub(1,160)

							end

						end


						if(event.target.id == "First Name") then

							if event.text:len() > 50 then

								event.target.text = event.target.text:sub(1,50)

							end

						end


						if(event.target.id == "Last Name") then

							if event.text:len() > 50 then

								event.target.text = event.target.text:sub(1,50)

							end

						end



						if event.target.id == "Password" then

							if (event.newCharacters==" ") then

								if string.find( current_textField.text," " ) ~= nil then
									current_textField.text=string.gsub(current_textField.text," ","")
								end

							end

							if event.text:len() > 12 then

								event.target.text = event.target.text:sub(1,12)

							end

						end



						if(event.target.id == "Comments") then

							scrollTo( -80 )

							if (event.newCharacters=="\n") then
								native.setKeyboardFocus( nil )
							end

						elseif(event.target.id =="Phone") then

							local text = event.target.text


							if event.target.text:len() > event.startPosition then

								text = event.target.text:sub(1,event.startPosition )

							end


							local maskingValue = Utils.PhoneMasking(tostring(text))

							
							event.target.text=maskingValue

							event.target:setSelection(maskingValue:len()+1,maskingValue:len()+1)

						end
						
					end

					
				end



				
				local function onRowRender( event )

				local row = event.row

				local rowHeight = row.contentHeight
				local rowWidth = row.contentWidth

				local rowTitle = display.newText(row, List_array[row.index][1], 0, 0,280,38, nil, 14 )
				rowTitle:setFillColor( 0 )
				rowTitle.anchorX = 0
				rowTitle.x = 5
				rowTitle.y = rowHeight * 0.5+5

				row.rowValue = List_array[row.index][2]

				row.text=List_array[row.index][1]
			end



			local function onRowTouch( event )
				local phase = event.phase
				local row = event.target

				if( "press" == phase ) then

		--work

		MKRank.text =row.text

		if MKRank.text:len() > 36 then

			MKRank.text= MKRank.text:sub(1,36).."..."

		end


		mkRank_id = row.rowValue

	elseif ( "release" == phase ) then
		
		if rankGroup then

			rankGroup.isVisible=false

			FirstName.isVisible=true
			Name.isVisible=true
			Email.isVisible=true
			Phone.isVisible=true
			Password.isVisible=true
			Comment.isVisible=true

		end

	end
end




local sumbitBtnRelease = function( event )

	if event.phase == "began" then

		elseif event.phase == "ended" then
		local validation = true

		native.setKeyboardFocus(nil)

		if Name.text == "" or Name.text == Name.id or Name.text == PopupGroup.LastNameRequired then
			validation=false
			SetError("*"..RequestAccess.Name_error,Name)
		end


		if Email.text == "" or Email.text == Email.id or Email.text == PopupGroup.EmailIdRequired then
			validation=false
			SetError("*"..RequestAccess.Email_error,Email)
		else
			if not Utils.emailValidation(Email.text) then
				validation=false
				SetError("*"..RequestAccess.Email_error,Email)
			end
		end


		if Phone.text == "" or Phone.text == Phone.id or Phone.text:len() < 14 or Phone.text==PopupGroup.PhoneNumRequired then
			validation=false
			SetError("*"..RequestAccess.Phone_error,Phone)
		elseif Phone.text == "*Phone number you have entered is invalid" then
			validation=false
			SetError("*"..RequestAccess.Phone_error,Phone)
		end


		if Password.text == "" or Password.text == Password.id or Password.text == "*"..RequestAccess.Password_error then
			validation=false
			SetError("*"..RequestAccess.Password_error,Password)
			
		elseif Password.text:len() < 6 or Password.text == "*"..PopupGroup.PasswordHelptext then
			validation=false
			SetError("*"..PopupGroup.PasswordHelptext,Password)

		elseif Password.text == "*Password must be between 6 and 12 characters in length" then
			validation=false
			SetError("*"..RequestAccess.Password_error,Password)
			
		end


		if(validation == true) then
			
			RequestProcess()

		end

	end
	return true
end



local function rankTouch( event )
	if event.phase == "began" then

		display.getCurrentStage():setFocus( event.target )

	elseif event.phase == "moved" then
		local dx = math.abs( event.x - event.xStart )
		local dy = math.abs( event.y - event.yStart )
		if dx > 5 or dy > 5 then
			display.getCurrentStage():setFocus( nil )
			native.setKeyboardFocus(nil)
        	--scrollView:takeFocus( event )
        end
        elseif event.phase == "ended" then
        display.getCurrentStage():setFocus( nil )

        if event.target.id == "MKrank" then
        	native.setKeyboardFocus( nil )

        	if listFlag == false then
        		listFlag=true
        		if rankGroup then
        			rankGroup.isVisible=true
        			FirstName.isVisible=false
        			Name.isVisible=false
        			Email.isVisible=false
        			Phone.isVisible=false
        			Password.isVisible=false
        			Comment.isVisible=false

        		end

        	elseif listFlag == true then

        		rankGroup.isVisible=false

        		listFlag=false

        	end

        end
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

			scrollTo( 0 )

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



function getGeneratedPassword( response )

	generatedPassword = response

	if Password.text == PopupGroup.PasswordRequired or Password.text == "*"..PopupGroup.PasswordHelptext then

		Password.text = generatedPassword
		Password.size=14
		Password:setTextColor(0,0,0)

	else

		Password.text = generatedPassword
		Password.size=14
		Password:setTextColor(0,0,0)

	end

	if (Password.newCharacters==" ") then
				--Password.text = Password.text:sub(1,Password.text:len()-1)
				if string.find( Password.text," " ) ~= nil then

					Password.text=string.gsub(Password.text," ","")
				end

			end

		end



		local function OnPasswordGeneration(event)

			if event.phase == "began" then

				elseif event.phase == "ended" then

				Webservice.GeneratePassword(getGeneratedPassword)

			end

			return true

		end



		local function onSwitchPress( event )

			local switch = event.target

			if (switch.id == "email_checkbox" ) then

				isSentMail = tostring(switch.isOn)

			end

			if (switch.id == "text_checkbox" ) then

				isSentText = tostring(switch.isOn)
				
			end
			
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
	title_bg.x=W/2;title_bg.y = tabBar.y+tabBar.contentHeight-5
	title_bg:setFillColor( Utils.convertHexToRGB(color.tabbar) )

	title = display.newText(sceneGroup,FlapMenu.AddAccess,0,0,native.systemFont,18)
	title.anchorX = 0
	title.x=5;title.y = title_bg.y
	title:setFillColor(0)


		addNewAccess_scrollview = widget.newScrollView
				{
					top = RecentTab_Topvalue,
					left = 0,
					width = W,
					height =H-RecentTab_Topvalue,
					hideBackground = true,
					isBounceEnabled=false,
					bottomPadding = 10,
					listener = addevent_scrollListener,
		         }

		sceneGroup:insert(addNewAccess_scrollview)
	


-------------------------------------- first name -------------------------------------------

FirstName_bg = display.newRect(10, 0, W-20, 25)
FirstName_bg.y = title.y-title.contentHeight-15
FirstName_bg.anchorX = 0
FirstName_bg.alpha = 0.01
addNewAccess_scrollview:insert(FirstName_bg)

FirstName = native.newTextField(W/2+3, 0, W-20, 25)
FirstName.id="First Name"
FirstName.size=14	
FirstName.anchorX = 0
FirstName.y = title.y-title.contentHeight-15
FirstName.x = 15
FirstName.hasBackground = false
FirstName:setReturnKey( "next" )
FirstName.placeholder=RequestAccess.FirstName_placeholder
addNewAccess_scrollview:insert(FirstName)

FirstName_bottom = display.newImageRect(addNewAccess_scrollview,"res/assert/line-large.png",W-20,5)
FirstName_bottom.x=10
FirstName_bottom.anchorX = 0
FirstName_bottom.y= FirstName.y+13
addNewAccess_scrollview:insert(FirstName_bottom)

-------------------------------------Last name ----------------------------------------------

Name_bg = display.newRect(W/2, FirstName_bg.y+FirstName_bg.height+7, W-20, 25)
Name_bg.y = FirstName_bg.y+FirstName_bg.height+7
Name_bg.alpha = 0.01
addNewAccess_scrollview:insert(Name_bg)

Name_bottom = display.newImageRect(addNewAccess_scrollview,"res/assert/line-large.png",W-20,5)
Name_bottom.x=W/2
Name_bottom.y= FirstName_bg.y+FirstName_bg.height+18
addNewAccess_scrollview:insert(Name_bottom)

Name = native.newTextField( W/2+3, FirstName_bg.y+FirstName_bg.height+7, W-20, 25)
Name.id="Last Name"
Name.y = FirstName_bg.y+FirstName_bg.height+7
Name.size=14
Name.anchorX = 0
Name.x = 15
Name:setReturnKey( "next" )
Name.hasBackground = false	
Name.placeholder = RequestAccess.LastName_placeholder
addNewAccess_scrollview:insert(Name)


----------------------------------Email address---------------------------------
Email_bg = display.newRect(W/2, Name_bg.y+Name_bg.height+7, W-20, 25 )
Email_bg.alpha = 0.01
addNewAccess_scrollview:insert(Email_bg)

Email_bottom = display.newImageRect(addNewAccess_scrollview,"res/assert/line-large.png",W-20,5)
Email_bottom.x=W/2
Email_bottom.y= Name_bg.y+Name_bg.height+18
addNewAccess_scrollview:insert(Email_bottom)

Email = native.newTextField(W/2+3, Name_bg.y+Name_bg.height+7, W-20, 25 )
Email.id="Email"
Email.size=14
Email.anchorX = 0
Email.x = 15	
Email:setTextColor(0,0,0)
Email:setReturnKey( "next" )
Email.hasBackground = false
Email.placeholder=RequestAccess.EmailAddress_placeholder
addNewAccess_scrollview:insert(Email)


emailnotifybox = widget.newSwitch(
{
	left = 0,
	top = Email_bottom.y,
	style = "checkbox",
	id = "email_checkbox",
	initialSwitchState = true,
	onPress = onSwitchPress
	})
emailnotifybox.width= 20
emailnotifybox.height = 20
emailnotifybox.isVisible = false
emailnotifybox.anchorX= 0

addNewAccess_scrollview:insert(emailnotifybox)


emailnotifytext = display.newText(PopupGroup.emailnotifytext,0,0,native.systemFont,14)
emailnotifytext.x= 40
emailnotifytext.anchorX=0
emailnotifytext:setFillColor(0,0,0)
emailnotifytext.y= Email_bottom.y + 15
emailnotifytext.isVisible = false
addNewAccess_scrollview:insert(emailnotifytext)


-----------------------------------phone------------------------------------------
Phone_bg = display.newRect(W/2, emailnotifytext.y+emailnotifytext.height+7, W-20, 25)
Phone_bg.alpha = 0.01
Phone_bg.y = Email_bg.y+Email_bg.height+9
addNewAccess_scrollview:insert(Phone_bg)

Phone = native.newTextField(W/2+3, emailnotifytext.y+emailnotifytext.height+15, W-20, 25)
Phone.id="Phone"
Phone.size=14	
Phone.y = Email_bg.y+Email_bg.height+9
Phone.anchorX = 0
Phone.x = 15
		--Phone.text = "(111) 111 -1111"
		Phone:setReturnKey( "next" )
		Phone.hasBackground = false
		Phone.placeholder=RequestAccess.Phone_placeholder
		Phone.inputType = "number"
		addNewAccess_scrollview:insert(Phone)

		Phone_bottom = display.newImageRect(sceneGroup,"res/assert/line-large.png",W-20,5)
		Phone_bottom.x=W/2
		Phone_bottom.y= Phone.y+12
		addNewAccess_scrollview:insert(Phone_bottom)


		textnotifybox = widget.newSwitch(
		{
			left =  0,
			top = Phone_bottom.y,
			style = "checkbox",
			id = "text_checkbox",
			initialSwitchState = true,
			onPress = onSwitchPress
			})
		textnotifybox.width= 20
		textnotifybox.height = 20
		textnotifybox.isVisible = false
		textnotifybox.anchorX= 0

		addNewAccess_scrollview:insert(textnotifybox)

		textnotifytext = display.newText(PopupGroup.textnotifytext,0,0,native.systemFont,14)
		textnotifytext.x= 40
		textnotifytext:setFillColor(0,0,0)
		textnotifytext.anchorX=0
		textnotifytext.y= Phone_bottom.y + 15
		textnotifytext.isVisible = false
		addNewAccess_scrollview:insert(textnotifytext)



-----------------------------------Password---------------------------------------

Password_bg = display.newRect(W/2, textnotifytext.y+textnotifytext.contentHeight+12, W-20, 25)
Password_bg.alpha = 0.01
Password_bg.y = Phone_bg.y+Phone_bg.height+9
addNewAccess_scrollview:insert(Password_bg)

Password = native.newTextField(W/2+3, textnotifytext.y+textnotifytext.height+15, W-20, 25)
Password.id="Password"
Password.size=14	
Password.anchorX = 0
Password.x = 15
Password.y = Phone_bg.y+Phone_bg.height+9
		--Password.y = textnotifytext.y+textnotifytext.contentHeight+15
		Password:setReturnKey( "next" )
		Password.hasBackground = false
		Password.placeholder="Password"
		addNewAccess_scrollview:insert(Password)

		Password_bottom = display.newImageRect(sceneGroup,"res/assert/line-large.png",W-20,5)
		Password_bottom.x=W/2
		Password_bottom.y=Password.y+12
		addNewAccess_scrollview:insert(Password_bottom)

		PasswordHelptext = display.newText(PopupGroup.PasswordHelptext,0,0,W-30,0,native.systemFont,11)
		PasswordHelptext.x= 12
		PasswordHelptext.anchorX=0
		PasswordHelptext:setFillColor(0,0,0)
		PasswordHelptext.y= Password_bottom.y + 19
		addNewAccess_scrollview:insert(PasswordHelptext)

		GeneratePasstext = display.newText(PopupGroup.GeneratePasstext,0,0,W-30,0,native.systemFontBold,14.5)
		GeneratePasstext.x= W-145
		GeneratePasstext.anchorX = 0
		GeneratePasstext:setFillColor(0,0,0.5)
		GeneratePasstext.y= PasswordHelptext.y + 22
		addNewAccess_scrollview:insert(GeneratePasstext)
		GeneratePasstext:addEventListener("touch",OnPasswordGeneration)


------------------------- contact and teammember checkbox ------------------------------


	    contact_switch = widget.newSwitch {
	  		left = 25,
	  		top = 180,
	  		style = "radio",
	  		id = "contact",
	  		initialSwitchState = true,
	  		onPress = radioSwitchListener,
	  	}
	  	addNewAccess_scrollview:insert( contact_switch )

	  	contact_switch.width=20;contact_switch.height=20
	  	contact_switch.x = leftPadding
	  	contact_switch.anchorX = 0
	  	contact_switch.y = GeneratePasstext.y+GeneratePasstext.contentHeight/2 + 18

	  	contact_txt = display.newText( addNewAccess_scrollview,"Contacts",0,0,native.systemFont,14 )
	  	contact_txt.x = contact_switch.x+24;contact_txt.y = contact_switch.y
	  	contact_txt.anchorX = 0
	  	contact_txt:setFillColor( 0 )
	  	addNewAccess_scrollview:insert(contact_txt)
	  	

	  	
	  	teammember_switch = widget.newSwitch {
	  		left = 25,
	  		top = 180,
	  		style = "radio",
	  		id = "teammember",
	  		initialSwitchState = false,
	  		onPress = radioSwitchListener,
	  	}
	  	addNewAccess_scrollview:insert( teammember_switch )
	  	teammember_switch.width=20;teammember_switch.height=20
	  	teammember_switch.x = contact_txt.x+contact_txt.contentWidth+20
	  	teammember_switch.anchorX = 0
	  	teammember_switch.y = GeneratePasstext.y+GeneratePasstext.contentHeight/2 +18

	  	teammember_txt = display.newText( addNewAccess_scrollview,"Team Member",0,0,native.systemFont,14 )
	  	teammember_txt.x = teammember_switch.x+24;teammember_txt.y = teammember_switch.y
	  	teammember_txt.anchorX = 0
	  	teammember_txt:setFillColor( 0 )
	  	addNewAccess_scrollview:insert(teammember_txt)





----------------------------------------MK rank------------------------------------------

MKRank_bg = display.newRect(W/2, Phone_bg.y+Phone_bg.height+7, W-20, 25)
MKRank_bg:setStrokeColor( 0, 0, 0 , 0.3 )
MKRank_bg.y = teammember_txt.y+teammember_txt.contentHeight+15
MKRank_bg.strokeWidth = 1
MKRank_bg.isVisible = false
MKRank_bg:setFillColor( 0,0,0,0 )
MKRank_bg.id="MKrank"
addNewAccess_scrollview:insert(MKRank_bg)


MKRank = display.newText("",MKRank_bg.x+5,MKRank_bg.y,MKRank_bg.contentWidth,MKRank_bg.height,native.systemFont,14 )
MKRank.text = RequestAccess.MKRank_placeholder
MKRank.value = "-Select MK Rank-"
MKRank.id="MKrank"
MKRank.alpha=0.9
MKRank.isVisible = false
MKRank:setFillColor( Utils.convertHexToRGB(sp_commonLabel.textColor))
MKRank.y=MKRank_bg.y+5
MKRank.x = 18
MKRank.anchorX=0
addNewAccess_scrollview:insert(MKRank)

rankText_icon = display.newImageRect(addNewAccess_scrollview,"res/assert/arrow2.png",14,9 )
rankText_icon.x=MKRank_bg.x+MKRank_bg.contentWidth/2-15
rankText_icon.isVisible = false
rankText_icon.y=MKRank_bg.y
addNewAccess_scrollview:insert(rankText_icon)



----------------------comments --------------------------------------
Comment_bg = display.newRect( W/2, 0, W-20, 55)
--Comment_bg.y=MKRank_bg.y+MKRank_bg.height+Comment_bg.height/2 - 5
Comment_bg.y = teammember_txt.y + teammember_txt.contentHeight+Comment_bg.height/2 +5
Comment_bg:setFillColor( 0,0,0,0 )
Comment_bg:setStrokeColor( 0, 0, 0 , 0.3 )
Comment_bg.strokeWidth = 1
addNewAccess_scrollview:insert(Comment_bg)

Comment = native.newTextBox(W/2, Comment_bg.y, W-20, 55 )
Comment.placeholder=RequestAccess.Comment_placeholder
Comment.isEditable = true
Comment.size=14	
Comment.x = 16
Comment.anchorX=0
Comment.y = Comment_bg.y
Comment.id = "Comments"
Comment.hasBackground = false
Comment:setReturnKey( "next" )

addNewAccess_scrollview:insert(Comment)


---------------------submit button------------------------------------
sumbitBtn = display.newRect( 0,0,0,0 )
sumbitBtn.x=W/2;sumbitBtn.y = Comment.y+Comment.height/2+20
sumbitBtn.width=100
sumbitBtn.height=25
sumbitBtn.anchorX=0
sumbitBtn:setStrokeColor(0,0,0,0.7)
sumbitBtn:setFillColor(0,0,0,0.3)
sumbitBtn.cornerRadius = 2
addNewAccess_scrollview:insert(sumbitBtn)
sumbitBtn.id="Submit"

sumbitBtn_lbl = display.newText( addNewAccess_scrollview,PopupGroup.Add,0,0,native.systemFont,16 )
sumbitBtn_lbl.y=sumbitBtn.y
sumbitBtn_lbl.anchorX=0
sumbitBtn_lbl:setFillColor(0,0,0)
addNewAccess_scrollview:insert(sumbitBtn_lbl)

sumbitBtn.width = sumbitBtn_lbl.contentWidth+35
sumbitBtn.x=W/2-sumbitBtn.contentWidth/2
sumbitBtn_lbl.x = sumbitBtn.x+16



local options = {
	width = 25,
	height = 25,
	numFrames = 4,
	sheetContentWidth = 50,
	sheetContentHeight = 50
}

local submit_spinnerSingleSheet = graphics.newImageSheet( "res/assert/requestProcess.png", options )

submit_spinner = widget.newSpinner
{
	width = 25,
	height = 25,
	deltaAngle = 10,
	sheet = submit_spinnerSingleSheet,
	startFrame = 1,
	incrementEvery = 20
}


submit_spinner.isVisible=false
submit_spinner.x=sumbitBtn_lbl.x+sumbitBtn_lbl.contentWidth+15
submit_spinner.y=sumbitBtn.y

sumbitBtn:addEventListener( "touch", sumbitBtnRelease )

MainGroup:insert(sceneGroup)

end



function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then


		function GetListArray(response)


			for i=1,#response do

				List_array[1] = {}
				List_array[1][1] = "- Select MK Rank -"
				List_array[1][2] = "0"

				List_array[i+1] = {}
				List_array[i+1][1] = response[i].MkRankLevel
				List_array[i+1][2] = response[i].MkRankId

			end


  		---Listview---

  		rankTop_bg = display.newRect( rankGroup, MKRank_bg.x, H/2-10, MKRank_bg.contentWidth+1, 311 )
  		rankTop_bg:setFillColor(Utils.convertHexToRGB(color.tabBarColor))

  		rankTop = display.newRect(rankGroup,W/2,H/2-160,300,30)
  		rankTop:setFillColor(Utils.convertHexToRGB(color.tabBarColor))

  		rankText = display.newText(rankGroup,RequestAccess.MKRank_placeholder,0,0,native.systemFont,16)
  		rankText.x=rankTop.x;rankText.y=rankTop.y


  		rankClose = display.newImageRect(rankGroup,"res/assert/cancel.png",19,19)
  		rankClose.x=rankTop.x+rankTop.contentWidth/2-15;rankClose.y=rankTop.y
  		rankClose.id="close"

  		rankClose_bg = display.newRect(rankGroup,0,0,30,30)
  		rankClose_bg.x=rankTop.x+rankTop.contentWidth/2-15;rankClose_bg.y=rankTop.y
  		rankClose_bg.id="close"
  		rankClose_bg.alpha=0.01


  		rankTop:addEventListener("touch",rankToptouch)
  		rankText:addEventListener("touch",rankToptouch)
  		rankClose_bg:addEventListener("touch",rankToptouch)

  		

  		rankList = widget.newTableView
  		{
  			left = 0,
  			top = -50,
  			height = 290,
  			width = 300,
  			onRowRender = onRowRender,
  			onRowTouch = onRowTouch,
  		--hideBackground = true,
  		noLines=true,
  		hideScrollBar=true,
  		isBounceEnabled=false,

  	}

  	rankList.x=MKRank_bg.x
  	rankList.y=rankTop.y+rankTop.height/2
  	rankList.height = 290
  	rankList.width = MKRank_bg.contentWidth
  	rankList.anchorY=0
  	rankGroup.isVisible=false

  	rankGroup:insert(rankList)

  	for i = 1, #List_array do

  		rankList:insertRow{ rowHeight = 35,
  		rowColor = { default={ 1,1,1}, over={ 0, 0, 0, 0.1 } }

  	}
  end

end


Webservice.GET_LIST_OF_RANKS(GetListArray)


elseif phase == "did" then

	composer.removeHidden()

	menuBtn:addEventListener("touch",menuTouch)
	BgText:addEventListener("touch",menuTouch)

	MKRank_bg:addEventListener( "touch", rankTouch )
	MKRank:addEventListener( "touch", rankTouch )

	FirstName:addEventListener( "userInput", textfield )
	Name:addEventListener( "userInput", textfield )
	Email:addEventListener( "userInput", textfield )
	Phone:addEventListener( "userInput", textfield )
	Comment:addEventListener( "userInput", textfield )
	Password:addEventListener( "userInput", textfield )
	
	Background:addEventListener("touch",touchBg)
	Runtime:addEventListener( "key", onKeyEvent )

end	

MainGroup:insert(sceneGroup)

end


function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if event.phase == "will" then

		for j=MainGroup.numChildren, 1, -1 do 
			display.remove(MainGroup[MainGroup.numChildren])
			MainGroup[MainGroup.numChildren] = nil
		end

		MKRank_bg:removeEventListener( "touch", rankTouch )
		MKRank:removeEventListener( "touch", rankTouch ) 
		Runtime:removeEventListener( "key", onKeyEvent )

		if rankTop then rankTop:removeEventListener("touch",rankToptouch) end
		if rankText then rankText:removeEventListener("touch",rankToptouch) end 
		if rankClose_bg then rankClose_bg:removeEventListener("touch",rankToptouch) end


	elseif phase == "did" then

		menuBtn:removeEventListener("touch",menuTouch)
		BgText:removeEventListener("touch",menuTouch)

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
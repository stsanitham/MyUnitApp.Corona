----------------------------------------------------------------------------------
--
-- SingIn Screen
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local widget = require( "widget" )
local scene = composer.newScene()
local outerGroup = display.newGroup()
local Utility = require( "Utils.Utility" )
local style = require("res.value.style")
local path = system.pathForFile( "MyUnitBuzz.db", system.DocumentsDirectory )
local db = sqlite3.open( path )
require( "Webservice.ServiceManager" )


--------------- Initialization -------------------

local W = display.contentWidth;
local H = display.contentHeight
--Display object--
local Background,BgText

--Snack--
local Snack;

--TextField--
local Unitnumber_field,UserName,Password

--Button--
local forgettBtn,signinBtn,requestBtn

local BackFlag = false

--------------------------------------------------

openPage="signInPage"


-----------------Function-------------------------


	local function touchBg( event )
		if event.phase == "began" then

			elseif event.phase == "ended" then

			native.setKeyboardFocus(nil)

		end
		return true
	end

	local function SetError( displaystring, object )

									if object.id == "Password" then
										object.isSecure = false
									end
									object.text=displaystring
									object.size=9
									object.alpha=1
									object:setTextColor(1,0,0)


	end


	local function loginProcess( Request_response )

		if Request_response.RequestAccessStatus == 5 then

			local UnitNumberOrDirectorName,EmailAddess,PhoneNumber,Status,UserId,GoogleUsername,GoogleTokenSecret,GoogleUserId,AccessToken
			local FacebookUsername,FacebookAccessToken
			local TwitterUsername,TwitterToken,TwitterTokenSecret
			local profileImageUrl,ContactId
			local ContactDisplay,LanguageId,CountryId


			if Request_response.MyUnitBuzzContacts.EmailAddress then

				local EmailTxt = Request_response.MyUnitBuzzContacts.EmailAddress

					if EmailTxt:len() > 26 then

						EmailTxt= EmailTxt:sub(1,26).."..."

					end


			end

		

			if Request_response.UnitNumber then
				UnitNumberOrDirectorName = Request_response.UnitNumber
			else
				UnitNumberOrDirectorName=""
			end



			if Request_response.MyUnitBuzzContacts.EmailAddress then

				EmailAddess = Request_response.MyUnitBuzzContacts.EmailAddress
			else
				EmailAddess=""
			end


			if Request_response.MyUnitBuzzContacts.PhoneNumber then
				PhoneNumber = Request_response.MyUnitBuzzContacts.PhoneNumber
			else
				PhoneNumber=""
			end
			if Request_response.MyUnitBuzzContacts.Status then
				Status = Request_response.MyUnitBuzzContacts.Status
			else
				Status=""
			end
			if Request_response.UserAccess.UserId then
				UserId = Request_response.UserAccess.UserId
			else
				UserId=""
			end

			if Request_response.UserAccess.AccessToken then
				AccessToken = Request_response.UserAccess.AccessToken
			else
				AccessToken=""
			end


			if Request_response.UserAccess.ContactId then
				ContactId = Request_response.UserAccess.ContactId
			else
				ContactId=""
			end

		if Request_response.GoogleSettings ~= nil then

			if Request_response.GoogleSettings.GoogleUsername ~= nil then

				GoogleUsername = Request_response.GoogleSettings.GoogleUsername

			else
				GoogleUsername=""
			end

			if Request_response.GoogleSettings.GoogleToken ~= nil then
				GoogleToken = Request_response.GoogleSettings.GoogleToken
			else
				GoogleToken=""
			end

			if Request_response.GoogleSettings.GoogleTokenSecret ~= nil then
				GoogleTokenSecret = Request_response.GoogleSettings.GoogleTokenSecret
			else
				GoogleTokenSecret=""
			end

			if Request_response.GoogleSettings.GoogleUserId ~= nil then

				GoogleUserId = Request_response.GoogleSettings.GoogleUserId
			else
				GoogleUserId=""
			end

	else

		GoogleUsername=""
		GoogleToken=""
		GoogleTokenSecret=""
		GoogleUserId=""

	end
	if Request_response.FacebookSettings then


			if Request_response.FacebookSettings.FacebookUsername ~= nil then
				FacebookUsername = Request_response.FacebookSettings.FacebookUsername
			else
				FacebookUsername=""
			end

			if Request_response.FacebookSettings.FacebookAccessToken ~= nil then
				FacebookAccessToken = Request_response.FacebookSettings.FacebookAccessToken
			else
				FacebookAccessToken=""
			end
	else

		FacebookUsername=""
		FacebookAccessToken=""

	end

	if Request_response.TwitterSettings then
			if Request_response.TwitterSettings.TwitterUsername ~= nil then
				TwitterUsername = Request_response.TwitterSettings.TwitterUsername
			else
				TwitterUsername=""
			end

			if Request_response.TwitterSettings.TwitterToken ~= nil then
				TwitterToken = Request_response.TwitterSettings.TwitterToken
			else
				TwitterToken=""
			end

			if Request_response.TwitterSettings.TwitterTokenSecret ~= nil then
				TwitterTokenSecret = Request_response.TwitterSettings.TwitterTokenSecret
			else
				TwitterTokenSecret=""
			end

	else

		TwitterUsername=""
		TwitterToken=""
		TwitterTokenSecret=""

	end  

	if Request_response.MyUnitBuzzContacts then

		if Request_response.MyUnitBuzzContacts.IsOwner ~= nil then
				IsOwner = Request_response.MyUnitBuzzContacts.IsOwner
			else
				IsOwner=""
		end

		if Request_response.MyUnitBuzzUserSetting.TimeZone ~= nil then
				TimeZone = Request_response.MyUnitBuzzUserSetting.TimeZone
			else
				TimeZone=""
		end



			if Request_response.MyUnitBuzzContacts.ImagePath ~= nil then
				profileImageUrl = Request_response.MyUnitBuzzContacts.ImagePath
			else
				profileImageUrl=""
			end
	else
				profileImageUrl=""
	end

				if Request_response.MyUnitBuzzUserSetting.ContactDisplay ~= nil then
				ContactDisplay = Request_response.MyUnitBuzzUserSetting.ContactDisplay
			else
				ContactDisplay=""
			end

			if Request_response.MyUnitBuzzUserSetting.LanguageId ~= nil then
				LanguageId = Request_response.MyUnitBuzzUserSetting.LanguageId
			else
				LanguageId=""
			end

			if Request_response.MyUnitBuzzUserSetting.CountryId ~= nil then
				CountryId = Request_response.MyUnitBuzzUserSetting.CountryId
			else
				CountryId=""
			end
			

			FirstName = Request_response.MyUnitBuzzContacts.FirstName


			Director_Name = Request_response.MyUnitBuzzContacts.LastName
			
			

				if Request_response.MyUnitBuzzContacts.FirstName then

					Director_Name = Request_response.MyUnitBuzzContacts.FirstName.." "..Request_response.MyUnitBuzzContacts.LastName

				end

			

			Director_Name = string.gsub( Director_Name, "'", "''" )




			local tablesetup = [[DROP TABLE logindetails;]]
			db:exec( tablesetup )

					

			local UserContactId


			local tablefound=false
			db:exec([[select * from sqlite_master where name='pu_MyUnitBuzz_Message';]],
			function(...) tablefound=true return 0 end)


			if tablefound then 
					
						for row in db:nrows("SELECT * FROM pu_MyUnitBuzz_Message WHERE id=1") do
				
					UserContactId = row.Message_From
				

					end


					if tostring(ContactId) == tostring(UserContactId) then


					else

							local tablesetup_msg = [[DROP TABLE pu_MyUnitBuzz_Message;]]
							db:exec( tablesetup_msg )

					end

			end

		

		

			local tablesetup = [[CREATE TABLE IF NOT EXISTS logindetails (id INTEGER PRIMARY KEY autoincrement, UnitNumberOrDirector, EmailAddess, PhoneNumber, Status, UserId, GoogleUsername, GoogleToken, GoogleTokenSecret, GoogleUserId, FacebookUsername, FacebookAccessToken, TwitterUsername, TwitterToken, TwitterTokenSecret, ProfileImageUrl, AccessToken, ContactId, ContactDisplay, LanguageId, CountryId, MemberName, MemberEmail );]]
			db:exec( tablesetup )

			local tablesetup_chat = [[CREATE TABLE IF NOT EXISTS pu_MyUnitBuzz_Message (id INTEGER PRIMARY KEY autoincrement,User_Id,MyUnitBuzz_Message,Message_Status,Message_Date,Is_Deleted,Create_Time_Stamp,Update_Time_Stamp,Image_Path,Audio_Path,Video_Path,MyUnitBuzz_Long_Message,Message_From,Message_To,Message_Type,ToName,FromName,GroupName);]]
			db:exec( tablesetup_chat )



			local insertQuery = [[INSERT INTO logindetails VALUES (NULL, ']]..UnitNumberOrDirectorName..[[',']]..EmailAddess..[[',']]..PhoneNumber..[[',']]..Status..[[',']]..UserId..[[',']]..GoogleUsername..[[',']]..GoogleToken..[[',']]..GoogleTokenSecret..[[',']]..GoogleUserId..[[',']]..FacebookUsername..[[',']]..FacebookAccessToken..[[',']]..TwitterUsername..[[',']]..TwitterToken..[[',']]..TwitterTokenSecret..[[',']]..profileImageUrl..[[',']]..AccessToken..[[',']]..ContactId..[[',']]..ContactDisplay..[[',']]..LanguageId..[[',']]..CountryId..[[',']]..Director_Name..[[',']]..Request_response.MyUnitBuzzContacts.EmailAddress..[[');]]
			db:exec( insertQuery )

			local options = {
			effect = "slideLeft",
			time =500,
			}


		composer.gotoScene( "Controller.flapMenu" )

		elseif(Request_response.RequestAccessStatus == 6) then



			if Request_response.FailStatus == "NOUNITNUMBER" then

					--local alert = native.showAlert(  ForgotPassword.PageTitle,LoginPage.ErrorMessage, { "OK" } )

					SetError(LoginPage.setError_Unitnumber,Unitnumber_field)


			else


				local alert = native.showAlert( LoginPage.ErrorTitle,LoginPage.ErrorMessage, { CommonWords.ok } )

			end


		end
	end

	local function signInRequest(  )

		local Request_response

		--native.setKeyboardFocus(nil)


		function get_loginresponse(response)

			loginProcess(response)

		end


		local Device_OS = system.getInfo("platformName")
		local Unique_Id = system.getInfo("deviceID")
		--local Manufacturer = system.getInfo("targetAppStore")
		local Model = system.getInfo("model")
		local Version = system.getInfo("appVersionString")
		local GCM = GCMValue


		if AppName == "DirectorApp" then

			Webservice.LOGIN_ACCESS(Device_OS,Unique_Id,Model,Version,GCM,Unitnumber_value,UserName.text,Password.text,get_loginresponse)
		else
			Webservice.LOGIN_ACCESS(Device_OS,Unique_Id,Model,Version,GCM,Unitnumber_field.text,UserName.text,Password.text,get_loginresponse)
		end



	end


	local function textfield( event )

		if ( event.phase == "began" ) then

			event.target:setTextColor(color.black)

			current_textField = event.target;


			current_textField.size=14

			if "*" == event.target.text:sub(1,1) then
				event.target.text=""
			end

			if(current_textField.id == "Password") then

				
						current_textField.isSecure=true


			end


			elseif  event.phase == "ended"  then


			elseif event.phase == "submitted" then


				if current_textField.id == "Unit Number / Director name" then

					native.setKeyboardFocus( nil )

					native.setKeyboardFocus( UserName )

				elseif current_textField.id == "User name or Email address" then

					native.setKeyboardFocus( nil )

					native.setKeyboardFocus( Password )

				elseif current_textField.id == "Password" then

					native.setKeyboardFocus( nil )

				end



	

			elseif ( event.phase == "editing" ) then

				print("newCharacters : ",event.newCharacters )
		        print( "oldText : ",event.oldText )
		        print( "startPosition",event.startPosition )
		        print( "text : ",event.text )
		        print( "_______________________________________\n" )
				if current_textField.id == "Unit Number / Director name" then

						if event.text:len() > 50 then

						event.target.text = event.text:sub(1,50)

			

					end


				elseif current_textField.id == "User name or Email address" then

						if event.text:len() > 100 then

						event.target.text = event.text:sub(1,100)

			

					end



				elseif(current_textField.id == "Password") then

					

					if event.text:len() > 12 then

						event.target.text = event.text:sub(1,12)

			

					end

		

				end

						local dotFlag = string.find(event.text,"%.")

						if event.text == "" or dotFlag then
						
						end

						  	end

						  end





								


								local signinBtnRelease = function( event )

								if event.phase == "began" then
									display.getCurrentStage():setFocus( event.target )
									native.setKeyboardFocus(nil)
									elseif event.phase == "ended" then
									display.getCurrentStage():setFocus( nil )
									local validation = true



									if AppName ~= "DirectorApp" then
										if Unitnumber_field.text == "" or Unitnumber_field.text == Unitnumber_field.id or Unitnumber_field.text == LoginPage.setError_Unitnumber or Unitnumber_field.value == 0 then
											validation=false
											SetError(LoginPage.setError_Unitnumber,Unitnumber_field)
										end
									end


									if UserName.text == "" or UserName.text == UserName.id or UserName.text == LoginPage.setError_UserName then
										validation=false
										SetError(LoginPage.setError_UserName,UserName)

									else
										if not Utils.emailValidation(UserName.text) then
										validation=false
										SetError(LoginPage.setError_UserName,UserName)

									end

									end


									if Password.text == "" or Password.text == Password.id or Password.text == LoginPage.setError_Password or Password.text:len() < 6 then
										validation=false
										SetError(LoginPage.setError_Password,Password)

									end

									

									if(validation == true) then

										signInRequest()

									end


								end



								return true
							end

							local function touchAction( event )

								if event.phase == "began" then
									display.getCurrentStage():setFocus( event.target )

									elseif event.phase == "ended" then
									display.getCurrentStage():setFocus( nil )

								    	if event.target.id == "forget" then

												local options = 
												{
												    effect = "slideLeft",
												    time = 600,
												}

											    composer.gotoScene( "Controller.forgetPasswordPage", options )


										elseif event.target.id == "teammember_request" then

												local options = 
												{
												    effect = "slideLeft",
												    time = 600,
												}

												composer.gotoScene( "Controller.request_Access_Page", options)


										elseif event.target.id == "director_request" then

												local options = 
												{
												    effect = "slideLeft",
												    time = 600,
												    params = { introvalue = "introduction"}
											    }

												composer.gotoScene( "Controller.registrationScreen", options)

										end

									end

									return true
								end 

			local pushTest = function( event )
			    if notificationFlag == false then
			    	if Unitnumber_field then Unitnumber_field.isVisible=true end
					UserName.isVisible=true
					Password.isVisible=true
			    else
			    	if Unitnumber_field then Unitnumber_field.isVisible=false end
					UserName.isVisible=false
					Password.isVisible=false

			    end
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


------------------------------------------------------

function scene:create( event )

	local sceneGroup = self.view

	
	Background = display.newImageRect(sceneGroup,"res/assert/background.jpg",W,H)
	Background.x=W/2;Background.y=H/2

	signinBanner = display.newImageRect(sceneGroup,"res/assert/banner.png",W,175)
	signinBanner.x=W/2;signinBanner.y=signinBanner.contentHeight/2

	signinBanner_text = display.newImageRect(sceneGroup,"res/assert/signin-page-logo.png",278/2,62/2)
	signinBanner_text.x=signinBanner.x;signinBanner_text.y=signinBanner.y

	signin_lbl = display.newText(sceneGroup,LoginPage.Signin_Button,0,0,native.systemFont,sp_commonLabel.textSize)
	signin_lbl.x=signin_lbl.contentWidth/2+30;signin_lbl.y=signinBanner.y+signinBanner.contentHeight/2+30
	Utils.CssforTextView(signin_lbl,sp_header)	

	UnitNumber_bg = display.newRect(sceneGroup, W/2, H/2, W-60, EditBoxStyle.height)
	UnitNumber_seprator = display.newImageRect(sceneGroup,EditBoxStyle.background,8,UnitNumber_bg.contentHeight)
	UnitNumber_seprator.x=UnitNumber_bg.x-UnitNumber_bg.contentWidth/2+35;UnitNumber_seprator.y=UnitNumber_bg.y
	UnitNumber_drawLeft = display.newImageRect(sceneGroup,"res/assert/unite-number.png",24/1.5,24/1.5)
	UnitNumber_drawLeft.x=UnitNumber_bg.x-UnitNumber_bg.contentWidth/2+UnitNumber_drawLeft.contentWidth;UnitNumber_drawLeft.y=UnitNumber_bg.y



	UserName_bg = display.newRect(sceneGroup, W/2, UnitNumber_bg.y+UnitNumber_bg.contentHeight/2+24, UnitNumber_bg.contentWidth, UnitNumber_bg.contentHeight )

	if AppName == "DirectorApp" then
		UnitNumber_bg.isVisible=false
		UnitNumber_seprator.isVisible=false
		UnitNumber_drawLeft.isVisible=false

		UserName_bg.x=UnitNumber_bg.x;UserName_bg.y=UnitNumber_bg.y
	else
		Unitnumber_field = native.newTextField(0, 0, W-100, EditBoxStyle.height)
		Unitnumber_field.id = "Unit Number / Director name"
		Unitnumber_field.placeholder = LoginPage.Unitnumber_placeholder
		Unitnumber_field.anchorX=0
		Unitnumber_field.size=14	
		Unitnumber_field.value=""
		Unitnumber_field:setReturnKey( "next" )
		--Utils.CssforTextField(Unitnumber_field,sp_fieldValue)	


		Unitnumber_field.hasBackground = false
		Unitnumber_field.x=UnitNumber_bg.x-UnitNumber_bg.contentWidth/2+40;Unitnumber_field.y=UnitNumber_bg.y
		sceneGroup:insert(Unitnumber_field)
	end

	UserName_seprator = display.newImageRect(sceneGroup,EditBoxStyle.background,8,UserName_bg.contentHeight)
	UserName_seprator.x=UserName_bg.x-UserName_bg.contentWidth/2+35;UserName_seprator.y=UserName_bg.y
	UserName_drawLeft = display.newImageRect(sceneGroup,"res/assert/user.png",24/1.5,24/1.5)
	UserName_drawLeft.x=UserName_bg.x-UserName_bg.contentWidth/2+UserName_drawLeft.contentWidth;UserName_drawLeft.y=UserName_bg.y

	UserName =  native.newTextField(0, 0, W-100, EditBoxStyle.height)
	UserName.id = "User name or Email address"
	UserName.placeholder = LoginPage.UserName_placeholder
	UserName.anchorX=0
	UserName.size=14
	UserName.value=""
	UserName:setReturnKey( "next" )
	UserName.hasBackground = false
	UserName.inputType = "email"
	sceneGroup:insert(UserName)
	UserName.x=UserName_bg.x-UserName_bg.contentWidth/2+40;UserName.y=UserName_bg.y

	Password_bg = display.newRect(sceneGroup, W/2, UserName_bg.y+UserName_bg.contentHeight/2+24, UnitNumber_bg.contentWidth, UnitNumber_bg.contentHeight)
	Password_seprator = display.newImageRect(sceneGroup,EditBoxStyle.background,8,Password_bg.contentHeight)
	Password_seprator.x=Password_bg.x-Password_bg.contentWidth/2+35;Password_seprator.y=Password_bg.y
	Password_drawLeft = display.newImageRect(sceneGroup,"res/assert/psw.png",24/1.5,24/1.5)

	Password_drawLeft.x=Password_bg.x-Password_bg.contentWidth/2+Password_drawLeft.contentWidth;Password_drawLeft.y=Password_bg.y

	Password = native.newTextField(0, 0, W-100, EditBoxStyle.height)
	Password.id = "Password"
	Password.anchorX=0
	Password.size=14
	Password.value=""
	Password:setReturnKey( "done" )
	Password.placeholder = LoginPage.Password_placeholder
	--Password.isSecure = true;	
	Password.hasBackground = false
	sceneGroup:insert(Password)
	Password.x=Password_bg.x-Password_bg.contentWidth/2+40;Password.y=Password_bg.y

	forgettBtn = display.newText(sceneGroup,LoginPage.Forget_Button,0,0,native.systemFont,12)
	forgettBtn.x=Password_bg.x+Password_bg.contentWidth/2-forgettBtn.contentWidth/2-5
	forgettBtn.y=Password_bg.y+Password_bg.contentHeight/2+10
	Utils.CssforTextView(forgettBtn,sp_labelName_small)	

	forgettBtn.id="forget"
	forgettBtn_drawLeft	= display.newImageRect(sceneGroup,"res/assert/forgot-psw.png",14,14)
	forgettBtn_drawLeft.x=forgettBtn.x-forgettBtn.contentWidth/2-forgettBtn_drawLeft.contentWidth/2-3;forgettBtn_drawLeft.y=forgettBtn.y


	signinBtn = display.newRect(sceneGroup,0,0,W-60,35)
	signinBtn.x=W/2;signinBtn.y = forgettBtn.y+38
	signinBtn.width = W-60
	signinBtn:setFillColor( Utils.convertHexToRGB(sp_primarybutton.Background_Color) )
	signinBtn.id="signin"

	signinBtn_text = display.newText(sceneGroup,LoginPage.Signin_Button,0,0,native.systemFont,16)
	signinBtn_text.x=signinBtn.x;signinBtn_text.y=signinBtn.y
	Utils.CssforTextView(signinBtn_text,sp_primarybutton)	


	--[[ requestBtn = display.newText(sceneGroup,LoginPage.Request_Button,0,0,native.systemFont,14)
	-- requestBtn.x=W/2
	-- requestBtn.y=signinBtn.y+signinBtn.contentHeight/2+40
	-- requestBtn:setFillColor(Utils.convertHexToRGB(color.blue))
	-- requestBtn.id="request"

	-- requestBtn.isVisible=false]]





	-- TM_RequestBtn = display.newRect(sceneGroup,0,0,W-60,45)
	-- TM_RequestBtn.x=W/2-W/3+30;TM_RequestBtn.y = signinBtn.y+30
	-- TM_RequestBtn.width = 150
	-- TM_RequestBtn:setFillColor(0,0,0,0.4) 
	-- TM_RequestBtn.anchorY=0
	-- TM_RequestBtn.id="teammember_request"


	-- TM_Requesttext = display.newText(sceneGroup,RegistrationScreen.UnitMember,0,0,display.contentWidth - 30,0,native.systemFontBold,14)
	-- TM_Requesttext.x=TM_RequestBtn.x - TM_RequestBtn.contentWidth/2+10
	-- TM_Requesttext.width = display.contentWidth - 30
	-- TM_Requesttext.y=TM_RequestBtn.y+10
	-- TM_Requesttext:setFillColor(0)
	-- TM_Requesttext.anchorY=0
	-- TM_Requesttext.anchorX=0


	-- TM_RequestAccesstext = display.newText(sceneGroup,RegistrationScreen.RequestAccessText,0,0,display.contentWidth - 10,0,native.systemFont,13)
	-- TM_RequestAccesstext.x=TM_RequestBtn.x - TM_RequestBtn.contentWidth/2 +10
	-- TM_RequestAccesstext.y=TM_Requesttext.y+TM_Requesttext.contentHeight+7
	-- TM_RequestAccesstext.width = display.contentWidth - 10
	-- TM_RequestAccesstext:setFillColor(0)
	-- TM_RequestAccesstext.anchorY=0
	-- TM_RequestAccesstext.anchorX=0
	-- --Utils.CssforTextView(TM_Requesttext,sp_primarybutton)	

	-- TM_RequestBtn.height= TM_Requesttext.contentHeight+TM_RequestAccesstext.contentHeight+30


	-- Director_RequestBtn = display.newRect(sceneGroup,0,0,W-60,45)
	-- Director_RequestBtn.x=W/2+W/3-30;Director_RequestBtn.y = signinBtn.y+30
	-- Director_RequestBtn.width = 140
	-- Director_RequestBtn.anchorY = 0
	-- Director_RequestBtn:setFillColor(0,0,0,0.4) 
	-- Director_RequestBtn.id="director_request"

	-- Director_Requesttext = display.newText(sceneGroup,RegistrationScreen.Director,0,0,Director_RequestBtn.contentWidth-12,0,native.systemFontBold,14)
	-- Director_Requesttext.x=Director_RequestBtn.x - Director_RequestBtn.contentWidth/2+10
	-- Director_Requesttext.y=Director_RequestBtn.y+10
	-- Director_Requesttext.anchorY=0
	-- Director_Requesttext:setFillColor(0)
	-- Director_Requesttext.anchorX=0

	-- Director_Accounttext = display.newText(sceneGroup,RegistrationScreen.CreateAccount,0,0,display.contentWidth - 10,0,native.systemFont,13)
	-- Director_Accounttext.x=Director_RequestBtn.x - Director_RequestBtn.contentWidth/2 +10
	-- Director_Accounttext.y=Director_Requesttext.y+Director_Requesttext.contentHeight+7
	-- Director_Accounttext.width = display.contentWidth - 10
	-- Director_Accounttext:setFillColor(0)
	-- Director_Accounttext.anchorY=0
	-- Director_Accounttext.anchorX=0
	-- --Utils.CssforTextView(Director_Requesttext,sp_primarybutton)	

	-- Director_RequestBtn.height= Director_Requesttext.contentHeight+Director_Accounttext.contentHeight+30



	TM_Requesttext = display.newText(sceneGroup,RegistrationScreen.UnitMember,0,0,200,0,native.systemFontBold,12)
	TM_Requesttext.x = W/2-130
	TM_Requesttext.width = TM_Requesttext.contentWidth
	TM_Requesttext.y = signinBtn.y+35
	TM_Requesttext:setFillColor(0,0,1,0.7)
	TM_Requesttext.anchorY=0
	TM_Requesttext.anchorX=0


	TM_Requesticon	= display.newImageRect(sceneGroup,"res/assert/requestaccess_icon.png",14,14)
	TM_Requesticon.x=W/2-125
	TM_Requesticon.id="teammember_request"
	TM_Requesticon:setFillColor(0)
	TM_Requesticon.y=TM_Requesttext.y+TM_Requesttext.contentHeight+14


	TM_RequestAccesstext = display.newText(sceneGroup,RegistrationScreen.RequestAccessText,0,0,display.contentWidth - 10,0,native.systemFont,11)
	TM_RequestAccesstext.x=TM_Requesticon.x + 15
	TM_RequestAccesstext.y=TM_Requesttext.y+TM_Requesttext.contentHeight+8
	TM_RequestAccesstext.width = display.contentWidth - 10
	TM_RequestAccesstext:setFillColor(Utils.convertHexToRGB(sp_primarybutton.Background_Color) )
    TM_RequestAccesstext.id="teammember_request"
	TM_RequestAccesstext.anchorY=0
	TM_RequestAccesstext.anchorX=0
	--Utils.CssforTextView(TM_Requesttext,sp_primarybutton)	

	local line = display.newRect(sceneGroup,TM_Requesticon.x+TM_RequestAccesstext.x+5,TM_RequestAccesstext.y,TM_RequestAccesstext.width,0.6)
	      line.width = TM_Requesttext.contentWidth - 110
		  line.y=TM_RequestAccesstext.y+TM_RequestAccesstext.contentHeight-line.contentHeight+1
		  line:setFillColor(Utils.convertHexToRGB(sp_primarybutton.Background_Color))





	Director_Requesttext = display.newText(sceneGroup,RegistrationScreen.Director,0,0,200,0,native.systemFontBold,12)
	Director_Requesttext.x=W/2+20
	Director_Requesttext.width=Director_Requesttext.contentWidth
	Director_Requesttext.y = signinBtn.y+35
	Director_Requesttext.anchorY=0
	Director_Requesttext:setFillColor(0,0,1,0.7)
	Director_Requesttext.anchorX=0


	Director_Requesticon = display.newImageRect(sceneGroup,"res/assert/create-account.png",15,12)
	Director_Requesticon.x=W/2+25
	Director_Requesticon.id="director_request"
	Director_Requesticon:setFillColor(0)
	Director_Requesticon.y=Director_Requesttext.y+Director_Requesttext.contentHeight+14



	Director_Accounttext = display.newText(sceneGroup,RegistrationScreen.CreateAccount,0,0,display.contentWidth - 10,0,native.systemFont,11)
	Director_Accounttext.x=Director_Requesticon.x +15
	Director_Accounttext.y=Director_Requesttext.y+Director_Requesttext.contentHeight+8
	Director_Accounttext.width = display.contentWidth - 10
	Director_Accounttext.id="director_request"
	Director_Accounttext:setFillColor(Utils.convertHexToRGB(sp_primarybutton.Background_Color))
	Director_Accounttext.anchorY=0
	Director_Accounttext.anchorX=0
	--Utils.CssforTextView(Director_Requesttext,sp_primarybutton)


	local line1 = display.newRect(sceneGroup,Director_Requesticon.x+Director_Accounttext.x-140,Director_Accounttext.y,Director_Accounttext.width,0.6)
	      line1.width = Director_Accounttext.contentWidth-215
		  line1.y=Director_Accounttext.y+Director_Accounttext.contentHeight-line.contentHeight+1
		  line1:setFillColor(Utils.convertHexToRGB(sp_primarybutton.Background_Color))	





end

function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then

	
		if event.params then
			list_response_total = event.params.responseValue
		end

		local Version = system.getInfo( "appVersionString" )

		local path = system.pathForFile( "version.txt", system.DocumentsDirectory )


		local file, errorString = io.open( path, "w" )

		if not file then
		    -- Error occurred; output the cause
		    print( "File error: " .. errorString )
		else
		    -- Write data to file
		    file:write( Version )
		    -- Close the file handle
		    io.close( file )
		end

		file = nil

		ga.enterScene("SignIn")

		elseif phase == "did" then

			composer.removeHidden()

			if Unitnumber_field then Unitnumber_field:addEventListener( "userInput", textfield ) end

			UserName:addEventListener( "userInput", textfield )
			Password:addEventListener( "userInput", textfield )

			Background:addEventListener("touch",touchBg)
			forgettBtn:addEventListener("touch",touchAction)
			--TM_RequestBtn:addEventListener("touch",touchAction)
			TM_Requesticon:addEventListener("touch",touchAction)
			TM_RequestAccesstext:addEventListener("touch",touchAction)
			--Director_RequestBtn:addEventListener("touch",touchAction)

			Director_Requesticon:addEventListener("touch",touchAction)
			Director_Accounttext:addEventListener("touch",touchAction)

			signinBtn:addEventListener("touch",signinBtnRelease)
			signinBtn_text:addEventListener("touch",signinBtnRelease)

			Runtime:addEventListener( "enterFrame", pushTest )
            Runtime:addEventListener( "key", onKeyEvent )

		end	
	end


	function scene:hide( event )

		local sceneGroup = self.view
		local phase = event.phase

				if event.phase == "will" then


				elseif phase == "did" then

					Runtime:removeEventListener( "enterFrame", pushTest )
					Runtime:removeEventListener( "key", onKeyEvent )

					Background:removeEventListener("touch",touchBg)
					forgettBtn:removeEventListener("touch",touchAction)

					TM_Requesticon:removeEventListener("touch",touchAction)
					TM_RequestAccesstext:removeEventListener("touch",touchAction)
				--	TM_RequestBtn:removeEventListener("touch",touchAction)
				--	Director_RequestBtn:removeEventListener("touch",touchAction)

					Director_Requesticon:addEventListener("touch",touchAction)
					Director_Accounttext:addEventListener("touch",touchAction)

					signinBtn:removeEventListener("touch",signinBtnRelease)
					signinBtn_text:removeEventListener("touch",signinBtnRelease)


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



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
require( "Controller.genericAlert" )

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

local RequestBg,TM_Requesttext,TM_Requesticon,TM_RequestAccesstext,line
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
	object.size=10
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

		
		local tablesetup = [[DROP TABLE pu_MyUnitBuzz_Message;]]
		db:exec( tablesetup )
		

		local tablesetup = [[CREATE TABLE IF NOT EXISTS logindetails (id INTEGER PRIMARY KEY autoincrement, UnitNumberOrDirector, EmailAddess, PhoneNumber, Status, UserId, GoogleUsername, GoogleToken, GoogleTokenSecret, GoogleUserId, FacebookUsername, FacebookAccessToken, TwitterUsername, TwitterToken, TwitterTokenSecret, ProfileImageUrl, AccessToken, ContactId, ContactDisplay, LanguageId, CountryId, MemberName, MemberEmail );]]
		db:exec( tablesetup )

		local tablesetup_chat = [[CREATE TABLE IF NOT EXISTS pu_MyUnitBuzz_Message (id INTEGER PRIMARY KEY autoincrement,User_Id,MyUnitBuzz_Message,Message_Status,Message_Date,Is_Deleted,Create_Time_Stamp,Update_Time_Stamp,Image_Path,Audio_Path,Video_Path,MyUnitBuzz_Long_Message,Message_From,Message_To,Message_Type,FromName,ToName,GroupName,isBroadcastmsg);]]
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


					function onComplete(event)
						Unitnumber_field.isVisible=true
						UserName.isVisible=true
						Password.isVisible=true

					end

							if Unitnumber_field then Unitnumber_field.isVisible=false end
							UserName.isVisible=false
							Password.isVisible=false

					local option ={
							 {content=CommonWords.ok,positive=true},
						}
						genericAlert.createNew(LoginPage.ErrorTitle, LoginPage.ErrorMessage,option,onComplete)
				--	local alert = native.showAlert( LoginPage.ErrorTitle,LoginPage.ErrorMessage, { CommonWords.ok } )

				end


			end
		end

		local function signInRequest(  )

			local Request_response

		--native.setKeyboardFocus(nil)


		function get_loginresponse(response)

			isSendNow = response.IsSendNow

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

			print( event.target.size )

			if 9 == event.target.size then
				event.target.text=""
			end

			if "E" == event.target.text:sub(1,1) then
				event.target.text=""
			end

			if(current_textField.id == "Password") then

				current_textField.isSecure=true

			end

			current_textField.size=14


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

	
	Background = display.newRect(sceneGroup,0,0,W,H)
	Background.x=W/2;Background.y=H/2

	signinBanner = display.newRect(sceneGroup,0,0,W,H/4)
	signinBanner.x=W/2;signinBanner.y=signinBanner.contentHeight/2
	signinBanner:setFillColor( Utils.convertHexToRGB(color.primaryColor) )

	signinBanner_text = display.newImageRect(sceneGroup,"res/assert/signin-page-logo.png",278/1.5,62/1.5)
	signinBanner_text.x=signinBanner.x;signinBanner_text.y=signinBanner.y


	local signinUser = display.newImageRect(sceneGroup,"res/assert/prof_img.png",80,80)
	signinUser.x = signinBanner.x+80;signinUser.y=signinBanner.y+signinBanner.contentHeight/2


	signin_lbl = display.newText(sceneGroup,LoginPage.Signin_Button:upper(),0,0,"Roboto-Bold",sp_commonLabel.textSize)
	signin_lbl.x=signin_lbl.contentWidth/2+30;signin_lbl.y=signinBanner.y+signinBanner.contentHeight/2+30
	signin_lbl:setTextColor( Utils.convertHexToRGB(color.Black) )

	UnitNumber_bg = display.newLine(sceneGroup, W/2-120, H/2-30, W/2+120, H/2-30)
	UnitNumber_bg:setStrokeColor( Utils.convertHexToRGB(color.LtyGray) )
	UnitNumber_bg.strokeWidth = 1

	-- UnitNumber_seprator = display.newImageRect(sceneGroup,EditBoxStyle.background,8,UnitNumber_bg.contentHeight)
	-- UnitNumber_seprator.x=UnitNumber_bg.x-UnitNumber_bg.contentWidth/2+35;UnitNumber_seprator.y=UnitNumber_bg.y
	UnitNumber_drawLeft = display.newImageRect(sceneGroup,"res/assert/signin_img.png",74/2,63/2)
	UnitNumber_drawLeft.x=UnitNumber_bg.x+UnitNumber_drawLeft.contentWidth/2+15;UnitNumber_drawLeft.y=UnitNumber_bg.y-UnitNumber_drawLeft.contentHeight/2-5

	UnitNumber_mandarory = display.newText(sceneGroup,"*",0,0,"Roboto-Light",14)
	UnitNumber_mandarory.x=UnitNumber_drawLeft.x+UnitNumber_drawLeft.contentWidth/2+9;UnitNumber_mandarory.y=UnitNumber_bg.y-UnitNumber_mandarory.contentHeight/2-15
	UnitNumber_mandarory:setTextColor( 1, 0, 0 )

	UserName_bg = display.newLine(sceneGroup, W/2-120, H/2+20, W/2+120, H/2+20)
	UserName_bg:setStrokeColor( Utils.convertHexToRGB(color.LtyGray) )
	UserName_bg.strokeWidth = 1

	if AppName == "DirectorApp" then
		UnitNumber_bg.isVisible=false
		--UnitNumber_seprator.isVisible=false
		UnitNumber_drawLeft.isVisible=false

	else
		Unitnumber_field = native.newTextField(0, 0, W-144, EditBoxStyle.height+3)
		Unitnumber_field.id = "Unit Number / Director name"
		Unitnumber_field.placeholder = LoginPage.Unitnumber_placeholder
		Unitnumber_field.anchorX=0
		Unitnumber_field.value=""
		Unitnumber_field.font=native.newFont("Roboto-Light",14)
		Unitnumber_field:setReturnKey( "next" )
		--Utils.CssforTextField(Unitnumber_field,sp_fieldValue)	


		Unitnumber_field.hasBackground = false
		Unitnumber_field.x=UnitNumber_bg.x+63;Unitnumber_field.y=UnitNumber_bg.y-Unitnumber_field.contentHeight/2
		sceneGroup:insert(Unitnumber_field)
	end

	
	UserName_drawLeft = display.newImageRect(sceneGroup,"res/assert/gender_img.png",70/2,63/2)
	UserName_drawLeft.x=UserName_bg.x+UserName_drawLeft.contentWidth/2+15;UserName_drawLeft.y=UserName_bg.y-UserName_drawLeft.contentHeight/2-5

	UserName_mandarory = display.newText(sceneGroup,"*",0,0,"Roboto-Light",14)
	UserName_mandarory.x=UserName_drawLeft.x+UserName_drawLeft.contentWidth/2+10;UserName_mandarory.y=UserName_bg.y-UserName_mandarory.contentHeight/2-15
	UserName_mandarory:setTextColor( 1, 0, 0 )


	UserName =  native.newTextField(0, 0, W-140, EditBoxStyle.height+3)
	UserName.id = "User name or Email address"
	UserName.placeholder = LoginPage.UserName_placeholder
	UserName.anchorX=0
	UserName.value=""
	UserName.font=native.newFont("Roboto-Light",14)
	UserName:setReturnKey( "next" )
	UserName.hasBackground = false
	UserName.inputType = "email"
	sceneGroup:insert(UserName)
	UserName.x=UserName_bg.x+63;UserName.y=UserName_bg.y-UserName.contentHeight/2

	Password_bg = display.newLine(sceneGroup, W/2-120, H/2+70, W/2+120, H/2+70)
	Password_bg:setStrokeColor( Utils.convertHexToRGB(color.LtyGray) )
	Password_bg.strokeWidth = 1
	-- Password_seprator = display.newImageRect(sceneGroup,EditBoxStyle.background,8,Password_bg.contentHeight)
	-- Password_seprator.x=Password_bg.x-Password_bg.contentWidth/2+35;Password_seprator.y=Password_bg.y
	
	Password_drawLeft = display.newImageRect(sceneGroup,"res/assert/pass_img.png",62/2,63/2)
	Password_drawLeft.x=Password_bg.x+Password_drawLeft.contentWidth/2+15;Password_drawLeft.y=Password_bg.y-Password_drawLeft.contentHeight/2-5


	Password_mandarory = display.newText(sceneGroup,"*",0,0,"Roboto-Light",14)
	Password_mandarory.x=Password_drawLeft.x+Password_drawLeft.contentWidth/2+13;Password_mandarory.y=Password_bg.y-Password_mandarory.contentHeight/2-15
	Password_mandarory:setTextColor( 1, 0, 0 )

	Password = native.newTextField(0, 0, W-140, EditBoxStyle.height+3)
	Password.id = "Password"
	Password.anchorX=0
	Password.font=native.newFont("Roboto-Light",14)
	Password.value=""
	Password:setReturnKey( "done" )
	Password.placeholder = LoginPage.Password_placeholder
	--Password.isSecure = true;	
	Password.hasBackground = false
	sceneGroup:insert(Password)
	Password.x=Password_bg.x+62;Password.y=Password_bg.y-Password.contentHeight/2

	forgettBtn = display.newText(sceneGroup,LoginPage.Forget_Button,0,0,"Roboto-Regular",12)
	forgettBtn.x=Password_bg.x+Password_bg.contentWidth/2+forgettBtn.contentWidth/2+25
	forgettBtn.y=Password_bg.y+Password_bg.contentHeight+20
	Utils.CssforTextView(forgettBtn,sp_labelName_small)	

	forgettBtn.id="forget"
	forgettBtn_drawLeft	= display.newImageRect(sceneGroup,"res/assert/forgot-psw.png",20,18)
	forgettBtn_drawLeft.x=forgettBtn.x-forgettBtn.contentWidth/2-forgettBtn_drawLeft.contentWidth/2-6;forgettBtn_drawLeft.y=forgettBtn.y


	signinBtn = display.newImageRect(sceneGroup,"res/assert/white_btnbg.png",550/2,50)
	signinBtn.x=W/2;signinBtn.y = forgettBtn.y+45
	signinBtn:setFillColor( Utils.convertHexToRGB(color.primaryColor) )
	signinBtn.id="signin"


	signinBtn_text = display.newText(sceneGroup,LoginPage.Signin_Button,0,0,"Roboto-Regular",16)
	signinBtn_text.x=signinBtn.x;signinBtn_text.y=signinBtn.y
	Utils.CssforTextView(signinBtn_text,sp_primarybutton)	


	RequestBg = display.newRect( sceneGroup, W/2, H-70, W, 70 )
	RequestBg.anchorY=0
	RequestBg:setFillColor( Utils.convertHexToRGB(color.lightGray) )


	local seprateLine = display.newImageRect( sceneGroup, "res/assert/triangle_shape.png", 80/2, RequestBg.contentHeight)
	seprateLine.x = RequestBg.x;seprateLine.y=RequestBg.y+RequestBg.contentHeight/2

	TM_Requesttext = display.newText(sceneGroup,RegistrationScreen.UnitMember:upper( ),0,0,200,0,"Roboto-Bold",14)
	TM_Requesttext.x = 30
	TM_Requesttext.width = TM_Requesttext.contentWidth
	TM_Requesttext.y = RequestBg.y+10
	TM_Requesttext:setFillColor(Utils.convertHexToRGB(color.secondaryColor))
	TM_Requesttext.anchorY=0
	TM_Requesttext.anchorX=0
	TM_Requesttext.id="teammember_request"


	TM_Requesticon	= display.newImageRect(sceneGroup,"res/assert/setting_icon.png",30,30)
	TM_Requesticon.x=W/2-125
	TM_Requesticon.id="teammember_request"
	TM_Requesticon:setFillColor(0)
	TM_Requesticon.y=TM_Requesttext.y+TM_Requesttext.contentHeight+20


	TM_RequestAccesstext = display.newText(sceneGroup,RegistrationScreen.RequestAccessText,0,0,display.contentWidth - 10,0,"Roboto-Regular",11)
	TM_RequestAccesstext.x=TM_Requesticon.x + 25
	TM_RequestAccesstext.y=TM_Requesttext.y+TM_Requesttext.contentHeight+15
	TM_RequestAccesstext.width = display.contentWidth - 10
	TM_RequestAccesstext:setFillColor(Utils.convertHexToRGB(color.Black) )
	TM_RequestAccesstext.id="teammember_request"
	TM_RequestAccesstext.anchorY=0
	TM_RequestAccesstext.anchorX=0
	--Utils.CssforTextView(TM_Requesttext,sp_primarybutton)	


	Director_Requesttext = display.newText(sceneGroup,RegistrationScreen.Director:upper( ),0,0,200,0,"Roboto-Bold",14)
	Director_Requesttext.x=W/2+30
	Director_Requesttext.width=Director_Requesttext.contentWidth
	Director_Requesttext.y = RequestBg.y+10
	Director_Requesttext.anchorY=0
	Director_Requesttext:setFillColor(Utils.convertHexToRGB(color.secondaryColor))
	Director_Requesttext.anchorX=0
	Director_Requesttext.id="director_request"


	Director_Requesticon = display.newImageRect(sceneGroup,"res/assert/file_icon.png",45/2,60/2)
	Director_Requesticon.x=W/2+25
	Director_Requesticon.id="director_request"
	Director_Requesticon:setFillColor(0)
	Director_Requesticon.y=Director_Requesttext.y+Director_Requesttext.contentHeight+20



	Director_Accounttext = display.newText(sceneGroup,RegistrationScreen.CreateAccount,0,0,display.contentWidth - 10,0,"Roboto-Regular",11)
	Director_Accounttext.x=Director_Requesticon.x +25
	Director_Accounttext.y=Director_Requesttext.y+Director_Requesttext.contentHeight+15
	Director_Accounttext.width = display.contentWidth - 10
	Director_Accounttext.id="director_request"
	Director_Accounttext:setFillColor(Utils.convertHexToRGB(color.Black))
	Director_Accounttext.anchorY=0
	Director_Accounttext.anchorX=0
	--Utils.CssforTextView(Director_Requesttext,sp_primarybutton)



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

			TM_Requesttext:addEventListener("touch",touchAction)


			--Director_RequestBtn:addEventListener("touch",touchAction)

			Director_Requesticon:addEventListener("touch",touchAction)
			Director_Accounttext:addEventListener("touch",touchAction)
			Director_Requesttext:addEventListener("touch",touchAction)



			signinBtn:addEventListener("touch",signinBtnRelease)
			signinBtn_text:addEventListener("touch",signinBtnRelease)

			Runtime:addEventListener( "key", onKeyEvent )

		end	
	end


	function scene:hide( event )

		local sceneGroup = self.view
		local phase = event.phase

		if event.phase == "will" then


		elseif phase == "did" then

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



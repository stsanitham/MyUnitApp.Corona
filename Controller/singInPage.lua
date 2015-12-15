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
require("res.value.string")
local path = system.pathForFile( "MyUnitBuzz.db", system.DocumentsDirectory )
local db = sqlite3.open( path )
require( "Webservice.ServiceManager" )


--------------- Initialization -------------------

local W = display.contentWidth;
local H = display.contentHeight
local signInGroup = display.newGroup()
--Display object--
local Background,BgText

--Snack--
local Snack;

--TextField--
local Unitnumber_field,UserName,Password

--Button--
local forgettBtn,signinBtn,requestBtn,unitnumer_list


local list_response_total = {}
local list_response = {}
--------------------------------------------------

openPage="signInPage"


-----------------Function-------------------------


local function scrollListener( event )

	local phase = event.phase
	if ( phase == "began" ) then print( "Scroll view was touched" )
		elseif ( phase == "moved" ) then print( "Scroll view was moved" )

			native.setKeyboardFocus(nil)


			elseif ( phase == "ended" ) then print( "Scroll view was released" )
		end

		if ( event.limitReached ) then

		end

		return true
	end

	local function onRowRender_unitnumber( event )

    -- Get reference to the row group
    local row = event.row

    -- Cache the row "contentWidth" and "contentHeight" because the row bounds can change as children objects are added
    local rowHeight = row.contentHeight
    local rowWidth = row.contentWidth

    local rect = display.newRect(row,0,0,row.width,rowHeight)
    rect.anchorX = 0
    rect.x = 0
    rect.y=rowHeight * 0.5
    rect:setFillColor(0,0,0,0.1)
    rect.strokeWidth = 1
    rect:setStrokeColor( 0, 0, 0,0.3 ) 
    local rowTitle


    if (list_response[row.index]) ~= nil then
    	rowTitle = display.newText( row, list_response[row.index].DirectorName, 0, 0, nil, 14 )
    else
    	rowTitle = display.newText( row, "", 0, 0, nil, 14 )

    end
    rowTitle:setFillColor( 0 )

    -- Align the label left and vertically centered
    rowTitle.anchorX = 0
    rowTitle.x = 10
    rowTitle.y = rowHeight * 0.5

    row.name = rowTitle.text
    row.id = list_response[row.index].UnitNumber
end


local function onRowTouch_unitnumber( event )

	local phase = event.phase
	local row = event.target

	if( "press" == phase ) then


		elseif ( "release" == phase ) then
			unitnumer_list.alpha=0

			UserName.isVisible=true
			Password.isVisible=true
			native.setKeyboardFocus(nil)
			Unitnumber_field.text = row.name
			Unitnumber_field.value = row.id
			Unitnumber_field.alpha=1

		end
	end


	local function touchBg( event )
		if event.phase == "began" then

			elseif event.phase == "ended" then

			native.setKeyboardFocus(nil)

		end
		return true
	end

	local function loginProcess( Request_response )

		if Request_response.RequestAccessStatus == 5 then

			local UnitNumberOrDirectorName,EmailAddess,PhoneNumber,Status,UserId,GoogleUsername,GoogleTokenSecret,GoogleUserId,AccessToken
			local FacebookUsername,FacebookAccessToken
			local TwitterUsername,TwitterToken,TwitterTokenSecret
			local profileImageUrl,ContactId

			if Request_response.MyUnitBuzzContacts.FirstName then

			Director_Name = Request_response.MyUnitBuzzContacts.FirstName

			elseif Request_response.MyUnitBuzzContacts.LastName then

				Director_Name = Director_Name.." "..Request_response.MyUnitBuzzContacts.LastName
			end


			if Request_response.UnitNumberOrDirectorName then
				UnitNumberOrDirectorName = Request_response.UnitNumberOrDirectorName
			else
				UnitNumberOrDirectorName=""
			end



			if Request_response.MyUnitBuzzContacts.EmailAddess then
				EmailAddess = Request_response.MyUnitBuzzContacts.EmailAddess
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
			print("User id : "..Request_response.UserAccess.UserId)
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
				GoogleUsername = Request_response.GoogleSettings.GoogleUsername
			else
				GoogleUsername=""
			end

			if Request_response.GoogleSettings ~= nil then
				GoogleToken = Request_response.GoogleSettings.GoogleToken
			else
				GoogleToken=""
			end

			if Request_response.GoogleSettings ~= nil then
				GoogleTokenSecret = Request_response.GoogleSettings.GoogleTokenSecret
			else
				GoogleTokenSecret=""
			end

			if Request_response.GoogleSettings ~= nil then
				GoogleUserId = Request_response.GoogleSettings.GoogleUserId
			else
				GoogleUserId=""
			end

			if Request_response.FacebookSettings ~= nil then
				FacebookUsername = Request_response.FacebookSettings.FacebookUsername
			else
				FacebookUsername=""
			end

			if Request_response.FacebookSettings ~= nil then
				FacebookAccessToken = Request_response.FacebookSettings.FacebookAccessToken
			else
				FacebookAccessToken=""
			end

			if Request_response.TwitterSettings ~= nil then
				TwitterUsername = Request_response.TwitterSettings.TwitterUsername
			else
				TwitterUsername=""
			end

			if Request_response.TwitterSettings ~= nil then
				TwitterToken = Request_response.TwitterSettings.TwitterToken
			else
				TwitterToken=""
			end

			if Request_response.TwitterSettings ~= nil then
				TwitterTokenSecret = Request_response.TwitterSettings.TwitterTokenSecret
			else
				TwitterTokenSecret=""
			end

			if Request_response.Profile.profileImageUrl ~= nil then
				profileImageUrl = Request_response.Profile.profileImageUrl
			else
				profileImageUrl=""
			end


			local insertQuery = [[INSERT INTO logindetails VALUES (NULL, ']]..UnitNumberOrDirectorName..[[',']]..EmailAddess..[[',']]..PhoneNumber..[[',']]..Status..[[',']]..UserId..[[',']]..GoogleUsername..[[',']]..GoogleToken..[[',']]..GoogleTokenSecret..[[',']]..GoogleUserId..[[',']]..FacebookUsername..[[',']]..FacebookAccessToken..[[',']]..TwitterUsername..[[',']]..TwitterToken..[[',']]..TwitterTokenSecret..[[',']]..profileImageUrl..[[',']]..AccessToken..[[',']]..ContactId..[[');]]
			db:exec( insertQuery )

			local options = {
			effect = "slideLeft",
			time =500,
			params = { Flag = "Login",value = Request_response }

		}


		composer.gotoScene( "Controller.eventCalenderPage", options )
		elseif(Request_response.RequestAccessStatus == 6) then


			--Utils.SnackBar(Request_response.FailStatus)

			local alert = native.showAlert( "Login Failed","The details you have entered are incorrect. Check again and re-enter the valid details", { "OK" } )


		end
	end

	local function signInRequest(  )

		local Request_response

		--native.setKeyboardFocus(nil)



		function get_loginresponse(response)

			loginProcess(response)

		end

		if AppName == "DirectorApp" then

			Webservice.LOGIN_ACCESS(Unitnumber_value,UserName.text,Password.text,get_loginresponse)
		else
			Webservice.LOGIN_ACCESS(Unitnumber_field.value,UserName.text,Password.text,get_loginresponse)
		end



	end

	local function scroll(scroll_value)

		--signInGroup.y=signInGroup.y+scroll_value

	end

	local function textfield( event )

		if ( event.phase == "began" ) then

			print("forget request")

			event.target:setTextColor(color.black)

			current_textField = event.target;


			current_textField.size=16	

			if "*" == event.target.text:sub(1,1) then
				event.target.text=""
			end


			elseif ( event.phase == "ended" or event.phase == "submitted" ) then
			print("end")

			


			--[[unitnumer_list.alpha=0

			UserName.isVisible=true
			Password.isVisible=true]]

			elseif ( event.phase == "editing" ) then
				

				if(current_textField.id == "Password") then

					current_textField.isSecure=true

					if event.text:len() > 12 then

						event.target.text = event.text:sub(1,12)

					end

				elseif(current_textField.id == "Unit Number / Director name") then

					unitnumer_list.alpha=1

					UserName.isVisible=false
					Password.isVisible=false

					current_textField.value=0



					unitnumer_list:deleteAllRows()

					--list_response = list_response_total

					if #list_response ~= nil then
						for i = #list_response,1,-1 do
							table.remove(list_response,i)
						end
					end

					for i = 1,#list_response_total do

						print( list_response_total[i].DirectorName, event.text)

						if string.find( list_response_total[i].DirectorName:upper() , event.text:upper() ) ~= nil then

							list_response[#list_response+1] = list_response_total[i]

						end
						
					end

		

					print("editing "..#list_response )

					if list_response ~= nil then

						if #list_response == 0 then

							UserName.isVisible=true
							Password.isVisible=true

							elseif #list_response == 1 then

								Password.isVisible=true

							else
								UserName.isVisible=false
								Password.isVisible=false
							end

							for i = 1, #list_response do
						  	 		 -- Insert a row into the tableView
						  	 		 unitnumer_list:insertRow{}

						  	 		end
						  	 	end
						  	 end



						  	end

						  end





								local function SetError( displaystring, object )

									if object.id == "Password" then
										object.isSecure = false
									end
									object.text=displaystring
									object.size=11
									object.alpha=1
									object:setTextColor(1,0,0)


								end


								local signinBtnRelease = function( event )

								if event.phase == "began" then
									print("123")
									display.getCurrentStage():setFocus( event.target )
									native.setKeyboardFocus(nil)
									elseif event.phase == "ended" then
									display.getCurrentStage():setFocus( nil )
									local validation = true


									if AppName ~= "DirectorApp" then
										if Unitnumber_field.text == "" or Unitnumber_field.text == Unitnumber_field.id or Unitnumber_field.text == "* Enter the Unit Number" then
											validation=false
											SetError("* Enter the valid Unit number or Director Name",Unitnumber_field)
										end
									end

									if UserName.text == "" or UserName.text == UserName.id or UserName.text == "* Enter the Username" then
										validation=false
										SetError("* Enter the valid email address or Username",UserName)
									else


									end

									if Password.text == "" or Password.text == Password.id or Password.text == "* Enter the password" or Password.text:len() < 6 then
										validation=false
										SetError("* Enter the Password",Password)

									end

									

									if(validation == true) then
										print("sign in validation complete")

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

										composer.gotoScene( "Controller.forgetPasswordPage", "slideLeft", 800 )


										elseif event.target.id == "request" then

											composer.gotoScene( "Controller.request_Access_Page", "slideLeft", 800 )

										end

									end

									return true
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

	signin_lbl = display.newText(sceneGroup,"Sign In",0,0,native.systemFont,sp_commonLabel.textSize)
	signin_lbl.x=signin_lbl.contentWidth/2+30;signin_lbl.y=signinBanner.y+signinBanner.contentHeight/2+30
	signin_lbl:setFillColor( Utility.convertHexToRGB(sp_commonLabel.textColor))
	

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
		Unitnumber_field.placeholder = "Unit Number / Director Name"
		Unitnumber_field.anchorX=0
		Unitnumber_field.value=""
		Unitnumber_field.hasBackground = false
		Unitnumber_field.x=UnitNumber_bg.x-UnitNumber_bg.contentWidth/2+45;Unitnumber_field.y=UnitNumber_bg.y
		sceneGroup:insert(Unitnumber_field)
	end

	UserName_seprator = display.newImageRect(sceneGroup,EditBoxStyle.background,8,UserName_bg.contentHeight)
	UserName_seprator.x=UserName_bg.x-UserName_bg.contentWidth/2+35;UserName_seprator.y=UserName_bg.y
	UserName_drawLeft = display.newImageRect(sceneGroup,"res/assert/user.png",24/1.5,24/1.5)
	UserName_drawLeft.x=UserName_bg.x-UserName_bg.contentWidth/2+UserName_drawLeft.contentWidth;UserName_drawLeft.y=UserName_bg.y

	UserName =  native.newTextField(0, 0, W-100, EditBoxStyle.height)
	UserName.id = "User name or Email address"
	UserName.placeholder = "Email Address"
	UserName.anchorX=0
	UserName.value=""
	UserName.hasBackground = false
	sceneGroup:insert(UserName)
	UserName.x=UserName_bg.x-UserName_bg.contentWidth/2+45;UserName.y=UserName_bg.y

	Password_bg = display.newRect(sceneGroup, W/2, UserName_bg.y+UserName_bg.contentHeight/2+24, UnitNumber_bg.contentWidth, UnitNumber_bg.contentHeight)
	Password_seprator = display.newImageRect(sceneGroup,EditBoxStyle.background,8,Password_bg.contentHeight)
	Password_seprator.x=Password_bg.x-Password_bg.contentWidth/2+35;Password_seprator.y=Password_bg.y
	Password_drawLeft = display.newImageRect(sceneGroup,"res/assert/psw.png",24/1.5,24/1.5)
	Password_drawLeft.x=Password_bg.x-Password_bg.contentWidth/2+Password_drawLeft.contentWidth;Password_drawLeft.y=Password_bg.y

	Password = native.newTextField(0, 0, W-100, EditBoxStyle.height)
	Password.id = "Password"
	Password.anchorX=0
	Password.value=""
	Password.placeholder = "Password"
	Password.isSecure = true;	
	Password.hasBackground = false
	sceneGroup:insert(Password)
	Password.x=Password_bg.x-Password_bg.contentWidth/2+45;Password.y=Password_bg.y

	forgettBtn = display.newText(sceneGroup,LoginPage.Forget_Button,0,0,native.systemFont,12)
	forgettBtn.x=Password_bg.x+Password_bg.contentWidth/2-forgettBtn.contentWidth/2-5
	forgettBtn.y=Password_bg.y+Password_bg.contentHeight/2+10
	forgettBtn:setFillColor(Utils.convertHexToRGB(color.tabBarColor))
	forgettBtn.id="forget"
	forgettBtn_drawLeft	= display.newImageRect(sceneGroup,"res/assert/forgot-psw.png",14,14)
	forgettBtn_drawLeft.x=forgettBtn.x-forgettBtn.contentWidth/2-forgettBtn_drawLeft.contentWidth/2-3;forgettBtn_drawLeft.y=forgettBtn.y


	signinBtn = display.newImageRect(sceneGroup,"res/assert/signin.jpg",W-60,35)
	signinBtn.x=W/2;signinBtn.y = forgettBtn.y+38
	signinBtn.width = W-60
	sceneGroup:insert(signinBtn)
	signinBtn.id="signin"
	signinBtn_text = display.newText(sceneGroup,LoginPage.Signin_Button,0,0,native.systemFont,16)
	signinBtn_text.x=signinBtn.x;signinBtn_text.y=signinBtn.y


	requestBtn = display.newText(sceneGroup,LoginPage.Request_Button,0,0,native.systemFont,16)
	requestBtn.x=W/2
	requestBtn.y=signinBtn.y+signinBtn.contentHeight/2+20
	requestBtn:setFillColor(Utils.convertHexToRGB(color.blue))
	requestBtn.id="request"
	requestBtn.isVisible=false

	signInGroup:insert(sceneGroup)
end

function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then

		unitnumer_list = widget.newTableView
		{
		left = 0,
		top = 0,
		height = 130,
		width = UnitNumber_bg.contentWidth,
		noLines = true,
		isBounceEnabled=false,
		onRowRender = onRowRender_unitnumber,
		onRowTouch = onRowTouch_unitnumber,
			--backgroundColor = { 0.8, 0.8, 0.8 },
			hideBackground=true,
			listener = scrollListener
		}

		unitnumer_list.x=UnitNumber_bg.x
		unitnumer_list.y=UnitNumber_bg.y+UnitNumber_bg.contentHeight/2
		unitnumer_list.anchorY=0

		unitnumer_list.alpha=0

		UserName.isVisible=true
		Password.isVisible=true

		--[[Unitnumber_field.text = "12345"
		Unitnumber_field.value="12345"
		UserName.text = "malarkodi.sellamuthu@w3magix.com"
		Password.text = "123123"
		Password.value = "123123"]]


		function get_GetSearchByUnitNumberOrDirectorName(response)

			list_response_total = response

			
		end

		Webservice.GET_SEARCHBY_UnitNumberOrDirectorName("1",get_GetSearchByUnitNumberOrDirectorName)

		elseif phase == "did" then


			--[[Unitnumber_field:addEventListener("touch",textListener)
			UserName:addEventListener("touch",textListener)
			Password:addEventListener("touch",textListener)]]

			composer.removeHidden()
			Unitnumber_field:addEventListener( "userInput", textfield )
			UserName:addEventListener( "userInput", textfield )
			Password:addEventListener( "userInput", textfield )

			Background:addEventListener("touch",touchBg)

			forgettBtn:addEventListener("touch",touchAction)
			requestBtn:addEventListener("touch",touchAction)

			signinBtn:addEventListener("touch",signinBtnRelease)
			signinBtn_text:addEventListener("touch",signinBtnRelease)

		end	
		signInGroup:insert(sceneGroup)
	end

	function scene:hide( event )

		local sceneGroup = self.view
		local phase = event.phase

		if event.phase == "will" then

				--if defalut ~= nil then defalut:removeSelf();defalut=nil end

				elseif phase == "did" then

					

					forgettBtn:removeEventListener("touch",touchAction)
					requestBtn:removeEventListener("touch",touchAction)


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
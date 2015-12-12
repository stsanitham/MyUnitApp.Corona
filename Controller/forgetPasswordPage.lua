----------------------------------------------------------------------------------
--
-- instagram Screen
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local widget = require( "widget" )


local stringValue = require( "res.value.string" )
local Utility = require( "Utils.Utility" )
require( "Webservice.ServiceManager" )

local unitNumGroup = display.newGroup()
local userNameGroup = display.newGroup()


--------------- Initialization -------------------

local W = display.contentWidth;H= display.contentHeight

local Background,BgText,unitnumer_list

local backBtn,UnitnumberField,UserName

openPage="eventCalenderPage"



--------------------------------------------------


-----------------Function-------------------------

local function bgTouch( event )
	if event.phase == "began" then
			display.getCurrentStage():setFocus( event.target )
	elseif event.phase == "ended" then
			display.getCurrentStage():setFocus( nil )
			native.setKeyboardFocus(nil)
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

			native.setKeyboardFocus(nil)
			UnitnumberField.text = row.name
			UnitnumberField.value = row.id

		end
	end

local function textfield( event )

		if ( event.phase == "began" ) then

			print("forget request")

			event.target.text=""
			event.target:setTextColor(color.black)


			elseif ( event.phase == "ended" or event.phase == "submitted" ) then
		
			if(current_textField.id ~= "Unit Number / Director name") then
				current_textField.text=event.target.text
			end
			current_textField:setFillColor(0)
			current_textField.size=16
			if current_textField.text == "" then
				current_textField.alpha = 0.5
				current_textField.text = current_textField.id
			end


        		unitnumer_list.alpha=0
        		event.target:removeSelf();event.target = nil

        		elseif ( event.phase == "editing" ) then

        			if(current_textField.id == "Unit Number / Director name") then

        				unitnumer_list.alpha=1

        				function get_GetSearchByUnitNumberOrDirectorName(response)

        					list_response = response
        					unitnumer_list:deleteAllRows()

	        				if list_response ~= nil then

	        					for i = 1, #list_response do
						  	 		 -- Insert a row into the tableView
						  	 		 unitnumer_list:insertRow{}

						  	 	end
						  	 end
        				end

        				
        				list_response = Webservice.GET_SEARCHBY_UnitNumberOrDirectorName(event.text,get_GetSearchByUnitNumberOrDirectorName)
     		


					  	end

					  end
					end




local function textfieldListener( event )



	if ( event.phase == "began" ) then
		native.setKeyboardFocus(nil)
		target = event.target

		display.getCurrentStage():setFocus( event.target )


		elseif ( event.phase == "ended" ) then
		display.getCurrentStage():setFocus( nil )
		current_textField = target[2]
		target[2].text=""			
	
			defalut = native.newTextField(target[1].x+20,target[1].y,target[1].contentWidth-40,target[1].contentHeight )
			defalut.hasBackground = false
			defalut:resizeFontToFitHeight()

		if target[2].alpha >= 1 then
			target[2]:setFillColor(0)
			target[2].size=16
		else
			target[2].alpha=1
		end

		native.setKeyboardFocus( defalut )

		defalut:addEventListener( "userInput", textfield )


	end
	return true
end 


local function forgotAction( Request_response )
	if Request_response == "SUCCESS" then

		Utils.SnackBar(Request_response)

		composer.gotoScene( "Controller.singInPage", "slideRight",500 )


		elseif Request_response == "NOUNITNUMBER" then

			Utils.SnackBar("Invalid Unit Number")

		else

			Utils.SnackBar(Request_response)

		end

	end
	local function signInRequest(  )

		local Request_response

		native.setKeyboardFocus(nil)

		function get_forgotpassword( response )
			Request_response = response
			forgotAction(Request_response)
		end

		if AppName == "DirectorApp" then

			Webservice.Forget_Password(Unitnumber_value,UserName.text,get_forgotpassword)

		else
			print("unit number : "..UnitnumberField.value)
			Webservice.Forget_Password(UnitnumberField.value,UserName.text,get_forgotpassword)

		end

	end

	local function SetError( displaystring, object )

		if object.id == "password" then
			object.isSecure = false
		end
		object.text=displaystring
		object.size=10
		object:setTextColor(1,0,0)


	end

	local function backAction( event )
		if event.phase == "began" then
			display.getCurrentStage():setFocus( event.target )
			elseif event.phase == "ended" then
			display.getCurrentStage():setFocus( nil )


			composer.gotoScene( "Controller.singInPage", "slideRight",500 )
		end

		return true

	end

	local signinBtnRelease = function( event )

	if event.phase == "began" then
		print("123")
		display.getCurrentStage():setFocus( event.target )
		elseif event.phase == "ended" then
		display.getCurrentStage():setFocus( nil )
		local validation = true
		native.setKeyboardFocus(nil)

		if AppName ~= "DirectorApp" then
			if UnitnumberField.text == "" then
				validation=false
				SetError("* Enter the Unit Number",UnitnumberField)
			end
		end

		if UserName.text == "" then
			validation=false
			SetError("* Enter the email",UserName)
		else

			if not Utils.emailValidation(UserName.text) then
				validation=false
				SetError("* Enter the valid email",UserName)

			end
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

		if event.target.id == "request" then

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

	tabBar = display.newRect(sceneGroup,W/2,0,W,40)
	tabBar.y=tabBar.contentHeight/2
	tabBar:setFillColor(Utils.convertHexToRGB(color.tabBarColor))

	BgText = display.newImageRect(sceneGroup,"res/assert/logo-flash-screen.png",398/4,81/4)
	BgText.x=5;BgText.y=20
	BgText.anchorX=0

	backBtn = display.newImageRect(sceneGroup,"res/assert/right-arrow(gray-).png",15/2,30/2)
	backBtn.x=20;backBtn.y=tabBar.y+tabBar.contentHeight+5
	backBtn.xScale=-1

	page_title = display.newText(sceneGroup,"Forget Password",0,0,native.systemFont,18)
	page_title.x=backBtn.x+18;page_title.y=backBtn.y
	page_title.anchorX=0
	page_title:setFillColor(Utils.convertHexToRGB(color.Black))


	sceneGroup:insert(unitNumGroup)
	sceneGroup:insert(userNameGroup)


	UnitNumber_bg = display.newRect(unitNumGroup, W/2, H/2-120, W-60, EditBoxStyle.height)
	UnitNumber_seprator = display.newImageRect(sceneGroup,EditBoxStyle.background,8,UnitNumber_bg.contentHeight)
	UnitNumber_seprator.x=UnitNumber_bg.x-UnitNumber_bg.contentWidth/2+35;UnitNumber_seprator.y=UnitNumber_bg.y
	UnitNumber_drawLeft = display.newImageRect(sceneGroup,"res/assert/unite-number.png",24/1.5,24/1.5)
	UnitNumber_drawLeft.x=UnitNumber_bg.x-UnitNumber_bg.contentWidth/2+UnitNumber_drawLeft.contentWidth;UnitNumber_drawLeft.y=UnitNumber_bg.y



	UserName_bg = display.newRect(userNameGroup, W/2, UnitNumber_bg.y+UnitNumber_bg.contentHeight/2+24, UnitNumber_bg.contentWidth, UnitNumber_bg.contentHeight )

	if AppName == "DirectorApp" then
		UnitNumber_bg.isVisible=false
		UnitNumber_seprator.isVisible=false
		UnitNumber_drawLeft.isVisible=false



		UserName_bg.x=UnitNumber_bg.x;UserName_bg.y=UnitNumber_bg.y
	else

		UnitnumberField = display.newText(unitNumGroup,"Unit Number / Director name",0,0,native.systemFont,14 )
		UnitnumberField.id = "Unit Number / Director name"
		UnitnumberField.anchorX=0
		UnitnumberField.value=""
		UnitnumberField.alpha=0.5
		UnitnumberField:setFillColor(0,0,0)
		UnitnumberField.x=UnitNumber_bg.x-UnitNumber_bg.contentWidth/2+45;UnitnumberField.y=UnitNumber_bg.y

	end
	

	UserName_seprator = display.newImageRect(sceneGroup,EditBoxStyle.background,8,UserName_bg.contentHeight)
	UserName_seprator.x=UserName_bg.x-UserName_bg.contentWidth/2+38;UserName_seprator.y=UserName_bg.y
	UserName_drawLeft = display.newImageRect(sceneGroup,"res/assert/user.png",24/1.5,24/1.5)
	UserName_drawLeft.x=UserName_bg.x-UserName_bg.contentWidth/2+UserName_drawLeft.contentWidth;UserName_drawLeft.y=UserName_bg.y

	UserName = display.newText(userNameGroup,"Username / Email",0,0,native.systemFont,14 )
	UserName.id = "Username / Email"
	UserName.anchorX=0
	UserName.value=""
	UserName.alpha=0.5
	UserName:setFillColor(0,0,0)
	UserName.x=UserName_bg.x-UserName_bg.contentWidth/2+45;UserName.y=UserName_bg.y

	

	signinBtn = display.newImageRect(sceneGroup,"res/assert/signin.jpg",W-60,35)
	signinBtn.x=W/2;signinBtn.y = UserName_bg.y+48
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

	MainGroup:insert(sceneGroup)

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


		elseif phase == "did" then

			composer.removeHidden(true)
			Background:addEventListener("touch",bgTouch)
			unitNumGroup:addEventListener("touch",textfieldListener)
			userNameGroup:addEventListener("touch",textfieldListener)
			requestBtn:addEventListener("touch",touchAction)
			signinBtn:addEventListener("touch",signinBtnRelease)
			signinBtn_text:addEventListener("touch",signinBtnRelease)
			backBtn:addEventListener("touch",backAction)
			page_title:addEventListener("touch",backAction)
			composer.removeHidden()

		end	

		MainGroup:insert(sceneGroup)

	end

	function scene:hide( event )

		local sceneGroup = self.view
		local phase = event.phase

		if event.phase == "will" then

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
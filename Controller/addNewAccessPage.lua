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


--------------- Initialization -------------------

local W = display.contentWidth;
local H= display.contentHeight

--Display Object
local Background,BgText,tabBar,backBtn,page_title,MKRank,rankText_icon,sumbitBtn_lbl

--EditText Background
local FirstName_bg,Name_bg,Email_bg,Phone_bg,MKRank_bg,Comment_bg,DirectorName_bg,DirectorEmail_bg

--EditText
local FirstName,Name,Email,Phone,UnitNumber,Comment,DirectorName,DirectorEmail

--Spinner
local submit_spinner

openPage="addNewAccessPage"

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
		object:setTextColor(1,0,0)

	end



	function onComplete(event)

	   if "clicked"==event.action then

	   	print("on complete action done [[[[[[980890890890]]]]]]")

	   end

	 end



local function RequestProcess()

	print( "here !!!!!" )


	if  submit_spinner.isVisible == false then

			submit_spinner.isVisible=true
			sumbitBtn.width = sumbitBtn.contentWidth+30
			sumbitBtn_lbl.x=sumbitBtn.x-sumbitBtn.contentWidth/2+15
			submit_spinner.x=sumbitBtn_lbl.x+sumbitBtn_lbl.contentWidth+15

			sumbitBtn.width = sumbitBtn_lbl.contentWidth+40
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
			submit_spinner.x=sumbitBtn_lbl.x+sumbitBtn_lbl.contentWidth+15
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
			emailnotifybox.isOn = true
			textnotifybox.isOn = true

				if Request_response == "SUCCESS" then

				  alert = native.showAlert( PopupGroup.AddNewAccess , PopupGroup.AddNewAccessText , { CommonWords.ok }, onComplete )

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


		Webservice.REQUEST_ACCESS(openPage,"WEB",isSentMailvalue,isSentTextvalue,"","",FirstName.text,Name.text,Email.text,Phone.text,"",Password.text,mkRank_id,Comment.text,get_requestAccess)
	
	end

end




	function onCompletionEvent(event)

            if "clicked"==event.action then

            	native.setKeyboardFocus(Email)

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
							scrollTo( -100 )
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


							if Email.text ~= nil and Email.text~= "" and Utils.emailValidation(Email.text) then

								for row in db:nrows("SELECT * FROM logindetails WHERE id=1") do

								ContactId = row.ContactId

								end

							Webservice.CheckExistsRequestStatus(ContactId,Email.text,getemailexistresponse)

							native.setKeyboardFocus(nil)

						    elseif Email.text ~= nil and Email.text ~= "" and not Utils.emailValidation(Email.text) then

                                 SetError("* ".."Enter the valid Email",Email)

                                 native.setKeyboardFocus(nil)

                            else

							native.setKeyboardFocus(Phone)

						    end

						elseif(event.target.id == "Phone") then

							native.setKeyboardFocus(Password)


						elseif(event.target.id == "Password") then

							native.setKeyboardFocus(Comment)

						end

					end

					scrollTo( 0 )


			elseif event.phase == "ended" then

				scrollTo( 0 )
					
					event.target:setSelection(event.target.text:len(),event.target.text:len())

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

				scrollTo( -100 )

				if (event.newCharacters=="\n") then
					native.setKeyboardFocus( nil )
				end

			elseif(event.target.id =="Phone") then

				local text = event.target.text

				if event.target.text:len() > event.startPosition then

					text = event.target.text:sub(1,event.startPosition )

				end


				local maskingValue =Utils.PhoneMasking(tostring(text))

								
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
		SetError("* "..RequestAccess.Name_error,Name)
		end


		if Email.text == "" or Email.text == Email.id or Email.text == PopupGroup.EmailIdRequired then
			validation=false
		SetError("* "..RequestAccess.Email_error,Email)
		else
		if not Utils.emailValidation(Email.text) then
		validation=false
		SetError("* "..RequestAccess.Email_error,Email)
		end
		end


		if Phone.text == "" or Phone.text == Phone.id or Phone.text:len() < 15 or Phone.text==PopupGroup.PhoneNumRequired then
			validation=false
			SetError("* "..RequestAccess.Phone_error,Phone)
		end


		if Password.text == "" or Password.text == Password.id or Password.text:len() > 12 or Password.text == LoginPage.setError_Password then
			validation=false
			SetError("* "..RequestAccess.Password_error,Password)
		end
		if Password.text:len() < 6 then
			validation=false
			SetError("* "..PopupGroup.PasswordHelptext,Password)
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

        		Utils.SnackBar("Press again to exit")

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

         	if Password.text == PopupGroup.PasswordRequired or Password.text == PopupGroup.PasswordLimit then

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

	title = display.newText(sceneGroup,PopupGroup.AddNewAccess,0,0,native.systemFont,18)
	title.anchorX = 0
	title.x=5;title.y = title_bg.y
	title:setFillColor(0)
	


-------------------------------------- first name -------------------------------------------

		FirstName_bg = display.newRect(W/2, 0, W-20, 25)
		FirstName_bg.y = title.y+title.contentHeight+15
		FirstName_bg.alpha = 0.01
		sceneGroup:insert(FirstName_bg)

		FirstName = native.newTextField(W/2+3, 0, W-20, 25)
		FirstName.id="First Name"
		FirstName.size=14	
		FirstName.anchorX = 0
		FirstName.x = 10
		FirstName.y = title.y+title.contentHeight+15
		FirstName.hasBackground = false
		FirstName:setReturnKey( "next" )
		FirstName.placeholder=RequestAccess.FirstName_placeholder
		sceneGroup:insert(FirstName)

		FirstName_bottom = display.newImageRect(sceneGroup,"res/assert/line-large.png",W-20,5)
		FirstName_bottom.x=W/2
		FirstName_bottom.y= FirstName.y+11

-------------------------------------Last name ----------------------------------------------

		Name_bg = display.newRect(W/2, FirstName_bg.y+FirstName_bg.height+7, W-20, 25)
		Name_bg.y = FirstName_bg.y+FirstName_bg.height+7
		Name_bg.alpha = 0.01
		sceneGroup:insert(Name_bg)

		Name_bottom = display.newImageRect(sceneGroup,"res/assert/line-large.png",W-20,5)
		Name_bottom.x=W/2
		Name_bottom.y= FirstName_bg.y+FirstName_bg.height+16

		Name = native.newTextField( W/2+3, FirstName_bg.y+FirstName_bg.height+7, W-20, 25)
		Name.id="Last Name"
		Name.y = FirstName_bg.y+FirstName_bg.height+7
		Name.size=14
		Name.anchorX = 0
		Name.x = 10
		Name:setReturnKey( "next" )
		Name.hasBackground = false	
		Name.placeholder = RequestAccess.LastName_placeholder
		sceneGroup:insert(Name)


----------------------------------Email address---------------------------------
		Email_bg = display.newRect(W/2, Name_bg.y+Name_bg.height+7, W-20, 25 )
		Email_bg.alpha = 0.01
		sceneGroup:insert(Email_bg)

		Email_bottom = display.newImageRect(sceneGroup,"res/assert/line-large.png",W-20,5)
		Email_bottom.x=W/2
		Email_bottom.y= Name_bg.y+Name_bg.height+16

		Email = native.newTextField(W/2+3, Name_bg.y+Name_bg.height+7, W-20, 25 )
		Email.id="Email"
		Email.size=14
		Email.anchorX = 0
		Email.x = 10	
		Email:setTextColor(0,0,0)
		Email:setReturnKey( "next" )
		Email.hasBackground = false
		Email.placeholder=RequestAccess.EmailAddress_placeholder
		sceneGroup:insert(Email)


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
	    emailnotifybox.anchorX= 0

	    sceneGroup:insert(emailnotifybox)


	    emailnotifytext = display.newText(PopupGroup.emailnotifytext,0,0,native.systemFont,14)
	    emailnotifytext.x= 40
	    emailnotifytext.anchorX=0
	    emailnotifytext:setFillColor(0,0,0)
	    emailnotifytext.y= Email_bottom.y + 15
	    sceneGroup:insert(emailnotifytext)


-----------------------------------phone------------------------------------------
		Phone_bg = display.newRect(W/2, emailnotifytext.y+emailnotifytext.height+7, W-20, 25)
		Phone_bg.alpha = 0.01
		sceneGroup:insert(Phone_bg)

		Phone = native.newTextField(W/2+3, emailnotifytext.y+emailnotifytext.height+15, W-20, 25)
		Phone.id="Phone"
		Phone.size=14	
		Phone.anchorX = 0
		Phone.x = 10
		--Phone.text = "(111) 111 -1111"
		Phone:setReturnKey( "next" )
		Phone.hasBackground = false
		Phone.placeholder=RequestAccess.Phone_placeholder
		Phone.inputType = "number"
		sceneGroup:insert(Phone)

		Phone_bottom = display.newImageRect(sceneGroup,"res/assert/line-large.png",W-20,5)
		Phone_bottom.x=W/2
		Phone_bottom.y= Phone.y+10


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
		textnotifybox.anchorX= 0

		sceneGroup:insert(textnotifybox)

		textnotifytext = display.newText(PopupGroup.textnotifytext,0,0,native.systemFont,14)
		textnotifytext.x= 40
		textnotifytext:setFillColor(0,0,0)
		textnotifytext.anchorX=0
		textnotifytext.y= Phone_bottom.y + 15
		sceneGroup:insert(textnotifytext)



-----------------------------------Password---------------------------------------
		
		Password_bg = display.newRect(W/2, textnotifytext.y+textnotifytext.contentHeight+12, W-20, 25)
		Password_bg.alpha = 0.01
		sceneGroup:insert(Password_bg)

		Password = native.newTextField(W/2+3, textnotifytext.y+textnotifytext.height+15, W-20, 25)
		Password.id="Password"
		Password.size=14	
		Password.anchorX = 0
		Password.x = 10
		Password.y = textnotifytext.y+textnotifytext.contentHeight+15
		Password:setReturnKey( "next" )
		Password.hasBackground = false
		Password.placeholder="Password"
		sceneGroup:insert(Password)

		Password_bottom = display.newImageRect(sceneGroup,"res/assert/line-large.png",W-20,5)
		Password_bottom.x=W/2
		Password_bottom.y=Password.y+10

		PasswordHelptext = display.newText(PopupGroup.PasswordHelptext,0,0,W-30,0,native.systemFont,11)
		PasswordHelptext.x= 12
		PasswordHelptext.anchorX=0
		PasswordHelptext:setFillColor(0,0,0)
		PasswordHelptext.y= Password_bottom.y + 18
		sceneGroup:insert(PasswordHelptext)

		GeneratePasstext = display.newText(PopupGroup.GeneratePasstext,0,0,W-30,0,native.systemFontBold,14.5)
		GeneratePasstext.x= W-145
		GeneratePasstext.anchorX = 0
		GeneratePasstext:setFillColor(0,0,0.5)
		GeneratePasstext.y= PasswordHelptext.y + 20
		sceneGroup:insert(GeneratePasstext)
		GeneratePasstext:addEventListener("touch",OnPasswordGeneration)


-----------------------------------MK rank----------------------------------------

		MKRank_bg = display.newRect(W/2, Phone_bg.y+Phone_bg.height+7, W-20, 25)
		MKRank_bg:setStrokeColor( 0, 0, 0 , 0.3 )
		MKRank_bg.y = GeneratePasstext.y+GeneratePasstext.contentHeight+15
		MKRank_bg.strokeWidth = 1
		MKRank_bg:setFillColor( 0,0,0,0 )
		MKRank_bg.id="MKrank"
		sceneGroup:insert(MKRank_bg)


		MKRank = display.newText("",MKRank_bg.x+5,MKRank_bg.y,MKRank_bg.contentWidth,MKRank_bg.height,native.systemFont,14 )
		MKRank.text = RequestAccess.MKRank_placeholder
		MKRank.value = "-Select MK Rank-"
		MKRank.id="MKrank"
		MKRank.alpha=0.9
		MKRank:setFillColor( Utils.convertHexToRGB(sp_commonLabel.textColor))
		MKRank.y=MKRank_bg.y+5
		MKRank.x = 15
	    MKRank.anchorX=0
	    sceneGroup:insert(MKRank)

  		rankText_icon = display.newImageRect(sceneGroup,"res/assert/arrow2.png",14,9 )
  		rankText_icon.x=MKRank_bg.x+MKRank_bg.contentWidth/2-15
  		rankText_icon.y=MKRank_bg.y



----------------------comments --------------------------------------
	Comment_bg = display.newRect( W/2, 0, W-20, 60)
	Comment_bg.y=MKRank_bg.y+MKRank_bg.height+Comment_bg.height/2 - 5
	Comment_bg:setFillColor( 0,0,0,0 )
	Comment_bg:setStrokeColor( 0, 0, 0 , 0.3 )
    Comment_bg.strokeWidth = 1
	sceneGroup:insert(Comment_bg)

	Comment = native.newTextBox(W/2, Comment_bg.y, W-20, 60 )
	Comment.placeholder=RequestAccess.Comment_placeholder
	Comment.isEditable = true
	Comment.size=14	
	Comment.x = 10
	Comment.anchorX=0
	Comment.y = Comment_bg.y
	Comment.id = "Comments"
	Comment.hasBackground = false
	Comment:setReturnKey( "next" )
	
	sceneGroup:insert(Comment)


---------------------submit button------------------------------------
	sumbitBtn = display.newRect( 0,0,0,0 )
	sumbitBtn.x=W/2;sumbitBtn.y = Comment.y+Comment.height/2+20
	sumbitBtn.width=100
	sumbitBtn.height=25
	sumbitBtn.anchorX=0
	sumbitBtn:setStrokeColor(0,0,0,0.7)
  	sumbitBtn:setFillColor(0,0,0,0.3)
  	sumbitBtn.cornerRadius = 2
	sceneGroup:insert(sumbitBtn)
	sumbitBtn.id="Submit"

	sumbitBtn_lbl = display.newText( sceneGroup,PopupGroup.Add,0,0,native.systemFont,16 )
	sumbitBtn_lbl.y=sumbitBtn.y
	sumbitBtn_lbl.anchorX=0
	sumbitBtn_lbl:setFillColor(0,0,0)

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

				List_array[i] = {}
				List_array[i][1] = response[i].MkRankLevel
				List_array[i][2] = response[i].MkRankId

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
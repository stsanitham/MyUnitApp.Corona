----------------------------------------------------------------------------------
--
-- event Calender Screen
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local widget = require( "widget" )

local scene = composer.newScene()

local stringValue = require( "res.value.string" )
require( "Utils.Utility" )
require( "Parser.GET_LIST_OF_RANKS" )
require( "Parser.REQUEST_ACCESS" )

local style = require("res.value.style")
local string = require("res.value.string")
local List_array = {}
local mkRank_id=0
local current_textField,defalut

local nameGroup = display.newGroup()
local emailGroup = display.newGroup()
local phoneGroup = display.newGroup()
local unitnumberGroup = display.newGroup()
local commentGroup = display.newGroup()

--malarkodi.sellamuthu@w3magix.com

--------------- Initialization -------------------

local W = display.contentWidth;
local H= display.contentHeight

local Background,BgText

--Button
local sumbitBtn,scrollView

--TexView
local PageTitle;

--List
local rankList

--Edittext
local PageTitle,Name_bg,Name,Email_bg,Email,Phone_bg,Phone,UnitNumber_bg,UnitNumber,MKRank_bg,MKRank,Comment_bg,Comment

openPage="request_Access_Page"

local listFlag= false


--------------------------------------------------


-----------------Function-------------------------



local function SetError( displaystring, object )

	if object.id == "password" then
		object.isSecure = false
	end
	object.text=displaystring
	object.size=10
	object:setTextColor(1,0,0)


end

local function scroll(scroll_value)

	scrollView:scrollToPosition
	{

	y = scroll_value,
	time = 400,
}

end

local function RequestProcess()

	if AppName == "DirectorApp" then
		Request_response = REQUEST_ACCESS(Name.text,Email.text,Phone.text,Unitnumber_value,mkRank_id,Comment.text)
	else
		Request_response = REQUEST_ACCESS(Name.text,Email.text,Phone.text,UnitNumber.text,mkRank_id,Comment.text)
	end

	if Request_response == "REQUEST"  then

		local options = {
		effect = "slideRight",
		time =300,
		params = { Snack = "Already Requested"}
	}

	composer.gotoScene( "Controller.singInPage", options )

			--Utils.SnackBar("Already Requested")

			elseif Request_response == "FIRSTREQUEST" then

				local options = {
				effect = "slideRight",
				time =300,
				params = { Snack = "Sussefully request send"}
			}

			

			composer.gotoScene( "Controller.singInPage", options )

			--Utils.SnackBar("Sussefully request send")

			elseif Request_response == "OPEN" then

				local options = {
				effect = "slideRight",
				time =300,
				params = { Snack = "Already your email registerd"}
			}


			composer.gotoScene( "Controller.singInPage", options )

			elseif Request_response == "GRANT" then

				local options = {
				effect = "slideRight",
				time =300,
				params = { Snack = "Already your email registerd"}
			}


			composer.gotoScene( "Controller.singInPage", options )

			--Utils.SnackBar("Already your email registerd")

			elseif Request_response == "NOUNITNUMBER" then

				SetError("* Enter the Valid UnitNumber",UnitNumber)

			end


		end


		local function textfield( event )

			if ( event.phase == "began" ) then

				print("key request")

				event.target.text=""
				event.target:setTextColor(color.black)


				elseif ( event.phase == "ended" or event.phase == "submitted" ) then
				print("id :"..current_textField.id)

				scroll(0)
				current_textField.text=event.target.text
				current_textField:setFillColor(0)
				current_textField.size=16
				if current_textField.text == "" then
					current_textField.alpha = 0.5
					current_textField.text = current_textField.id
				end
        		--event.target:removeEventListener( "userInput", textfield )
        		event.target:removeSelf();event.target = nil

        		elseif ( event.phase == "editing" ) then
        			print("editing")
        		end
        	end


        	local function textfieldListener( event )



        		if ( event.phase == "began" ) then
        			native.setKeyboardFocus(nil)
        			target = event.target

        			display.getCurrentStage():setFocus( event.target )

			--current_textField=nil

			elseif event.phase == "moved" then
				local dx = math.abs( event.x - event.xStart )
				local dy = math.abs( event.y - event.yStart )
	        -- if finger drags button more than 5 pixels, pass focus to scrollView
	        if dx > 5 or dy > 5 then
	        	print("enter")
	        	display.getCurrentStage():setFocus( nil )
	        	native.setKeyboardFocus(nil)
	        	scrollView:takeFocus( event )
	        end

	        elseif ( event.phase == "ended" ) then
	        print(target[2].id)
	        display.getCurrentStage():setFocus( nil )
	        current_textField = target[2]
	        target[2].text=""			
	        if target[2].id == "Comments" then
	        	defalut = native.newTextBox(target[1].x,target[1].y,target[1].contentWidth,target[1].contentHeight )
	        	defalut.hasBackground = false
	        	defalut.isEditable=true
	        	defalut.size=16
	        	scroll(-150)

	        else
	        	defalut = native.newTextField(target[1].x,target[1].y,target[1].contentWidth,target[1].contentHeight )
	        	defalut.hasBackground = false
	        	defalut:resizeFontToFitHeight()

	        end


	        if target[2].alpha >= 1 then
	        	target[2]:setFillColor(0)
	        	target[2].size=16
	        else
	        	target[2].alpha=1
	        end



	        scrollView:insert(defalut)

	        native.setKeyboardFocus( defalut )





	        defalut:addEventListener( "userInput", textfield )


	    end
	    return true
	end 




	local function onRowRender( event )

    -- Get reference to the row group
    local row = event.row

    -- Cache the row "contentWidth" and "contentHeight" because the row bounds can change as children objects are added
    local rowHeight = row.contentHeight
    local rowWidth = row.contentWidth



    local rowTitle = display.newText(row, List_array[row.index][1], 0, 0, nil, 14 )
    rowTitle:setFillColor( 0 )
    rowTitle.anchorX = 0
    rowTitle.x = 5
    rowTitle.y = rowHeight * 0.5


    local line = display.newLine( 0,row.contentHeight,row.contentWidth,row.contentHeight )
    row:insert(line)
    line:setStrokeColor( 0, 0, 0, 1 )
    line.strokeWidth = 0.5

    row.rowValue = List_array[row.index][2]

    row.text=List_array[row.index][1]

end

local function onRowTouch( event )
	local phase = event.phase
	local row = event.target

	if( "press" == phase ) then

		MKRank.text =row.text

		mkRank_id = row.rowValue

		elseif ( "release" == phase ) then
			
			rankList.isVisible=false
			Comment.y = MKRank.y+MKRank.contentHeight+Comment_bg.contentHeight/2
			Comment_bg.y = Comment.y
			sumbitBtn.y = Comment.y+Comment.contentHeight/2+25

		end
	end



	local sumbitBtnRelease = function( event )
	
	local validation = true
	native.setKeyboardFocus(nil)

	if Name.text == "" or Name.text == Name.id  then
		validation=false
		SetError("* Enter the Name",Name)
	end
	if Email.text == "" or Email.text == Email.id then
		validation=false
		SetError("* Enter the Email",Email)
	else

		if not Utils.emailValidation(Email.text) then
			validation=false
			SetError("* Enter the valid email",Email)

		end

	end
	if Phone.text == "" or Phone.text == Phone.id then
		validation=false
		SetError("* Enter the Phone Number",Phone)
	end
	if AppName ~= "DirectorApp" then
		if UnitNumber.text == "" or UnitNumber.text == UnitNumber.id then
			validation=false
			SetError("* Enter the UnitNumber",UnitNumber)
		end
	end
	if MKRank.text == "" then
		validation=false
		SetError("* Select MKRank",MKRank)
	end
	if Comment.text == "" or Comment.text == Comment.id then
		validation=false
		SetError("* Enter the Comment",Comment)
	end

	if(validation == true) then

		print("request validation complete")
		
		RequestProcess()

	end

end




local function rankTouch( event )
	if event.phase == "began" then

		print("1234")
		elseif event.phase == "moved" then
			local dx = math.abs( event.x - event.xStart )
			local dy = math.abs( event.y - event.yStart )
        -- if finger drags button more than 5 pixels, pass focus to scrollView
        if dx > 5 or dy > 5 then
        	print("enter")
        	native.setKeyboardFocus(nil)
        	scrollView:takeFocus( event )
        end
        elseif event.phase == "ended" then
        if event.target.id == "MKrank" then
        	native.setKeyboardFocus( nil )

        	if listFlag == false then
        		listFlag=true
        		rankList.isVisible=true
        		Comment.y = Comment.y + rankList.contentHeight
        		Comment_bg.y = Comment.y
        		sumbitBtn.y = Comment.y+Comment.contentHeight/2+25

        		elseif listFlag == true then

        			rankList.isVisible=false
        			Comment.y = MKRank.y+MKRank.contentHeight+Comment_bg.contentHeight/2
        			Comment_bg.y = Comment.y
        			sumbitBtn.y = Comment.y+Comment.contentHeight/2+25

        			listFlag=false

        		end

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


	BgText = display.newText(sceneGroup,"MyUnit Buzz",0,0,native.systemFont,16)
	BgText:setFillColor( Utils.convertHexToRGB(color.White))
	BgText.x=tabBar.x-tabBar.contentWidth/2+8;BgText.y=tabBar.y
	BgText.anchorX=0


	PageTitle = display.newText(sceneGroup,"",0,0,native.systemFont,sp_commonLabel.textSize)
	PageTitle:setFillColor( Utils.convertHexToRGB(sp_commonLabel.textColor))
	PageTitle.x=BgText.x;PageTitle.y=BgText.y+15
	PageTitle.anchorX=0

	scrollView = widget.newScrollView
	{
	top = H/2,
	left = 0,
	width = 320,
	height = H-40,
	scrollWidth = 320,
	scrollHeight = 1200,
	horizontalScrollDisabled = true,
		    backgroundColor = {255,255,255,0}  -- r,g,b, alpha
		}



		scrollView.x=W/2;scrollView.y=H/2+20

		Name_bg = display.newRect(W/2, PageTitle.y+5, W-20, 30)
		nameGroup:insert(Name_bg)

		Name = display.newText("Name",0,0,native.systemFont,16 )
		Name.x=Name_bg.x-Name_bg.contentWidth/2+3;Name.y=Name_bg.y
		Name.anchorX=0
		Name.id="Name"
		Name.alpha=0.5
		nameGroup:insert(Name)
		Name:setFillColor(0,0,0)

		scrollView:insert(nameGroup)


		Email_bg = display.newRect(W/2, Name_bg.y+Name_bg.contentHeight+15, W-20, 30 )
		emailGroup:insert(Email_bg)

		Email = display.newText("Email",0,0,native.systemFont,16 )
		Email.anchorX=0
		Email.alpha=0.5
		Email.id="Email"
		Email:setFillColor(0,0,0)
		Email.x=Email_bg.x-Email_bg.contentWidth/2+3;Email.y=Email_bg.y

		emailGroup:insert(Email)

		scrollView:insert(emailGroup)


		Phone_bg = display.newRect(W/2, Email_bg.y+Email_bg.contentHeight+15, W-20, 30)
		phoneGroup:insert(Phone_bg)


		Phone = display.newText("Phone",0,0,native.systemFont,16 )
		Phone.anchorX=0
		Phone.alpha=0.5
		Phone.id="Phone"
		Phone:setFillColor(0,0,0)
		Phone.x=Phone_bg.x-Phone_bg.contentWidth/2+3;Phone.y=Phone_bg.y
		phoneGroup:insert(Phone)


		scrollView:insert(phoneGroup)



		if AppName ~= "DirectorApp" then
			UnitNumber_bg = display.newRect( W/2, Phone_bg.y+Phone_bg.contentHeight+15, W-20, 30)
			unitnumberGroup:insert(UnitNumber_bg)

			UnitNumber = display.newText("Unit Number / Director name",0,0,native.systemFont,16 )
			UnitNumber.id = "Unit Number / Director name"
			UnitNumber.anchorX=0
			UnitNumber.alpha=0.5
			UnitNumber:setFillColor(0,0,0)
			UnitNumber.x=UnitNumber_bg.x-UnitNumber_bg.contentWidth/2+3;UnitNumber.y=UnitNumber_bg.y
			unitnumberGroup:insert(UnitNumber)

			scrollView:insert(unitnumberGroup)

			MKRank_bg = display.newRect(W/2, UnitNumber_bg.y+UnitNumber_bg.contentHeight+15, W-20, 30)

		else
			MKRank_bg = display.newRect( W/2, Phone_bg.y+Phone_bg.contentHeight+15, W-20, 30)

		end

		MKRank_bg.id="MKrank"
		scrollView:insert(MKRank_bg)


		MKRank = display.newText("",MKRank_bg.x+10,MKRank_bg.y,MKRank_bg.contentWidth,MKRank_bg.contentHeight,native.systemFont,16 )
		MKRank.text = "-Select MK Rank-"
		MKRank.id="MKrank"
		MKRank.alpha=0.7
		MKRank:setFillColor( Utils.convertHexToRGB(sp_commonLabel.textColor))
		MKRank.y=MKRank_bg.y+8
	--MKRank.size=20
	scrollView:insert(MKRank)



	Comment_bg = display.newRect( W/2, 0, W-20, 130)
	Comment_bg.y=MKRank_bg.y+MKRank_bg.contentHeight+Comment_bg.contentHeight/2
	commentGroup:insert(Comment_bg)


	Comment = display.newText("Comments",0,0,Comment_bg.contentWidth-10,Comment_bg.contentHeight-10,native.systemFont,16 )
	Comment.id = "Comments"
	Comment.anchorX=0
	Comment.anchorY=0
	Comment.alpha=0.5

	Comment:setFillColor(0,0,0)
	Comment.x=Comment_bg.x-Comment_bg.contentWidth/2+8;Comment.y=Comment_bg.y-Comment_bg.contentHeight/2+8
	commentGroup:insert(Comment)

	scrollView:insert(commentGroup)



	sumbitBtn = widget.newButton
	{
	defaultFile = "res/assert/signin.jpg",
	overFile = "res/assert/signin.jpg",
	label = "Sumbit",
	labelColor = 
	{ 
	default = { 1 },
	},
	emboss = true,
	onRelease = sumbitBtnRelease,
}

sumbitBtn.x=W/2;sumbitBtn.y = Comment_bg.y+Comment_bg.contentHeight/2+25
sumbitBtn.width=80
sumbitBtn.height=35
scrollView:insert(sumbitBtn)
sumbitBtn.id="Submit"

sceneGroup:insert(scrollView)


---Listview---
rankList = widget.newTableView
{
	left = 0,
	top = -50,
	height = 100,
	width = MKRank_bg.contentWidth,
	onRowRender = onRowRender,
	onRowTouch = onRowTouch,
	hideBackground = true,
	noLines=true,
	hideScrollBar=true,
	isBounceEnabled=false,

}

rankList.x=MKRank_bg.x
rankList.y=MKRank_bg.y+MKRank_bg.contentHeight/2
rankList.height = 100
rankList.width = MKRank_bg.contentWidth
rankList.anchorY=0
rankList.isVisible=false


scrollView:insert(rankList)


---------------

MainGroup:insert(sceneGroup)


end

function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then


		elseif phase == "did" then

			composer.removeHidden(true)

			MKRank_bg:addEventListener( "touch", rankTouch )
			MKRank:addEventListener( "touch", rankTouch )


			
			nameGroup:addEventListener( "touch", textfieldListener )
			emailGroup:addEventListener( "touch", textfieldListener )
			phoneGroup:addEventListener( "touch", textfieldListener )
			unitnumberGroup:addEventListener( "touch", textfieldListener )
			commentGroup:addEventListener( "touch", textfieldListener )

			List_array = GET_LIST_OF_RANKS()

			print(List_array[1])


			for i = 1, #List_array do
			    -- Insert a row into the tableView
			    rankList:insertRow{ rowHeight = 30,


			    rowColor = { default={ 0,0,0,0.1 }, over={ 1, 0.5, 0, 0.2 } }

			}
		end

	end	

	MainGroup:insert(sceneGroup)

end

function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if event.phase == "will" then



--MUB_Android_Dev_V1.0.0_11042015_b1.apk

elseif phase == "did" then

	MKRank_bg:removeEventListener( "touch", rankTouch )
	MKRank:removeEventListener( "touch", rankTouch )
	nameGroup:removeEventListener( "touch", textfieldListener )
	emailGroup:removeEventListener( "touch", textfieldListener )
	phoneGroup:removeEventListener( "touch", textfieldListener )
	unitnumberGroup:removeEventListener( "touch", textfieldListener )
	commentGroup:removeEventListener( "touch", textfieldListener )


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
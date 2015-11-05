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


local function scroll(scroll_value)

	scrollView:scrollToPosition
	{

	y = scroll_value,
	time = 400,
}

end

local function RequestProcess()


local Request_response = REQUEST_ACCESS(Name.text,Email.text,Phone.text,UnitNumber.text,MKRank.text,Comment.text)

		if Request_response == 1 then

			composer.gotoScene( "Controller.singInPage", "slideRight", 800 )

		end

end




local function RequestListener( event )

	if ( event.phase == "began" ) then

			print("key request")
		

		event.target.text=""

		if event.target.id == "comment" then
			event.target.size = 20
		else
			event.target:resizeFontToFitHeight()
		end


		listFlag=false

			if event.target.id == "comment" then

				scroll(-250)
			else
				scroll(0)

			end

		
		event.target:setTextColor(color.black)

		elseif ( event.phase == "ended" or event.phase == "submitted" ) then

		scroll(0)

		elseif ( event.phase == "editing" ) then

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


local function onRowRender( event )

    -- Get reference to the row group
    local row = event.row

    -- Cache the row "contentWidth" and "contentHeight" because the row bounds can change as children objects are added
    local rowHeight = row.contentHeight
    local rowWidth = row.contentWidth



    local rowTitle = display.newText(row, List_array[row.index], 0, 0, nil, 14 )
    rowTitle:setFillColor( 0 )
    rowTitle.anchorX = 0
    rowTitle.x = 5
    rowTitle.y = rowHeight * 0.5


    local line = display.newLine( 0,row.contentHeight,row.contentWidth,row.contentHeight )
    row:insert(line)
    line:setStrokeColor( 0, 0, 0, 1 )
    line.strokeWidth = 0.5

    row.rowValue = row.index

    row.text=List_array[row.index]

end

local function onRowTouch( event )
	local phase = event.phase
	local row = event.target

	if( "press" == phase ) then

		MKRank.text =row.text

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

	if Name.text == "" then
		validation=false
		SetError("* Enter the Name",Name)
	end
	if Email.text == "" then
		validation=false
		SetError("* Enter the Email",Email)
	else

		if not Utils.emailValidation(Email.text) then
			validation=false
			SetError("* Enter the valid email",Email)

		end

	end
	if Phone.text == "" then
		validation=false
		SetError("* Enter the Phone Number",Phone)
	end
	if UnitNumber.text == "" then
		validation=false
		SetError("* Enter the UnitNumber",UnitNumber)
	end
	if MKRank.text == "" then
		validation=false
		SetError("* Select MKRank",MKRank)
	end
	if Comment.text == "" then
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

	local function textListener( event )

		if ( event.phase == "began" ) then

			rankList.isVisible=false
			Comment.y = MKRank.y+MKRank.contentHeight+Comment_bg.contentHeight/2
			Comment_bg.y = Comment.y
			sumbitBtn.y = Comment.y+Comment.contentHeight/2+25

			listFlag=false

			if event.target.id == "comment" then

				scroll(-250)
			else

				scroll(0)

			end

			elseif ( event.phase == "ended" or event.phase == "submitted" ) then

			scroll(0)

			elseif ( event.phase == "editing" ) then

			end
		end

------------------------------------------------------

function scene:create( event )

	local sceneGroup = self.view

	Background = display.newRect(sceneGroup,W/2,H/2,W,H)


	scrollView = widget.newScrollView
	{
	top = H/2,
	left = 0,
	width = 320,
	height = H,
	scrollWidth = 320,
	scrollHeight = 1200,
	horizontalScrollDisabled = true,
		    backgroundColor = {255,255,255,0}  -- r,g,b, alpha
		}



		scrollView.x=W/2;scrollView.y=H/2


		BgText = display.newText("MyUnit App",0,0,native.systemFontBold,sp_commonLabel.textSize)
		BgText:setFillColor( Utils.convertHexToRGB(sp_commonLabel.textColor))
		BgText.x=10;BgText.y=30
		BgText.anchorX=0
		scrollView:insert(BgText)


		PageTitle = display.newText("<  Request Access",0,0,native.systemFont,sp_commonLabel.textSize)
		PageTitle:setFillColor( Utils.convertHexToRGB(sp_commonLabel.textColor))
		PageTitle.x=BgText.x;PageTitle.y=BgText.y+45
		PageTitle.anchorX=0
		scrollView:insert(PageTitle)



		Name_bg = display.newRect(W/2, PageTitle.y+45, W-20, 30)
		Name_bg.fill = { type="image", filename="res/assert/textfield.jpg" }
		scrollView:insert(Name_bg)

		Name = native.newTextField(Name_bg.x,Name_bg.y,Name_bg.contentWidth,Name_bg.contentHeight )
		Name.hasBackground = false
		Name.placeholder = "Name"
		Name:resizeFontToFitHeight()
		scrollView:insert(Name)



		Email_bg = display.newRect( W/2, Name.y+Name.contentHeight+15, W-20, 30)
		Email_bg.fill = { type="image", filename="res/assert/textfield.jpg" }
		scrollView:insert(Email_bg)

		Email = native.newTextField(Email_bg.x,Email_bg.y,Email_bg.contentWidth,Email_bg.contentHeight )
		Email.hasBackground = false
		Email.placeholder = "Email"
		Email:resizeFontToFitHeight()
		scrollView:insert(Email)

		Phone_bg = display.newRect(W/2, Email.y+Email.contentHeight+15, W-20, 30)
		Phone_bg.fill = { type="image", filename="res/assert/textfield.jpg" }
		scrollView:insert(Phone_bg)


		Phone = native.newTextField(Phone_bg.x,Phone_bg.y,Phone_bg.contentWidth,Phone_bg.contentHeight )
		Phone.hasBackground = false
		Phone.placeholder = "Phone"
		Phone:resizeFontToFitHeight()
		scrollView:insert(Phone)

		UnitNumber_bg = display.newRect( W/2, Phone.y+Phone.contentHeight+15, W-20, 30)
		UnitNumber_bg.fill = { type="image", filename="res/assert/textfield.jpg" }
		scrollView:insert(UnitNumber_bg)

		UnitNumber = native.newTextField(UnitNumber_bg.x,UnitNumber_bg.y,UnitNumber_bg.contentWidth,UnitNumber_bg.contentHeight )
		UnitNumber.hasBackground = false
		UnitNumber.placeholder = "Unit Number / Director name"
		UnitNumber:resizeFontToFitHeight()
		scrollView:insert(UnitNumber)

		MKRank_bg = display.newRect(W/2, UnitNumber.y+UnitNumber.contentHeight+15, W-20, 30)
		MKRank_bg.fill = { type="image", filename="res/assert/textfield.jpg" }
		MKRank_bg.id="MKrank"
		scrollView:insert(MKRank_bg)

	--[[MKRank = native.newTextBox(MKRank_bg.x,MKRank_bg.y,MKRank_bg.contentWidth,MKRank_bg.contentHeight )
	MKRank.hasBackground = false
	MKRank.placeholder = "-Select MK Rank-"
	MKRank.id="MKrank"
	MKRank.size=20
	scrollView:insert(MKRank)]]

	MKRank = display.newText("ghg",MKRank_bg.x+10,MKRank_bg.y,MKRank_bg.contentWidth,MKRank_bg.contentHeight,native.systemFont,16 )
	MKRank.text = "-Select MK Rank-"
	MKRank.id="MKrank"
	MKRank.alpha=0.7
	MKRank:setFillColor( Utils.convertHexToRGB(sp_commonLabel.textColor))
	MKRank.y=MKRank_bg.y+8
	--MKRank.size=20
	scrollView:insert(MKRank)



	Comment_bg = display.newRect( W/2, 0, W-20, 130)
	Comment_bg.y=MKRank.y+MKRank.contentHeight+Comment_bg.contentHeight/2
	Comment_bg.fill = { type="image", filename="res/assert/textfield.jpg" }
	scrollView:insert(Comment_bg)


	Comment = native.newTextBox(Comment_bg.x,Comment_bg.y,Comment_bg.contentWidth,Comment_bg.contentHeight )
	Comment.hasBackground = false
	Comment.isEditable = true
	Comment.placeholder = "Comments"
	Comment.size=20;Comment.id="comment"
	--Comment:resizeFontToFitHeight()
	scrollView:insert(Comment)



	sumbitBtn = widget.newButton
	{
	defaultFile = "res/assert/signin.png",
	overFile = "res/assert/signinover.png",
	label = "Sumbit",
	labelColor = 
	{ 
	default = { 1 },
	},
	emboss = true,
	onRelease = sumbitBtnRelease,
}

sumbitBtn.x=W/2;sumbitBtn.y = Comment.y+Comment.contentHeight/2+25
scrollView:insert(sumbitBtn)
sumbitBtn.id="sumbit"

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

			Name:addEventListener( "userInput", RequestListener )
			Email:addEventListener( "userInput", RequestListener )
			Phone:addEventListener( "userInput", RequestListener )
			UnitNumber:addEventListener( "userInput", RequestListener )
			Comment:addEventListener( "userInput", RequestListener )


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
			Name:removeEventListener( "userInput", RequestListener )
			Email:removeEventListener( "userInput", RequestListener )
			Phone:removeEventListener( "userInput", RequestListener )
			UnitNumber:removeEventListener( "userInput", RequestListener )
			Comment:removeEventListener( "userInput", RequestListener )

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
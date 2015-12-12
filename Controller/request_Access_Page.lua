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
local string = require("res.value.string")
local List_array = {}
local mkRank_id=0
local current_textField,defalut
local FirstnameGroup = display.newGroup()
local nameGroup = display.newGroup()
local emailGroup = display.newGroup()
local phoneGroup = display.newGroup()
local unitnumberGroup = display.newGroup()
local commentGroup = display.newGroup()
local rankGroup = display.newGroup()

--malarkodi.sellamuthu@w3magix.com

--------------- Initialization -------------------

local W = display.contentWidth;
local H= display.contentHeight

local Background,BgText

--Button
local sumbitBtn,scrollView

--TexView
local PageTitle;

--rank
local rankList,rankTop,rankClose,rankText

--Edittext
local PageTitle,Name_bg,Name,Email_bg,Email,Phone_bg,Phone,UnitNumber_bg,UnitNumber,MKRank_bg,MKRank,Comment_bg,Comment

openPage="request_Access_Page"

local listFlag= false

local unitnumer_list

local list_response = {}


--------------------------------------------------


-----------------Function-------------------------

local function rankToptouch( event )
	if event.phase == "began" then
		display.getCurrentStage():setFocus( event.target )
		elseif event.phase == "ended" then
		display.getCurrentStage():setFocus( nil )

		if event.target.id == "close" then
			rankGroup.isVisible=falses
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

local function backAction( event )
		if event.phase == "began" then
			display.getCurrentStage():setFocus( event.target )
			elseif event.phase == "ended" then
			display.getCurrentStage():setFocus( nil )


			composer.gotoScene( "Controller.singInPage", "slideRight",500 )
		end

		return true

	end

local function onRowRender_unitnumber_request( event )

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
    if list_response[row.index].UnitNumber then
    	row.id = list_response[row.index].UnitNumber
    end
end


local function onRowTouch_unitnumber_request( event )

	local phase = event.phase
	local row = event.target

	if( "press" == phase ) then


		elseif ( "release" == phase ) then

			native.setKeyboardFocus(nil)
			UnitNumber.text = row.name
			UnitNumber.value = row.id

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

	local function scroll(scroll_value)

		scrollView:scrollToPosition
		{

		y = scroll_value,
		time = 400,
	}

end

local function RequestProcess()

	
	function get_requestAccess(response)

		Request_response = response

		if Request_response == "REQUEST"  then

			Utils.SnackBar("Already Requested")

			elseif Request_response == "FIRSTREQUEST" then

				composer.gotoScene( "Controller.singInPage", "slideRight",500 )

				Utils.SnackBar("FIRSTREQUEST")

				elseif Request_response == "OPEN" then


						Utils.SnackBar("OPEN")
						
					composer.gotoScene( "Controller.singInPage", "slideRight",500 )


					elseif Request_response == "GRANT" then

						Utils.SnackBar("GRANT")

						composer.gotoScene( "Controller.singInPage", "slideRight",500 )


						elseif Request_response == "NOUNITNUMBER" then

							SetError("* Enter the Valid UnitNumber",UnitNumber)

						end

					end
					if FirstName.text == FirstName.id then
						FirstName.text=""
					end
					if AppName == "DirectorApp" then

						Webservice.REQUEST_ACCESS(FirstName.text,Name.text,Email.text,Phone.text,Unitnumber_value,mkRank_id,Comment.text,get_requestAccess)
					else
						Webservice.REQUEST_ACCESS(FirstName.text,Name.text,Email.text,Phone.text,UnitNumber.value,mkRank_id,Comment.text,get_requestAccess)
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
						if(current_textField.id ~= "Unit Number / Director name") then
							current_textField.text=event.target.text
						end
						current_textField:setFillColor(0)
						current_textField.size=16
						if current_textField.text == "" then
							current_textField.alpha = 0.5
							current_textField.text = current_textField.id
						end


        		--event.target:removeEventListener( "userInput", textfield )
        		unitnumer_list.alpha=0
        		event.target:removeSelf();event.target = nil

        		elseif ( event.phase == "editing" ) then

        			if(current_textField.id == "Unit Number / Director name") then

        				unitnumer_list.alpha=1

        				function get_GetSearchByUnitNumberOrDirectorName(response)

        					list_response = response

        					print("empty")
        					
        					unitnumer_list:deleteAllRows()

        					if list_response ~= nil then

        						for i = 1, #list_response do
						  	 	 -- Insert a row into the tableView
						  	 	 unitnumer_list:insertRow{rowColor = { default={1,1,1}, over={ 243/255,29/255,98/255} }
						  	 	}

						  	 end
						  	 if(#list_response == 0 )then
						  	 	unitnumer_list.isVisible=false
						  	 else
						  	 	unitnumer_list.isVisible=true
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
						if rankGroup then
							rankGroup.isVisible=false
						end
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
			
			if rankGroup then
				rankGroup.isVisible=false

			end

		end
	end



	local sumbitBtnRelease = function( event )
	
	local validation = true
	native.setKeyboardFocus(nil)

	if Name.text == "" or Name.text == Name.id  then
		validation=false
		SetError("* Enter the Last Name",Name)
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
		if UnitNumber.value == "" or UnitNumber.value == UnitNumber.id then
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
        		if rankGroup then
        			rankGroup.isVisible=true

        		end

        		elseif listFlag == true then

        			rankGroup.isVisible=false


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
	tabBar.y=tabBar.height/2
	tabBar:setFillColor(Utils.convertHexToRGB(color.tabBarColor))
	
	BgText = display.newImageRect(sceneGroup,"res/assert/logo-flash-screen.png",398/4,81/4)
	BgText.x=5;BgText.y=20
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

	backBtn = display.newImageRect("res/assert/right-arrow(gray-).png",15/2,30/2)
	backBtn.x=20;backBtn.y=PageTitle.y-20
	backBtn.xScale=-1
	backBtn.anchorY=0

	page_title = display.newText("Request Access",0,0,native.systemFont,18)
	page_title.x=backBtn.x+18;page_title.y=backBtn.y+8
	page_title.anchorX=0
	page_title:setFillColor(Utils.convertHexToRGB(color.Black))
	scrollView:insert(backBtn)
	scrollView:insert(page_title)



		FirstName_bg = display.newRect(W/2, PageTitle.y+25, W-20, 30)
		FirstnameGroup:insert(FirstName_bg)

		FirstName = display.newText("First Name",0,0,native.systemFont,16 )
		FirstName.x=FirstName_bg.x-FirstName_bg.contentWidth/2+3;FirstName.y=FirstName_bg.y
		FirstName.anchorX=0
		FirstName.id="First Name"
		FirstName.alpha=0.5
		FirstnameGroup:insert(FirstName)
		FirstName:setFillColor(0,0,0)

		scrollView:insert(FirstnameGroup)

		Name_bg = display.newRect(W/2, FirstName_bg.y+FirstName_bg.height+15, W-20, 30)
		nameGroup:insert(Name_bg)

		Name = display.newText("Last Name",0,0,native.systemFont,16 )
		Name.x=Name_bg.x-Name_bg.contentWidth/2+3;Name.y=Name_bg.y
		Name.anchorX=0
		Name.id="Last Name"
		Name.alpha=0.5
		nameGroup:insert(Name)
		Name:setFillColor(0,0,0)

		scrollView:insert(nameGroup)


		Email_bg = display.newRect(W/2, Name_bg.y+Name_bg.height+15, W-20, 30 )
		emailGroup:insert(Email_bg)

		Email = display.newText("Email",0,0,native.systemFont,16 )
		Email.anchorX=0
		Email.alpha=0.5
		Email.id="Email"
		Email:setFillColor(0,0,0)
		Email.x=Email_bg.x-Email_bg.contentWidth/2+3;Email.y=Email_bg.y

		emailGroup:insert(Email)

		scrollView:insert(emailGroup)


		Phone_bg = display.newRect(W/2, Email_bg.y+Email_bg.height+15, W-20, 30)
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
			UnitNumber_bg = display.newRect( W/2, Phone_bg.y+Phone_bg.height+15, W-20, 30)
			unitnumberGroup:insert(UnitNumber_bg)

			UnitNumber = display.newText("Unit Number / Director name",0,0,native.systemFont,16 )
			UnitNumber.id = "Unit Number / Director name"
			UnitNumber.anchorX=0
			UnitNumber.value=""
			UnitNumber.alpha=0.5
			UnitNumber:setFillColor(0,0,0)
			UnitNumber.x=UnitNumber_bg.x-UnitNumber_bg.contentWidth/2+3;UnitNumber.y=UnitNumber_bg.y
			unitnumberGroup:insert(UnitNumber)

			scrollView:insert(unitnumberGroup)

			MKRank_bg = display.newRect(W/2, UnitNumber_bg.y+UnitNumber_bg.height+15, W-20, 30)

		else
			MKRank_bg = display.newRect( W/2, Phone_bg.y+Phone_bg.height+15, W-20, 30)

		end

		MKRank_bg.id="MKrank"
		scrollView:insert(MKRank_bg)



		MKRank = display.newText("",MKRank_bg.x+10,MKRank_bg.y,MKRank_bg.contentWidth,MKRank_bg.height,native.systemFont,16 )
		MKRank.text = "-Select MK Rank-"
		MKRank.id="MKrank"
		MKRank.alpha=0.7
		MKRank:setFillColor( Utils.convertHexToRGB(sp_commonLabel.textColor))
		MKRank.y=MKRank_bg.y+8
	--MKRank.size=20
	scrollView:insert(MKRank)



	Comment_bg = display.newRect( W/2, 0, W-20, 130)
	Comment_bg.y=MKRank_bg.y+MKRank_bg.height+Comment_bg.height/2
	commentGroup:insert(Comment_bg)


	Comment = display.newText("Comments",0,0,Comment_bg.contentWidth-10,Comment_bg.contentHeight-10,native.systemFont,16 )
	Comment.id = "Comments"
	Comment.anchorX=0
	Comment.anchorY=0
	Comment.alpha=0.5

	Comment:setFillColor(0,0,0)
	Comment.x=Comment_bg.x-Comment_bg.contentWidth/2+8;Comment.y=Comment_bg.y-Comment_bg.height/2+8
	commentGroup:insert(Comment)

	scrollView:insert(commentGroup)



	sumbitBtn = widget.newButton
	{
	defaultFile = "res/assert/signin.jpg",
	overFile = "res/assert/signin.jpg",
	label = "Submit",
	labelColor = 
	{ 
	default = { 1 },
	},
	emboss = true,
	onRelease = sumbitBtnRelease,
}

sumbitBtn.x=W/2;sumbitBtn.y = Comment_bg.y+Comment_bg.height/2+25
sumbitBtn.width=80
sumbitBtn.height=35
scrollView:insert(sumbitBtn)
sumbitBtn.id="Submit"

sceneGroup:insert(scrollView)




MainGroup:insert(sceneGroup)


end

function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then


		elseif phase == "did" then

			composer.removeHidden()

			unitnumer_list = widget.newTableView
			{
			left = 0,
			top = 0,
			height = 130,
			width = 300,
			noLines = true,
			onRowRender = onRowRender_unitnumber_request,
			onRowTouch = onRowTouch_unitnumber_request,
			--backgroundColor = { 0.8, 0.8, 0.8 },
			--hideBackground=true,
			listener = scrollListener
		}

		unitnumer_list.x=UnitNumber_bg.x
		unitnumer_list.y=UnitNumber_bg.y+UnitNumber_bg.height+25
		unitnumer_list.anchorY=0

		unitnumer_list.alpha=0

		
		sceneGroup:insert(unitnumer_list)

		MKRank_bg:addEventListener( "touch", rankTouch )
		MKRank:addEventListener( "touch", rankTouch )


		FirstnameGroup:addEventListener( "touch", textfieldListener )
		nameGroup:addEventListener( "touch", textfieldListener )
		emailGroup:addEventListener( "touch", textfieldListener )
		phoneGroup:addEventListener( "touch", textfieldListener )
		unitnumberGroup:addEventListener( "touch", textfieldListener )
		commentGroup:addEventListener( "touch", textfieldListener )
					Background:addEventListener("touch",touchBg)


		function GetListArray(response)


			for i=1,#response do

				List_array[i] = {}
				List_array[i][1] = response[i].MkRankLevel
				List_array[i][2] = response[i].MkRankId

			end
  		---Listview---
  		rankTop = display.newRect(rankGroup,W/2,H/2-200,300,30)
  		rankTop:setFillColor(Utils.convertHexToRGB(color.tabBarColor))

  		rankText = display.newText(rankGroup,"-Select MK Rank-",0,0,native.systemFont,16)
  		rankText.x=rankTop.x;rankText.y=rankTop.y

  		rankClose = display.newImageRect(rankGroup,"res/assert/cancel.png",19,19)
  		rankClose.x=rankTop.x+rankTop.contentWidth/2-15;rankClose.y=rankTop.y
  		rankClose.id="close"

  		rankTop:addEventListener("touch",rankToptouch)
  		rankText:addEventListener("touch",rankToptouch)
  		rankClose:addEventListener("touch",rankToptouch)

  		

  	rankList = widget.newTableView
  		{
  		left = 0,
  		top = -50,
  		height = 350,
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
  	rankList.height = 300
  	rankList.width = MKRank_bg.contentWidth
  	rankList.anchorY=0
  	rankGroup.isVisible=false

  	rankGroup:insert(rankList)
	
  --	scrollView:insert(rankGroup)


---------------

		for i = 1, #List_array do
			    -- Insert a row into the tableView
			    rankList:insertRow{ rowHeight = 30,
			    rowColor = { default={ 1,1,1}, over={ 0, 0, 0, 0.1 } }

			}
		end
end


	Webservice.GET_LIST_OF_RANKS(GetListArray)

		backBtn:addEventListener("touch",backAction)
		page_title:addEventListener("touch",backAction)

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
	rankTop:removeEventListener("touch",rankToptouch)
	rankText:removeEventListener("touch",rankToptouch)
	rankClose:removeEventListener("touch",rankToptouch)


	composer.removeHidden()



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
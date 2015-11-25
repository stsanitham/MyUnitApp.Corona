----------------------------------------------------------------------------------
--
-- resource Screen
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

local stringValue = require( "res.value.string" )
local Utility = require( "Utils.Utility" )
require( "Parser.GET_ALL_MYUNITAPP_DOCUMENT" )
local widget = require( "widget" )




--------------- Initialization -------------------

local W = display.contentWidth;H= display.contentHeight

local Background,BgText

local menuBtn

openPage="resourcePage"



--------------------------------------------------


-----------------Function-------------------------


local function onRowRender_DocLib( event )

 -- Get reference to the row group
 local row = event.row

    -- Cache the row "contentWidth" and "contentHeight" because the row bounds can change as children objects are added
    local rowHeight = row.contentHeight
    local rowWidth = row.contentWidth

    text = display.newText(row,List_array[row.index].DocumentFileName,0,0,native.systemFont,16)
    text.x=20;text.y=rowHeight/2
    text.anchorX=0
    text:setFillColor(Utils.convertHexToRGB(color.Black))

    row.ImageId = List_array[row.index].DocumentCategoryId
    row.FilePath = List_array[row.index].FilePath

end

local function onRowTouch_DocLib( event )
	local phase = event.phase
	local row = event.target

	if( "press" == phase ) then

		print("FilePath : "..row.FilePath)

		local options = {
		effect = "flip",
		time =100,
		params = { FilePath = row.FilePath }
	}

	composer.gotoScene( "Controller.imageSlideView", options )


	elseif ( "release" == phase ) then


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

	
	MainGroup:insert(sceneGroup)

end

function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then


		elseif phase == "did" then


			

			List_array = Get_AllMyunitappdocument()


			Document_Lib_list = widget.newTableView
			{
			left = -10,
			top = 45,
			height = H-45,
			width = W+10,
			onRowRender = onRowRender_DocLib,
			onRowTouch = onRowTouch_DocLib,
			hideBackground = true,
			isBounceEnabled = false,
			--noLines = true,
		}

		sceneGroup:insert(Document_Lib_list)

		for i = 1, #List_array do
		    -- Insert a row into the tableView
		    Document_Lib_list:insertRow{ rowHeight = 45,rowColor = 
		    {
		    default = { 1, 1, 1, 0 },
		    over={ 1, 0.5, 0, 0 },

		    }}
		end


		menuBtn:addEventListener("touch",menuTouch)
		BgText:addEventListener("touch",menuTouch)


	end	

	MainGroup:insert(sceneGroup)

end

function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if event.phase == "will" then


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
----------------------------------------------------------------------------------
--
-- Career path Screen
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

local stringValue = require( "res.value.string" )
local Utility = require( "Utils.Utility" )
require( "Parser.GET_ACTIVE_TEAMMEMBERS" )
local widget = require( "widget" )
local Applicationconfig = require("Utils.ApplicationConfig")



--------------- Initialization -------------------

local W = display.contentWidth;H= display.contentHeight

local Background,BgText

--Button

local menuBtn

openPage="careerPathPage"



--------------------------------------------------


-----------------Function-------------------------



local function onRowRender_CareerLib( event )

 -- Get reference to the row group
 local row = event.row

    -- Cache the row "contentWidth" and "contentHeight" because the row bounds can change as children objects are added
    local rowHeight = row.contentHeight
    local rowWidth = row.contentWidth



    local Image 

    if List_array[row.index].Image_Path ~= nil then

    	print("Image Path :"..ApplicationConfig.IMAGE_BASE_URL..List_array[row.index].Image_Path)
    	display.loadRemoteImage(ApplicationConfig.IMAGE_BASE_URL..List_array[row.index].Image_Path, "GET", 
    		function ( img_event )
    			if ( img_event.isError ) then
    				print ( "Network error - download failed" )
    			else
    				img_event.target.alpha = 0
    				transition.to( img_event.target, { alpha = 1.0 } )
    				img_event.target.width=50
    				img_event.target.height=50
    				img_event.target.x=50;img_event.target.y=rowHeight/2

    				event.row:insert(img_event.target)
    			end

    			print ( "event.response.fullPath: ", img_event.response.fullPath )
    			print ( "event.response.filename: ", img_event.response.filename )
    			print ( "event.response.baseDirectory: ", img_event.response.baseDirectory )
    			end, "career"..List_array[row.index].Contact_Id..".png", system.TemporaryDirectory, 5,5 )
    else
    	Image = display.newImageRect(row,"res/assert/twitter_placeholder.png",50,50)
    	Image.x=50;Image.y=rowHeight/2

    end

    text = display.newText(row,List_array[row.index].Last_Name,0,0,native.systemFont,14)
    text.x=80;text.y=rowHeight/2-15
    text.anchorX=0
    text:setFillColor(Utils.convertHexToRGB(color.Black))

    role = display.newText(row,List_array[row.index].CarrierProgress,0,0,native.systemFont,14)
    role.x=80;role.y=rowHeight/2+10
    role.anchorX=0
    role:setFillColor(Utils.convertHexToRGB(color.Black))

    row.Contact_Id = List_array[row.index].Contact_Id
end



local function onRowTouch_CareerLib( event )
	local phase = event.phase
	local row = event.target

	if( "release" == phase ) then


		local options = {
		isModal = true,
		effect = "slideLeft",
		time = 300,
		params = {
		contactId = row.Contact_Id
	}
}

print("Contact id : "..row.Contact_Id)

composer.showOverlay( "Controller.careerPathDetailPage", options )

-- By some method (a pause button, for example), show the overlay

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


	title = display.newText(sceneGroup,"Career Path",0,0,native.systemFontBold,18)
	title.anchorX = 0 ;title.anchorY=0
	title.x=5;title.y = tabBar.y+tabBar.contentHeight/2+10
	title:setFillColor(0)


	MainGroup:insert(sceneGroup)

end

function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then


		elseif phase == "did" then

			List_array = GetActiveTeammembers()

			Career_Lib_list = widget.newTableView
			{
			left = -10,
			top = 75,
			height = H-45,
			width = W+10,
			onRowRender = onRowRender_CareerLib,
			onRowTouch = onRowTouch_CareerLib,
			hideBackground = true,
			isBounceEnabled = false,
			--noLines = true,
		}

		sceneGroup:insert(Career_Lib_list)

		for i = 1, #List_array do
		    -- Insert a row into the tableView
		    Career_Lib_list:insertRow{ rowHeight = 60,rowColor = 
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
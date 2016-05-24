----------------------------------------------------------------------------------
--
-- Golas Screen
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

local Utility = require( "Utils.Utility" )
local widget = require( "widget" )
local json = require('json')

--------------- Initialization -------------------

local W = display.contentWidth;H= display.contentHeight

local Background,BgText

local GoalText

local menuBtn,webView

local webView

local editGoals_icon,title_bg,title



local BackFlag = false

local RecentTab_Topvalue = 40


		local content=""
		local goalsid


--------------------------------------------------


-----------------Function-------------------------


------------------------------------------------------


local function onTimer ( event )

	print( "event time completion" )

	BackFlag = false

end




local function editEvent( event)

	if event.phase == "ended" then

		if webView then	webView:removeSelf( );webView=nil end

		Runtime:removeEventListener( "key", onKeyEvent )
	
		local options = {
		    effect = "fromRight",
		    time = 500,
  			params = {

				content = content,
				goalsid = goalsid
			}
		}

		composer.showOverlay( "Controller.editGoalsPage",options )

	end

return true

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





function scene:create( event )

	openPage="goalsPage"

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


function scene:resumeGame(isEdited)

	if isEdited == true then

		local alert = native.showAlert(  Goals.PageTitle,Goals.SuccessMsg, { "OK" } )

	end


	Webservice.GET_MYUNITAPP_GOALS(get_Goals)

	Runtime:addEventListener( "key", onKeyEvent )

end


function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then

		ga.enterScene("Unit Goals")

		elseif phase == "did" then

			composer.removeHidden()

	title_bg = display.newRect(sceneGroup,0,0,W,30)
	title_bg.x=W/2;title_bg.y = tabBar.y+tabBar.contentHeight-5
	title_bg:setFillColor( Utils.convertHexToRGB(color.tabbar) )

	title = display.newText(sceneGroup,Goals.PageTitle,0,0,native.systemFont,18)
	title.anchorX = 0
	title.x=5;title.y = title_bg.y
	title:setFillColor(0)


	editGoals_icon = display.newImageRect( sceneGroup, "res/assert/edit-48.png", 36,28 )
	editGoals_icon.x=title_bg.x+title_bg.contentWidth/2-20
	editGoals_icon.y=title_bg.y+title_bg.contentHeight/2 - 17
	editGoals_icon:addEventListener( "touch", editEvent )

		if not IsOwner then

			editGoals_icon.isVisible = false

		end



function get_Goals(response)


		goalsid = response.MyUnitBuzzGoalsId

	if response.MyUnitBuzzGoals ~= nil and response.MyUnitBuzzGoals ~= "" then

		local t = response.MyUnitBuzzGoals

		content = t

		local saveData = [[<!DOCTYPE html>
		<html>

		<head>
		<meta charset="utf-8">
		<meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
		</head>]]..t..[[</html>]]

		-- Path for the file to write
		local path = system.pathForFile( "goals.html", system.DocumentsDirectory )

		-- Open the file handle
		local file, errorString = io.open( path, "w" )

		if not file then
		    -- Error occurred; output the cause
		    print( "File error: " .. errorString )
		else
		    -- Write data to file
		    file:write( saveData )
		    -- Close the file handle
		    io.close( file )
		end

		file = nil

		webView = native.newWebView( display.contentCenterX, 70, display.viewableContentWidth, display.viewableContentHeight-80 )
		webView.anchorY=0
		webView.hasBackground=false
		webView:request( "goals.html", system.DocumentsDirectory )
		sceneGroup:insert( webView )

	else
		NoEvent = display.newText( sceneGroup, Goals.NoGolas, 0,0,0,0,native.systemFontBold,16)
		NoEvent.x=W/2;NoEvent.y=H/2
		NoEvent:setFillColor( Utils.convertHexToRGB(color.Black) )
	end

end

	Webservice.GET_MYUNITAPP_GOALS(get_Goals)

	menuBtn:addEventListener("touch",menuTouch)
	BgText:addEventListener("touch",menuTouch)

	Runtime:addEventListener( "key", onKeyEvent )

end	

MainGroup:insert(sceneGroup)

end




function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if event.phase == "will" then

			Runtime:removeEventListener( "key", onKeyEvent )

			
			if webView then webView:removeSelf( );webView=nil end


		elseif phase == "did" then

			menuBtn:removeEventListener("touch",menuTouch)
			BgText:removeEventListener("touch",menuTouch)

			--editGoals_icon:removeEventListener( "touch", editEvent )

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
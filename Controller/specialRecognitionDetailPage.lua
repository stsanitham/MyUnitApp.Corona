----------------------------------------------------------------------------------
--
-- instagram Screen
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local widget = require( "widget" )
require( "res.value.style" )
require( "Webservice.ServiceManager" )
local json = require("json")
local path = system.pathForFile( "MyUnitBuzz.db", system.DocumentsDirectory )
local db = sqlite3.open( path )

local Utility = require( "Utils.Utility" )



--------------- Initialization -------------------

local W = display.contentWidth;H= display.contentHeight

local Background,BgText

local menuBtn

local isRotate = false

local webView

openPage="specialRecognition"


--------------------------------------------------


-----------------Function-------------------------

local function closeDetails( event )

	if event.phase == "began" then

			display.getCurrentStage():setFocus( event.target )

	elseif event.phase == "ended" then

			display.getCurrentStage():setFocus( nil )

	end

return true

end




local function onKeyEvent( event )

        local phase = event.phase
        local keyName = event.keyName

    if phase == "up" then

        if keyName == "back" or keyName == "a" then

        	isRotate = false

        	Runtime:removeEventListener("enterFrame", animate) 

        	composer.hideOverlay( "slideRight", 300 )

               return true
        end

    end

        return false
 end





 local function onButtonTouch( event )

		if event.phase == "began" then

				   display.getCurrentStage():setFocus( event.target )

		elseif event.phase == "ended" then

				   display.getCurrentStage():setFocus( nil )

					if event.target.id == "backbtn" or event.target.id == "titlename" then

								isRotate = false

								Runtime:removeEventListener("enterFrame", animate) 

								composer.hideOverlay( "slideRight", 300 )

					elseif event.target.id == "refresh" then

							    isRotate = true

								refresh.rotation = 1

								refresh.anchorX = 0.5
								refresh.anchorY = 0.5

								local function animate(event)

									if isRotate == true then

									  refresh.rotation = refresh.rotation + 9

											  local function onTimer ( event )


														function getRefreshedSpecialRecognition_PageContent(response)

														    isRotate = true

															if response.PageContent ~= nil and response.PageContent ~= "" then

																isRotate = false

																refresh.rotation = 1

															end

														end


										      Webservice.GetSpecialRecognitionPageContent(sr_eventid,getRefreshedSpecialRecognition_PageContent)

										      end

								      timer.performWithDelay(1000, onTimer )
		 
								    end

								end

								Runtime:addEventListener("enterFrame", animate) 

					end

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

		back_icon_bg = display.newRect(sceneGroup,0,0,20,20)
		back_icon_bg.x= 5
		back_icon_bg.anchorX=0
		back_icon_bg.anchorY=0
		back_icon_bg.alpha=0.01
		back_icon_bg:setFillColor(0)
		back_icon_bg.y= title_bg.y-8

		back_icon = display.newImageRect(sceneGroup,"res/assert/left-arrow(white).png",20/2,30/2)
		back_icon.x= 8
		back_icon.id = "backbtn"
		back_icon.anchorX=0
		back_icon.anchorY=0
		back_icon:setFillColor(0)
		back_icon.y= title_bg.y - 8


		title = display.newText(sceneGroup,"",0,0,native.systemFont,16)
		title.anchorX = 0
		title.id = "titlename"
		title.x=back_icon.x+back_icon.contentWidth+7;title.y = title_bg.y
		title:setFillColor(0)

		if IsOwner then

		refresh = display.newImageRect( sceneGroup, "res/assert/refreshicon.png",20,20 )
		refresh.anchorX = 0
		refresh.id = "refresh"
		refresh.x = W-25;refresh.y = title_bg.y

	    end

		-- NoEvent = display.newText( sceneGroup, SpecialRecognition.NoEvent , 0,0,0,0,native.systemFontBold,16)
		-- NoEvent.x=W/2;NoEvent.y=H/2
		-- NoEvent.isVisible=false
		-- NoEvent:setFillColor( Utils.convertHexToRGB(color.Black) )

MainGroup:insert(sceneGroup)

end





function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then


		if event.params then

			sr_eventdetails = event.params.specialRecognition_Details

			sr_eventid = event.params.specialRecognition_id

			print(json.encode(sr_eventdetails).."        "..json.encode(sr_eventid))

		end

		title.text = sr_eventdetails.ReportName



		function getSpecialRecognition_PageContent(response)

						    sr_detailresponse = response.PageContent

							if response.PageContent ~= nil and response.PageContent ~= "" then

								local t = response.PageContent

								content = t

								local saveData = [[<!DOCTYPE html>
								<html>
								<head>
								<meta charset="utf-8">
								<meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
								</head>]]..t..[[</html>]]

								-- Path for the file to write
								local path = system.pathForFile( "specialRecognition.html", system.DocumentsDirectory )

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
								webView:request( "specialRecognition.html", system.DocumentsDirectory )
								sceneGroup:insert( webView )

							else
								NoEvent = display.newText( sceneGroup, SpecialRecognition.NoEvent, 0,0,0,0,native.systemFontBold,16)
								NoEvent.x=W/2;NoEvent.y=H/2
								NoEvent:setFillColor( Utils.convertHexToRGB(color.Black) )
							end


		end


        Webservice.GetSpecialRecognitionPageContent(sr_eventid,getSpecialRecognition_PageContent)


	elseif phase == "did" then

		Runtime:addEventListener( "key", onKeyEvent )

		menuBtn:addEventListener("touch",menuTouch)

		back_icon:addEventListener("touch",onButtonTouch)

		title:addEventListener("touch",onButtonTouch)

		refresh:addEventListener("touch",onButtonTouch)
		
	end	
	
MainGroup:insert(sceneGroup)

end




function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if event.phase == "will" then

		if webView then webView:removeSelf( );webView=nil end

		Runtime:addEventListener( "key", onKeyEvent )
		back_icon:removeEventListener("touch",onButtonTouch)
		title:removeEventListener("touch",onButtonTouch)
		refresh:removeEventListener("touch",onButtonTouch)

		isRotate = false

		Runtime:removeEventListener( "enterFrame", animate )

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
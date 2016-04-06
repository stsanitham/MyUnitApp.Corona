----------------------------------------------------------------------------------
--
-- instagram Screen
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

local Utility = require( "Utils.Utility" )



--------------- Initialization -------------------

local W = display.contentWidth;H= display.contentHeight

local Background,BgText

local menuBtn

local back_icon_bg, back_icon

openPage="pushNotificationListPage"



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




local function closeMessagePage( event )
	if event.phase == "began" then
			display.getCurrentStage():setFocus( event.target )
	elseif event.phase == "ended" then
			display.getCurrentStage():setFocus( nil )

			composer.gotoScene("Controller.pushNotificationListPage",slideLeft,300)

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
	back_icon.x= back_icon_bg.x + 5
	back_icon.anchorX=0
	back_icon.anchorY=0
	back_icon:setFillColor(0)
	back_icon.y= title_bg.y - 8

	title = display.newText(sceneGroup,MessagePage.ComposeMessage,0,0,native.systemFont,18)
	title.anchorX = 0
	title.x=back_icon.x+15;title.y = title_bg.y
	title:setFillColor(0)


MainGroup:insert(sceneGroup)

end



	function scene:show( event )

		local sceneGroup = self.view
		local phase = event.phase
		
		if phase == "will" then

				shortmsg_title = display.newText(sceneGroup,MessagePage.ShortMessage,0,0,native.systemFont,14)
				shortmsg_title.anchorX = 0
				shortmsg_title.x=10
				shortmsg_title.y = title_bg.y+title_bg.contentHeight+5
				shortmsg_title:setFillColor(0)


				shortmsg_textbox = native.newTextBox( 0,0, W - 20, EditBoxStyle.height+50)
				shortmsg_textbox.placeholder = MessagePage.ShortMessage_Placeholder
				shortmsg_textbox.isEditable = true
				shortmsg_textbox.size=14
				shortmsg_textbox.anchorX = 0
				shortmsg_textbox.anchorY=0
				shortmsg_textbox.value=""
				shortmsg_textbox.id = "shortmessage"
				shortmsg_textbox.hasBackground = true
				shortmsg_textbox:setReturnKey( "done" )
				shortmsg_textbox.inputType = "default"
				sceneGroup:insert(shortmsg_textbox)
				shortmsg_textbox.x=10
				shortmsg_textbox.y=shortmsg_title.y+ shortmsg_title.height+3


				longmsg_title = display.newText(sceneGroup,MessagePage.LongMessage,0,0,native.systemFont,14)
				longmsg_title.anchorX = 0
				longmsg_title.x=10
				longmsg_title.y = shortmsg_textbox.y+shortmsg_textbox.contentHeight+18
				longmsg_title:setFillColor(0)


				longmsg_textbox = native.newTextBox( 0,0, W - 20, EditBoxStyle.height+50)
				longmsg_textbox.placeholder = MessagePage.LongMessage_Placeholder
				longmsg_textbox.isEditable = true
				longmsg_textbox.size=14
				longmsg_textbox.anchorX = 0
				longmsg_textbox.anchorY=0
				longmsg_textbox.value=""
				longmsg_textbox.id = "longmessage"
				longmsg_textbox.hasBackground = true
				longmsg_textbox:setReturnKey( "done" )
				longmsg_textbox.inputType = "default"
				sceneGroup:insert(longmsg_textbox)
				longmsg_textbox.x=10
				longmsg_textbox.y=longmsg_title.y+ longmsg_title.height+3



		elseif phase == "did" then

			composer.removeHidden()

			menuBtn:addEventListener("touch",menuTouch)

			back_icon:addEventListener("touch",closeMessagePage)
			back_icon_bg:addEventListener("touch",closeMessagePage)
			title:addEventListener("touch",closeMessagePage)
			
		end	
		
	MainGroup:insert(sceneGroup)

	end




	function scene:hide( event )

		local sceneGroup = self.view
		local phase = event.phase

		if event.phase == "will" then

			back_icon:removeEventListener("touch",closeMessagePage)
		    back_icon_bg:removeEventListener("touch",closeMessagePage)
		    title:addEventListener("touch",closeMessagePage)

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
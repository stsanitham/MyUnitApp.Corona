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

openPage="eventCalenderPage"

local tabBarGroup = display.newGroup( )


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



local function CreateTabBarIcons( )

	if tab_Group_btn ~= nil then if tab_Group_btn.y then tab_Group_btn:removeSelf( );tab_Group_btn=nil end end
	if tab_Message_btn ~= nil then if tab_Message_btn.y then tab_Message_btn:removeSelf( );tab_Message_btn=nil end end
	if tab_Contact_btn ~= nil then if tab_Contact_btn.y then tab_Contact_btn:removeSelf( );tab_Contact_btn=nil end end
	if tab_broadcast_btn ~= nil then if tab_broadcast_btn.y then tab_broadcast_btn:removeSelf( );tab_broadcast_btn=nil end end


	tab_Group_btn = display.newImageRect( tabBarGroup, "res/assert/group.png", 35/1.4, 31/1.4 )
	tab_Group_btn.x=tab_Group.x
	tab_Group_btn.y=tab_Group.y+tab_Group_btn.contentHeight/2-8
	tab_Group_btn.anchorY=0



	tab_Message_btn = display.newImageRect( tabBarGroup, "res/assert/chats.png", 35/1.4, 31/1.4 )
	tab_Message_btn.x=tab_Message.x
	tab_Message_btn.y=tab_Message.y+tab_Message_btn.contentHeight/2-8
	tab_Message_btn.anchorY=0

	if IsOwner == true then

		tab_broadcast_btn = display.newImageRect( tabBarGroup, "res/assert/resource.png", 35/1.4, 31/1.4 )
		tab_broadcast_btn.x=tab_Boradcast.x
		tab_broadcast_btn.y=tab_Boradcast.y+tab_broadcast_btn.contentHeight/2-8
		tab_broadcast_btn.anchorY=0
		tab_broadcast_btn:setFillColor( 0 )

	end


	tab_Contact_btn = display.newImageRect( tabBarGroup, "res/assert/Consultant.png", 35/1.4, 31/1.4 )
	tab_Contact_btn.x=tab_Contact.x
	tab_Contact_btn.y=tab_Contact.y+tab_Contact_btn.contentHeight/2-8
	tab_Contact_btn.anchorY=0


end


------------------------------------------------------

function scene:create( event )

	local sceneGroup = self.view

	Background = display.newImageRect(sceneGroup,"res/assert/background.jpg",W,H)
	Background.x=W/2;Background.y=H/2

	tabBar = display.newRect(sceneGroup,W/2,0,W,40)
	tabBar.y=tabBar.contentHeight/2
	tabBar:setFillColor(Utils.convertHexToRGB(color.primaryColor))

	menuBtn = display.newImageRect(sceneGroup,"res/assert/menu.png",23,17)
	menuBtn.anchorX=0
	menuBtn.x=10;menuBtn.y=20;

	BgText = display.newImageRect(sceneGroup,"res/assert/logo.png",398/4,81/4)
	BgText.x=menuBtn.x+menuBtn.contentWidth+5;BgText.y=menuBtn.y
	BgText.anchorX=0

	title_bg = display.newRect(sceneGroup,0,0,W,30)
	title_bg.x=W/2;title_bg.y = tabBar.y+tabBar.contentHeight-5
	title_bg:setFillColor( Utils.convertHexToRGB(color.tabbar) )

	title = display.newText(sceneGroup,ChatPage.Chats,0,0,native.systemFont,18)
	title.anchorX = 0
	title.x=5;title.y = title_bg.y
	title:setFillColor(0)

	title.text = ChatPage.Chats

	MainGroup:insert(sceneGroup)

end

function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then


	elseif phase == "did" then

		local function reload( event )
			spinner_hide ()
			timer.cancel( event.source )
			composer.gotoScene( "Controller.MessagingPage"  )
		end

		

		spinner_show ()
		timer.performWithDelay( 500,  reload )


		  tabBg = display.newRect( tabBarGroup, W/2, H-40, W, 40 )
                       tabBg.anchorY=0
                       tabBg.strokeWidth = 1
                       tabBg:setStrokeColor( Utils.convertHexToRGB(color.primaryColor),0.7 )

                       tab_Group = display.newRect(tabBarGroup,0,0,70,40)
                       tab_Group.x=W/2-W/3;tab_Group.y=tabBg.y
                       tab_Group.anchorY=0
                       tab_Group.alpha=0.01
                       tab_Group.id="group"
                       tab_Group:setFillColor( 0.2 )

                       tab_Message = display.newRect(tabBarGroup,0,0,70,40)
                       if IsOwner == true then
                       	tab_Message.x=W/2-W/8
                       else
                       	tab_Message.x = W/2
                       end
                       tab_Message.y=tabBg.y
                       tab_Message.anchorY=0
                       tab_Message.alpha=0.01
                       tab_Message.id="message"
                       tab_Message:setFillColor( 0.2 )

                       if IsOwner == true then
                       	tab_Boradcast = display.newRect(tabBarGroup,0,0,70,40)
                       	tab_Boradcast.x=W/2+W/10;tab_Boradcast.y=tabBg.y
                       	tab_Boradcast.anchorY=0
                       	tab_Boradcast.alpha=0.01
                       	tab_Boradcast.id="broadcast"
                       	tab_Boradcast:setFillColor( 0.2 )

                     --  	tab_Boradcast:addEventListener( "touch", TabbarTouch )
                       end

                       tab_Contact = display.newRect(tabBarGroup,0,0,70,40)
                       tab_Contact.x=W/2+W/3;tab_Contact.y=tabBg.y
                       tab_Contact.anchorY=0
                       tab_Contact.alpha=0.01
                       tab_Contact.id="contact"
                       tab_Contact:setFillColor( 0.2 )

                       -- tab_Group:addEventListener( "touch", TabbarTouch )
                       -- tab_Message:addEventListener( "touch", TabbarTouch )
                       -- tab_Contact:addEventListener( "touch", TabbarTouch )

                       CreateTabBarIcons()

                       if tab_Message_btn then tab_Message_btn:removeSelf( );tab_Message_btn=nil end

                       tab_Message_btn = display.newImageRect( tabBarGroup, "res/assert/chats active.png", 35/1.4, 31/1.4 )
                       tab_Message_btn.x=tab_Message.x
                       tab_Message_btn.y=tab_Message.y+tab_Message_btn.contentHeight/2-8
                       tab_Message_btn.anchorY=0

                       overlay = display.newImageRect( tabBarGroup, "res/assert/overlay.png", 55,56/1.4)
                       overlay.y=tabBg.y+6;overlay.x=tab_Message_btn.x

                       tab_Group_txt = display.newText( tabBarGroup,  ChatPage.Group ,0,0,native.systemFont,11 )
                       tab_Group_txt.x=tab_Group_btn.x;tab_Group_txt.y=tab_Group_btn.y+tab_Group_btn.contentHeight+5
                       tab_Group_txt:setFillColor( 0.3 )

                       tab_Message_txt = display.newText( tabBarGroup,  ChatPage.Chats ,0,0,native.systemFont,11 )
                       tab_Message_txt.x=tab_Message_btn.x;tab_Message_txt.y=tab_Message_btn.y+tab_Message_btn.contentHeight+5
                       tab_Message_txt:setFillColor( Utils.convertHexToRGB(color.primaryColor) )

                       if IsOwner == true then
                       	tab_Broadcast_txt = display.newText( tabBarGroup, ChatPage.Broadcast ,0,0,native.systemFont,11 )
                       	tab_Broadcast_txt.x=tab_broadcast_btn.x;tab_Broadcast_txt.y=tab_Message_btn.y+tab_Message_btn.contentHeight+5
                       	tab_Broadcast_txt:setFillColor( 0.3 )
                       end

                       tab_Contact_txt = display.newText( tabBarGroup, ChatPage.Consultant_List ,0,0,native.systemFont,11 )
                       tab_Contact_txt.x=tab_Contact_btn.x;tab_Contact_txt.y=tab_Contact_btn.y+tab_Contact_btn.contentHeight+5
                       tab_Contact_txt:setFillColor( 0.3 )

                       sceneGroup:insert( tabBarGroup )
		--menuBtn:addEventListener("touch",menuTouch)
		
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
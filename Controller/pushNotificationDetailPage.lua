----------------------------------------------------------------------------------
--
-- instagram Screen
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local Utility = require( "Utils.Utility" )
local widget = require( "widget" )
require( "Webservice.ServiceManager" )
local style = require("res.value.style")
local json = require("json")




--------------- Initialization -------------------

local W = display.contentWidth;H= display.contentHeight

local Background,BgText

local menuBtn

openPage="pushNotificationDetailPage"

local RecentTab_Topvalue = 40

local back_icon,short_msg_txt,short_msg_delete,short_msg_edit

local  messageList_array = {}

local careerListArray = {}

local messagedetail_scrollView

local sentMessage_detail

local BackFlag = false



--------------------------------------------------


-----------------Function-------------------------




		local function BgTouch( event )
			if event.phase == "ended" then


			end

		return true
		end




		local function closeDetails( event )
			if event.phase == "began" then

			elseif event.phase == "ended" then

					 composer.hideOverlay("slideRight",300)

			end

		return true

		end




		local function onTimer ( event )

			print( "event time completion" )

			BackFlag = false

		end



		local function onKeyEventDetail( event )

		        local phase = event.phase
		        local keyName = event.keyName

		        if phase == "up" then

		        if keyName=="back" or keyName == "a" then

		        	composer.hideOverlay( "slideRight", 300 )
		            
		        end

		    end

		        return false
		 end






	local function MessageDetail_scrollListener( event )

		    local phase = event.phase

		    if ( phase == "began" ) then 

		    elseif ( phase == "moved" ) then

		    elseif ( phase == "ended" ) then 

		    end


		    if ( event.limitReached ) then

		        if ( event.direction == "up" ) then print( "Reached bottom limit" )
		        	
		        elseif ( event.direction == "down" ) then print( "Reached top limit" )

		        elseif ( event.direction == "left" ) then print( "Reached right limit" )

		        elseif ( event.direction == "right" ) then print( "Reached left limit" )

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

	menuBtn = display.newImageRect(sceneGroup,"res/assert/menu.png",23,17)
	menuBtn.anchorX=0
	menuBtn.x=10;menuBtn.y=20;

	BgText = display.newImageRect(sceneGroup,"res/assert/logo-flash-screen.png",398/4,81/4)
	BgText.x=menuBtn.x+menuBtn.contentWidth+5;BgText.y=menuBtn.y
	BgText.anchorX=0

	Background:addEventListener( "touch", BgTouch )

    MainGroup:insert(sceneGroup)


end



	function scene:show( event )

		local sceneGroup = self.view
		local phase = event.phase
		
		if phase == "will" then

		elseif phase == "did" then

			--composer.removeHidden()


			if event.params then

				messagelistvalue = event.params.messagelistvalues

				print("\n\n\n Message Detail Values : \n\n ", json.encode(messagelistvalue))

			end


			messagedetail_scrollView = widget.newScrollView
				{
					top = 40,
					left = 0,
					width = W,
					height =H-RecentTab_Topvalue-5,
					bottomPadding = 5,
					hideBackground = true,
					isBounceEnabled=false,
					horizontalScrollingDisabled = true,
					verticalScrollingDisabled = false,
					listener = MessageDetail_scrollListener,
				}

            sceneGroup:insert(messagedetail_scrollView)




        function DisplayDetailValues( detail_value)

		    print("********************************* : ", detail_value)

		    back_icon = display.newImageRect(sceneGroup,"res/assert/left-arrow(white).png",15/2,30/2)
			back_icon.x= 10
			back_icon.anchorX=0
			back_icon.anchorY=0
			back_icon:setFillColor(0)
			back_icon.y= tabBar.y - 5
			messagedetail_scrollView:insert(back_icon)


			short_msg_txt= display.newText(sceneGroup,detail_value.MyUnitBuzzMessage,0,0,W-80,0,native.systemFont,14)
			short_msg_txt.x=back_icon.x + 18
			short_msg_txt.y= back_icon.y
			short_msg_txt.anchorX=0
			short_msg_txt.anchorY = 0
			Utils.CssforTextView(short_msg_txt,sp_labelName)
			short_msg_txt:setFillColor(0)
			messagedetail_scrollView:insert(short_msg_txt)
            

            if IsOwner == true then

			short_msg_edit= display.newImageRect(sceneGroup,"res/assert/editicon.png",20,20)
			short_msg_edit.x= short_msg_txt.x+short_msg_txt.width+ 5
			short_msg_edit.anchorX=0
			short_msg_edit.anchorY=0
			short_msg_edit.isVisible = true
			short_msg_edit:setFillColor(0)
			short_msg_edit.y= tabBar.y - 7
			messagedetail_scrollView:insert(short_msg_edit)

		    else

		    	short_msg_txt.width = W-40
		    	short_msg_txt.x=back_icon.x + 8
			    short_msg_txt.y= back_icon.y


			end


			short_msg_delete= display.newImageRect(sceneGroup,"res/assert/delete.png",18,16)
			short_msg_delete.x= W-24
			short_msg_delete.anchorX=0
			short_msg_delete.anchorY=0
			short_msg_delete:setFillColor(0)
			short_msg_delete.y= tabBar.y - 5
			messagedetail_scrollView:insert(short_msg_delete)

            
            local timecreated = detail_value.MessageDate
			local time = makeTimeStamp(timecreated)

			short_msg_timedate= display.newText(sceneGroup,os.date("%b %d, %Y %I:%M %p",time),0,0,W-130,0,native.systemFont,12)
			short_msg_timedate.x = W-133
			short_msg_timedate.y = short_msg_txt.y+short_msg_txt.contentHeight+12
			short_msg_timedate.anchorX=0
			short_msg_timedate.anchorY = 0
			short_msg_timedate:setFillColor(Utils.convertHexToRGB(color.tabBarColor))
			messagedetail_scrollView:insert(short_msg_timedate)
			--short_msg_timedate:setFillColor(0)


				if detail_value.MyUnitBuzzLongMessage ~= nil then

			    long_msg_text= display.newText(sceneGroup,detail_value.MyUnitBuzzLongMessage,0,0,W-30,0,native.systemFont,14)
				long_msg_text.x = 15
				long_msg_text.y = short_msg_timedate.y+short_msg_timedate.contentHeight+12
				long_msg_text.anchorX=0
				long_msg_text.anchorY = 0
				Utils.CssforTextView(long_msg_text,sp_labelName)
				long_msg_text:setFillColor(0)
				messagedetail_scrollView:insert(long_msg_text)

				end


	    end


            DisplayDetailValues(messagelistvalue)


			menuBtn:addEventListener("touch",menuTouch)
			back_icon:addEventListener("touch",closeDetails)

            Runtime:addEventListener( "key", onKeyEventDetail )
			
		end	
		
	MainGroup:insert(sceneGroup)

	end





	function scene:hide( event )

		local sceneGroup = self.view
		local phase = event.phase

		if event.phase == "will" then


			elseif phase == "did" then

				event.parent:resumeGame()


				menuBtn:removeEventListener("touch",menuTouch)

				Runtime:removeEventListener("key",onKeyEventDetail)


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
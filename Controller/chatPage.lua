----------------------------------------------------------------------------------
--
-- instagram Screen
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local widget = require("widget")
local lfs = require ("lfs")
local mime = require("mime")
local style = require("res.value.style")
local Utility = require( "Utils.Utility" )
local json = require("json")
local path = system.pathForFile( "MyUnitBuzz.db", system.DocumentsDirectory )
local db = sqlite3.open( path )



--------------- Initialization -------------------

local W = display.contentWidth;H= display.contentHeight

local Background,BgText

local menuBtn,tabButtons,chattabBar,chatScroll

openPage="chatPage"

local BackFlag = false

local ChatBox

local ContactDetails = {}

local ChatHistory = {}

local MeassageList={}

local UserId,ContactId,To_ContactId

local tabBarBackground = "res/assert/tabBarBg.png"
local tabBarLeft = "res/assert/tabSelectedLeft.png"
local tabBarMiddle = "res/assert/tabSelectedMiddle.png"
local tabBarRight = "res/assert/tabSelectedRight.png"


for row in db:nrows("SELECT * FROM logindetails WHERE id=1") do
		UserId = row.UserId
		ContactId = row.ContactId

end



--------------------------------------------------


-----------------Function-------------------------

local function sendMeaasage()
	
	ChatBox.text=""

	print( "sendMeaasage" )

	for i=#MeassageList, 1, -1 do 
			display.remove(MeassageList[#MeassageList])
			MeassageList[#MeassageList] = nil
	end
	for i=#ChatHistory, 1, -1 do 
			ChatHistory[#ChatHistory] = nil
	end


	           --native.showAlert("MyUnitBuzz", "From : "..tostring(ContactId).."To :"..tostring(To_ContactId), { "OK" } )


	for row in db:nrows("SELECT * FROM pu_MyUnitBuzz_Message WHERE (Message_To='"..tostring(To_ContactId).."') OR (Message_To='"..tostring(ContactId).."') ORDER BY id DESC ") do

		local q = "UPDATE pu_MyUnitBuzz_Message SET Message_Status='SEND' WHERE Message_To='"..tostring(To_ContactId).."' AND Message_To='"..tostring(ContactId)..";"
		db:exec( q )

		ChatHistory[#ChatHistory+1] =row



	end

	


	for i=1,#ChatHistory do

		MeassageList[#MeassageList+1] = display.newGroup( )

		local tempGroup = MeassageList[#MeassageList]

		local bg = display.newRoundedRect(0,0,W-100,25,3 )
		tempGroup:insert(bg)
		bg.strokeWidth = 1
		bg:setStrokeColor( Utils.convertHexToRGB(color.LtyGray) )
		bg.anchorX=0;bg.anchorY=0




		if MeassageList[#MeassageList-1] ~= nil then
			
			bg.y=MeassageList[#MeassageList-1][1].y-MeassageList[#MeassageList-1][1].contentHeight-5
		else
			bg.y=H-210
		end
		bg.x=5

		if ChatHistory[i].Message_From == tostring(ContactId) then
			print( "here" )
			bg.x=W-10
			bg.anchorX=1
			bg:setFillColor( 0.2,0.6,0.8,0.3 )
			bg:setStrokeColor( 0.2,0.4,0.6)

		end

		local chat = display.newText( ChatHistory[i].MyUnitBuzz_Message,W-40,0,native.systemFont,14)
		chat.anchorY=0
		chat.anchorX = bg.anchorX
		chat.x=bg.x+2;chat.y=bg.y
		chat:setFillColor( 0 )
		if chat.width >  W then
			chat.width = W-60
			chat.x=bg.x+5

		end

		tempGroup:insert( chat )

		bg.width = chat.contentWidth+10

		chatScroll:insert(tempGroup)

	end



end

function get_sendMssage(response)

	sendMeaasage()

end

local function ChatSendAction( event )
	if event.phase == "began" then
			display.getCurrentStage():setFocus( event.target )
	elseif event.phase == "ended" then
			display.getCurrentStage():setFocus( nil )
			if ChatBox.text ~= nil and ChatBox.text ~= "" then
			local Message_date,isDeleted,Created_TimeStamp,Updated_TimeStamp,ImagePath,AudioPath,VideoPath,MyUnitBuzz_LongMessage,From,To,Message_Type
			
			Message_date=os.date("%Y-%m-%dT%H:%m:%S")
			isDeleted="false"
			Created_TimeStamp=os.date("%Y-%m-%dT%H:%m:%S")
			Updated_TimeStamp=os.date("%Y-%m-%dT%H:%m:%S")
			ImagePath="NULL"
			AudioPath="NULL"
			VideoPath="NULL"
			MyUnitBuzz_LongMessage=ChatBox.text
			From=ContactId
			To=To_ContactId
			Message_Type = "INDIVIDUAL"

				print(UserId.."\n"..ChatBox.text.."\n"..Message_date.."\n"..isDeleted.."\n"..Created_TimeStamp.."\n"..Updated_TimeStamp.."\n"..MyUnitBuzz_LongMessage.."\n"..From.."\n"..To_ContactId.."\n" )
				local insertQuery = [[INSERT INTO pu_MyUnitBuzz_Message VALUES (NULL, ']]..UserId..[[',']]..ChatBox.text..[[','SEND',']]..Message_date..[[',']]..isDeleted..[[',']]..Created_TimeStamp..[[',']]..Updated_TimeStamp..[[',']]..ImagePath..[[',']]..AudioPath..[[',']]..VideoPath..[[',']]..MyUnitBuzz_LongMessage..[[',']]..From..[[',']]..To..[[',']]..Message_Type..[[',']]..title.text..[[');]]
				db:exec( insertQuery )

			Webservice.SEND_MESSAGE(ChatBox.text,"","","","","SEND",From,To,Message_Type,get_sendMssage)


	end

	end

return true
end

local function onTimer ( event )

	print( "event time completion" )

	BackFlag = false

end


local function onKeyEvent( event )

        local phase = event.phase
        local keyName = event.keyName

        if phase == "up" then

        if keyName=="back" then

        	if BackFlag == false then

        		Utils.SnackBar("Press again to exit")

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




	local function handleTabBarEvent( event )

		if event.phase == "press" then 

				tabbutton_id = event.target._id 


			if tabbutton_id == "chat" then

				title.text = "Chat"

			elseif tabbutton_id == "broadcast_list" then

				    print("tabButtons details : "..json.encode(tabButtons))

					chattabBar:setSelected( 1 ) 
   				    local options = {
									effect = "crossFade",
									time = 300,	
									params = { tabbuttonValue2 =json.encode(tabButtons)}
									}

				    composer.gotoScene( "Controller.broadCastListPage", options )

			elseif tabbutton_id == "group" then

					chattabBar:setSelected( 3 ) 
   				    local options = {
									effect = "crossFade",
									time = 300,	  
									params = { tabbuttonValue3 =json.encode(tabButtons)}
									}

				    composer.gotoScene( "Controller.groupPage", options )

			elseif tabbutton_id == "consultant_list" then

			    	chattabBar:setSelected( 4 ) 
   				    local options = {
									effect = "crossFade",
									time = 300,	 
									params = { tabbuttonValue4 =json.encode(tabButtons)}
									}

				    composer.gotoScene( "Controller.consultantListPage", options )

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

	title_bg = display.newRect(sceneGroup,0,0,W,30)
	title_bg.x=W/2;title_bg.y = tabBar.y+tabBar.contentHeight-5
	title_bg:setFillColor( Utils.convertHexToRGB(color.tabbar) )

	title = display.newText(sceneGroup,FlapMenu.chatMessageTitle,0,0,native.systemFont,18)
	title.anchorX = 0
	title.x=5;title.y = title_bg.y
	title:setFillColor(0)

	title.text = "Chat"


		 tabButtons = {
    {
        label = "Broadcast List",
        defaultFile = "res/assert/user.png",
        overFile = "res/assert/user.png",
        size = 11.5,
        labelYOffset = 2,
        id = "broadcast_list",
        labelColor = { 
            default = { 0,0,0}, 
            over = {0,0,0}
        },
        width = 20,
        height = 20,
        onPress = handleTabBarEvent,
        selected = true,
    },
    {
        label = "Chat",
        defaultFile = "res/assert/mail.png",
        overFile = "res/assert/mail.png",
        size = 11.5,
        labelYOffset = 2,
        id = "chat",
        labelColor = { 
            default = { 0,0,0}, 
            over = {0,0,0}
        },
        width = 20,
        height = 15,
        onPress = handleTabBarEvent,
    },
    {
        label = "Group",
        defaultFile = "res/assert/phone.png",
        overFile = "res/assert/phone.png",
        size = 11.5,
        labelYOffset = 2,
        id = "group",
        labelColor = { 
            default = { 0,0,0}, 
            over = { 0,0,0 }
        },
        width = 20,
        height = 20,
        onPress = handleTabBarEvent,
    },
   
}

if IsOwner == true then

tabButtons[#tabButtons+1] =  {
        label = "Consultant List",
        defaultFile = "res/assert/map.png",
        overFile = "res/assert/map.png",
        size = 11.5,
        labelYOffset = 2,
        id = "consultant_list",
        labelColor = { 
            default = { 0,0,0}, 
            over = { 0,0,0 }
        },
        width = 16,
        height = 20,
        onPress = handleTabBarEvent,
    }

end

			    chattabBar = widget.newTabBar{
			    top =  display.contentHeight - 55,
			    left = 0,
			    width = display.contentWidth, 
			    backgroundFile = tabBarBackground,
			    tabSelectedLeftFile = tabBarLeft,   
			    tabSelectedRightFile = tabBarRight,    
			    tabSelectedMiddleFile = tabBarMiddle,   
			    tabSelectedFrameWidth = 20,                                         
			    tabSelectedFrameHeight = 50, 
			    backgroundFrame = 1,
			    tabSelectedLeftFrame = 2,
			    tabSelectedMiddleFrame = 3,
			    tabSelectedRightFrame = 4,                                       
			    buttons = tabButtons,
			    height = 50,
			}

			sceneGroup:insert(chattabBar)


            local rect = display.newRect(0,0,display.contentWidth,1.3)
			rect.x = 0;
			rect.anchorX=0
			rect.y = display.contentHeight - 50;
			rect:setFillColor(0)
			sceneGroup:insert( rect )


MainGroup:insert(sceneGroup)

end

function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then

		if event.params then
			nameval = event.params.tabbuttonValue2
		end



	elseif phase == "did" then

		ContactDetails = event.params.contactDetails

		print( "ContactDetails : "..json.encode(ContactDetails) )

		title.text = ContactDetails.Name or ContactDetails.ToName

		To_ContactId = ContactDetails.Contact_Id or ContactDetails.Message_From

		ChatBox_bg = display.newRect(sceneGroup,0,H-100, W-50, 40 )
		ChatBox_bg.anchorY=0;ChatBox_bg.anchorX=0
		ChatBox_bg.x=5
		ChatBox_bg.strokeWidth = 1
		ChatBox_bg:setStrokeColor( Utils.convertHexToRGB(color.LtyGray))

		ChatBox = native.newTextBox( 0, ChatBox_bg.y, ChatBox_bg.contentWidth-5, ChatBox_bg.contentHeight-5 )
		ChatBox.isEditable = true
		ChatBox.anchorY=0;ChatBox.anchorX=0
		ChatBox.x=ChatBox_bg.x
		ChatBox.hasBackground = false
		sceneGroup:insert( ChatBox )

		sendBtn = display.newImageRect( sceneGroup, "res/assert/msg_send.png", 25,20 )
		sendBtn.x=ChatBox_bg.x+ChatBox_bg.contentWidth+5
		sendBtn.y=ChatBox_bg.y+ChatBox_bg.contentHeight/2-sendBtn.contentHeight/2
		sendBtn.anchorY=0;sendBtn.anchorX=0


		chatScroll = widget.newScrollView(
    {
        top = 125,
        left = 0,
        width = W,
        height = H-175,
        listener = scrollListener,
        hideBackground=true,
       
    }
)

		chatScroll.anchorY=1
		chatScroll.anchorX=0
		chatScroll.x=0;chatScroll.y=ChatBox_bg.y-5
		sceneGroup:insert( chatScroll )

		sendMeaasage()

		sendBtn:addEventListener( "touch", ChatSendAction )
		menuBtn:addEventListener("touch",menuTouch)


		function printTimeSinceStart( event )
		    if chatReceivedFlag==true then
		    	chatReceivedFlag=false
		    	sendMeaasage()
		    end
		end 
		Runtime:addEventListener( "enterFrame", printTimeSinceStart )
		
	end	



	
MainGroup:insert(sceneGroup)

end

	function scene:hide( event )

		local sceneGroup = self.view
		local phase = event.phase

		if event.phase == "will" then

					Runtime:removeEventListener( "enterFrame", printTimeSinceStart )


		elseif phase == "did" then


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
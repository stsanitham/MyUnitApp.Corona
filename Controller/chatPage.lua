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

local menuBtn,tabButtons,chattabBar,chatScroll,BackBtn

openPage="chatPage"

local BackFlag = false

local ChatBox

local ContactDetails = {}

local ChatHistory = {}

local MeassageList={}

local MessageType=""

local MemberName

local tabBarGroup = display.newGroup( )

local ChatScrollContent = display.newGroup( )

local UserId,ContactId,To_ContactId

local tabBarBackground = "res/assert/tabBarBg.png"
local tabBarLeft = "res/assert/tabSelectedLeft.png"
local tabBarMiddle = "res/assert/tabSelectedMiddle.png"
local tabBarRight = "res/assert/tabSelectedRight.png"

local PHOTO_FUNCTION = media.PhotoLibrary 


for row in db:nrows("SELECT * FROM logindetails WHERE id=1") do
		UserId = row.UserId
		ContactId = row.ContactId
		MemberName = row.MemberName

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


	          -- native.showAlert("MyUnitBuzz", "ContactId : "..tostring(ContactId).."To_ContactId :"..tostring(To_ContactId), { "OK" } )


	for row in db:nrows("SELECT * FROM pu_MyUnitBuzz_Message WHERE (Message_To='"..tostring(To_ContactId):lower().."') ") do

		local q = "UPDATE pu_MyUnitBuzz_Message SET Message_Status='SEND' WHERE id='"..row.id.."';"
		db:exec( q )

		ChatHistory[#ChatHistory+1] =row


	end

	


	for i=1,#ChatHistory do



		MeassageList[#MeassageList+1] = display.newGroup( )

		local tempGroup = MeassageList[#MeassageList]

		local bg = display.newRect(0,0,W-100,25 )
		tempGroup:insert(bg)
		
		bg.anchorX=0;bg.anchorY=0




		if MeassageList[#MeassageList-1] ~= nil then
			bg.y=MeassageList[#MeassageList-1][1].y+MeassageList[#MeassageList-1][1].contentHeight+5
		else
			bg.y=0
		end
		bg.x=5

		if ChatHistory[i].Message_From == tostring(ContactId) then

			
				print( "here" )
				bg.x=W-10
				bg.anchorX=1
			
		end

		local chat	

		if ChatHistory[i].MyUnitBuzz_Message:len() > 40 then

		chat = display.newText( ChatHistory[i].MyUnitBuzz_Message,W-40,0,W-40,0,native.systemFont,14)

		else

			chat = display.newText( ChatHistory[i].MyUnitBuzz_Message,W-40,0,native.systemFont,14)

		end
		chat.anchorY=0
		chat.anchorX = 0
		chat.x=bg.x+5;chat.y=bg.y
	

		tempGroup:insert( chat )

	
		bg.width = chat.contentWidth+10	
		bg.height = chat.contentHeight+10	

		local owner

		if MessageType == "GROUP" then

			owner = display.newText(tempGroup,"",0,0,native.systemFont,14)
			owner.anchorY=0
			owner.anchorX = 0
			owner.x=chat.x
			owner.y=chat.y
			owner:setTextColor( 1, 1, 0 )
			chat.y=owner.y+20



			bg.height = bg.height+20

			if ChatHistory[i].Message_From == tostring(ContactId) then

				owner.text = MemberName

			else

				owner.text = ChatHistory[i].FromName or ChatHistory[i].ToName or "(~No Name)"

			end
		

			if owner.contentWidth > bg.contentWidth then
					bg.width = owner.contentWidth+10	
			end

			

		local alert = native.showAlert( LoginPage.ErrorTitle,owner.text, { CommonWords.ok } )


		end

			
		local arrow = display.newImageRect( tempGroup, "res/assert/whitetriangle.png", 10, 10 )
		arrow.x=bg.x-5
		arrow.y=bg.y-0.3
		arrow.anchorY=0

		if ChatHistory[i].Message_From == tostring(ContactId) then
			chat.x = bg.x-bg.contentWidth+5
			if owner ~= nil then print("$$$ : "..owner.text);owner.x=chat.x end
			bg:setFillColor( Utils.convertHexToRGB(color.tabBarColor) )

		else
			bg:setFillColor( Utils.convertHexToRGB(color.Gray) )
		end



		if ChatHistory[i].Message_From == tostring(ContactId) then
			arrow.x=bg.x+5
			arrow:setFillColor( Utils.convertHexToRGB(color.tabBarColor) )

		else
		
		arrow:scale( -1, 1 )
		arrow:setFillColor( Utils.convertHexToRGB(color.Gray) )


		end





		chatScroll:insert(tempGroup)

	end

chatScroll:scrollTo( "bottom", { time=200 } )

end



function get_sendMssage(response)

	sendMeaasage()

end


local function backAction( event )
	if event.phase == "began" then

		display.getCurrentStage():setFocus( event.target )

	elseif ( event.phase == "moved" ) then
        local dy = math.abs( ( event.y - event.yStart ) )
       
	        if ( dy > 10 ) then
	        	display.getCurrentStage():setFocus( nil )
	            chatScroll:takeFocus( event )
	        end

	elseif event.phase == "ended" then
			display.getCurrentStage():setFocus( nil )

				      local options = {
				      		effect = "flipFadeOutIn",
							time = 200,	

							}

				    composer.gotoScene( "Controller.MessagingPage", options )

	end

return true
end



local function ChatSendAction( event )
	if event.phase == "began" then

		print( "###############" )
			display.getCurrentStage():setFocus( event.target )

	elseif ( event.phase == "moved" ) then
        local dy = math.abs( ( event.y - event.yStart ) )
        -- If the touch on the button has moved more than 10 pixels,
        -- pass focus back to the scroll view so it can continue scrolling

        if ( dy > 10 ) then
        	display.getCurrentStage():setFocus( nil )
            chatScroll:takeFocus( event )
        end

	elseif event.phase == "ended" then
			display.getCurrentStage():setFocus( nil )
			if ChatBox.text ~= nil and ChatBox.text ~= "" then
			local Message_date,isDeleted,Created_TimeStamp,Updated_TimeStamp,ImagePath,AudioPath,VideoPath,MyUnitBuzz_LongMessage,From,To,Message_Type
			
			Message_date=os.date("%Y-%m-%dT%H:%M:%S")
			isDeleted="false"
			Created_TimeStamp=os.date("%Y-%m-%dT%H:%M:%S")
			Updated_TimeStamp=os.date("%Y-%m-%dT%H:%M:%S")
			ImagePath="NULL"
			AudioPath="NULL"
			VideoPath="NULL"
			MyUnitBuzz_LongMessage=ChatBox.text
			From=ContactId
			To=To_ContactId
			Message_Type = MessageType

			print( "Created_TimeStamp : "..Created_TimeStamp )

		--	native.showAlert("Type",Message_Type,{CommonWords.ok})

				print(UserId.."\n"..ChatBox.text.."\n"..Message_date.."\n"..isDeleted.."\n"..Created_TimeStamp.."\n"..Updated_TimeStamp.."\n"..MyUnitBuzz_LongMessage.."\n"..From.."\n"..To_ContactId.."\n"..MemberName.."\n end" )
				local insertQuery = [[INSERT INTO pu_MyUnitBuzz_Message VALUES (NULL, ']]..UserId..[[',']]..ChatBox.text..[[','SEND',']]..Message_date..[[',']]..isDeleted..[[',']]..Created_TimeStamp..[[',']]..Updated_TimeStamp..[[',']]..ImagePath..[[',']]..AudioPath..[[',']]..VideoPath..[[',']]..MyUnitBuzz_LongMessage..[[',']]..From..[[',']]..To..[[',']]..Message_Type..[[',']]..title.text..[[',']]..MemberName..[[',']]..title.text..[[');]]
				db:exec( insertQuery )

			Webservice.SEND_MESSAGE(ChatBox.text,"","","","","SEND",From,To,Message_Type,get_sendMssage)


	end

	end

return true
end




	 local function formatSizeUnits(event)

      if (event>=1073741824) then 

      	size=(event/1073741824)..' GB'

      print("size of the image11 ",size)


      elseif (event>=1048576) then   

       	size=(event/1048576)..' MB'

      print("size of the image 22",size)

	  
	  elseif (event > 10485760) then

	  print("highest size of the image ",size)

	    local image = native.showAlert( "Error in Image Upload", "Size of the image cannot be more than 10 MB", { CommonWords.ok } )

	       
      elseif (event>=1024)  then   

      	size = (event/1024)..' KB'

       print("size of the image 33",size)

      else      

  	  end

      --  local alert = native.showAlert(Message.FileSelect, size, {"OK"} , onComplete12)

	end



     local function onImageSelectionComplete ( event )

        print(event.target)
 
        local photo_image = event.target

        local baseDir = system.DocumentsDirectory

        if photo_image then

        photo_image.x = display.contentCenterX
		photo_image.y = display.contentCenterY
		local w = photo_image.width
		local h = photo_image.height
		print( "w,h = ".. w .."," .. h )

		local function rescale()
					
					if photo_image.width > W or photo_image.height > H then

						photo_image.width = photo_image.width/2
						photo_image.height = photo_image.height/2

						intiscale()

					else
               
						return false

					end
				end

				function intiscale()
					
					if photo_image.width > W or photo_image.height > H then

						photo_image.width = photo_image.width/2
						photo_image.height = photo_image.height/2

						rescale()

					else

						return false

					end

				end

				intiscale()

		photoname = "photo.jpg"

        display.save(photo_image,photoname,system.DocumentsDirectory)

        photo_image:removeSelf()

        photo_image = nil


         path = system.pathForFile( photoname, baseDir)

         local size = lfs.attributes (path, "size")

		 local fileHandle = io.open(path, "rb")

		 file_inbytearray = mime.b64( fileHandle:read( "*a" ) )

		 io.close( fileHandle )

            print("mime conversion ",file_inbytearray)

        	print("bbb ",size)

        	formatSizeUnits(size)

        	--sendImage()

	else

	end

end







	local function onCompleteImage( event )
		
		if "clicked"==event.action then

			local i = event.index 

		if 1 == i then

			if media.hasSource( PHOTO_FUNCTION  ) then
			timer.performWithDelay( 100, function() media.selectPhoto( { listener = onImageSelectionComplete, mediaSource = PHOTO_FUNCTION } ) 
			end )
		    end

		elseif 2 == i then

			if media.hasSource( media.Camera ) then
	        timer.performWithDelay( 100, function() media.capturePhoto( { listener = onImageSelectionComplete, mediaSource = media.Camera } ) 
			end )
		    end

		end

	end

	return true
	end



    function UploadImageAction( event )

    	local phase = event.phase

    	if phase=="began" then

    		display.getCurrentStage():setFocus( event.target )

    	elseif phase=="ended" then

    	display.getCurrentStage():setFocus( nil )

        local alert = native.showAlert(Message.FileSelect, Message.FileSelectContent, {Message.FromGallery,Message.FromCamera,"Cancel"} , onCompleteImage)
	
	    return true

        end

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

local function CreateTabBarIcons( )

	if tab_Group_btn ~= nil then if tab_Group_btn.y then tab_Group_btn:removeSelf( );tab_Group_btn=nil end end
	if tab_Message_btn ~= nil then if tab_Message_btn.y then tab_Message_btn:removeSelf( );tab_Message_btn=nil end end
	if tab_Contact_btn ~= nil then if tab_Contact_btn.y then tab_Contact_btn:removeSelf( );tab_Contact_btn=nil end end


	tab_Group_btn = display.newImageRect( tabBarGroup, "res/assert/group.png", 35/1.4, 31/1.4 )
	tab_Group_btn.x=tab_Group.x
	tab_Group_btn.y=tab_Group.y+tab_Group_btn.contentHeight/2-8
	tab_Group_btn.anchorY=0



	tab_Message_btn = display.newImageRect( tabBarGroup, "res/assert/chats.png", 35/1.4, 31/1.4 )
	tab_Message_btn.x=tab_Message.x
	tab_Message_btn.y=tab_Message.y+tab_Message_btn.contentHeight/2-8
	tab_Message_btn.anchorY=0



	tab_Contact_btn = display.newImageRect( tabBarGroup, "res/assert/Consultant.png", 35/1.4, 31/1.4 )
	tab_Contact_btn.x=tab_Contact.x
	tab_Contact_btn.y=tab_Contact.y+tab_Contact_btn.contentHeight/2-8
	tab_Contact_btn.anchorY=0


end


	local function TabbarTouch( event )

		if event.phase == "began" then 

		elseif event.phase == "ended" then
			
			if event.target.id == "message" then

				title.text = "Messages"

			    	CreateTabBarIcons()

			    	tab_Message_btn:removeSelf( );tab_Message_btn=nil

			    	tab_Message_btn = display.newImageRect( tabBarGroup, "res/assert/chats active.png", 35/1.4, 31/1.4 )
					tab_Message_btn.x=tab_Message.x
					tab_Message_btn.y=tab_Message.y+tab_Message_btn.contentHeight/2-8
					tab_Message_btn.anchorY=0
					tab_Message_btn:scale(0.1,0.1)

					tab_Message_txt:setFillColor( Utils.convertHexToRGB(color.tabBarColor) )

					local circle = display.newCircle( tabBarGroup, tab_Message_btn.x, tab_Message_btn.y+tab_Message_btn.contentHeight/2, 25 )
					circle.strokeWidth=4
					circle:scale(0.1,0.1)
					circle.alpha=0.3
					circle:setFillColor( Utils.convertHexToRGB(color.tabBarColor) )
					circle:setStrokeColor( Utils.convertHexToRGB(color.tabBarColor) )

					tab_Group_txt:setFillColor( 0.3 )
					tab_Message_txt:setFillColor( Utils.convertHexToRGB(color.tabBarColor) )
					tab_Contact_txt:setFillColor(  0.3  )


					local function listener1( obj )

						circle:removeSelf( );circle=nil
						tab_Message_btn:scale(0.9,0.9)
					 	
					 	 overlay = display.newImageRect( tabBarGroup, "res/assert/overlay.png", 55,56/1.4)
					    overlay.y=tabBg.y+6;overlay.x=tab_Message_btn.x

					      local options = {
									time = 300,	 
									params = { tabbuttonValue3 =event.target.id}
									}

				    composer.gotoScene( "Controller.MessagingPage", options )
					end


					transition.to( circle, { time=200, delay=100, xScale=1,yScale=1,alpha=0 } )
					transition.to( tab_Message_btn, { time=200, delay=100, xScale=1,yScale=1 , onComplete=listener1} )


			elseif event.target.id == "group" then


				CreateTabBarIcons()


					tab_Group_btn:removeSelf( );tab_Group_btn=nil

					tab_Group_btn = display.newImageRect( tabBarGroup, "res/assert/group active.png", 35/1.4, 31/1.4 )
					tab_Group_btn.x=tab_Group.x
					tab_Group_btn.y=tab_Group.y+tab_Group_btn.contentHeight/2-8
					tab_Group_btn.anchorY=0
					tab_Group_btn:scale(0.1,0.1)

					tab_Group_txt:setFillColor( Utils.convertHexToRGB(color.tabBarColor) )
					tab_Message_txt:setFillColor( 0.3 )
					tab_Contact_txt:setFillColor(  0.3  )

					local circle = display.newCircle( tabBarGroup, tab_Group_btn.x, tab_Group_btn.y+tab_Group_btn.contentHeight/2, 25 )
					circle.strokeWidth=4
					circle:scale(0.1,0.1)
					circle.alpha=0.3
					circle:setFillColor( Utils.convertHexToRGB(color.tabBarColor) )
					circle:setStrokeColor( Utils.convertHexToRGB(color.tabBarColor) )

					local function listener1( obj )

						circle:removeSelf( );circle=nil
						tab_Group_btn:scale(0.8,0.8)

					    overlay = display.newImageRect( tabBarGroup, "res/assert/overlay.png", 55,56/1.4)
					    overlay.y=tabBg.y+6;overlay.x=tab_Group_btn.x

					        local options = {
									time = 300,	  
									params = { tabbuttonValue3 =event.target.id}
									}

				    composer.gotoScene( "Controller.groupPage", options )
					end

					if overlay then if overlay.y then overlay:removeSelf( );overlay=nil end end
					

					transition.to( circle, { time=200, delay=100, xScale=1,yScale=1,alpha=0 } )
					transition.to( tab_Group_btn, { time=220, delay=100, xScale=1.3,yScale=1.3 , onComplete=listener1} )

   				

				
			elseif event.target.id == "contact" then

			    	CreateTabBarIcons()

			    	tab_Contact_btn:removeSelf( );tab_Contact_btn=nil

			    	tab_Contact_btn = display.newImageRect( tabBarGroup, "res/assert/Consultant active.png", 35/1.4, 31/1.4 )
					tab_Contact_btn.x=tab_Contact.x
					tab_Contact_btn.y=tab_Contact.y+tab_Contact_btn.contentHeight/2-8
					tab_Contact_btn.anchorY=0
					tab_Contact_btn:scale(0.1,0.1)

					tab_Contact_txt:setFillColor( Utils.convertHexToRGB(color.tabBarColor) )

					local circle = display.newCircle( tabBarGroup, tab_Contact_btn.x, tab_Contact_btn.y+tab_Contact_btn.contentHeight/2, 25 )
					circle.strokeWidth=4
					circle:scale(0.1,0.1)
					circle.alpha=0.3
					circle:setFillColor( Utils.convertHexToRGB(color.tabBarColor) )
					circle:setStrokeColor( Utils.convertHexToRGB(color.tabBarColor) )

					tab_Group_txt:setFillColor( 0.3 )
					tab_Message_txt:setFillColor( 0.3 )
					tab_Contact_txt:setFillColor(  Utils.convertHexToRGB(color.tabBarColor)  )


					local function listener1( obj )

						circle:removeSelf( );circle=nil
						tab_Contact_btn:scale(0.9,0.9)
					 	
					 	 overlay = display.newImageRect( tabBarGroup, "res/assert/overlay.png", 55,56/1.4)
					    overlay.y=tabBg.y+6;overlay.x=tab_Contact_btn.x

					      local options = {
									time = 300,	 
									params = { tabbuttonValue3 =event.target.id}
									}

				    composer.gotoScene( "Controller.consultantListPage", options )
					end

					transition.to( circle, { time=200, delay=100, xScale=1,yScale=1,alpha=0 } )
					transition.to( tab_Contact_btn, { time=200, delay=100, xScale=1,yScale=1 , onComplete=listener1} )

   				

			end

	    end

    return true 

	end

	local function scrollAction(value)

		       		-- if value == 0 then
		       		-- else

		       		-- end
	ChatScrollContent.y=value

	end


	local function ChatBoxHandler( event )

   		 if ( event.phase == "began" ) then
        -- user begins editing numericField

        scrollAction(-140)


        elseif event.phase == "submitted" then
       		
       		

       	elseif event.phase == "ended" then

       		scrollAction(0)

        elseif event.phase == "editing" then

        	if (event.newCharacters=="\n") then
				native.setKeyboardFocus( nil )
			end

				if event.text:len() > 250 then

						event.target.text = event.text:sub(1,250)

			

					end

        	if event.text:len() >=1 then


        		sendBtn.isVisible=true
        		recordBtn.isVisible=false
        	else
        		sendBtn.isVisible=false
        		recordBtn.isVisible=true
        	end


	    end   
	end

	local function RecordAction(event)


		local filePath = system.pathForFile( "newRecording.wav", system.DocumentsDirectory )
		local r = media.newRecording( filePath )

		if event.phase == "began" then
			display.getCurrentStage():setFocus( event.target )

			 
			 
			
			r:startRecording()

			ChatBox.text="Start Recoding...."


		elseif event.phase == "ended" then
				display.getCurrentStage():setFocus( nil )

				ChatBox.text=""
				r:stopRecording()


		end

return true


	end

	local function scrollListener( event )

    local phase = event.phase
   
    if ( phase == "began" ) then print( "Scroll view was touched" )
    elseif ( phase == "moved" ) then print( "Scroll view was moved" )
    elseif ( phase == "ended" ) then print( "Scroll view was released" )

    	print( #ChatHistory )

    	if #ChatHistory < 10 then
    		chatScroll:scrollTo( "bottom", { time=500 } )
    	end
    end

    -- In the event a scroll limit is reached...
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

	title_bg = display.newRect(sceneGroup,0,0,W,30)
	title_bg.x=W/2;title_bg.y = tabBar.y+tabBar.contentHeight-5
	title_bg:setFillColor( Utils.convertHexToRGB(color.tabbar) )

	BackBtn = display.newText( sceneGroup, "<", 0, 0 , native.systemFontBold ,16 )
	BackBtn.anchorX = 0
	BackBtn.x=5;BackBtn.y = title_bg.y
	BackBtn:setFillColor(0)

	title = display.newText(sceneGroup,FlapMenu.chatMessageTitle,0,0,native.systemFont,18)
	title.anchorX = 0
	title.x=BackBtn.x+BackBtn.contentWidth+5;title.y = title_bg.y
	title:setFillColor(0)

	title.text = "Chat"





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



		title.text = ContactDetails.Name or ContactDetails.ToName or ContactDetails.MyUnitBuzzGroupName



		To_ContactId = ContactDetails.Contact_Id or ContactDetails.Message_To or ContactDetails.MyUnitBuzzGroupId

		if ContactDetails.MyUnitBuzzGroupId ~= nil then

			MessageType = "GROUP"

		else

			MessageType = "INDIVIDUAL"

		end

		if ContactDetails.Message_Type then

			MessageType=ContactDetails.Message_Type

		end
		print( MessageType )
		ChatBox_bg = display.newRect(ChatScrollContent,0,H-100, W-50, 40 )
		ChatBox_bg.anchorY=0;ChatBox_bg.anchorX=0
		ChatBox_bg.x=5
		ChatBox_bg.strokeWidth = 1
		ChatBox_bg:setStrokeColor( Utils.convertHexToRGB(color.LtyGray))

		ChatBox = native.newTextBox( 0, ChatBox_bg.y, ChatBox_bg.contentWidth, ChatBox_bg.contentHeight-5 )
		ChatBox.isEditable = true
		ChatBox.anchorY=0;ChatBox.anchorX=0
		ChatBox.x=ChatBox_bg.x
		ChatBox.hasBackground = false
		ChatScrollContent:insert( ChatBox )

		-- cameraBtn = display.newImageRect( sceneGroup, "res/assert/user.png", 25,20 )
		-- cameraBtn.x=ChatBox_bg.x+ChatBox_bg.contentWidth-35
		-- cameraBtn.y=ChatBox_bg.y+ChatBox_bg.contentHeight/2-cameraBtn.contentHeight/2
		-- cameraBtn.anchorY=0;cameraBtn.anchorX=0
		-- cameraBtn.isVisible=true

		sendBtn = display.newImageRect( ChatScrollContent, "res/assert/msg_send.png", 25,20 )
		sendBtn.x=ChatBox_bg.x+ChatBox_bg.contentWidth+5
		sendBtn.y=ChatBox_bg.y+ChatBox_bg.contentHeight/2-sendBtn.contentHeight/2
		sendBtn.anchorY=0;sendBtn.anchorX=0
		sendBtn.isVisible=false

		sendBtn_bg = display.newRect( ChatScrollContent, sendBtn.x+5, sendBtn.y+5, 45,45 )
		sendBtn_bg:setFillColor( 0,0,0,0.01 )

		recordBtn = display.newImageRect( ChatScrollContent, "res/assert/record.png", 25,20 )
		recordBtn.x=ChatBox_bg.x+ChatBox_bg.contentWidth+5
		recordBtn.y=ChatBox_bg.y+ChatBox_bg.contentHeight/2-recordBtn.contentHeight/2
		recordBtn.anchorY=0;recordBtn.anchorX=0


		chatScroll = widget.newScrollView(
    {
        top = 125,
        left = 0,
        width = W,
        height = H-175,
        listener = scrollListener,
        hideBackground=true,
        hideScrollBar=true,
       
    }
)

		chatScroll.anchorY=0
		chatScroll.anchorX=0
		chatScroll.x=0;chatScroll.y=title_bg.y+title_bg.contentHeight/2
		ChatScrollContent:insert( chatScroll )

		sendMeaasage()

		sceneGroup:insert( ChatScrollContent )


			--Tabbar---



tabBg = display.newRect( tabBarGroup, W/2, H-40, W, 40 )
tabBg.anchorY=0
tabBg.strokeWidth = 1
tabBg:setStrokeColor( Utils.convertHexToRGB(color.tabBarColor),0.7 )

tab_Group = display.newRect(tabBarGroup,0,0,70,40)
tab_Group.x=W/2-W/3;tab_Group.y=tabBg.y
tab_Group.anchorY=0
tab_Group.alpha=0.01
tab_Group.id="group"
tab_Group:setFillColor( 0.2 )

tab_Message = display.newRect(tabBarGroup,0,0,70,40)
tab_Message.x=W/2;tab_Message.y=tabBg.y
tab_Message.anchorY=0
tab_Message.alpha=0.01
tab_Message.id="message"
tab_Message:setFillColor( 0.2 )

tab_Contact = display.newRect(tabBarGroup,0,0,70,40)
tab_Contact.x=W/2+W/3;tab_Contact.y=tabBg.y
tab_Contact.anchorY=0
tab_Contact.alpha=0.01
tab_Contact.id="contact"
tab_Contact:setFillColor( 0.2 )

tab_Group:addEventListener( "touch", TabbarTouch )
tab_Message:addEventListener( "touch", TabbarTouch )
tab_Contact:addEventListener( "touch", TabbarTouch )

CreateTabBarIcons()

	if tab_Message_btn then tab_Message_btn:removeSelf( );tab_Message_btn=nil end

	tab_Message_btn = display.newImageRect( tabBarGroup, "res/assert/chats active.png", 35/1.4, 31/1.4 )
	tab_Message_btn.x=tab_Message.x
	tab_Message_btn.y=tab_Message.y+tab_Message_btn.contentHeight/2-8
	tab_Message_btn.anchorY=0

	overlay = display.newImageRect( tabBarGroup, "res/assert/overlay.png", 55,56/1.4)
	overlay.y=tabBg.y+6;overlay.x=tab_Message_btn.x

tab_Group_txt = display.newText( tabBarGroup, "Group",0,0,native.systemFont,11 )
tab_Group_txt.x=tab_Group_btn.x;tab_Group_txt.y=tab_Group_btn.y+tab_Group_btn.contentHeight+5
tab_Group_txt:setFillColor( 0.3 )


tab_Message_txt = display.newText( tabBarGroup, "Chats",0,0,native.systemFont,11 )
tab_Message_txt.x=tab_Message_btn.x;tab_Message_txt.y=tab_Message_btn.y+tab_Message_btn.contentHeight+5
tab_Message_txt:setFillColor( 0.3 )

tab_Contact_txt = display.newText( tabBarGroup, "Consultant List",0,0,native.systemFont,11 )
tab_Contact_txt.x=tab_Contact_btn.x;tab_Contact_txt.y=tab_Contact_btn.y+tab_Contact_btn.contentHeight+5
tab_Contact_txt:setFillColor( 0.3 )

sceneGroup:insert( tabBarGroup )


		sendBtn_bg:addEventListener( "touch", ChatSendAction )
		--cameraBtn:addEventListener("touch", UploadImageAction)
		menuBtn:addEventListener("touch",menuTouch)
		ChatBox:addEventListener( "userInput", ChatBoxHandler )
		recordBtn:addEventListener( "touch", RecordAction )

		function printTimeSinceStart( event )

			tabBar:toFront( );menuBtn:toFront( );BgText:toFront( );title_bg:toFront( );title:toFront( );BackBtn:toFront( )

		    if chatReceivedFlag==true then


		    	chatReceivedFlag=false
		    	sendMeaasage()
		    end
		end 
		Runtime:addEventListener( "enterFrame", printTimeSinceStart )
		Runtime:addEventListener( "key", onKeyEvent )
		BackBtn:addEventListener( "touch", backAction )
		title:addEventListener( "touch", backAction )
		
	end	



	
MainGroup:insert(sceneGroup)

end

	function scene:hide( event )

		local sceneGroup = self.view
		local phase = event.phase

		if event.phase == "will" then

					Runtime:removeEventListener( "enterFrame", printTimeSinceStart )
					Runtime:removeEventListener( "key", onKeyEvent )


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
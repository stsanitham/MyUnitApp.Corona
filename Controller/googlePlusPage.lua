	----------------------------------------------------------------------------------
--
-- google plus Screen
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

local Utility = require( "Utils.Utility" )
local json = require( "json" )
local widget = require( "widget" )
local path = system.pathForFile( "MyUnitBuzz.db", system.DocumentsDirectory )
local db = sqlite3.open( path )


--------------- Initialization -------------------

local W = display.contentWidth;H= display.contentHeight

local Background,BgText

local menuBtn



--local User_id="101096891522352574060"
local AccessApi = "AIzaSyCWHBLU9okAnzMk1Y_AP1XJKZZ0RCCsipQ";


local User_id

for row in db:nrows("SELECT * FROM logindetails WHERE id=1") do
	print("User : "..row.GoogleUserId)

	print("Secret : "..row.GoogleToken)

	User_id = row.GoogleUserId
--AccessApi = row.GoogleToken
end


local scrollView
local groupArray={}

local feedArray={}

local RecentTab_Topvalue = 70

local User_name=""

local BackFlag = false

local feedProcess = 10

local feedCount=0


--------------------------------------------------


-----------------Function-------------------------
local function linkTouch( event )
	if event.phase == "ended" then
		system.openURL( event.target.value )
	end
return true
end

function googleplusCallback( res,scrollView,flag )

	spinner_hide()

	if flag == true then

		for i=1,#groupArray do
			groupArray[i]:removeSelf();groupArray[i]=nil
		end

	end



	feedArray=res

	for i=1,10 do

		feedCount = feedCount+1 

		groupArray[#groupArray+1] = display.newGroup()

		local tempGroup = groupArray[#groupArray]

		local bgsize

	if feedArray[feedCount] ~= nil then

		if feedArray[feedCount].object.attachments then

			bgsize = 180
		else
			bgsize = 68
		end



		local background = display.newRect(tempGroup,0,0,W-80,bgsize)

		local tempHeight = 20

		if groupArray[#groupArray-1] ~= nil then

				tempHeight = groupArray[#groupArray-1][1].y + groupArray[#groupArray-1][1].contentHeight+5

			
		end

		background.x=W/2+30;background.y=tempHeight
		background.anchorY = 0
		background:setFillColor(Utils.convertHexToRGB("#d2d3d4"))


		profilePic = display.newImage("usergoogleplus.png", system.TemporaryDirectory)
		if not profilePic then
			profilePic = display.newImageRect("assert/twitter_placeholder.png",100,100)
		end
		profilePic.width=55;profilePic.height=50

					tempGroup:insert(profilePic)

									local mask = graphics.newMask( "res/assert/mask2.png" )

									profilePic:setMask( mask )

		tempGroup:insert(profilePic)
		


		local time = tostring(os.date("%Y-%b-%d %I:%M %p", Utils.makeTimeStamp(feedArray[feedCount].published)));



		userTime = display.newText( tempGroup, time, 0, 0, native.systemFont, 11 )
		userTime.anchorX = 0
		userTime.anchorY = 0
		Utils.CssforTextView(userTime,sp_Date_Time)
		userTime:setFillColor( Utils.convertHexToRGB(color.tabBarColor) )


		username = display.newText( tempGroup, User_name, 0, 0,100,0, native.systemFont, 14 )

		username.anchorX = 0
		username.anchorY = 0
		
		username:setFillColor(41/255,129/255,203/255)

		local rowTitle

		if not feedArray[feedCount].title then

			rowTitle = display.newText( tempGroup," ", 0, 0,native.systemFont, 18 )

		else

			local optionsread = {
			text = feedArray[feedCount].title,
			x = display.contentCenterX,
			y = display.contentCenterY,
			fontSize = 11,
			width = 220,
			height = 0,
			align = "left"
		}

		rowTitle = display.newText( optionsread )

	end
	tempGroup:insert(rowTitle)
	rowTitle.anchorX = 0

	rowTitle:setFillColor(0)


	

	background.height = background.height+rowTitle.height

								background.y=tempHeight

								local background_arrow = display.newImageRect( tempGroup, "res/assert/arrow3.png", 11,20 )
								background_arrow.x=background.x-background.contentWidth/2-background_arrow.contentWidth/2+1
								background_arrow.y=background.y+background_arrow.contentHeight/2+5
								background.alpha=0.8


	profilePic.x=background.x-background.contentWidth/2-profilePic.contentWidth/2-10
								profilePic.y=background.y+profilePic.height/2-5

	username.x=profilePic.x+profilePic.contentWidth/2+15
	username.y=background.y+5

	userTime.x=background.x+background.contentWidth/2-userTime.contentWidth-5
	userTime.y=background.y+5

	local line = display.newRect( tempGroup, 0, 0, background.contentWidth-10, 1 )
									line:setFillColor( Utils.convertHexToRGB(color.Gray) )
									line.x=background.x;line.y=username.y+username.contentHeight+4

	rowTitle.anchorY=0
	rowTitle.x=username.x
								rowTitle.y=username.y+username.contentHeight+8


	local function postedimg_position( event )
		if ( event.isError ) then
			print ( "Network error - download failed" )
		else

			event.target.width=200
			event.target.height=100

			tempGroup:insert(event.target)

			
		end

	end

	if feedArray[feedCount].object.attachments then

		local img = feedArray[feedCount].object.attachments
		if(img[1].image ~= nil ) then
			local shared_img = display.loadRemoteImage(img[1].image.url, "GET", postedimg_position, feedCount..".png", system.TemporaryDirectory,100+rowTitle.x,rowTitle.y+rowTitle.contentHeight+55 )
			
		

		
			
		else

			background.height = background.height-110

		end

	end


				local img = feedArray[feedCount].object.attachments
				local link = display.newText(tempGroup,feedArray[feedCount].url,0,0,native.systemFont,12)
				link:setFillColor( 0,0,1 )
				link.anchorX = 0
				link.anchorY = 0
				link.value = feedArray[feedCount].url
				link.x = username.x
				link.y =  background.y+background.contentHeight-20
				link:addEventListener( "touch", linkTouch )

				if img ~= nil then

					if rowTitle.text == "" or rowTitle.text == nil then
						rowTitle.text = img[1].displayName
					end

				if string.find( link.text, "https:" ) == nil then
					link.text = img[1].url or "https:"..link.text
					link.value = link.text
				end
				end

				if link.text:len() > 35 then
					link.text = string.sub( link.text,1,35).."..."
				end


			local line = display.newLine( link.x, background.y+background.contentHeight-5, link.x+link.contentWidth,  background.y+background.contentHeight-5  )
			line:setStrokeColor( Utils.convertHexToRGB(color.blue) )
			line.strokeWidth = 1
			tempGroup:insert( line )

	scrollView:insert(tempGroup)

end
end
end

local function getgoogleplus_stream( event )
	if ( event.isError ) then

		print("error")

	else



		local response =  json.decode(event.response)


		if response ~= nil then

					print ( "RESPONSE: " .. json.encode(response.items ))


			response = response.items

			User_name=response[1].actor.displayName


			local function profilepic_download( event )
				if ( event.isError ) then
					print ( "Network error - download failed" )
				else

					if feedCount == 0 then

						googleplusCallback(response,scrollView,true)

					else

						googleplusCallback(response,scrollView,false)
					end
				end

			end
			network.download(
				response[1].actor.image.url,
				"GET",
				profilepic_download,
				"usergoogleplus.png",
				system.TemporaryDirectory
				)

		end

	end
end


local function Google_scrollListener( event )

		    local phase = event.phase
		    if ( phase == "began" ) then 
		    elseif ( phase == "moved" ) then 
		    elseif ( phase == "ended" ) then 
		    end

		    -- In the event a scroll limit is reached...
		    if ( event.limitReached ) then
		        if ( event.direction == "up" ) then print( "Reached bottom limit" )

		        	spinner_show()

		        	feedProcess = feedProcess + 10

		        	 network.request( "https://www.googleapis.com/plus/v1/people/"..User_id.."/activities/public/?maxResults="..feedProcess.."&key="..AccessApi, "GET", getgoogleplus_stream )
		   

		        elseif ( event.direction == "down" ) then print( "Reached top limit" )

		        		feedProcess = 10

		        		feedCount = 0

		        		spinner_show()

 			        	 network.request( "https://www.googleapis.com/plus/v1/people/"..User_id.."/activities/public/?maxResults="..feedProcess.."&key="..AccessApi, "GET", getgoogleplus_stream )
		        elseif ( event.direction == "left" ) then print( "Reached right limit" )
		        elseif ( event.direction == "right" ) then print( "Reached left limit" )
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


	title = display.newText(sceneGroup,Google_Plus.PageTitle,0,0,native.systemFont,18)
	title.anchorX = 0
	title.x=5;title.y = title_bg.y
	title:setFillColor(0)


	
	MainGroup:insert(sceneGroup)

end

function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	openPage="googlePlusPage"
	
	if phase == "will" then

		ga.enterScene("Google +")

		elseif phase == "did" then

			composer.removeHidden()

			scrollView = widget.newScrollView
			{
			top = RecentTab_Topvalue,
			left = 0,
			width = W,
			height =H-RecentTab_Topvalue,
			hideBackground = true,
			isBounceEnabled=true,
			horizontalScrollDisabled = true,
	   		scrollWidth = W,
			bottomPadding=20,
   			listener = Google_scrollListener,
}



sceneGroup:insert(scrollView)

 network.request( "https://www.googleapis.com/plus/v1/people/"..User_id.."/activities/public/?maxResults="..feedProcess.."&key="..AccessApi, "GET", getgoogleplus_stream )

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


		elseif phase == "did" then

			menuBtn:removeEventListener("touch",menuTouch)
			BgText:removeEventListener("touch",menuTouch)

			Runtime:removeEventListener( "key", onKeyEvent )

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
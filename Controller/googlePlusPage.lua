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

local RecentTab_Topvalue = 40

local User_name=""

--------------------------------------------------


-----------------Function-------------------------


function googleplusCallback( res,scrollView )

	spinner_hide()

	for i=1,#groupArray do
		groupArray[i]:removeSelf();groupArray[i]=nil
	end
	feedArray=res
	print(#feedArray)

	for i=1,#feedArray do

		groupArray[#groupArray+1] = display.newGroup()

		local tempGroup = groupArray[#groupArray]

		local bgsize

		if feedArray[i].object.attachments then

			bgsize = 200
		else
			bgsize = 100
		end



		local background = display.newRect(tempGroup,0,0,W,bgsize)

		local tempHeight = 0

		if(groupArray[#groupArray-1]) then

			tempHeight = groupArray[#groupArray-1][1].y + groupArray[#groupArray-1][1].contentHeight+5
		end

		background.x=W/2;background.y=tempHeight
		background.anchorY = 0
		background:setFillColor(1)


		profilePic = display.newImage("usergoogleplus.png", system.TemporaryDirectory)
		if not profilePic then
			profilePic = display.newImageRect("assert/twitter_placeholder.png",100,100)
		end
		profilePic.width=40;profilePic.height=40

		tempGroup:insert(profilePic)
		


		local time = tostring(os.date("%Y-%b-%d %H:%m %p", Utils.makeTimeStamp(feedArray[i].published)));



		userTime = display.newText( tempGroup, time, 0, 0, native.systemFontBold, 11 )

		userTime.anchorX = 0
		
		userTime:setFillColor(125/255,125/255,125/255)


		username = display.newText( tempGroup, User_name, 0, 0, native.systemFontBold, 18 )

		username.anchorX = 0
		
		username:setFillColor(41/255,129/255,203/255)


		if not feedArray[i].title then

			rowTitle = display.newText( tempGroup," ", 0, 0,native.systemFontBold, 18 )

		else

			local optionsread = {
			text = feedArray[i].title,
			x = display.contentCenterX,
			y = display.contentCenterY,
			fontSize = 11,
			width = 280,
			height = 0,
			align = "left"
		}

		rowTitle = display.newText( optionsread )

	end
	tempGroup:insert(rowTitle)
	rowTitle.anchorX = 0

	rowTitle:setFillColor(0)

	

	background.height = background.height+rowTitle.contentHeight/1.5

	background.x=W/2;background.y=tempHeight


	profilePic.x=background.x-background.contentWidth/2+profilePic.contentWidth/2+5
	profilePic.y=background.y+profilePic.contentHeight/2+15

	userTime.x=background.contentWidth-userTime.contentWidth
	userTime.y=profilePic.y-profilePic.contentHeight/2-5

	username.x=profilePic.x+profilePic.contentWidth/2+10
	username.y=profilePic.y-profilePic.contentHeight/2+username.contentHeight/2

	rowTitle.x=profilePic.x-profilePic.contentWidth/2
	rowTitle.y=profilePic.y+rowTitle.contentHeight/2+25


	local function postedimg_position( event )
		if ( event.isError ) then
			print ( "Network error - download failed" )
		else

			event.target.width=200
			event.target.height=100

			tempGroup:insert(event.target)
		end

	end

	if feedArray[i].object.attachments then

		local img = feedArray[i].object.attachments
		if(img[1].image ~= nil ) then
			local shared_img = display.loadRemoteImage(img[1].image.url, "GET", postedimg_position, i..".png", system.TemporaryDirectory,100+profilePic.x-profilePic.contentWidth/2,rowTitle.y+rowTitle.contentHeight+55 )
		end

	end
	scrollView:insert(tempGroup)

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
					googleplusCallback(response,scrollView)
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


local function getFeed()



	User_id = tostring(defaultField.text)
	
 --User_id = "2154857409"
 network.request( "https://www.googleapis.com/plus/v1/people/"..User_id.."/activities/public?key="..AccessApi, "GET", getgoogleplus_stream )

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
			isBounceEnabled=false,
			horizontalScrollingDisabled = false,
			verticalScrollingDisabled = false,

   -- listener = scrollListener
}



sceneGroup:insert(scrollView)

network.request( "https://www.googleapis.com/plus/v1/people/"..User_id.."/activities/public?key="..AccessApi, "GET", getgoogleplus_stream )

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
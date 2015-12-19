----------------------------------------------------------------------------------
--
-- twitter Screen
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

local stringValue = require( "res.value.string" )
local Utility = require( "Utils.Utility" )
local TwitterManager = require( "Utils.Twitter" )
local widget = require( "widget" )
local json = require("json")
local http = require "socket.http"
local path = system.pathForFile( "MyUnitBuzz.db", system.DocumentsDirectory )
local db = sqlite3.open( path )

--------------- Initialization -------------------

local W = display.contentWidth;H= display.contentHeight

local Background,BgText

local menuBtn,UserName



local groupArray={}
local callback = {}
local TwiiteAction,scrollView
local feedArray = {}

local RecentTab_Topvalue = 40


for row in db:nrows("SELECT * FROM logindetails WHERE id=1") do
	print(row.TwitterToken)
UserName = row.TwitterUsername -- key string goes here

end
--------------------------------------------------


-----------------Function-------------------------

function TwitterCallback(res,scrollView)
	--local feedArray = {{name="dsfd",text="malar"},{name="dsfd",text="malar"},{name="dsfd",text="malar"},{name="dsfd",text="malar"},{name="dsfd",text="malar"},{name="dsfd",text="malar"},{name="dsfd",text="malar"},{name="dsfd",text="malar"},{name="dsfd",text="malar"}}


	feedArray = res

	spinner_hide()

	local function networkListener( event )
		if ( event.isError ) then
			print ( "Network error - download failed" )
		else

			for j=#groupArray, 1, -1 do 
				display.remove(groupArray[#groupArray])
				groupArray[#groupArray] = nil
			end

			for i=1,#feedArray do

				if feedArray[i].text and feedArray[i].text ~= nil   then

					groupArray[#groupArray+1] = display.newGroup()

					local tempGroup = groupArray[#groupArray]

					
					local background = display.newRect(tempGroup,0,0,W,80)

					local tempHeight = 0

					if(groupArray[#groupArray-1]) then

						tempHeight = groupArray[#groupArray-1][1].y + groupArray[#groupArray-1][1].contentHeight+3
					end

					background.anchorY = 0

					background.x=W/2;background.y=tempHeight
					background:setFillColor(1)

					profilePic = display.newImage("userPhoto.png", system.TemporaryDirectory)
					if not profilePic then
						profilePic = display.newImageRect("assert/twitter_placeholder.png",100,100)
					end
					profilePic.width=40;profilePic.height=40

					tempGroup:insert(profilePic)
					

					userTime = display.newText( tempGroup, tostring(os.date("%Y-%b-%d %H:%m %p", feedArray[i].created_time)), 0, 0, native.systemFontBold, 11 )

					userTime.anchorX = 0
					
					userTime:setFillColor(125/255,125/255,125/255)
					if not feedArray[i].user then

						rowTitle = display.newText( tempGroup,"test", 0, 0,native.systemFontBold, 18 )

					else

						local userArray = feedArray[i].user


						rowTitle = display.newText( tempGroup, userArray.name.." @"..userArray.screen_name, 0, 0, native.systemFontBold, 14 )

					end
					rowTitle.anchorX = 0
					
					rowTitle:setFillColor(41/255,129/255,203/255)



					local rowStory


					if not feedArray[i].text then

						rowStory = display.newText( tempGroup, "", 0, 0, native.systemFont, 11 )

					else 



						local options = {
						text = feedArray[i].text,
						x = display.contentCenterX,
						y = display.contentCenterY,
						fontSize = 11,
						width = 250,
						height = 100,
						align = "left"
					}


					rowStory = display.newText( options )

				end


				rowStory:setFillColor( 0 )
				tempGroup:insert(rowStory)
				rowStory.anchorX = 0


				background.height = background.height+rowStory.contentHeight/1.5

				background.x=W/2;background.y=tempHeight


				profilePic.x=background.x-background.contentWidth/2+profilePic.contentWidth/2+5
				profilePic.y=background.y+profilePic.contentHeight/2+15

				userTime.x=background.contentWidth-userTime.contentWidth
				userTime.y=profilePic.y-profilePic.contentHeight/2-5

				rowTitle.x=profilePic.x+profilePic.contentWidth/2+10
				rowTitle.y=profilePic.y-profilePic.contentHeight/2+rowTitle.contentHeight/2


				rowStory.x = rowTitle.x
				rowStory.y = rowTitle.y+60

				scrollView:insert(tempGroup)

			end
		end

	end
end

network.download(
	feedArray[1].user.profile_image_url,
	"GET",
	networkListener,
	"userPhoto.png",
	system.TemporaryDirectory
	)



end


function callback.twitterCancel()
	print( "Twitter Cancel" )

	test_response.text = "Twitter Cancel" 

end

function callback.twitterSuccess( requestType, name, res )


	local response = json.decode( res )

	local results = ""

	print( "Twitter msg : "..res )

	if "friends" == requestType then
	results = response.users[1].name .. ", count: " ..
	response.users[1].statuses_count
end

if "users" == requestType then

	TwitterCallback(response,scrollView)

end

if "tweet" == requestType then
	results = "Tweet Posted"
	native.showAlert( "Result", "Tweet Posted", { "Ok" } )

end

print( results )
--test_response.text = results	

end

function callback.twitterFailed()
	print( "Failed: Invalid Token" )

	native.showAlert( "Result", "Failed: Invalid Token", { "Ok" } )

end

local function recent_tweet()
	if UserName ~= "" then
		local params = {"users", "statuses/user_timeline.json", "GET",
		{"screen_name", UserName}, {"skip_status", "true"},
		{"include_entities", "false"} }
		TwitterManager.tweet(callback, params)
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

recent_tweet()

MainGroup:insert(sceneGroup)

end

function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	openPage="twitterPage"
	
	if phase == "will" then


		elseif phase == "did" then
			composer.removeHidden()
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
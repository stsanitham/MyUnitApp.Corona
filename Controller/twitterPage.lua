----------------------------------------------------------------------------------
--
-- twitter Screen
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
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

local RecentTab_Topvalue = 70

local FeedCount = 0

local FeedProcess = 10

local TwitterFlag = true

local BackFlag = false


for row in db:nrows("SELECT * FROM logindetails WHERE id=1") do
	print(row.TwitterToken)
UserName = row.TwitterUsername -- key string goes here

end
--------------------------------------------------




-----------------Function-------------------------

function makeTimeStamp( dateString )
   local pattern = "(%d+)%-(%d+)%-(%d+)%a(%d+)%:(%d+)%:([%d%.]+)([Z%p])(%d%d)%:?(%d%d)"
   local year, month, day, hour, minute, seconds, tzoffset, offsethour, offsetmin = dateString:match(pattern)
   local timestamp = os.time(
      { year=year, month=month, day=day, hour=hour, min=minute, sec=seconds }
   )
   local offset = 0
   if ( tzoffset ) then
      if ( tzoffset == "+" or tzoffset == "-" ) then  -- We have a timezone

      	print( "offsethour : "..offsethour )
         offset = offsethour * 60 + offsetmin
         if ( tzoffset == "-" ) then
            offset = offset * -1
         end
         timestamp = timestamp + offset
      end
   end


   return timestamp
end

function TwitterCallback(res,scrollView)
	--local feedArray = {{name="dsfd",text="malar"},{name="dsfd",text="malar"},{name="dsfd",text="malar"},{name="dsfd",text="malar"},{name="dsfd",text="malar"},{name="dsfd",text="malar"},{name="dsfd",text="malar"},{name="dsfd",text="malar"},{name="dsfd",text="malar"}}


	feedArray = res

	

	local function networkListener( event )

		spinner_hide()
		
		if ( event.isError ) then
			print ( "Network error - download failed" )
		else

			if TwitterFlag == true then

				for j=#groupArray, 1, -1 do 
					display.remove(groupArray[#groupArray])
					groupArray[#groupArray] = nil
				end

			end

			for i=1,10 do

				FeedCount = FeedCount + 1

				if feedArray[FeedCount] ~= nil then


					groupArray[#groupArray+1] = display.newGroup()

					local tempGroup = groupArray[#groupArray]

						local bgheight = 0

							if feedArray[FeedCount].picture ~= nil then
	
								bgheight = 100

							end
		
							bgheight = bgheight+20


					
					local background = display.newRect(tempGroup,0,0,W-80,bgheight)

					local tempHeight = 20

					if(groupArray[#groupArray-1]) then

						tempHeight = groupArray[#groupArray-1][1].y + groupArray[#groupArray-1][1].contentHeight+3
					end

					background.anchorY = 0
					background.x=W/2+30;background.y=Initial_Height
					background:setFillColor(Utils.convertHexToRGB("#d2d3d4"))

					profilePic = display.newImage("userPhoto.png", system.TemporaryDirectory)
					if not profilePic then
						profilePic = display.newImageRect("assert/twitter_placeholder.png",100,100)
					end
					profilePic.width=55;profilePic.height=50

					local mask = graphics.newMask( "res/assert/mask2.png" )

					profilePic:setMask( mask )

					tempGroup:insert(profilePic)


					local makeTimeStamp = function ( dateString )

						print(dateString)

						if string.find(dateString,"+0000") ~= nil then
							dateString = string.gsub(dateString,"+0000","")
						end
						--dateString="Mon Oct 15 12:56:52 2014"

						local pattern = "(%a+) (%a+)% (%d+) (%d+):(%d+):(%d+)  (%d+)"
						--local day, month, date, hour, minute, seconds, year = dateString:match(pattern)

						local weekday,month,day,hour, minute, seconds,year= dateString:match(pattern)

						print(weekday,table.indexOf( MonthNumber, "Jan" ),day,hour, minute, seconds,year)

				

						local timestamp = os.time( {year=year, month=table.indexOf( MonthNumber, month ), day=day, hour=hour, min=minute, sec=seconds, isdst=false} )

						return timestamp;
					end


					
					local time = makeTimeStamp(feedArray[i].created_at)

					local timeValue = Utils.getTime(time,"%b-%d-%Y %I:%M %p",TimeZone)

					userTime = display.newText( tempGroup, timeValue , 0, 0, native.systemFont, 11 )
					userTime.anchorX = 0
					userTime.anchorY = 0
					Utils.CssforTextView(userTime,sp_Date_Time)
					userTime:setFillColor( Utils.convertHexToRGB(color.tabBarColor) )

				

						local userArray = feedArray[FeedCount].user or ""


						rowTitle = display.newText( tempGroup, userArray.name.." @"..userArray.screen_name, 50, 0,100,0, native.systemFont, 12 )

					
					rowTitle.anchorX = 0
					rowTitle.anchorY = 0
					
					rowTitle:setFillColor(41/255,129/255,203/255)


					local line = display.newRect( tempGroup, 0, 0, background.contentWidth-10, 1 )
					line:setFillColor( Utils.convertHexToRGB(color.Gray) )
					line.anchorY = 0


					local rowStory


				

										local optionsread = {
										text = feedArray[FeedCount].text or "",
										x = display.contentCenterX,
										y = rowTitle.y+rowTitle.contentHeight+5,
										fontSize = 11,
										width = 210,
										height = 0,
										align = "left"
									}

					rowStory = display.newText( optionsread )

			


				rowStory:setFillColor( 0 )
				tempGroup:insert(rowStory)
				rowStory.anchorX = 0
				rowStory.anchorY = 0


				background.height = background.height+rowStory.height+rowTitle.height

				background.y=tempHeight

								local background_arrow = display.newImageRect( tempGroup, "res/assert/arrow3.png", 11,20 )
								background_arrow.x=background.x-background.contentWidth/2-background_arrow.contentWidth/2+1
								background_arrow.y=background.y+background_arrow.contentHeight/2+5
								background.alpha=0.8


								profilePic.x=background.x-background.contentWidth/2-profilePic.contentWidth/2-10
								profilePic.y=background.y+profilePic.height/2-5

								userTime.x=background.x+background.contentWidth/2-userTime.contentWidth-5
								userTime.y=background.y+5

								rowTitle.x=background.x-background.contentWidth/2+5
								rowTitle.y=background.y+5

								line.x=background.x;line.y=rowTitle.y+rowTitle.contentHeight+3
								rowStory.x = rowTitle.x
								rowStory.y = rowTitle.y+rowTitle.contentHeight+8



				scrollView:insert(tempGroup)

			end
		end

	end
end

spinner_show()

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
		{"include_entities", "false"},{"count",tostring(FeedProcess)} }
		TwitterManager.tweet(callback, params)
	end
end

	local function Twitter_scrollListener( event )

		    local phase = event.phase
		    if ( phase == "began" ) then 




		    elseif ( phase == "moved" ) then 
		    elseif ( phase == "ended" ) then 
		    end

		    -- In the event a scroll limit is reached...
		    if ( event.limitReached ) then
		        if ( event.direction == "up" ) then print( "Reached bottom limit" )

		        	TwitterFlag = false

		        	local params = {"users", "statuses/user_timeline.json", "GET",
					{"screen_name", UserName}, {"skip_status", "true"},
					{"include_entities", "false"},{"count",tostring(FeedCount+FeedProcess)} }
					TwitterManager.tweet(callback, params)

		        elseif ( event.direction == "down" ) then print( "Reached top limit" )

		        	TwitterFlag = true

			    	FeedCount = 0

			    	FeedProcess = 10

		        	local params = {"users", "statuses/user_timeline.json", "GET",
					{"screen_name", UserName}, {"skip_status", "true"},
					{"include_entities", "false"},{"count",tostring(FeedCount+FeedProcess)} }
					TwitterManager.tweet(callback, params)


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


	title = display.newText(sceneGroup,Twitter.PageTitle,0,0,native.systemFont,18)
	title.anchorX = 0
	title.x=5;title.y = title_bg.y
	title:setFillColor(0)


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
    listener = Twitter_scrollListener,

}



sceneGroup:insert(scrollView)
spinner_show()
recent_tweet()

MainGroup:insert(sceneGroup)

end

function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	openPage="twitterPage"
	
	ga.enterScene("Twitter")
	
	if phase == "will" then


		elseif phase == "did" then
			composer.removeHidden()
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
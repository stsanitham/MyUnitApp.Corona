----------------------------------------------------------------------------------
--
-- img lib Screen
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local json = require("json")
local stringValue = require( "res.value.string" )
local Utility = require( "Utils.Utility" )
local TwitterManager = require( "Utils.Twitter" )

local widget = require( "widget" )
local path = system.pathForFile( "MyUnitBuzz.db", system.DocumentsDirectory )
local db = sqlite3.open( path )
local totalFeeds=3
--------------- Initialization -------------------

local W = display.contentWidth;H= display.contentHeight

local Background,BgText,landing_feeds_list

local menuBtn,tabBar,Banner
local callback = {}

openPage="LandingPage"

local response_count = 0

local Feed_Icon_Array = {"facebook","twitter","google+"}
local Feed_Title_Array = {"Facebook","Twitter","Google+"}
local Facebook_asscesToken,Facebook_userid,Twitter_UserName,googleUser_id
local facebookresponse,twitterresponse,googleresponse = {},{},{}
local AccessApi = "AIzaSyCWHBLU9okAnzMk1Y_AP1XJKZZ0RCCsipQ";


for row in db:nrows("SELECT * FROM logindetails WHERE id=1") do

	Facebook_asscesToken = row.FacebookAccessToken
	Facebook_userid = row.FacebookUsername

	Twitter_UserName = row.TwitterUsername 
	googleUser_id = row.GoogleUserId

end


--------------------------------------------------


-----------------Function-------------------------
local function makeTimeStamp(dateString)
	local pattern = "(%d+)%-(%d+)%-(%d+)%a(%d+)%:(%d+)%:([%d%.]+)([Z%p])(%d*)%:?(%d*)";
	local year, month, day, hour, minute, seconds, tzoffset, offsethour, offsetmin = dateString:match(pattern);

	local timestamp = os.time({year=year, month=month, day=day, hour=hour, min=minute, sec=seconds});
	local offset = 0;

	if (tzoffset) then
		if ((tzoffset == "+") or (tzoffset == "-")) then  -- we have a timezone!
			offset = offsethour * 60 + offsetmin;
			
			if (tzoffset == "-") then
				offset = offset * -1;
			end
			
			timestamp = timestamp + offset;
		end
	end

	return timestamp;
end



local function onRowRender_Landing( event )

 -- Get reference to the row group
 local row = event.row

    -- Cache the row "contentWidth" and "contentHeight" because the row bounds can change as children objects are added
    local rowHeight = row.contentHeight
    local rowWidth = row.contentWidth

    row.id = Feed_Title_Array[row.index]



    local function Row_render()

    Icon = display.newImageRect(row,"res/assert/LandingPage/"..Feed_Icon_Array[row.index]..".png",25,20)
    Icon.x=25;Icon.y = 25

    Bg = display.newImageRect(row,"res/assert/LandingPage/popbg.png",375/1.5,86)
    Bg.x=W/2+10;Bg.y = Icon.y+30

    title = display.newText(row,Feed_Title_Array[row.index],0,0,native.systemFont,16)
    title.x=Bg.x-Bg.contentWidth/2+15;title.y=Bg.y-Bg.contentHeight/2+10
    title.anchorX=0

    date_time = display.newText(row,"date/time",0,0,native.systemFont,10)
    date_time.x=Bg.x+Bg.contentHeight/2;date_time.y=title.y
    date_time:setFillColor(Utils.convertHexToRGB(color.tabBarColor ))

    line = display.newRect(row,Bg.x-Bg.contentWidth/2+10,title.y+title.contentHeight/2+8,Bg.contentWidth-24,0.5)
    line.anchorX=0
    line:setFillColor(Utils.convertHexToRGB(color.Black ))

    content = display.newText(row,"content",0,0,Bg.contentWidth-10,Bg.contentHeight-30,native.systemFont,14)
    content:setFillColor(Utils.convertHexToRGB(color.Black))
    content.x=Bg.x-Bg.contentWidth/2+15;content.y=line.y+8
    content.anchorX=0;content.anchorY=0

    seemore = display.newText(row,"Read more...",0,0,native.systemFont,10)
    seemore.x=Bg.x+Bg.contentHeight/2+25;seemore.y=Bg.y+Bg.contentHeight/2-10
    seemore:setFillColor(Utils.convertHexToRGB(color.tabBarColor ))


    if Feed_Title_Array[row.index] == "Facebook" then

    	if facebookresponse[1] ~= nil then
    		time = makeTimeStamp(string.gsub( facebookresponse[1].created_time, "+0000", "Z" ))
    		content.text = facebookresponse[1].message or facebookresponse[1].story
    		date_time.text = tostring(os.date("%Y-%b-%d %H:%m %p",time ))
    	end
    	elseif Feed_Title_Array[row.index] == "Twitter" then
    		if twitterresponse[1] ~= nil then
    			content.text = twitterresponse[1].text
    			date_time.text = tostring(os.date("%Y-%b-%d %H:%m %p", twitterresponse[1].created_time))
    		end

    		elseif Feed_Title_Array[row.index] == "Google+" then


    			if googleresponse[1] ~= nil then
    				content.text = googleresponse[1].title
    				date_time.text = tostring(os.date("%Y-%b-%d %H:%m %p", makeTimeStamp(googleresponse[1].published)));
    			end

    		end



    	end

    	landing_feeds_list:scrollToY( { y=0, time=200} )

    	if Feed_Title_Array[row.index] == "Facebook" then

    		if facebookresponse ~= nil then
    			Row_render()
    		else
    			row:removeSelf();row=nil
		--landing_feeds_list:scrollToY( { y=-rowHeight, time=200} )


		return true
	end
else
	Row_render()
end

if Feed_Title_Array[row.index] == "Twitter" then

	if twitterresponse[1] ~= nil then
		Row_render()
		if facebookresponse == nil then
			print("scroll")
			landing_feeds_list:scrollToY( { y=-rowHeight, time=200} )
		end
	else


		row:removeSelf();row=nil
		return true
	end
else
	Row_render()
end

if Feed_Title_Array[row.index] == "Google+" then

	if googleresponse[1] ~= nil then
		Row_render()

		if twitterresponse[1] == nil and facebookresponse == nil then

			landing_feeds_list:scrollToY( { y=-rowHeight*2, time=200} )

			elseif twitterresponse[1] == nil or facebookresponse == nil then

				landing_feeds_list:scrollToY( { y=-rowHeight, time=200} )
			end
		else

		--row.rowHeight=5
		--row:removeSelf();row=nil


		
		return true
	end
else
	Row_render()
end

end


local function getgoogleplus_stream( event )
	if ( event.isError ) then

		print("error")

	else



		local response =  json.decode(event.response)

		response_count=response_count+1

		if response ~= nil then

			googleresponse = response.items

		end

		print("here google")

		landing_feeds_list:reloadData()


		
	end

end
function callback.twitterSuccess( requestType, name, res )


	local response = json.decode( res )

	local results = ""





	if "users" == requestType then

		twitterresponse = response

		

		landing_feeds_list:reloadData()

		
	end



end

function callback.twitterFailed()
	print( "Failed: Invalid Token" )

	native.showAlert( "Result", "Failed: Invalid Token", { "Ok" } )

end

local function feed_networkListener( event )
	if ( event.isError ) then
	else

		facebookresponse = json.decode( event.response )

		facebookresponse = facebookresponse.data

		response_count = response_count+1

		print("here facebook") 
		landing_feeds_list:reloadData()
		
		
	end

end

local function onRowTouch_Landing( event )
	local phase = event.phase
	local row = event.target

	if( "press" == phase ) then


		elseif ( "release" == phase ) then

			if row.id == "Facebook" then
				composer.gotoScene( "Controller.facebookPage", "slideUp", 500 )
				elseif row.id == "Twitter" then
					composer.gotoScene( "Controller.twitterPage", "slideUp", 500 )
					elseif row.id == "Google+" then
						composer.gotoScene( "Controller.googlePlusPage", "slideUp", 500 )
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

	Banner = display.newImageRect(sceneGroup,"res/assert/LandingPage/banner.jpg",W,178)
	Banner.x=W/2;Banner.y=tabBar.y+tabBar.contentHeight/2+Banner.contentHeight/2


	SocialHead = display.newText(sceneGroup,"Social Feed",0,0,native.systemFont,16)
	SocialHead.x=5;SocialHead.y=Banner.y+Banner.contentHeight/2+20
	SocialHead.anchorX=0
	SocialHead.anchorX=0
	SocialHead:setFillColor(Utils.convertHexToRGB(color.google_plus))


	
	landing_feeds_list = widget.newTableView
	{
	left = 0,
	top = 0,
	height = (H-H/2-40),
	width = W,
	onRowRender = onRowRender_Landing,
	onRowTouch = onRowTouch_Landing,
	hideBackground = true,
	isBounceEnabled = false,
	noLines = true,
}
landing_feeds_list.y=H/2+10
landing_feeds_list.height = (H-landing_feeds_list.y)
landing_feeds_list.anchorY=0
for i = 1, totalFeeds do
		    -- Insert a row into the tableView
		    landing_feeds_list:insertRow{ rowHeight = 90,rowColor = 
		    {
		    default = { 1, 1, 1, 0 },
		    over={ 1, 0.5, 0, 0 },

		    }}
		end

		sceneGroup:insert(landing_feeds_list)


		getFeeds = network.request( "https://graph.facebook.com/"..Facebook_userid.."/feed?access_token="..Facebook_asscesToken, "GET", feed_networkListener )
		getgoogle_feed = network.request( "https://www.googleapis.com/plus/v1/people/"..googleUser_id.."/activities/public?key="..AccessApi, "GET", getgoogleplus_stream )

		if Twitter_UserName ~= "" then
			local params = {"users", "statuses/user_timeline.json", "GET",
			{"screen_name", Twitter_UserName}, {"skip_status", "true"},
			{"include_entities", "false"} }
			TwitterManager.tweet(callback, params)
		else
			response_count = response_count+1
		end



		MainGroup:insert(sceneGroup)

	end

	function scene:show( event )

		local sceneGroup = self.view
		local phase = event.phase

		if phase == "will" then


			elseif phase == "did" then

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
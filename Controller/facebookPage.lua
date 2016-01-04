----------------------------------------------------------------------------------
--
-- facebook Screen
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local widget = require( "widget" )
local json = require( "json" )
local Utility = require( "Utils.Utility" )
local path = system.pathForFile( "MyUnitBuzz.db", system.DocumentsDirectory )
local db = sqlite3.open( path )



--------------- Initialization -------------------

local W = display.contentWidth
local H= display.contentHeight

local Background,BgText


local menuBtn




local http = require "socket.http"

local groupArray={}

local feedArray={}

local RecentTab_Topvalue = 40

local user_Name=""

--local asscesToken = "CAAN87eY7fioBANlVRC0h1q8mZCxsDwbcPoNQp6H1D21yXI3gk8bfMonzDkNp4lpgSC0yJimgrdQOjHGPCKnd4tbKI4E1d0Jzyvu3ktODPsoZAGRWRjTj6eJJZBmRjwWZAZBjSWWtbDbxzXfK4lZB8Ym73t9yhLa7W4JeoxEQrnMIfkH0ZBJbOVi0GwuvFnLjO7joVf6734N8mYfuq7lS1VZB"

local asscesToken,userid

for row in db:nrows("SELECT * FROM logindetails WHERE id=1") do
	print(row.FacebookUsername)

	asscesToken = row.FacebookAccessToken
	userid = row.FacebookUsername
end




local defaultField,Post_text,scrollView;
local fbCommand = nil
local GET_FEED = "getfeed"
local POST_RETURN = "postreturn"

local GET_USER_INFO="self"

--------------------------------------------------


-----------------Function-------------------------


function FacebookCallback(res,scrollView)

	spinner_hide()

	feedArray = res

					for j=#groupArray, 1, -1 do 
						display.remove(groupArray[#groupArray])
						groupArray[#groupArray] = nil
					end

					local function networkListener( event )
						if ( event.isError ) then
							print ( "Network error - download failed" )
						else

							for i=1,#feedArray do

								if  feedArray[i].message ~= nil  or feedArray[i].story ~= nil then

									groupArray[#groupArray+1] = display.newGroup()

									local tempGroup = groupArray[#groupArray]

									local bgheight = 0

									if feedArray[i].picture ~= nil then

										bgheight = 90

									end

									if  feedArray[i].story ~= nil then
										bgheight = bgheight+110
									else
										bgheight = bgheight+80
									end

									local background = display.newRect(tempGroup,0,0,W,bgheight)

									local Initial_Height = 0

									if(groupArray[#groupArray-1]) ~= nil then

										Initial_Height = groupArray[#groupArray-1][1].y + groupArray[#groupArray-1][1].height+3

									end

									background.anchorY = 0
									background.x=W/2;background.y=Initial_Height
									background:setFillColor(1)

									profilePic = display.newImage("userfb.png", system.TemporaryDirectory)
									if not profilePic then
										profilePic = display.newImageRect("res/assert/twitter_placeholder.png",100,100)
									end
									profilePic.width=40;profilePic.height=40

									tempGroup:insert(profilePic)


									time = Utils.makeTimeStamp(string.gsub( feedArray[i].created_time, "+0000", "Z" ))

									userTime = display.newText( tempGroup, tostring(os.date("%Y-%b-%d %H:%m %p",time )), 0, 0, native.systemFontBold, 11 )
									userTime.anchorX = 0
									Utils.CssforTextView(userTime,sp_Date_Time)
									



									userName = display.newText( tempGroup,user_Name, 0, 0, native.systemFontBold, 14 )
									userName.anchorX = 0
									Utils.CssforTextView(userName,sp_socialHeaderFb)

									if feedArray[i].message == nil then

										rowTitle = display.newText( tempGroup," ", 0, 0,native.systemFontBold, 18 )

									else

										local optionsread = {
										text = feedArray[i].message,
										x = display.contentCenterX,
										y = display.contentCenterY,
										fontSize = 11,
										width = 210,
										height = 0,
										align = "left"
									}


									rowTitle = display.newText( optionsread )

								end
								tempGroup:insert(rowTitle)
								rowTitle.anchorX = 0
								Utils.CssforTextView(rowTitle,sp_socialText)

								background.height = background.height+rowTitle.height/1.5

								background.x=W/2;background.y=Initial_Height


								profilePic.x=background.x-background.contentWidth/2+profilePic.contentWidth/2+5
								profilePic.y=background.y+profilePic.height/2+15

								userTime.x=background.contentWidth-userTime.contentWidth
								userTime.y=profilePic.y-profilePic.height/2-5

								userName.x=profilePic.x+profilePic.contentWidth/2+10
								userName.y=profilePic.y-profilePic.height/2+userName.height/2

								rowTitle.x=profilePic.x+profilePic.contentWidth/2+10
								rowTitle.y=profilePic.y+rowTitle.height/2
								local rowStory


								if feedArray[i].story == nil then

									rowStory = display.newText( tempGroup, "", 0, 0, native.systemFont, 11 )

								else 

									local options = {
									text = feedArray[i].story,
									x = display.contentCenterX,
									y = display.contentCenterY,
									fontSize = 11,
									width = 250,
									height = 60,
									align = "left"
								}


								rowStory = display.newText( options )

							end

							tempGroup:insert(rowStory)
							rowStory.anchorX = 0
							rowStory.x=profilePic.x-profilePic.contentWidth/2
							rowStory.y=profilePic.y+profilePic.height/2+5+rowStory.height/2
							Utils.CssforTextView(rowStory,sp_socialText)

							local function postedimg_position( event )
								if ( event.isError ) then
									print ( "Network error - download failed" )
								else

									event.target.width=200
									event.target.height=100

									tempGroup:insert(event.target)
								end

							end
							if feedArray[i].picture ~= nil then

								local img = feedArray[i].picture

								local shared_img = display.loadRemoteImage(img, "GET", postedimg_position, "facebook"..i..".png", system.TemporaryDirectory,100+profilePic.x-profilePic.contentWidth/2,rowStory.y+rowStory.height/2+55 )


							end
							scrollView:insert(tempGroup)

						end
					end

				end
			end

				--test_response.text = tostring(feedArray[1].id)

				local temp = tostring(feedArray[1].id)

				local tempvalue = string.find( temp, "_" )
				temp = temp:sub(1,tempvalue-1)

				local function get_username( event )
					if ( event.isError ) then

						print("error")

					else

						print("user : "..event.response )
						local response = json.decode( event.response )

					end
				end

				getuser = network.request( "https://graph.facebook.com/"..temp, "GET", get_username )


				network.download(
					"https://graph.facebook.com/"..temp.."/picture",
					"GET",
					networkListener,
					"userfb.png",
					system.TemporaryDirectory
					)



			end


------------------------------------------------------

function scene:create( event )

	local sceneGroup = self.view

	Background = display.newImageRect(sceneGroup,"res/assert/background.jpg",W,H)
	Background.x=W/2;Background.y=H/2

	tabBar = display.newRect(sceneGroup,W/2,0,W,40)
	tabBar.y=tabBar.height/2
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

	openPage="facebookPage"
	
	if phase == "will" then


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

spinner_show()

sceneGroup:insert(scrollView)



local function feed_networkListener( event )
	if ( event.isError ) then
	else
		print ( "RESPONSE: " .. event.response )
		spinner_hide()
		local response = json.decode( event.response )
		FacebookCallback(response.data,scrollView)
	end

end


local function networkListener( event )
	if ( event.isError ) then
	else
		print ( "RESPONSE: " .. event.response )

		local response = json.decode( event.response )

		user_Name = response.name

		getFeeds = network.request( "https://graph.facebook.com/"..userid.."/feed?access_token="..asscesToken, "GET", feed_networkListener )



	end
end

-- Access Google over SSL:
getAccess = network.request( "https://graph.facebook.com/"..userid.."/?access_token="..asscesToken, "GET", networkListener )



menuBtn:addEventListener("touch",menuTouch)
BgText:addEventListener("touch",menuTouch)


end	
MainGroup:insert(sceneGroup)

end

function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if event.phase == "will" then

		network.cancel( getuser )
		network.cancel( getFeeds )
		network.cancel( getAccess )




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
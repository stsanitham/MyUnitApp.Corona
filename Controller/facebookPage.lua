----------------------------------------------------------------------------------
--
-- Facebook Screen
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

local RecentTab_Topvalue = 70

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

								print(i)


								if  feedArray[i].message ~= nil  or feedArray[i].story ~= nil then

									groupArray[#groupArray+1] = display.newGroup()

									local tempGroup = groupArray[#groupArray]

									local bgheight = 0

									if feedArray[i].picture ~= nil then

										bgheight = 100

									end

									
										bgheight = bgheight+40
									

									local background = display.newRect(tempGroup,0,0,W-80,bgheight)

									local Initial_Height = 20

									if(groupArray[#groupArray-1]) ~= nil then

										Initial_Height = groupArray[#groupArray-1][1].y + groupArray[#groupArray-1][1].height+10

									end

									background.anchorY = 0
									background.x=W/2+30;background.y=Initial_Height
									--background.strokeWidth = 1
									--background:setStrokeColor( 0.8, 0.8, 0.8 )
									background:setFillColor(Utils.convertHexToRGB("#d2d3d4"))
									--background.alpha=0.5

									local profilePic = display.newImageRect("userfb.png", system.TemporaryDirectory,55,45)

									if not profilePic then
										profilePic = display.newImageRect("res/assert/twitter_placeholder.png",55,45)
									end
									profilePic.width=55;profilePic.height=50

									tempGroup:insert(profilePic)

									local mask = graphics.newMask( "res/assert/mask2.png" )

									profilePic:setMask( mask )


									time = Utils.makeTimeStamp(string.gsub( feedArray[i].created_time, "+0000", "Z" ))

									local userTime = display.newText( tempGroup, tostring(os.date("%Y-%b-%d %H:%m %p",time )), 0, 0, native.systemFont, 10 )
									userTime.anchorX = 0
									userTime.anchorY = 0
									Utils.CssforTextView(userTime,sp_Date_Time)
									userTime:setFillColor( Utils.convertHexToRGB(color.tabBarColor) )
									



									local userName = display.newText( tempGroup,user_Name, 0, 0, native.systemFont, 12 )
									userName.anchorX = 0
									userName.anchorY = 0
									Utils.CssforTextView(userName,sp_socialHeaderFb)


									local line = display.newRect( tempGroup, 0, 0, background.contentWidth-10, 1 )
									line:setFillColor( Utils.convertHexToRGB(color.Gray) )
									line.x=background.x;line.y=background.y+20							

									local rowTitle

									if feedArray[i].message == nil and feedArray[i].story == nil  then

										rowTitle = display.newText( tempGroup," ", 0, 0,native.systemFontBold, 18 )

									else

										local optionsread = {
										text = feedArray[i].message or feedArray[i].story,
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
								rowTitle.anchorY = 0
								Utils.CssforTextView(rowTitle,sp_socialText)

								background.height = background.height+rowTitle.height

								background.y=Initial_Height

								local background_arrow = display.newImageRect( tempGroup, "res/assert/arrow3.png", 11,20 )
								background_arrow.x=background.x-background.contentWidth/2-background_arrow.contentWidth/2+1
								background_arrow.y=background.y+background_arrow.contentHeight/2+5
								background.alpha=0.8


								profilePic.x=background.x-background.contentWidth/2-profilePic.contentWidth/2-10
								profilePic.y=background.y+profilePic.height/2-5

								userTime.x=background.x+background.contentWidth/2-userTime.contentWidth-5
								userTime.y=background.y+5

								userName.x=background.x-background.contentWidth/2+5
								userName.y=background.y+5

								rowTitle.x=userName.x
								rowTitle.y=background.y+25

						
			

							

							local function postedimg_position( event )
								if ( event.isError ) then
									print ( "Network error - download failed" )
								else

									event.target.width=200
									event.target.height=100
									print( "here.."..i )													

									event.target.y = rowTitle.y+rowTitle.contentHeight+event.target.contentHeight/2+5

									tempGroup:insert(event.target)
								end

							end
							if feedArray[i].picture ~= nil then

								local img = feedArray[i].picture

								
									local shared_img = display.loadRemoteImage(img, "GET", postedimg_position, "facebook"..i..".png", system.TemporaryDirectory,userName.x+105,rowTitle.y+rowTitle.contentHeight+10)

							
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

	title_bg = display.newRect(sceneGroup,0,0,W,30)
	title_bg.x=W/2;title_bg.y = tabBar.y+tabBar.contentHeight-5
	title_bg:setFillColor( Utils.convertHexToRGB(color.tabbar) )


	title = display.newText(sceneGroup,Facebook.PageTitle,0,0,native.systemFont,18)
	title.anchorX = 0
	title.x=5;title.y = title_bg.y
	title:setFillColor(0)
	
	MainGroup:insert(sceneGroup)

end

function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	openPage="facebookPage"

	ga.enterScene("Facebook")
	
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
			 bottomPadding = 60

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
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

local BackFlag = false

local menuBtn

local FeedNextUrl




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
local function linkTouch( event )
	if event.phase == "ended" then
		system.openURL( event.target.value )
	end
return true
end

function FacebookCallback(res,scrollView,flag)

	spinner_hide()

	feedArray = res

				if flag == true then


					for j=#groupArray, 1, -1 do 
						display.remove(groupArray[#groupArray])
						groupArray[#groupArray] = nil
					end

				else



				end

					local function networkListener( event )
						if ( event.isError ) then
							print ( "Network error - download failed" )
						else

							for i=1,#feedArray do


									groupArray[#groupArray+1] = display.newGroup()

									local tempGroup = groupArray[#groupArray]

									local bgheight = 0

									if feedArray[i].picture ~= nil then

										bgheight = 110

									end

									
										bgheight = bgheight+50
									

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



									local time = Utils.makeTimeStamp(string.gsub( feedArray[i].created_time, "+0000", "Z" ))

									print( feedArray[i].created_time,time )

									local userTime = display.newText( tempGroup, tostring(os.date("%b-%d-%Y %I:%m %p",time )), 0, 0, native.systemFont, 10 )
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
										text = feedArray[i].message or feedArray[i].story or "",
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

										--test_response.text = tostring(feedArray[1].id)

								if feedArray[i].link ~= nil and feedArray[i].type ~= "video" then 

								local link = display.newText(tempGroup,feedArray[i].link,0,0,native.systemFont,12)
								link:setFillColor( 0,0,1 )
								link.anchorX = 0
								link.anchorY = 0
								link.value = feedArray[i].link
								link.x = userName.x
								link.y =  background.y+background.contentHeight-20
								link:addEventListener( "touch", linkTouch )

								if link.text:len() > 35 then
									link.text = string.sub( link.text,1,35).."..."
								end

								local line = display.newLine( link.x, background.y+background.contentHeight-5, link.x+link.contentWidth,  background.y+background.contentHeight-5  )
								line:setStrokeColor( Utils.convertHexToRGB(color.blue) )
								line.strokeWidth = 1
								tempGroup:insert( line )

								end

							if feedArray[i].picture ~= nil then

								local img = feedArray[i].picture

								
									local shared_img = display.loadRemoteImage(img, "GET", function ( event )
								if ( event.isError ) then
									print ( "Network error - download failed" )
								else

									event.target.width=200
									event.target.height=100

									event.target.y = rowTitle.y+rowTitle.contentHeight+event.target.contentHeight/2+5


									tempGroup:insert(event.target)
									if feedArray[i].type == "video" then

									print( "here............" )
										local play = display.newImageRect( "res/assert/play.png", 35,35 )
										tempGroup:insert(play)
										play.x=event.target.x;play.y=event.target.y
										play.value = feedArray[i].link
										play:addEventListener( "touch", linkTouch )

									end

								end

							end, "facebook"..i..".png", system.TemporaryDirectory,userName.x+105,rowTitle.y+rowTitle.contentHeight+10)

							

										
									

							end
							scrollView:insert(tempGroup)

						end
					end

				
			end



				local temp = tostring(feedArray[1].id)

				local tempvalue = string.find( temp, "_" )
				temp = temp:sub(1,tempvalue-1)

			

				network.download(
					"https://graph.facebook.com/"..temp.."/picture",
					"GET",
					networkListener,
					"userfb.png",
					system.TemporaryDirectory
					)



			end

local function feed_Load( event )
	if ( event.isError ) then
	else
		print ( "RESPONSE: " .. event.response )
		spinner_hide()
		local response = json.decode( event.response )

		if response.paging.next ~= nil then

			FeedNextUrl = response.paging.next

		else

			FeedNextUrl=nil

		end
		FacebookCallback(response.data,scrollView,false)
	end

end

local function feed_networkListener( event )
	if ( event.isError ) then
	else
		print ( "RESPONSE: " .. event.response )
		spinner_hide()
		local response = json.decode( event.response )

		FeedNextUrl = response.paging.next
		FacebookCallback(response.data,scrollView,true)
	end

end


	local function Facebook_scrollListener( event )

		    local phase = event.phase
		    if ( phase == "began" ) then 
		    elseif ( phase == "moved" ) then 
		    elseif ( phase == "ended" ) then 
		    end

		    -- In the event a scroll limit is reached...
		    if ( event.limitReached ) then
		        if ( event.direction == "up" ) then print( "Reached bottom limit" )

		        	if FeedNextUrl ~= nil then
		        		spinner_show()
						getFeeds = network.request( FeedNextUrl, "GET", feed_Load )

					end


		        elseif ( event.direction == "down" ) then print( "Reached top limit" )

		        	spinner_show()

        			getFeeds = network.request( "https://graph.facebook.com/"..userid.."/feed?access_token="..asscesToken, "GET", feed_networkListener )

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
			isBounceEnabled=true,
			horizontalScrollDisabled = true,
	   		scrollWidth = W,
			bottomPadding = 60,
   			listener = Facebook_scrollListener,
}

spinner_show()

sceneGroup:insert(scrollView)






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

Runtime:addEventListener( "key", onKeyEvent )


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
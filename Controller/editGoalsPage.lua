----------------------------------------------------------------------------------
--
-- Golas Screen
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

local Utility = require( "Utils.Utility" )
local widget = require( "widget" )
local mime = require("mime")
local http = require("socket.http")
local json = require('json')
local ck_editor = require('Utils.ckeditor')

--------------- Initialization -------------------

local W = display.contentWidth;H= display.contentHeight

local Background,BgText

local GoalText

local menuBtn,BackBtn

local webView 

openPage="goalsPage"

local BackFlag = false

local RecentTab_Topvalue = 40

local updatedresponse

local base64 = {}

local Goalsid

local isEdited = false


--------------------------------------------------


-----------------Function-------------------------


------------------------------------------------------


local function onTimer ( event )

	BackFlag = false

end


local function onKeyEventDetail( event )

        local phase = event.phase
        local keyName = event.keyName

        if phase == "up" then

        if keyName=="back"  then

        	composer.hideOverlay( "slideRight", 300 )
            
            return true
            
        end

    end

        return false
 end



local function BackTouch( event )

	if event.phase == "began" then

		display.getCurrentStage():setFocus( event.target )

	elseif event.phase == "ended" then

	     print("webview check")
	     display.getCurrentStage():setFocus( nil )

		 composer.hideOverlay( "slideRight", 300 )

		 --composer.gotoScene("Controller.goalsPage","slideRight",500)

	end

	return true

end



function string.urlEncode( str )
	if ( str ) then
		str = string.gsub( str, "\n", "\r\n" )
		str = string.gsub( str, "([^%w ])",
			function (c) return string.format( "%%%02X", string.byte(c) ) end )
		str = string.gsub( str, " ", "+" )
	end
	return str
end

function urlDecode( str )
    assert( type(str)=='string', "urlDecode: input not a string" )
    str = string.gsub (str, "+", " ")
    str = string.gsub (str, "%%(%x%x)",
        function(h) return string.char(tonumber(h,16)) end)
    str = string.gsub (str, "\r\n", "\n")
    return str
end

function get_SaveMyUnitBuzzGoals(response)
	isEdited=true
	composer.hideOverlay( )
end


local function webListener( event )
    local shouldLoad = true

    local url = event.url

    print( "here" )
    if 1 == string.find( url, "corona:close" ) then
        -- Close the web popup

        shouldLoad = false

        print(url)


        updatedresponse = urlDecode(url)


        updatedresponse = (string.sub( updatedresponse, 13,updatedresponse:len()-1 ))

        print( "updatedresponse : "..updatedresponse )

        if webView then webView:removeSelf( );webView=nil end

        Webservice.SaveMyUnitBuzzGoals(Goalsid,updatedresponse,get_SaveMyUnitBuzzGoals)

    end

    if event.errorCode then
        -- Error loading page
        print( "Error: " .. tostring( event.errorMessage ) )
        shouldLoad = false
    end

    return shouldLoad
end



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

	--composer.removeHidden()

title_bg = display.newRect(sceneGroup,0,0,W,30)
title_bg.x=W/2;title_bg.y = tabBar.y+tabBar.contentHeight-5
title_bg:setFillColor( Utils.convertHexToRGB(color.tabbar) )

BackBtn = display.newText(sceneGroup,"<",0,0,native.systemFont,26)
BackBtn.x=20;BackBtn.y=tabBar.y+tabBar.contentHeight/2+15
BackBtn:setFillColor(Utils.convertHexToRGB(color.Black))

title = display.newText(sceneGroup,Goals.PageTitle,0,0,native.systemFont,18)
title.anchorX = 0
title.x=BackBtn.x+BackBtn.contentWidth/2+5;title.y = BackBtn.y
title:setFillColor(0)  




--Utils.copyDatabaseTo("sample.txt", system.ResourceDirectory,"sample.txt",system.DocumentsDirectory )
--Utils.copyDatabaseTo("ckeditor.html", system.ResourceDirectory,"ckeditor.html",system.DocumentsDirectory  )
local test= string.urlEncode(event.params.content)

local path = system.pathForFile( "ckeditor.html",system.DocumentsDirectory )

		-- Open the file handle
		local file, errorString = io.open( path, "w+" )

		if not file then
		    -- Error occurred; output the cause
		    print( "File error: " .. errorString )
		else
		    -- Write data to file
		    file:write( ckeditor.htmlContent.."'"..test.."'"..ckeditor.endHtml..""..ckeditor.buttonHtml )
		    -- Close the file handle

		   --     local options =
					-- {
					--     hasBackground = false,
					--     baseUrl = system.DocumentsDirectory,
					--     urlRequest = webListener
					-- }
					--  native.showWebPopup( 0, 70, display.viewableContentWidth, display.viewableContentHeight-80, "ckeditor.html", options )


					 webView = native.newWebView( 0, 70, display.viewableContentWidth, display.viewableContentHeight )

					 webView.hasBackground = false

					 webView.anchorX=0;webView.anchorY=0
					 webView:request( "ckeditor.html", system.DocumentsDirectory )

					webView:addEventListener( "urlRequest", webListener )

					sceneGroup:insert( webView)

		    file:close()

		end

		file = nil

		-- local space = display.newRect( 0,0,W,80 )
		-- space.x=W/2;space.y=webView.y+webView.contentHeight
		-- webView.anchorY=0

	-- local test=string.urlEncode( event.params.content )

	-- print( test )

	-- local textpath = system.pathForFile( "sample.txt",system.DocumentsDirectory )

	-- 	-- Open the file handle
	-- 	local txtfile, txterrorString = io.open( textpath, "w+" )

	-- 	if not txtfile then
	-- 	    -- Error occurred; output the cause
	-- 	    print( "File error: " .. txterrorString )
	-- 	else
	-- 	    -- Write data to file
	-- 	    txtfile:write( test )
	-- 	    -- Close the file handle
	-- 	   txtfile:close()

		 

	-- 	end

	-- 	txtfile = nil




		-- webView = native.newWebView( display.contentCenterX, 70, display.viewableContentWidth, display.viewableContentHeight-80 )
		-- webView.anchorY=0
		-- webView:request( "ckeditor.html?value='"..test.."'", system.ResourceDirectory )
		-- sceneGroup:insert( webView )
		-- webView:addEventListener( "urlRequest", ResourceDirectory )

		--webView:executeJS("Updategoals", "sample value")



function saveEditedGoals(response)


end


--Webservice.SAVE_MYUNITAPP_GOALS(saveEditedGoals)


menuBtn:addEventListener("touch",menuTouch)
BgText:addEventListener("touch",menuTouch)

BackBtn:addEventListener("touch",BackTouch)
title:addEventListener("touch",BackTouch)

Runtime:addEventListener( "key", onKeyEventDetail )



	MainGroup:insert(sceneGroup)
end



function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then

		ga.enterScene("Unit Goals")

		print( "edit goals" )

		Goalsid = event.params.goalsid

		elseif phase == "did" then

			end	

MainGroup:insert(sceneGroup)

end




function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if event.phase == "will" then

			--composer.removeHidden()

			if webView then webView:removeSelf( );webView=nil end

			native.cancelWebPopup()


		elseif phase == "did" then

			event.parent:resumeGame(isEdited)

			menuBtn:removeEventListener("touch",menuTouch)
			BgText:removeEventListener("touch",menuTouch)

			Runtime:removeEventListener( "key", onKeyEventDetail )

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
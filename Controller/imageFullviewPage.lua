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
local pasteboard = require( "plugin.pasteboard" )
local toast = require('plugin.toast')
local context


--------------- Initialization -------------------

local W = display.contentWidth;H= display.contentHeight

local Background,BgText

local menuBtn

openPage="imageFullviewPage"

local BackFlag = false

local webView

--------------------------------------------------


-----------------Function-------------------------

local function closeDetails( event )
	if event.phase == "began" then
		display.getCurrentStage():setFocus( event.target )
		elseif event.phase == "ended" then
		display.getCurrentStage():setFocus( nil )

	end

	return true

end



local function onTimer ( event )

	BackFlag = false

end



local function onKeyEvent( event )

	local phase = event.phase
	local keyName = event.keyName

	if phase == "up" then

		if keyName == "back" or keyName == "a" then

			composer.hideOverlay( "slideRight", 300 )

			return true
		end

	end

	return false
end






local function onBackButtonTouch( event )

	if event.phase == "began" then

		display.getCurrentStage():setFocus( event.target )

		elseif event.phase == "ended" then

		display.getCurrentStage():setFocus( nil )

		if event.target.id == "fullimage" or event.target.id == "background" then	

		else

			composer.hideOverlay("slideRight", 300)

		end

	end

	return true

end






local function listTouch( event )

	if event.phase == "began" then
		display.getCurrentStage():setFocus( event.target )
		
		elseif event.phase == "ended" then
		display.getCurrentStage():setFocus( nil )

		event = event.target

		if event.id =="download" then

			local function onComplete( event )

				if event.action == "clicked" then

					local i = event.index

					if i == 1 then

						local localpath = system.pathForFile(  downImg.filename, system.DocumentsDirectory )
						
									local path = system.pathForFile("/storage/sdcard1/"..photoview)    --External (SD Card)


								--------------------------- Read ----------------------------

								local file, reason = io.open( localpath, "r" )                              
								local contents
								if file then
											    contents = file:read( "*a" )                                        -- Read contents
											    io.close( file )                                                    -- Close the file (Important!)
											else
												print("Invalid path")
												return
											end

								--------------------------- Write ----------------------------
								
									local file = io.open( path, "w" )                                    -- Open the destination path in write mode
									
									if file then

										    file:write(contents)                                                -- Writes the contents to a file
										    io.close(file)   
										                                                       -- Close the file (Important!)
										                                                   else

											path = system.pathForFile("/storage/sdcard0/".. downImg.filename) -- internal
											local file = io.open( path, "w" )   
											                                 -- Open the destination path in write mode
											                                 if file then
											    file:write(contents)                                                -- Writes the contents to a file
											    io.close(file)                                                      -- Close the file (Important!)
											else
												path = system.pathForFile("/storage/sdcard/".. downImg.filename)
												local file = io.open( path, "w" )    
												                                -- Open the destination path in write mode
												                                if file then
														file:write(contents)                                                -- Writes the contents to a file
														io.close(file)                                                      -- Close the file (Important!)
													else
														print("Error")
														return
													end

												end

											end

											native.showAlert( downImg.filename, ResourceLibrary.Download_alert, { CommonWords.ok} )

										end

									end

								end


								native.showAlert( event.filename, "Are you sure you want to save this image?", {CommonWords.ok,CommonWords.cancel} , onComplete )

							end

						end

						return true

					end








------------------------------------------------------

function scene:create( event )

	local sceneGroup = self.view

	Background = display.newImageRect(sceneGroup,"res/assert/background.jpg",W,H)
	Background.id = "background"
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

	BackBtn = display.newImageRect( sceneGroup, "res/assert/right-arrow(gray-).png",15,15 )
	BackBtn.anchorX = 0
	BackBtn.x=25;BackBtn.y = title_bg.y
	BackBtn.xScale=-1
		--BackBtn:setFillColor(0)

		title = display.newText(sceneGroup,FlapMenu.chatMessageTitle,0,0,native.systemFont,18)
		title.anchorX = 0
		title.x=BackBtn.x+BackBtn.contentWidth-5;title.y = title_bg.y
		title:setFillColor(0)


		MainGroup:insert(sceneGroup)

	end




	function scene:show( event )

		local sceneGroup = self.view
		local phase = event.phase

		context = event.parent
		
		if phase == "will" then

			baseDir = system.DocumentsDirectory
			
			if event.params then

				photoview = event.params.imagenameval

			end


			title.text = photoview

			if event.params.pagename == "image" then

				photo = display.newImage( photoview, baseDir )
				photo.anchorY=0
				photo.height = 250
				photo.width = W-60
				photo.y=100
				photo.id = "fullimage"
				photo.x=W/2
				sceneGroup:insert( photo )
				

		-- if photo.width > photo.height then
		-- 			photo.height = 200
		-- 			photo.width = W-60
		-- 			photo.y=H/2-photo.contentHeight/2

		-- else
		-- 			if photo.height > H-100 then
		-- 				photo.height = H-80
		-- 				photo.width = W-60
		-- 			else
		-- 				photo.y=H/2-photo.contentHeight/2-80
		-- 			end

		-- 			if photo.width > W-60 then
		-- 				photo.width = W-60
		-- 			end
		-- end


		
		if isAndroid then

			downImg_bg = display.newRect(sceneGroup,0,0,30,25)
			downImg_bg.x=title.x+title.contentWidth+35;downImg_bg.y=title.y
			downImg_bg.id="download"
			downImg_bg.filename = photoview
			downImg_bg.alpha=0.01


			downImg = display.newImageRect(sceneGroup,"res/assert/save2.png",20,20)
			downImg.x=downImg_bg.x;downImg.y=downImg_bg.y
			downImg:setFillColor(0)
			downImg.filename = photoview
			downImg.id="download"

			downImg:addEventListener("touch",listTouch)
			downImg_bg:addEventListener("touch",listTouch)

		else

		end

		photo:addEventListener("touch",onBackButtonTouch)

	elseif event.params.pagename == "video" then

		title.text= title.text:sub(1,30).."..."
		print( "video page" )


		webView = native.newWebView( display.contentCenterX, display.contentCenterY+35, display.viewableContentWidth, display.viewableContentHeight-80 )
		webView.hasBackground=false
		webView:request( event.params.imagenameval )
		sceneGroup:insert( webView )

	elseif event.params.pagename == "text" then


	end




elseif phase == "did" then

	menuBtn:addEventListener("touch",menuTouch)

	Runtime:addEventListener( "key", onKeyEvent )

	BackBtn:addEventListener("touch", onBackButtonTouch)
	title:addEventListener("touch", onBackButtonTouch)
	Background:addEventListener("touch",onBackButtonTouch)
	
end	

MainGroup:insert(sceneGroup)

end




function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if event.phase == "will" then

		if webView then webView:removeSelf( );webView=nil end
		Runtime:removeEventListener( "key", onKeyEvent )

		BackBtn:removeEventListener("touch", onBackButtonTouch)
		title:removeEventListener("touch", onBackButtonTouch)
		if photo ~= nil then
			photo:removeEventListener("touch",onBackButtonTouch)
			photo=nil
		end

		Background:removeEventListener("touch",onBackButtonTouch)


	elseif phase == "did" then


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
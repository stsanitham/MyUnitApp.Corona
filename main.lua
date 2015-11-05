--------------------------------------------------------
-- MainActivity
--------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )
local composer = require "composer"
local newPanel = require "Utils.newPanel"
local widget = require( "widget" )


MainGroup = display.newGroup();

local W,H = display.contentWidth, display.contentHeight;
NavigationSpeed = 400;
menuShowFlag = false;
menuTransTime = 1000;
openPage="eventCalenderPage"
menuTitel = {"","Event Calender","Career Path","Goals","Resource","Image Library","Social Media","Facebook","Twitter","Instagram","Google+"}
rowValues = {"","eventCalenderPage","careerPathPage","goalsPage","resourcePage","imageLibPage","","facebookPage","twitterPage","instagramPage","googlePlusPage"}





local function panelTransDone( target )
	if ( target.completeState ) then
		print( "PANEL STATE IS: "..target.completeState )
	end
end

function slideAction()
	if(menuShowFlag) then

		transition.to( MainGroup, { time=menuTransTime,x=0,transition=easing.outCubic} )
		panel:hide();
		menuShowFlag =false

	else

		transition.to( MainGroup, { time=menuTransTime,x=panel.width,transition=easing.outCubic} )
		panel:show();
		menuShowFlag =true

	end

end


function menuTouch( event )

	if(event.phase == "began") then
		display.getCurrentStage():setFocus( event.target )

		elseif(event.phase == "ended") then

		display.getCurrentStage():setFocus( nil )

		slideAction()

	end

	return true;
end


local function menuTouch(event)
	if event.phase == "began" then

		display.getCurrentStage():setFocus( event.target )

		elseif event.phase == "ended" then
		display.getCurrentStage():setFocus( nil )

		local t = event.target;

		print(t[2].text)

		if(menuTitel[t.value] == "Social Media") then

		else

			for i = 1, panel.menuList:getNumRows() do

				local tmpRow = panel.menuList:getRowAtIndex(i)

				if(menuTitel[i] == "Social Media") then

				else
					tmpRow[1]:setFillColor( 0.1, 0.1, 0.1, 0.1)
				end
			end
			

			t[1]:setFillColor(21/255, 141/255, 233/255)


			--if(menuTitel[row.index] == "Content Section" or menuTitel[row.index] == "Social Feed") then

			--else


			slideAction()

			if openPage ~= event.target.id then

				for j=MainGroup.numChildren, 1, -1 do 
					display.remove(MainGroup[MainGroup.numChildren])
					MainGroup[MainGroup.numChildren] = nil
				end

				composer.gotoScene( "Controller."..event.target.id )
			end

		end

			--end
		end
		return true

	end

	local function onRowRender( event )
	local phase = event.phase
	local row = event.row

	local groupContentHeight = row.contentHeight


	local rowRect = display.newRect(row,W/2,H/2,W,H)
	rowRect:setFillColor(1,1,1,0)


	local rowTitle

	if(menuTitel[row.index] == "Social Media") then

		rowTitle = display.newText( row, menuTitel[row.index], 0, 0, native.systemFontBold, 14 )
		rowTitle.x = 5
		rowTitle.anchorX = 0
		rowTitle.id=menuTitel[row.index]
		rowTitle.y = groupContentHeight * 0.5


	else
		rowTitle = display.newText( row, menuTitel[row.index], 0, 0, native.systemFont, 14 )
		rowTitle.x = 20
		rowTitle.anchorX = 0
		rowTitle.id=menuTitel[row.index]
		rowTitle.y = groupContentHeight * 0.5


	end
	

	local line = display.newLine(row,0, groupContentHeight, row.contentWidth, groupContentHeight )

	row.id=rowValues[row.index]
	row.value=row.index


	row:addEventListener("touch",menuTouch)

end

	-- Handle row updates
	local function onRowUpdate( event )
		local phase = event.phase
		local row = event.row
		--print( row.index, ": is now onscreen" )
	end
	
	-- Handle touches on the row
	local function onRowTouch( event )
		local phase = event.phase
		local row = event.target

		if( "press" == phase ) then

			transition.cancel()



			elseif ( "release" == phase ) then



			end
		end


		panel = widget.newPanel{
	location = "left",
	onComplete = panelTransDone,
	width = display.contentWidth * 0.8,
	height = H,
	speed = menuTransTime,
	inEasing = easing.outCubic,
	outEasing = easing.outCubic
}

panel.background = display.newRect( 0, 0, panel.width, panel.height )
panel.background:setFillColor( 0, 0.25, 0.5 )
panel:insert( panel.background )

panel.menuList = widget.newTableView
{
	left = -(panel.contentWidth*0.5),
	top = -(panel.contentHeight*0.5),
	height = H,
	width = panel.contentWidth,
	onRowRender = onRowRender,
   -- onRowTouch = onRowTouch,
   hideBackground = true,
   noLines = true,
   isLocked = true

}


panel:insert( panel.menuList )

for i = 1, #menuTitel do

	local isCategory = false
	local rowHeight = 40
	local rowColor = {default={ 0.1, 0.1, 0.1, 0.1 },over = { 21/255, 141/255, 233/255 }}
	if menuTitel[i] == "Social Media"then

		isCategory = true
		rowHeight = 30
		rowColor = {default = {35/255, 188/255, 18/255},over = { 242/255, 242/255, 177/255,0 }}
	end

	panel.menuList :insertRow{

	isCategory = isCategory,
	rowHeight = rowHeight,
	rowColor = rowColor

}


end

composer.gotoScene( "Controller.splashScreen")

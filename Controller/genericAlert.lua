
genericAlert = {}
local W,H = display.contentWidth, display.contentHeight;
local leftPadding = 10

function genericAlert.createNew(title,content,values)

	

	Background = display.newImageRect(genericAlertGroup,"res/assert/background.jpg",W,H)
	Background.x=W/2;Background.y=H/2
	Background.alpha = 0.35
	--Background:addEventListener("touch",touchBg)

	genericAlert_bg = display.newRect(genericAlertGroup,leftPadding_value + 140, H/2-11, W-20, 60 )
	genericAlert_bg:setFillColor(1)
	genericAlert_bg.strokeWidth = 1
	genericAlert_bg:setStrokeColor(Utils.convertHexToRGB(color.tabBarColor))

	--genericAlert_bg.isVisible=false
	--genericAlert_bg:addEventListener("touch",touchBg)

	genericAlert_Top = display.newRect(W/2,genericAlert_bg.y-genericAlert_bg.contentHeight/2,genericAlert_bg.contentWidth-1,30)
	genericAlert_Top:setStrokeColor(Utils.convertHexToRGB(color.tabBarColor))
	genericAlert_Top.strokeWidth = 0.51
	genericAlert_Top:setFillColor(Utils.convertHexToRGB(color.tabBarColor))
	genericAlertGroup:insert(genericAlert_Top)

	genericAlert_Toptext = display.newText(title,0,0,native.systemFontBold,15)
	genericAlert_Toptext.anchorX=0
	genericAlert_Toptext.x=20;genericAlert_Toptext.y=genericAlert_Top.y
	genericAlert_Toptext:setFillColor(1,1,1)
	genericAlertGroup:insert(genericAlert_Toptext)

	genericAlert_content = display.newText(content,0,0,W-20,0,native.systemFont,14)
	genericAlert_content.x = 20
	genericAlert_content.anchorX= 0
	genericAlert_content.y=genericAlert_Top.y+genericAlert_Top.contentHeight+5
	genericAlert_content:setFillColor(0,0,0)
	genericAlertGroup:insert(genericAlert_content)

	local random = math.random( 1,2 )
	if random == 1 then
		genericAlertGroup.y= -W+100
	else
		genericAlertGroup.y=W+100
	end

	
	transition.to( genericAlertGroup, {time=400,y=0,transition=easing.outBack} )


end

--[[	local option ={
			 {content="yes",positive=true},
			{content="no",positive=false}
			}
		genericAlert.createNew("MUB","Are you sure to delete?",option)]]

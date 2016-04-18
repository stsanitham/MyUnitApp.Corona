
timePicker = {}
local widget = require( "widget" )
local W = display.contentWidth;H= display.contentHeight

print( "######"..os.date( "%p" ))
local Min = {}
	local Hour = {}
	for i = 1,60 do Min[i] = (string.format("%02d",i-1)) end
	for j = 1,12 do Hour[j] = (string.format("%02d",j)) end

	local tz = {"AM","PM"}

	local columnData = { 
		{
			align = "right",
			width = 125,
			startIndex = tonumber(string.format("%2d",os.date( "%I" ))),
			labels = Hour,
		},
		{
			align = "center",
			width = 70,
			startIndex = tonumber(string.format("%2d",os.date( "%M" ))),
			labels = Min,
		},
		{
			align = "center",
			width = 65,
			startIndex = table.indexOf( tz, os.date( "%p" ) ),
			labels = tz,
		},
	}



	



timePicker.getTimeValue = function(listner)



local function showValues( event )
		-- Retrieve the current values from the picker
		local values = pickerWheel:getValues()
		
		-- Update the status box text
		--statusText.text = "Column 1 Value: " .. values[1].value .. "\nColumn 2 Value: " .. values[2].value .. "\nColumn 3 Value: " .. values[3].value
		--[[
		for i = 1, #values do
			print( "Column", i, "value is:", values[i].value )
			print( "Column", i, "index is:", values[i].index )
		end
		--]]
		display.remove(doneBg);doneBg=nil
		display.remove(getValuesButton);getValuesButton=nil
		display.remove(pickerWheel);pickerWheel=nil
		listner(values[1].value..":"..values[2].value.." "..values[3].value)
		
		return true
	end



if pickerWheel then display.remove(pickerWheel);pickerWheel=nil end
if doneBg then display.remove(doneBg);doneBg=nil end
if getValuesButton then display.remove(getValuesButton);getValuesButton=nil end



	pickerWheel = widget.newPickerWheel {
		top = display.contentHeight-192,
		columns = columnData
	}
	pickerWheel.x = display.contentCenterX

	doneBg = display.newRect(W/2,0,W,30)
	doneBg:setFillColor( 1 )
	doneBg.x=W/2;doneBg.y=pickerWheel.y-pickerWheel.contentHeight/2

	getValuesButton = display.newText(CommonWords.done, 0, 0, native.systemFont, 20 )
	getValuesButton:setFillColor(Utils.convertHexToRGB(color.today_blue))
	getValuesButton.x=doneBg.x+100;getValuesButton.y=doneBg.y
	getValuesButton:addEventListener( "touch", showValues )


end


return timePicker
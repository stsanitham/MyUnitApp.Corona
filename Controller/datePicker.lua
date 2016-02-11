
datePicker = {}
local widget = require( "widget" )
local W = display.contentWidth;H= display.contentHeight

local monthArray={ "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" }
local weekLbl = {"Sun","Mon","Tue","Wed","Thu","Fri","Sat"}
local days = {}
local years = {}

-- Populate the "days" table
for d = 1, 31 do
    days[d] = string.format("%02d",d)

    print( days[d] )
end

-- Populate the "years" table
for y = 1, 48 do
    years[y] = (os.date( "%Y" )-5) + y
end

-- Configure the picker wheel columns
local columnData = 
{
    -- Months
    { 
        align = "right",
        width = 140,
        startIndex =tonumber(os.date( "%m" )),
        labels = monthArray
    },
    -- Days
    {
        align = "center",
        width = 60,
        startIndex = tonumber(os.date( "%d" )),
        labels = days
    },
    -- Years
    {
        align = "center",
        width = 80,
        startIndex = 5,
        labels = years
    }
}


	



datePicker.getTimeValue = function(listner)


	local getValuesButton,pickerWheel,doneBg

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
		listner(string.format("%02d",values[1].index).."/"..values[2].value.."/"..values[3].value)
		
		return true
	end

print( "############" )

	pickerWheel = widget.newPickerWheel {
		top = display.contentHeight-200,
		columns = columnData
	}
	pickerWheel.x = display.contentCenterX

	doneBg = display.newRect(W/2,0,W,35)
	doneBg:setFillColor( 1 )
	doneBg.x=W/2;doneBg.y=pickerWheel.y-pickerWheel.contentHeight/2

	getValuesButton = display.newText(CommonWords.done, 0, 0, native.systemFont, 20 )
	getValuesButton:setFillColor(Utils.convertHexToRGB(color.today_blue))
	getValuesButton.x=doneBg.x+100;getValuesButton.y=doneBg.y
	getValuesButton:addEventListener( "touch", showValues )



end


return datePicker
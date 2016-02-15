application =
{
	content = {
	
		width = 320,
        height = 480,
        scale = "normal",
        xAlign = "center",
        yAlign = "center",
        audioPlayFrequency = 22050,
	},
}


-- application =
-- {
--         content =
--         {
--                 width = 330,
--                 height = 586,
--                 scale = "letterbox",
--           		xAlign = "center",
--         		yAlign = "center",
--         },
-- } 

--[[if ( string.sub( system.getInfo("model"), 1, 2 ) == "iP" and display.pixelHeight > 960 ) then
	application =
	   {
	      content =
	      {
	         width = 320,
	         height = 568,
	         scale = "letterBox",
	         xAlign = "center",
	         yAlign = "center",
	         
	      },

	}


elseif ( string.sub( system.getInfo("model"), 1, 2 ) == "iP" ) then
   application =
   {
      content =
      {
         width = 320,
         height = 480,
         scale = "letterBox",
         xAlign = "center",
         yAlign = "center",
        
      },
   }
elseif ( display.pixelHeight / display.pixelWidth > 1.72 ) then
   application =
   {
      content =
      {
         width = 320,
         height = 570,
         scale = "letterBox",
         xAlign = "center",
         yAlign = "center",
         
      },
   }

else
   application =
   {
      content =
      {
         width = 320,
         height = 512,
         scale = "letterBox",
         xAlign = "center",
         yAlign = "center",
        
      },
   }
   end]]
	--[[
	-- Push notifications
	notification =
	{
		iphone =
		{
			types =
			{
				"badge", "sound", "alert", "newsstand"
			}
		}
	},
	--]]    
--}

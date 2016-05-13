application =
{
	content = {
	
		width = 320,
        height = 480,
        scale = "normal",
        xAlign = "center",
        yAlign = "center",
        audioPlayFrequency = 44100,
	},

	 notification = 
    {
        google =
        {
            projectNumber = "800876064299"
        },

        iphone =
		{
			types =
			{
				"badge", "sound", "alert", "newsstand"
			}
		}
    }  
}


-- -- application =
-- -- {
-- --         content =
-- --         {
-- --                 width = 350,
-- --                 height = 586,
-- --                 scale = "letterbox",
-- --           		xAlign = "center",
-- --         		yAlign = "top",
-- --         },
-- -- } 

-- -- if ( string.sub( system.getInfo("model"), 1, 2 ) == "iP" and display.pixelHeight > 960 ) then
-- -- 	application =
-- -- 	   {
-- -- 	      content =
-- -- 	      {
-- -- 	         width = 320,
-- -- 	         height = 568,
-- -- 	         scale = "letterBox",
-- -- 	         xAlign = "center",
-- -- 	         yAlign = "center",
	         
-- -- 	      },

-- -- 	}


-- if ( string.sub( system.getInfo("model"), 1, 2 ) == "iP" ) then
--    application =
--    {
--       content =
--       {
--          width = 320,
--          height = 480,
--          scale = "letterBox",
--          xAlign = "center",
--          yAlign = "center",
        
--       },
--    }
--  end
-- --[[elseif ( display.pixelHeight / display.pixelWidth > 1.72 ) then
--    application =
--    {
--       content =
--       {
--          width = 320,
--          height = 570,
--          scale = "letterBox",
--          xAlign = "center",
--          yAlign = "center",
         
--       },
--    }

-- else
--    application =
--    {
--       content =
--       {
--          width = 320,
--          height = 512,
--          scale = "letterBox",
--          xAlign = "center",
--          yAlign = "center",
        
--       },
--    }
--    end]]
-- 	--[[
-- 	-- Push notifications
-- 	notification =
-- 	{
-- 		iphone =
-- 		{
-- 			types =
-- 			{
-- 				"badge", "sound", "alert", "newsstand"
-- 			}
-- 		}
-- 	},
-- 	--]]    
-- --}




----------------------------------------------NEWLY MODIFIED--------------------------------------------------------

-- if string.sub(system.getInfo("model"),1,4) == "iPad" then
--     application = 
--     {
--         content =
--         {           
--             fps = 60,
--             width = 360,
--             height = 480,
--             scale = "letterBox",
--             xAlign = "center",
--             yAlign = "center",
--             imageSuffix = 
--             {
--                 ["@2x"] = 1.5,
--                 ["@4x"] = 3.0,
--             },
--         },
--         notification = 
--         {
--             iphone = {
--                 types = {
--                     "badge", "sound", "alert"
--                 }
--             },
--         }
--     }

-- elseif string.sub(system.getInfo("model"),1,2) == "iP" and display.pixelHeight > 960 then
--     application = 
--     {
--         content =
--         {
--             antialias = true,
--             fps = 60,
--             width = 320,
--             height = 568,
--             scale = "letterBox",
--             xAlign = "center",
--             yAlign = "center",
--             imageSuffix = 
--             {
--                 ["@2x"] = 1.5,
--                 ["@4x"] = 3.0
--             },
--         },
--         notification = 
--         {
--             iphone = {
--                 types = {
--                     "badge", "sound", "alert"
--                 }
--             },
        
--         }
--     }

-- elseif string.sub(system.getInfo("model"),1,2) == "iP" then
--     application = 
--     {
--         content =
--         {
--             antialias = true,
--             fps = 60,
--             width = 320,
--             height = 480,
--             scale = "letterBox",
--             xAlign = "center",
--             yAlign = "center",
--             imageSuffix = 
--             {
--                 ["@2x"] = 1.5,
--                 ["@4x"] = 3.0,
--             },
--         },
--         notification = 
--         {
--             iphone = {
--                 types = {
--                     "badge", "sound", "alert"
--                 }
--             },
           
--         }
--     }
-- elseif display.pixelHeight / display.pixelWidth > 1.72 then
--     application = 
--     {
--         content =
--         {
--             antialias = true,
--             fps = 60,
--             width = 320,
--             height = 570,
--             scale = "letterBox",
--             xAlign = "center",
--             yAlign = "center",
--             imageSuffix = 
--             {
--                 ["@2x"] = 1.5,
--                 ["@4x"] = 3.0,
--             },
--         },
--     }
-- else
--     application = 
--     {
--         content =
--         {
--             antialias = true,
--             fps = 60,
--             width = 320,
--             height = 512,
--             scale = "letterBox",
--             xAlign = "center",
--             yAlign = "center",
--             imageSuffix = 
--             {
--                 ["@2x"] = 1.5,
--                 ["@4x"] = 3.0,
--             },
--         },
--         notification = 
--         {
--             iphone = {
--                 types = {
--                     "badge", "sound", "alert"
--                 }
--             },
        
--         }
--     }
-- end
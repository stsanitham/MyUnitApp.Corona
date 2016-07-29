ApplicationConfig = {}


if AppPlatform:lower( ) == "android" then

---------Android Live----------------

IsLive = true

ApplicationConfig.Version = "/Android/"..AndroidVersion	    --1.2.2

ApplicationConfig.BASE_URL = "http://api.myunitbuzz.com/"..ApplicationConfig.Version

ApplicationConfig.OneSignal_Appid = "e1eb0e41-5e12-488b-800a-5596fab2d45a"

ApplicationConfig.IMAGE_BASE_URL = "http://c.unitwise.com/"

ApplicationConfig.API_PUBLIC_KEY = "gVbPxZHlEcnaM5LLEQ7j7Wc"

ApplicationConfig.ProjectNumber = "464801321790"

ApplicationConfig.API_PRIVATE_KEY = "5Doh1kteJKYZbSemCipRTGZiyzRAAhkSKEDhAf5TPcY"

ApplicationConfig.Analysic_TrackId = "UA-51545075-4"


elseif AppPlatform:lower( ) == "ios" then



---------IOS Live----------------

IsLive = true


ApplicationConfig.Version = "/iOS/"..IosVersion	    --1.1.2

ApplicationConfig.BASE_URL = "http://api.myunitbuzz.com/"..ApplicationConfig.Version

ApplicationConfig.OneSignal_Appid = "e1eb0e41-5e12-488b-800a-5596fab2d45a"

ApplicationConfig.IMAGE_BASE_URL = "http://c.unitwise.com/"

ApplicationConfig.API_PUBLIC_KEY = "1WpGzpHPab445FJgxSpo8NJ"

ApplicationConfig.ProjectNumber = "464801321790"

ApplicationConfig.API_PRIVATE_KEY = "i67cHiLg5p7XkrnLrW2L6x4xNsqpNworZgboKHGHpdc"

ApplicationConfig.Analysic_TrackId = "UA-51545075-4"


end


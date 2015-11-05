ApplicationConfig = {}



ApplicationConfig.BASE_URL = "http://api.myunitapp.dotnetethic.com"
ApplicationConfig.API_PUBLIC_KEY = "Or2tf5TjnfLObg5qZ1VfLOd"
ApplicationConfig.API_PRIVATE_KEY = "ZujprDvpDDi4lvcitlgaRksJtpKxT7SOHiMxoB17i28"

ApplicationConfig.testUrl = ApplicationConfig.BASE_URL.."/Therapy/List"

ApplicationConfig.GET_LIST_OF_RANKS = ApplicationConfig.BASE_URL.."/MyUnitApp/GetListOfMkRanks"

ApplicationConfig.REQUEST_ACCESS = ApplicationConfig.BASE_URL.."/MyUnitApp/MyUnitAppRequestAccess"

ApplicationConfig.LOGIN_ACCESS = ApplicationConfig.BASE_URL.."/MyUnitApp/SignIn?emailAddress={emailAddress}&password={password}&unitNumberOrDirectorName={unitNumberOrDirectorName}"




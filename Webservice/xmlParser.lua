local M = {}

local socket = require "socket"
local dispatch = require "Utils.dispatch"
local http = require "socket.http"
local ltn12 = require "ltn12"
local dispatch1 = require("Utils.dispatch")

TIMEOUT = 10
local Runtime = Runtime
local table = table
local print = print
local coroutine = coroutine

local function blockingRequest( httpRequest )

    local body
    if httpRequest.body then

      body = ltn12.source.string(httpRequest.body)

    end


    local httpResponse = { 
        body = {},
    }

   
    
    local result
    result, httpResponse.code, httpResponse.headers, httpResponse.status = http.request{
        url =  httpRequest.url,
        method = httpRequest.method,
        headers = httpRequest.headers,
        source = body,
        sink = ltn12.sink.table(httpResponse.body),
        proxy = httpRequest.proxy,
    }

   

    if result then

  print("enter")

        httpResponse.body = table.concat(httpResponse.body)

        return {
            isError = false,
            request = httpRequest,
            response = httpResponse,
        }
    else
        return {
            isError = true,
            errorMessage = httpResponse.code,
            request = httpRequest,
        }
    end

end

local function asyncRequest( httpRequest, listener )
        print("**********************************")

	local handler = dispatch.newhandler("coroutine")
	local running = true
    spinner_show()
	handler:start(function()
    
		local body
        if httpRequest.body then
            body = ltn12.source.string(httpRequest.body)
        end

        local httpResponse = { 
            body = {},
        }
        
        local result
		result, httpResponse.code, httpResponse.headers, httpResponse.status = http.request{
			url = httpRequest.url,
			method = httpRequest.method,
			create = handler.tcp,
			headers = httpRequest.headers,
			source = body,
			sink = ltn12.sink.table(httpResponse.body),
            proxy = httpRequest.proxy,
		}
		if result then
            httpResponse.body = table.concat(httpResponse.body)
			listener{
				isError = false,
                request = httpRequest,
				response = httpResponse,
			}
		else
			listener{
				isError = true,
                errorMessage = httpResponse.code,
                request = httpRequest,
			}
		end
		running = false
         spinner_hide()
        
	end)
    
	local httpThread = {}
    
	function httpThread.enterFrame()
		if running then
            handler:step()
		else
			Runtime:removeEventListener("enterFrame", httpThread)
		end
	end
    
	function httpThread:cancel()
		Runtime:removeEventListener("enterFrame", self)
        --spinner_hide()
		handler = nil
	end
    
	Runtime:addEventListener("enterFrame", httpThread)
	return httpThread
end

function M.xmlParser( httpRequest, listener )


    if listener then

        return asyncRequest(httpRequest, listener)
    else

        return blockingRequest(httpRequest)
    end
end

return M
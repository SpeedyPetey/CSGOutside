print("Commands are now running\n")

function connect()
    websocket = require'websocket'
    url = 'ws://206.87.112.30:8000/fe-ws'
    client = websocket.createClient()

    --Send Backend Connected
    local json_payload = '{"id":"backend", "data":"Backend Connected"}'
    client:on("connection", function()
        client:send(json_payload)
    end)
    
    --Receive Data from Server
    client:on("receive", function(_, msg, opcode)
        currentstate = string.match(msg, '"state"%s*:%s*"([^"]+)"')
        if currentstate == "attack" then
            sendHardware(currentstate)
        end
    end)
    client:connect(url)
end

function sendServer(msg)
    local json_payload = '{"id":"backend", "data":"' .. msg .. '"}'
    client:send(json_payload)
end


function sendHardware(msg)
    print("\nSending to Hardware\n")
    msg = "<" .. msg .. ">"
    uart.setup(0, 115200, 8, uart.PARITY_NONE, uart.STOPBITS_1, 0)
    uart.write(0, msg)
end

--SSID    = "SpeedyPetey"
--APPWD   = "peteriscool"
CMDFILE = "commands.lua"   -- File that is executed after connection

wifiTrys     = 15     -- Counter of trys to connect to wifi
NUMWIFITRYS  = 200    -- Maximum number of WIFI Testings while waiting for connection

function launch()
  print("Connected to WIFI!")
  print("IP Address: " .. wifi.sta.getip())
  -- Call our command file. Note: if you foul this up you'll brick the device!
  dofile(CMDFILE)
  --makeConn()
end

function checkWIFI() 
  if ( wifiTrys > NUMWIFITRYS ) then
    print("Sorry. Not able to connect")
    uart.write(0, "Sorry. Not able to connect\n")
  else
    ipAddr = wifi.sta.getip()
    if ( ( ipAddr ~= nil ) and  ( ipAddr ~= "0.0.0.0" ) )then
      --tmr.alarm( 1 , 500 , 0 , launch )
      local mytimer1 = tmr.create()
      mytimer1:register(2500, tmr.ALARM_SINGLE, function (t) launch(); t:unregister() end)
      mytimer1:start()
    else
      -- Reset alarm again
      --tmr.alarm( 0 , 2500 , 0 , checkWIFI)
      local mytimer2 = tmr.create()
      mytimer2:register(2500, tmr.ALARM_SINGLE, function (t) checkWIFI(); t:unregister() end)
      mytimer2:start()

      print("Checking WIFI..." .. wifiTrys)
      uart.write(0, "Checking WIFI...\n")
      wifiTrys = wifiTrys + 1
    end 
  end 
end

print("-- Starting up! ")
uart.setup(1, 115200, 8, uart.PARITY_NONE, uart.STOPBITS_1, 0)

-- Lets see if we are already connected by getting the IP
ipAddr = wifi.sta.getip()
if ( ( ipAddr == nil ) or  ( ipAddr == "0.0.0.0" ) ) then
  -- We aren't connected, so let's connect
  print("Configuring WIFI....")
  wifi.setmode( wifi.STATION )
  --inserted below
  station_cfg={}
  station_cfg.ssid="SpeedyPetey"
  station_cfg.pwd="peteriscool"
  station_cfg.save=true
  wifi.sta.config(station_cfg)
  --wifi.sta.config( SSID , APPWD)
  print("Waiting for connection")
  --tmr.alarm( 0 , 2500 , 0 , checkWIFI )
  local mytimer = tmr.create()
  mytimer:register(2500, tmr.ALARM_SINGLE, function (t) checkWIFI(); t:unregister() end)
  mytimer:start()

else
 -- We are connected, so just run the launch code.
 launch()
end

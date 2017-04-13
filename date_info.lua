local setmetatable = setmetatable
local io           = io
local os           = os
local string       = string
local print        = print
local tonumber     = tonumber
local util         = require( "awful.util"               )
local wibox        = require( "wibox"                    )
local button       = require( "awful.button"             )
local vicious      = require( "vicious"           )
local menu         = require( "radical.context"          )
local widget       = require( "awful.widget"             )
local radical      = require( "radical"                  )
local beautiful    = require( "beautiful"                )
local json         = require( "lain.util.dkjson"              )
local spawn        = require( "awful.spawn"              )
local shape        = require( "gears.shape"              )
local ct           = require( "radical.widgets.constrainedtext" )
local markup       = require("lain.util.markup")
local capi = { screen = screen , mouse  = mouse  , timer  = timer  }
local naughty      = require( "naughty" )
local gears        = require( "gears" )
local info_menu    = require( "info_menu" )
local inspect      = require( "inspect" )

local dateModule = {}
local dateInfoMenu = info_menu()
local mainMenu = nil
local month = {"Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"}

function dump(o)
   if type(o) == 'table' then
      local s ='{'
      for k,v in pairs(o) do
	 if type(k) ~= 'number' then k='"'..k..'"' end
	 s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '}'
   else
      return tostring(o)
   end
end

local function getHour(input)
  local toReturn
  if input < 0 then
    toReturn = 24 + input
  elseif input > 24 then
    toReturn = input - 24
  else
    toReturn = input
  end
  return toReturn
end

local function testFunc()
  local dateInfo = ""
  local pipe=io.popen(util.getdir("config")..'/Scripts/worldTime.sh')
  dateInfo=pipe:read("*a")
  dateInfo = dateInfo:gsub("\n$", "")
  pipe:close()
  return {dateInfo}
end

local function createDrawer()

  test.parent = "test"

  --[[
  --Weather stuff
  local weatherInfo2=wibox.widget.textbox()

  function updateWeater()
    if dateModule.latitude ~= nil and dateModule.longitude ~= nil then
       local address = "http://api.openweathermap.org/data/2.5/weather?lat="..dateModule.latitude.."&lon="..dateModule.longitude;
       error( address )
      local f=io.popen("curl -S '"..address.."'")
      local weatherInfo = nil
      if f ~= nil then
        local wData=json.decode(f:read("*all"), 1, nil)
        f:close()
        if wData ~= nil then
	   error(dump(wData))
          weatherInfo=" "..wData.name..", "..wData.sys.country.."\n"
          weatherInfo=weatherInfo.."  <b>Temp:</b> "..(wData.main.temp-273.15).." °C\n"
          weatherInfo=weatherInfo.."  <b>Wind:</b> "..(wData.wind.speed).." m/s\n"
          weatherInfo=weatherInfo.."  <b>Humidity:</b> "..(wData.main.humidity).." hPa"

          weatherInfo2:set_markup(weatherInfo or "N/A")
        else
          weatherInfo2:set_markup("N/A")
        end
      end
    end
  end

  mytimer2 = capi.timer({ timeout = 1800 })
  mytimer2:connect_signal("timeout", updateWeater)
  mytimer2:start()
  updateWeater()
  --]]

  local camImage       = wibox.widget.imagebox()
  local testImage3     = wibox.widget.imagebox()
  camImage:set_image("/tmp/cam")
  testImage3:set_image("/tmp/dateInfo.map")

  --local spacer96                   = wibox.widget.textbox()
  --spacer96:set_text("\n\n")

  --mainMenu:add_widget(weatherInfo2)
  local calendarHeader = radical.widgets.header(mainMenu, "CALENDAR"     ),{height = 20 , width = 200}
  calendarHeader2 = wibox.widget.base.make_widget( calendarHeader )
  mainMenu:add_widget(calendarHeader2)
  --mainMenu:add_item(calInfo)
  mainMenu:add_widget(radical.widgets.header(mainMenu, "INTERNATIONAL"),{height = 20 , width = 200})
  --mainMenu:add_item(timeInfo)
  --mainMenu:add_widget(radical.widgets.header(mainMenu, "CAM"    ),{height = 20 , width = 200})
  --mainMenu:add_item(camImage)
  mainMenu:add_widget(radical.widgets.header(mainMenu, "MAP"    ),{height = 20 , width = 200})
  mainMenu:add_widget(testImage3)
  --mainMenu:add_widget(radical.widgets.header(mainMenu, "FORCAST"      ),{height = 20 , width = 200})
  return testImage3:get_preferred_size()
end

--Widget stuff
local ib2 = nil
function dateModule.update_date_widget()
  ib2:set_text(month[tonumber(os.date('%m'))].." "..os.date('%d'))
end


--Functions-------------------------------------------------
--Private-------------
local function getPosition()
  local pipe=io.popen("curl -s http://whatismycountry.com/ | awk '/<h3>/;/Location/;/Coordinates/'")
  local buffer=pipe:read("*a")
  pipe:close()

  _, _, city, country = string.find(buffer, "(%a+),(%a+)")
  _, _, latitude,longitude = string.find(buffer, "Coordinates ([0-9.]+)%s+([0-9.]+)")
  _, _, mapUrl = string.find(buffer, "src=\"(%S+)\"[^<>]+Location")

  --print(city, country,latitude,longitude,mapUrl)

  --Save map image
  if mapUrl ~= nil then
    spawn.with_shell("wget -q \""..mapUrl.."\" -O /tmp/dateInfo.map > /dev/null")
  end

  --Save Position
  dateModule.latitude=latitude or dateModule.latitude
  dateModule.longitude=longitude or dateModule.longitude
  dateModule.city=city or dateModule.city
  dateModule.country=country or dateModule.country

end

local camUrl,camTimeout = nil,nil
local function init()
  
end

local function new(screen, args)
  local calInfo = wibox.widget.textbox()
  local timeInfo = wibox.widget.textbox()

  vicious.register(timeInfo,  testFunc, '$1',1)
  function updateCalendar()
    function update( year, month, day )
      day = day or 0
      local fg   = theme.fg_normal
      local bg   = theme.bg_normal
      local we   = theme.border_normal
      local f = io.popen('/usr/bin/cal -m ' .. month .. " " .. year ,"r")
      local title = f:read()
      local description = f:read()
      local calendar_data = f:read( "*all" ) 
      calendar_data = calendar_data:gsub("(%d%d%d%d)", "%1 ")
      calendar_data = calendar_data:gsub('(%d+%s%s%s)(%s\n)', markup.color(we, bg, '%1')..'%2')
      calendar_data = calendar_data:gsub('(%d+%s+%d+)(%s\n)', markup.color(we, bg, '%1') .. '%2')
      calendar_data = calendar_data:gsub('(%d+)(%s\n)', markup.color(we, bg, '%1')..'%2')
      calendar_data = calendar_data:gsub('%s\n','\n')
      calendar_data = calendar_data:gsub("[\n%s]+$", "")
      calendar_data = calendar_data:gsub("\n+$", "")
      calendar_data = calendar_data:gsub("(%D)"..day.."(%D)", "%1<b><u>"..markup.color(bg, fg, day).."</u></b>%2")
      local result = "<tt><b><i>" .. title .. "</i></b><u>" .. "\n" .. description .. '</u>\n' .. calendar_data .. "</tt>"
      f:close()
      return result
    end
    local day = tonumber(os.date('%d'))
    local month = os.date('%m')
    local year = os.date('%Y')

    calInfo.markup = update( year, month, day )
  end

  --Calendar stuff

  updateCalendar()

  local new_shape = function( cr, width, height )
    gears.shape.partially_rounded_rect( cr, width, height, true, true, false, false, 5 )
  end
  dateInfoMenu.add_header( "Calendar" )
  dateInfoMenu.add_widget( calInfo )
  dateInfoMenu.add_header( "Time" )
  dateInfoMenu.add_widget( timeInfo )
  --Location variables
  dateModule.city,dateModule.country,dateModule.mapUrl = nil,nil,nil
  --Cam variables

  --Arg parsing
  if args ~= nil then
    camUrl=args.camUrl
    camTimeout=args.camTimeout or 1800
  end

  --Public--------------
  --Toggles date menu and returns visibility
  function dateModule.toggle(geo)
    if not  mainMenu then
      --Constructor---------------------------------------------
      if camUrl then
        --Download new image every camTimeout
        local timerCam = capi.timer({ timeout = camTimeout })
        timerCam:connect_signal("timeout", function() spawn.with_shell("wget -q "..camUrl.." -O /tmp/cam") end)
        timerCam:start()
      end

      --Check for position every 60 minutes 
      local timerPosition = capi.timer({ timeout = 3600 })
      timerPosition:connect_signal("timeout", getPosition)
      timerPosition:start()
      getPosition()

      mainMenu = radical.context(
	 {
	    header = "test",
	    layout = radical.layout.grid,
	    column = 1,
	    arrow_type=radical.base.arrow_type.CENTERED,
	    select_on = radical.item.event.NEVER
      })
      local screen_txt = wibox.widget.textbox()
      screen_txt:set_markup( "<b>test2</b>" )
      mainMenu:add_widget( screen_txt )
      mainMenu:add_item {text="Screen 9\nabc",icon= beautiful.awesome_icon}
      min_width = createDrawer()
      mainMenu.width = min_width + 2*mainMenu.border_width + 150
      mainMenu._internal.width = min_width
    end
    if not mainMenu.visible then
      if geo then
        mainMenu.parent_geometry = geo
      end

      mainMenu.visible = true
      return true
    else
      mainMenu.visible = false
      mainMenu=nil
      return false
    end
  end

  local mytextclock = wibox.widget.textclock(" %H:%M ")

  --Date widget

  local mytimer5 = capi.timer({ timeout = 1800 }) -- 30 mins
  mytimer5:connect_signal("timeout", dateModule.update_date_widget)
  mytimer5:start()

  local right_layout = wibox.layout {
    mytextclock,
    {
      {
        {
          {
            text    = "Jan 01",
            id      = "date",
            padding = 1,
            widget  = ct
          },
          top    = 2,
          bottom = 2,
          left   = 5,
          right  = 5,
          widget = wibox.container.margin
        },
        fg     = beautiful.bg_normal,
        bg     = beautiful.fg_normal,
        shape  = shape.rounded_bar,
        widget = wibox.container.background
      },
      margins = 3,
      widget  = wibox.container.margin
    },
    buttons = util.table.join(button({ }, 1, dateInfoMenu.toggle )),
    layout  = wibox.layout.fixed.horizontal
  }

  ib2 = right_layout : get_children_by_id "date" [1]
  dateModule.update_date_widget()

  right_layout:connect_signal( "mouse::enter", dateInfoMenu.previewOn )
  right_layout:connect_signal( "mouse::leave", dateInfoMenu.previewOff )

    local f=io.popen("task '(status:pending|status:waiting)' export")
    if f ~= nil then
        local wData=json.decode(f:read("*all"), 1, nil)
	--error(inspect(#wData))
    end

  return right_layout
end

return setmetatable(dateModule, { __call = function(_, ...) return new(...) end })
-- kate: space-indent on; indent-width 2; replace-tabs on;

local setmetatable = setmetatable
local io           = io
local pairs        = pairs
local ipairs       = ipairs
local print        = print
local loadstring   = loadstring
local tonumber     = tonumber
local next         = next
local type         = type
local table        = table
local button       = require( "awful.button"             )
local beautiful    = require( "beautiful"                )
local widget2      = require( "awful.widget"             )
local wibox        = require( "wibox"                    )
local menu         = require( "radical.context"          )
local radtab       = require( "radical.widgets.table"    )
local vicious      = require("vicious")
--local config       = require( "forgotten"                )
local util         = require( "awful.util"               )
local radical      = require( "radical"                  )
--local themeutils   = require( "blind.common.drawing"     )
local embed        = require( "radical.embed"            )
local color        = require( "gears.color"              )
local cairo        = require( "lgi"                      ).cairo
local allinone     = require( "widgets.allinone"         )
local fd_async     = require("utils.fd_async"         )

local info_menu    = require("info_menu"         )
local awful        = require("awful")
local inspect      = require("inspect")

local capi = { image  = image  ,
    screen = screen ,
    widget = widget ,
    client = client ,
    mouse  = mouse  ,
    timer  = timer  }

local ramInfoMenu = info_menu()

local module = {}

local dataMenu = nil

--local myTimer

local tabWdg = nil
local tabWdgCol = {
    TOTAL =1,
    FREE  =2,
    USED  =3,
}
local tabWdgRow = {
    RAM =1,
    SWAP=2
}

--MENUS
local usrMenu,typeMenu,topMenu
local st = false

local function split( str, delimiter )
    local retval = {}
    local counter = 1
    for i in string.gmatch( str, "[^"..delimiter.."]+") do
	retval[counter] = i
	counter=counter+1
    end
    return retval
end

local function refreshStat()
    local process={}
    local memState={}
    --Load all info
    fd_async.exec.command(util.getdir("config")..'Scripts/memStatistics.sh'):connect_signal("new::line",function(content)
            --Ignore nil content
            if content == nil then return end

            --Check header
	    local packet = split( content, ";" )
            --Check for header
            if packet[1] == 't' then
                --Top line

                --Check for empty packet line
                if packet[2] ~= nil then
		    local t = split(packet[2], ",")
                    --Insert process
                    table.insert(process,t)
                else
                    --Repaint
		    topMenu.children = {}
                    for i = 0, #(process or {}) do
                        if process[i] ~= nil then
                            local aMem = wibox.widget.textbox()
                            aMem:set_text(process[i][1].." %")
                            aMem.fit = function()
                                return 58,22
                            end

                            for k2,v2 in ipairs(capi.client.get()) do
                                if v2.class:lower() == process[i][2]:lower() or v2.name:lower():find(process[i][2]:lower()) ~= nil then
                                    aMem.bg_image = v2.icon
                                    break
                                end
                            end

                            local aMemName = wibox.widget.textbox()
                            aMemName:set_text(process[i][2])

                            local killImage       = wibox.widget.imagebox()
			    killImage:set_forced_height( 22 )
                            killImage:set_image(beautiful.icon_path .. "kill.png")

			    local entry = wibox.layout.align.horizontal()
			    entry.forced_width = 200
			    --entry.forced_height= 200
			    entry.first = aMem
			    entry.second = aMemName
			    entry.third = killImage
                            topMenu:add(entry)
                        end
                    end
                end



            elseif packet[1] == 'u' then
                -- Users line
                --Clear User menu
		usrMenu.children = {}
                --Reload User list
                if packet[2] ~= nil then
                    local data=split( packet[2], ',')
                    for key,field in pairs(data) do
			if #usrMenu.children < usrMenu.max_items then
			    --Load user data
			    local user=split( field, ' ')
			    --print("N:",user[1],"User:",user[2])

			    local anUser = wibox.widget.textbox()
			    anUser:set_text( user[2] .. "("..user[1]..")" )
			    usrMenu:add(anUser)
			end
                    end
                end
            elseif packet[1] == 'p' then
                --Process line
                if packet[2] ~= nil then
		    local data = split( packet[2], "," )
                    for key,field in pairs(data) do
			local temp = split( field, " " )
			table.insert( memState, { temp[2] .. "(" .. temp[1] .. ")", temp[1] } )
                    end
                    if memState ~= nil then
			typeMenu:set_data_list(memState)
                    end
                end
            else
                print("INFO@memInfo: Unknown line",packet[2])
            end
        end)


end

local function repaint()

    local imb = wibox.widget.imagebox()
    imb:set_image(beautiful.icon_path .. "reload.png")
    imb:set_forced_height(22)
    imb:buttons(button({ }, 1, function (geo) refreshStat() end))

    ramInfoMenu.add_header( "Usage", imb )

    local m3 = wibox.container.margin()
    m3:set_margins(3)
    m3:set_bottom(10)
    local tab,wdgs = radtab({
            {"","",""},
            {"","",""}},
        {row_height=20,v_header = {"Ram","Swap"},
            h_header = {"Total","Free","Used"}
        })
    tabWdg = wdgs
    m3:set_widget(tab)
    m3:set_forced_width( 300 )
    ramInfoMenu.add_widget(m3)
    ramInfoMenu.add_header("Users")
    usrMenu = wibox.layout.fixed.vertical()
    usrMenu.max_items = 3
    ramInfoMenu.add_widget(usrMenu)

    ramInfoMenu.add_header("State")

    typeMenu = wibox.widget {
       data_list = {
	  { 'L1', 100 },
	  { 'L2', 200 },
	  { 'L3', 300 }
       },
       border_width = 1,
       colors = {
	  beautiful.bg_normal,
	  beautiful.bg_highlight,
	  beautiful.border_color,
       },
       widget = wibox.widget.piechart
    }
    typeMenu:set_forced_width( 100)
    typeMenu:set_forced_height( 100)
    ramInfoMenu.add_widget(typeMenu)
    refreshStat()

    ramInfoMenu.add_header("Processes")

    topMenu = wibox.layout.fixed.vertical()
    ramInfoMenu.add_widget(topMenu)

    return mainMenu
end

local function new(margin, args)
   --[[
    local function toggle()
        if not dataMenu then
            dataMenu = repaint()
        end
        if not dataMenu.visible then
            refreshStat()
        end

        return dataMenu
    end
   ]]--

   repaint()

    local memwidget = wibox.widget.textbox()
    memwidget.height = 22
    memwidget.width = 44
    memwidget.align = "center"

    -- Initialize widget
    local memwidget_graph = wibox.widget.graph()
    -- Graph properties
    memwidget_graph:set_width( 40 )
    memwidget_graph:set_background_color(beautiful.bg_alternate)
    memwidget_graph:set_max_value( 100 )
    memwidget_graph:set_color(
	{
	    type = "linear",
	    from = { 0, 0 },
	    to = { 0, 22 },
	    stops = {
		{0, "#7F2828"},
		{0.5, "#44503A"},
		{1, "#576748" }
	    } 
	} ) 

    local function parseViciousMemstat(widget,content)
	tabWdg[ tabWdgRow.RAM  ][ tabWdgCol.TOTAL ]:set_text( string.format("%.2f GB",content[3]/1024) or "N/A")
	tabWdg[ tabWdgRow.RAM  ][ tabWdgCol.FREE  ]:set_text( string.format("%.2f GB",content[4]/1024) or "N/A")
	tabWdg[ tabWdgRow.RAM  ][ tabWdgCol.USED  ]:set_text((string.format("%.1f",content[1]) or "N/A") .. " %" )
	tabWdg[ tabWdgRow.SWAP ][ tabWdgCol.TOTAL ]:set_text( string.format("%.1f GB",content[7]/1024) or "N/A")
	tabWdg[ tabWdgRow.SWAP ][ tabWdgCol.FREE  ]:set_text( string.format("%.1f GB",content[8]/1024) or "N/A")
	tabWdg[ tabWdgRow.SWAP ][ tabWdgCol.USED  ]:set_text((string.format("%.2f",content[5]) or "N/A") .. " %" )
	memwidget_graph:add_value( content[1], 1 )
	return content[1] .. "%"
    end

    vicious.register          ( memwidget, vicious.widgets.mem,parseViciousMemstat,1 )

    local radial = wibox.widget {
	{
	    {
		memwidget_graph,
		memwidget,
		layout = wibox.layout.stack
	    },
	    bg     = beautiful.bg_alternate or beautiful.bg_normal,
	    widget = wibox.container.background,
	},
	border_color  = beautiful.bg_focus,
	color         = beautiful.fg_focus,
	widget        = wibox.container.radialprogressbar,
	forced_width  = 44
    }

    local rpb = wibox.layout {
	{
	    image    = beautiful.icon_path .. "mem.png",
	    widget  = wibox.widget.imagebox,
	},
	radial,
	buttons       = util.table.join(button({ }, 1, ramInfoMenu.toggle )),
	layout  = wibox.layout.fixed.horizontal
    }

    rpb:connect_signal( "mouse::enter", ramInfoMenu.previewOn )
    rpb:connect_signal( "mouse::leave", ramInfoMenu.previewOff )

    return rpb
end


return setmetatable(module, { __call = function(_, ...) return new(...) end })
-- kate: space-indent on; indent-width 2; replace-tabs on;

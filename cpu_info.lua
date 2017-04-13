local setmetatable = setmetatable
local io           = io
local ipairs       = ipairs
local loadstring   = loadstring
local print        = print
local tonumber     = tonumber
local beautiful    = require( "beautiful"             )
local button       = require( "awful.button"          )
local widget2      = require( "awful.widget"          )
--local config       = require( "forgotten"             )
local vicious      = require("vicious")
local menu         = require( "radical.context"       )
local util         = require( "awful.util"            )
local wibox        = require( "wibox"                 )
--local themeutils   = require( "blind.common.drawing"  )
local radtab       = require( "radical.widgets.table" )
local embed        = require( "radical.embed"         )
local radical      = require( "radical"               )
local color        = require( "gears.color"           )
local allinone     = require( "widgets.allinone"      )
local fd_async     = require("utils.fd_async"         )
local info_menu    = require("info_menu"         )
local awful        = require("awful")
local inspect        = require("inspect")

local data     = {}

--Menus
local procMenu , govMenu = nil, nil
local cpuInfoMenu = info_menu()

local capi = { client = client }

local cpuInfoModule = {}

local function split( str, delimiter )
    local retval = {}
    local counter = 1
    for i in string.gmatch( str, "[^"..delimiter.."]+") do
	retval[counter] = i
	counter=counter+1
    end
    return retval
end

local function refresh_process()
    data.process={}

    --Load process information
    fd_async.exec.command(util.getdir("config")..'/Scripts/topCpu.sh'):connect_signal("new::line",function(content)
	    procMenu.children = {}
            if content ~= nil then
	       local t = split( content, "," )
                table.insert(data.process,t)
            end
            if data.process then
                local procIcon = {}
                for k2,v2 in ipairs(capi.client.get()) do
                    if v2.icon then
                        procIcon[v2.class:lower()] = v2.icon
                    end
                end
                for i=1,#data.process do
                    local wdg = {}
                    wdg.percent       = wibox.widget.textbox()
                    wdg.percent.fit = function()
                        return 42,procMenu.item_height
                    end
                    wdg.kill          = wibox.widget.imagebox()
		    wdg.kill:set_forced_height( 22 )
                    wdg.kill:set_image(beautiful.icon_path .. "kill.png")

		    wdg.text = wibox.widget.textbox()
		    wdg.text:set_text( data.process[i][3] )

		    local txt = wibox.widget.textbox()
		    txt:set_text( inspect(data.process[i][3]) )
                    --Show process and cpu load
                    wdg.percent:set_text((data.process[i][2] or "N/A").."%")
		    local entry = wibox.layout.align.horizontal()
		    entry.forced_width = 200
		    entry.first = wdg.percent
		    entry.second = wdg.text
		    entry.third = wdg.kill
		    --procMenu:add( txt )
                    --procMenu:add_item({text=data.process[i][3],suffix_widget=wdg.kill,prefix_widget=wdg.percent})
		    procMenu:add( entry )
                end
            end
        end)
end

--TODO make them private again
local cpuModel
local spacer1
local volUsage

local modelWl
local cpuWidgetArrayL
local main_table

local function init()

    --Load initial data
    print("Load initial data")
    --Evaluate core number
    local pipe0 = io.popen("cat /proc/cpuinfo | grep processor | tail -n1 | grep -e'[0-9]*' -o")
    local coreN = pipe0:read("*all") or "0"
    pipe0:close()

    if coreN then
        data.coreN=(coreN+1)
        print("Detected core number: ",data.coreN)
    else
        print("Unable to load core number")    
    end



    cpuInfoModule.refresh=function()
        --Update core(s) temperature
        local pipe0 = io.popen('sensors | grep "Core" | grep -e ": *+[0-9]*" -o| grep -e "[0-9]*" -o')
        local i=0
        for line in pipe0:lines() do
            main_table[i+1][3]:set_text(line.." °C")
            i=i+1
        end
        pipe0:close()

        refresh_process()
    end




    -- Generate governor list menu
    local function generateGovernorMenu(cpuN)
        local govLabel
        if cpuN ~= nil then govLabel="Set Cpu"..cpuN.." Governor"
        else govLabel="Set global Governor" end

        govMenu = menu({arrow_type=radical.base.arrow_type.CENTERED})
        govMenu:add_item {text=govLabel,sub_menu=function()
                local govList=radical.context{}

                --Load available governor list
                local pipe0 = io.popen('cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors')
                for i,gov in pairs(pipe0:read("*all"):split(" ")) do
                    print("G:",gov)
                    --Generate menu list
                    if cpuN ~= nil then
                        --Specific Cpu
                        govList:add_item {text=gov,button1=function(_menu,item,mods) util.spawn_with_shell('sudo cpufreq-set -c '..cpuN..' -g '..gov) end}
                    else
                        --All cpu together
                        govList:add_item {text=gov,button1=function(_menu,item,mods) 
                                for cpuI=0,data.coreN do
                                    --print('sudo cpufreq-set -c '..cpuI..' -g '..gov)
                                    util.spawn('sudo cpufreq-set -c '..cpuI..' -g '..gov) 
                                    govMenu.visible = false
                                end
                            end}
                        --govList:add_item {text="Performance",button1=function(_menu,item,mods) print("Performances") end}
                    end
                end
                pipe0:close()

                return govList
            end
        }
    end

    local function showGovernor()
        if not govMenu then
            generateGovernorMenu()
        end
        govMenu.visible = not govMenu.visible
    end

    --Constructor
    cpuModel          = wibox.widget.textbox()
    spacer1           = wibox.widget.textbox()
    volUsage          = wibox.widget.graph()

    topCpuW           = {}
    local emptyTable={};
    local tabHeader={};
    for i=1,data.coreN,1 do
        emptyTable[i]= {"",""}
        tabHeader[i]="C"..(i-1)
    end
    local tab,widgets = radtab(emptyTable,
        {row_height=20,v_header = tabHeader,
            h_header = {"GHz","Used %"}
        })
    main_table = widgets

    --Single core load

    --Register cell table as vicious widgets
    for i=0, (data.coreN-1) do
        --Cpu Speed (Frequency in Ghz
        vicious.register(main_table[i+1][1], vicious.widgets.cpuinf,    function (widget, args)
                return string.format("%.2f", args['{cpu'..i..' ghz}'])
            end,2)
        --Governor
        --vicious.register(main_table[i+1][4], vicious.widgets.cpufreq,'$5',5,"cpu"..i)
    end
    modelWl         = wibox.layout.fixed.horizontal()
    modelWl:add         ( cpuModel      )

    --loadData()

    cpuWidgetArrayL = wibox.container.margin()
    cpuWidgetArrayL:set_margins(3)
    cpuWidgetArrayL:set_bottom(10)
    cpuWidgetArrayL:set_widget(tab)
    cpuWidgetArrayL:set_forced_width(50)

    --Load Cpu model
    local pipeIn = io.popen('cat /proc/cpuinfo | grep "model name" | cut -d ":" -f2 | head -n 1',"r")
    local cpuName = pipeIn:read("*all") or "N/A"
    cpuName = cpuName:gsub( "^ ", "")
    cpuName = cpuName:gsub( "\n$", "")
    --error(cpuName)
    pipeIn:close()

    cpuModel:set_text(cpuName)
    cpuModel.width     = 212

    volUsage:set_height       ( 30                                   )
    volUsage:set_border_color ( beautiful.fg_normal                  )
    volUsage:set_color        ( beautiful.fg_normal                  )
    volUsage:set_max_value( 100 )
end

local function new(margin, args)
    --Functions-----------------------
    --"Public" (Accessible from outside)
    --Toggle visibility if no argument given or set visibility. Return current visibility
    procMenu = wibox.layout.fixed.vertical()
    init()

    local imb = wibox.widget.imagebox()
    imb:set_image(beautiful.icon_path .. "reload.png")
    imb:set_forced_height(22)
    imb:buttons(button({ }, 1, function (geo) refresh_process() end))

    cpuInfoMenu.add_header( "Info")
    cpuInfoMenu.add_widget(modelWl)
    cpuInfoMenu.add_header( "Usage" )
    cpuInfoMenu.add_widget(volUsage)
    cpuInfoMenu.add_widget(cpuWidgetArrayL)
    cpuInfoMenu.add_header( "Processes", imb )
    cpuInfoMenu.add_widget( procMenu )

    refresh_process()
    --cpuInfoMenu.add_header( "Process" )
    --cpuInfoMenu.add_widget(procMenu)


    --local cpuwidget = wibox.widget.textbox()
    local cpuwidget = wibox.widget.textbox()
    cpuwidget.height = 22
    cpuwidget.width = 44
    cpuwidget.align = "center"
    --vicious.register( cpuwidget, vicious.widgets.cpu, "$1%", 1 )

    -- Initialize widget
    local cpuwidget_graph = wibox.widget.graph()
    -- Graph properties
    cpuwidget_graph:set_width( 40 )
    cpuwidget_graph:set_background_color(beautiful.bg_alternate)
    cpuwidget_graph:set_max_value( 100 )
    cpuwidget_graph:set_color(
	{
	    type = "linear",
	    from = { 0, 0 },
	    to = { 0, 22 },
	    stops = {
		{0, "#FF5656"},
		{0.5, "#88A175"},
		{1, "#AECF96" }
	    } 
	} ) 

    local cpuRegistrar = {}

    local function refreshCoreUsage(widget,content)
        --If menu created
        --if data.menu ~= nil then
            --Add current value to graph
            volUsage:add_value(content[1], 1)
	    cpuwidget_graph:add_value( content[1], 1 )
	    cpuwidget.text = content[1] .. "%"
	    --Update table data only if visible
	    for i=1, (data.coreN) do
		main_table[i][2]:set_text(string.format("%2.1f",content[i+1]))
	    end
        --end

        --Set bar widget as global usage
        return content[1]
    end

    vicious.register          ( volUsage, vicious.widgets.cpu,refreshCoreUsage,1 )

    local radial = wibox.widget {
	{
	    {
		cpuwidget_graph,
		cpuwidget,
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
	    image    = beautiful.icon_path .. "cpu.png",
	    widget  = wibox.widget.imagebox,
	},
	radial,
	buttons       = util.table.join(button({ }, 1, cpuInfoMenu.toggle )),
	layout  = wibox.layout.fixed.horizontal,
    }

    rpb:connect_signal( "mouse::enter", cpuInfoMenu.previewOn )
    rpb:connect_signal( "mouse::leave", cpuInfoMenu.previewOff )

    return rpb
end

return setmetatable(cpuInfoModule, { __call = function(_, ...) return new(...) end })
-- kate: space-indent on; indent-width 4; replace-tabs on;

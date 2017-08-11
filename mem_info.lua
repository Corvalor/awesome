local wibox        = require( "wibox"                    )
local beautiful    = require( "beautiful"                )
local shape        = require( "gears.shape"              )
local util         = require( "awful.util"               )
local ct           = require( "radical.widgets.constrainedtext" )
local vicious      = require( "vicious" )
local inspect      = require( "inspect" )

local taskModule = {}

local function new( args )
    args = args or {}

    local fswidget = wibox.widget.textbox()
    fswidget.height = 22
    fswidget.width = 44
    fswidget.align = "center"

    -- Initialize widget
    local fswidget_graph = wibox.widget.graph()
    -- Graph properties
    fswidget_graph:set_width( 40 )
    fswidget_graph:set_background_color(beautiful.bg_alternate)
    fswidget_graph:set_max_value( 100 )
    fswidget_graph:set_color(
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

    vicious.register(   fswidget, vicious.widgets.fs,
			function( widget, content )
			    return content["{/ avail_p}"] .. "%"
			end, 41)

    local radial = wibox.widget {
	{
	    {
		fswidget_graph,
		fswidget,
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

    local right_layout = wibox.layout {
	{
	    image    = beautiful.icon_path .. "hdd.png",
	    widget  = wibox.widget.imagebox,
	},
	radial,
	--buttons = util.table.join(button({ }, 1, dateInfoMenu.toggle )),
	layout  = wibox.layout.fixed.horizontal
    }

  return right_layout
end

return setmetatable(taskModule, { __call = function(_, ...) return new(...) end })

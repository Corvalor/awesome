local wibox        = require( "wibox" )
local beautiful    = require( "beautiful" )
local shape        = require( "gears.shape" )
local util         = require( "awful.util" )
local button       = require( "awful.button"             )
local ct           = require( "radical.widgets.constrainedtext" )
local info_menu    = require( "info_menu" )
local vicious      = require( "vicious" )
local vicious_task = require( "vicious_task" )
local inspect = require('inspect')

local taskModule = {}

local function createMenu()
    local taskInfoMenu = info_menu()

    taskInfoMenu.add_header( "Pending" )
    taskInfoMenu.add_header( "Waiting" )

    return taskInfoMenu
end

local function new( args )
    args = args or {}

    local taskInfoMenu = createMenu()

    local taskwidget = wibox.widget.textbox()
    taskwidget.height = 22
    taskwidget.width = 44
    taskwidget.align = "center"

    local function parseViciousTaskStats( widget, content )

	taskInfoMenu.clear( "Pending" )
        for entryIndex=1,content.count_pending do
	    local entry = content.pending[entryIndex]
	    local task = wibox.widget.textbox()
	    task.text = entry.id .. ") " .. entry.description
	    taskInfoMenu.add_widget( task, "Pending" )
	end

	taskInfoMenu.clear( "Waiting" )
        for entryIndex=1,content.count_waiting do
	    local entry = content.waiting[entryIndex]
	    local task = wibox.widget.textbox()
	    task.text = entry.id .. ") " .. entry.description
	    taskInfoMenu.add_widget( task, "Waiting" )
	end

	return content.count_pending .. "-" .. content.count_waiting
    end

    vicious.register( taskwidget, vicious_task,
		      parseViciousTaskStats, 9 )

    local radial = wibox.widget {
	{
	    {
		taskwidget,
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
	local mybutton = util.table.join(button({ }, 1, taskInfoMenu.toggle ))

    local right_layout = wibox.layout {
	{
	    image    = beautiful.icon_path .. "tw-s.png",
	    widget  = wibox.widget.imagebox,
	},
	radial,
	buttons = mybutton,
	layout  = wibox.layout.fixed.horizontal
    }

	local function toggle(p,a)
		taskInfoMenu.toggle(p,taskInfoMenu);
	end

    right_layout:connect_signal( "mouse::enter", taskInfoMenu.previewOn )
    right_layout:connect_signal( "mouse::leave", taskInfoMenu.previewOff )
    right_layout:connect_signal( "toggle", toggle )

  return right_layout
end

return setmetatable(taskModule, { __call = function(_, ...) return new(...) end })

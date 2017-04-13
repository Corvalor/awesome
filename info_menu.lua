local wibox     = require("wibox")
local gears     = require("gears")
local beautiful = require("beautiful")
local awful = require("awful")
local inspect   = require("inspect")

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


local info_menu = {}

local function new(args)
    args = args or {}

    local corner_radius = 10
    local arrow_size = 10
    local border_width = 2

    local result = wibox()
    result.sections = {}
    result.x = 20
    result.y = 20
    result.width = 10
    result.height = 100
    result.margin_width = 5
    result.visible = false
    result.ontop = true
    local new_shape = function( cr, width, height )
	gears.shape.infobubble( cr, width, height, corner_radius, arrow_size )
    end
    result.shape = new_shape
    result.shape_bounding = new_shape
    result.shape_clip= new_shape
    result.border_width = border_width
    result.border_color = beautiful.bg_alternate_inner
    result.opacity = 0.5

    --result.widget = grid

    local grid = wibox.layout.fixed.vertical()

    result.widget = grid

    local self = result

    function result.toggle( parent, hover )
	if hover then
	    if self.opacity < 1.0 then
		new_visibility = not self.visible
		opacity = 0.5
	    else
		new_visibility = self.visible
		opacity = self.opacity
	    end
	else
	    new_visibility = self.visible
	    if self.opacity < 1.0 then
		opacity = 1.0
	    else
		opacity = 0.5
	    end
	end
	local fit_w, fit_h = grid:get_preferred_size(1)
	self.width = fit_w
	self.height = fit_h
	self.visible = new_visibility
	self.screen = parent.screen
	self.opacity = opacity
	local x_offset = (parent.width - self.width) / 2
	local cur_screen = awful.screen.focused()
	if cur_screen then
	   x_offset = x_offset + cur_screen.geometry.x
	end
	self.x = parent.x + x_offset
    end
    function result.add_header( text, right_widget )
	local first = self.current_part == nil
	
	self.current_part = nil
	local header_txt = wibox.widget.textbox("<big>"..text.."</big>")
	header_txt.align = "center"
	local header_txt_layout = wibox.layout.align.horizontal( nil, header_txt, right_widget)
	header_txt_layout:set_forced_width(200)
	local header_txt_bg = wibox.container.background( header_txt_layout, beautiful.bg_alternate );
	local contains = header_txt_bg
	if first then
	   contains = wibox.container.margin( header_txt_bg, 0, 0, arrow_size, 0)
	   contains.color = beautiful.bg_alternate_outer
	end
	header_txt.forced_height = 22
	self.add_widget( contains )
	local new_current_part = wibox.layout.fixed.vertical()
	local margin_width = self.margin_width
	local new_current_part_margin = wibox.container.margin( new_current_part,   margin_width, margin_width,
										    margin_width, margin_width )
	local new_current_part_bg = wibox.container.background( new_current_part_margin )
	new_current_part_bg.bg = beautiful.bg_normal
	new_current_part_bg.shape = function( cr, width, height )
	   gears.shape.rounded_rect( cr, width, height, corner_radius )
	end
	local new_current_part_outer_bg = wibox.container.background( new_current_part_bg )
	new_current_part_outer_bg.bg = beautiful.bg_alternate_outer
	self.add_widget( new_current_part_outer_bg )
	self.current_part = new_current_part
	self.sections[text] = new_current_part
    end
    function result.add_widget( widget, section_override )
        if section_override then
	   self.sections[section_override]:add(widget)
	else
	    if self.current_part then
		self.current_part:add(widget)
	    else
		grid:add(widget)
	    end
	end
    end

    function result.previewOn(result, result2)
	self.toggle(result2, true)
    end

    function result.previewOff(result, result2)
	self.toggle(result2, true)
    end

    function result.clear( section )
       self.sections[section].children = {}
    end

    return result
end



return setmetatable(info_menu, { __call = function(_, ...) return new(...) end })

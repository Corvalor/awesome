local awful = require("awful")
local wibox = require("wibox")
local vicious = require("vicious")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local radical = require("radical")
local lain = require("lain")
local markup = lain.util.markup
local separators = lain.util.separators
local gears = require("gears")
local dateInfo = require( "date_info" )
local cpuInfo = require( "cpu_info" )
local ramInfo = require( "ram_info" )
local taskInfo = require( "task_info" )
local memInfo = require( "mem_info" )

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier
}

-- Textclock
--os.setlocale(os.getenv("LANG")) -- to localize the clock
local mytextclock = wibox.widget.textclock()

local clock       = dateInfo(nil)
local mem       = memInfo(nil)
local cpu       = cpuInfo(nil)
local ram       = ramInfo(nil)
local task       = taskInfo(nil)

lain.widget.contrib.task.attach( mytextclock );
-- Calendar
local cal = lain.widget.calendar({
    attach_to = { mytextclock },
    cal = "gcal -s1",
    followtag = true,
    notification_preset = {
        icon_size = 120,
        font = theme.font,
        fg   = theme.fg_normal,
        bg   = theme.bg_alternate_outer,
        we   = theme.border_normal
    }
})


-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytask = task
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({
                                                      theme = { width = 250 }
                                                  })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))



function create_wavy(col1, col2, fill)
   local wavy = { height = 0, width = 14 }
    local widget = wibox.widget.base.make_widget()

    widget.fit = function(m, w, h)
        return wavy.width, wavy.height
    end

    widget.draw = function(mycross, wibox, cr, width, height)
	local PI = 2 * math.asin(1)
	local col = nil
        if col1 ~= "alpha" then
	    cr:set_source(gears.color(col1))
            cr:new_path()

	    if fill then
		cr:move_to( 0, 0 )
		cr:line_to( width/2, 0 )
	    else
		cr:move_to( width/2, 0 )
	    end
	    cr:curve_to( 0, height / 2, width, height/2, width/2, height )
	    if fill then
		cr:line_to( 0, height )
	    else
		cr:new_sub_path()
	    end

            cr:close_path()
	    if fill then
		cr:fill()
	    else
		cr:stroke()
	    end
	    col = col1
        end

        if col2 ~= "alpha" then
	    cr:set_source(gears.color(col2))
            cr:new_path()
	    if fill then
	    end

	    if fill then
		cr:move_to( width, 0 )
		cr:line_to( width/2, 0 )
	    else
		cr:move_to( width/2, 0 )
	    end
	    cr:curve_to( 0, height / 2, width, height/2, width/2, height )
	    if fill then
		cr:line_to( width, height )
	    else
		cr:new_sub_path()
	    end

            cr:close_path()
	    if fill then
		cr:fill()
	    else
		cr:stroke()
	    end
	    col = col2
        end
	if col and fill then
            cr:set_source(gears.color(col))
            cr:new_path()

	    cr:move_to( width/2, 0 )
	    cr:curve_to( 0, height / 2, width, height/2, width/2, height )
	    cr:new_sub_path()

            cr:close_path()
	    cr:stroke()
	end
   end

   return widget
end

-- Separators
arrl = separators.arrow_left( beautiful.bg_alternate, "alpha", false );
arrl_dl = separators.arrow_left( beautiful.bg_alternate, "alpha", true );
arrl_ld = separators.arrow_left( "alpha", beautiful.bg_alternate, true );

arrl_f = separators.arrow_left( beautiful.bg_focus_gradient, "alpha", false );
arrl_dl_f = separators.arrow_left( beautiful.bg_focus_gradient, "alpha", true );
arrl_ld_f = separators.arrow_left( "alpha", beautiful.bg_focus_gradient, true );

arrr = separators.arrow_right( beautiful.bg_alternate, "alpha", false );
arrr_dl = separators.arrow_right( beautiful.bg_alternate, "alpha", true );
arrr_ld = separators.arrow_right( "alpha", beautiful.bg_alternate, true );

arrr_f = separators.arrow_right( beautiful.bg_focus_gradient, "alpha", false );
arrr_dl_f = separators.arrow_right( beautiful.bg_focus_gradient, "alpha", true );
arrr_ld_f = separators.arrow_right( "alpha", beautiful.bg_focus_gradient, true );

wavy = create_wavy( beautiful.bg_focus_gradient, "alpha", false )
wavy_dl = create_wavy( beautiful.bg_focus_gradient, "alpha", true )
wavy_ld = create_wavy( "alpha", beautiful.bg_focus_gradient, true )

local common = require("awful.widget.common")
function taglist_update(w, buttons, label, data, objects)
    local left_layout_toggle = true
    -- update the widgets, creating them if needed
    w:reset()
    for i, o in ipairs(objects) do
	local cache = data[o]
	local ib, tb, bgb, bgb2, m, l
	if cache then
	    ib = cache.ib
	    tb = cache.tb
	    bgb = cache.bgb
	    bgb2 = cache.bgb2
	    m   = cache.m
	else
	    ib = wibox.widget.imagebox()
	    tb = wibox.widget.textbox()
	    bgb = wibox.container.background()
	    bgb2 = wibox.container.background()
	    m = wibox.layout.margin(tb, 4, 4)
	    l = wibox.layout.fixed.horizontal()

	    -- All of this is added in a fixed widget
	    l:fill_space(true)
	    l:add(ib)
	    l:add(m)

	    -- And all of this gets a background
	    bgb:set_widget(l)

	    bgb:buttons(common.create_buttons(buttons, o))

	    bgb2:set_widget(bgb)

	    data[o] = {
		ib = ib,
		tb = tb,
		bgb = bgb,
		bgb2 = bgb2,
		m   = m
	    }
	end

	local text, bg, bg_image, icon = label(o)

	local bg2 = nil
	if left_layout_toggle then
	   bg2 = beautiful.bg_alternate
	end
	-- The text might be invalid, so use pcall
	if not pcall(tb.set_markup, tb, text) then
	    tb:set_markup("<i>&lt;Invalid text&gt;</i>")
	end
	if bg == beautiful.bg_focus then
	   is_active = true
	else
	   is_active = false
	end
	bgb:set_bg(bg)
	bgb2:set_bg(bg2)
	if type(bg_image) == "function" then
	    bg_image = bg_image(tb,o,m,objects,i)
	end
	bgb:set_bgimage(bg_image)
	ib:set_image(icon)
	if i > 1 then
	    if left_layout_toggle then
		w:add(arrr_ld)
	    else 
		w:add(arrr_dl)
	    end
	end
	w:add(bgb2)
	left_layout_toggle = not left_layout_toggle
     end
     if left_layout_toggle then
	w:add(arrr)
     else
	w:add(arrr_dl)
     end
end

function tasklist_update(w, buttons, label, data, objects)
    -- update the widgets, creating them if needed
    w:reset()

    local last_was_active = false
    local is_active = false
    local first = true
    local envelope = wibox.layout.fixed.horizontal();
    for i, o in ipairs(objects) do
        local cache = data[o]
        local ib, tb, bgb, tbm, ibm, l
        if cache then
            ib = cache.ib
            tb = cache.tb
            bgb = cache.bgb
            tbm = cache.tbm
            ibm = cache.ibm
        else
            ib = wibox.widget.imagebox()
            tb = wibox.widget.textbox()
            bgb = wibox.container.background()
            tbm = wibox.container.margin(tb, dpi(4), dpi(4))
            ibm = wibox.container.margin(ib, dpi(4))
            l = wibox.layout.fixed.horizontal()

            -- All of this is added in a fixed widget
            l:fill_space(true)
            l:add(ibm)
            l:add(tbm)

            -- And all of this gets a background
            bgb:set_widget(l)

            bgb:buttons(common.create_buttons(buttons, o))

            data[o] = {
                ib  = ib,
                tb  = tb,
                bgb = bgb,
                tbm = tbm,
                ibm = ibm,
            }
        end

        local text, bg, bg_image, icon, args = label(o, tb)
        args = args or {}

        -- The text might be invalid, so use pcall.
        if text == nil or text == "" then
            tbm:set_margins(0)
        else
            if not tb:set_markup_silently(text) then
                tb:set_markup("<i>&lt;Invalid text&gt;</i>")
            end
        end
	if bg == beautiful.bg_focus then
	   is_active = true
	   bg = beautiful.bg_focus_gradient
	else
	   is_active = false
	   bg = beautiful.bg_normal_gradient
	end
        bgb:set_bg(bg)
        if type(bg_image) == "function" then
            -- TODO: Why does this pass nil as an argument?
            bg_image = bg_image(tb,o,nil,objects,i)
        end
        bgb:set_bgimage(bg_image)
        if icon then
            ib:set_image(icon)
        else
            ibm:set_margins(0)
        end

        bgb.shape              = args.shape
        bgb.shape_border_width = args.shape_border_width
        bgb.shape_border_color = args.shape_border_color

	if first then
	    if is_active then
		envelope:add(arrl_ld_f)
	    else
		envelope:add(arrl_f)
	    end
	    first = false
	else
	    if is_active then
		envelope:add(wavy_ld)
	    else
		if last_was_active then
		    envelope:add(wavy_dl)
		else
		    envelope:add(wavy)
		end
	    end
	end
        envelope:add(bgb)
	last_was_active = is_active
    end
    if not first then
	if is_active then
	    envelope:add(arrr_dl_f)
	else
	    envelope:add(arrr_f)
	end
    end
    outer_envelope = wibox.layout.align:horizontal()
    outer_envelope.first = wibox.widget.base.make_widget()
    outer_envelope.second = envelope
    outer_envelope.third = wibox.widget.base.make_widget()
    outer_envelope.expand = "outside"
    w:add(outer_envelope)
end

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))

    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons, nil, taglist_update)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons, nil, tasklist_update )

    -- Create the wibox
    mywibox[s] = awful.wibar({ position = "top", screen = s, height = 22 })
    mywibox[s].bg = beautiful.bg_normal_gradient

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    right_layout = wibox.layout.fixed.horizontal()
    local right_layout_toggle = true
    local function right_layout_add (...)
        local arg = {...}
        if right_layout_toggle then
            right_layout:add(arrl_ld)
            for i, n in pairs(arg) do
                right_layout:add(wibox.container.background(n, beautiful.bg_alternate))
            end
        else
            right_layout:add(arrl_dl)
            for i, n in pairs(arg) do
                right_layout:add(n)
            end
        end
        right_layout_toggle = not right_layout_toggle
    end

    --right_layout:add(wibox.widget.systray())
    right_layout_add(mem)
    right_layout_add(ram)
    right_layout_add(cpu)
    right_layout_add(task)
    right_layout_add(clock)
    right_layout_add(mylayoutbox[s], kbdcfg.widget)

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
end
-- }}}

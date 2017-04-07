-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
awful.autofocus = require("awful.autofocus")

local settings = require("settings")

-- {{{ Signals
-- Signal function to execute when a new client appears.
-- @DOC_MANAGE_HOOK@
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
    local matches = awful.rules.matching_rules( c, awful.rules.rules )
    if #matches > 0 then
        for key, match in pairs(matches) do
	   if match.callback then
               match.callback( c )
	   end
        end
    end
end)

-- load tyrannical
local tyrannical = require( "tyrannical" )
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
local radical = require("radical")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
-- Load vicious
local vicious = require("vicious")
-- Load lain
local lain = require("lain")
-- load autostart
local autostart = require("autostart")


-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

    file = io.open("/home/cknappe/test2.txt","a")
    io.output(file)
    io.write("test: " .. err )
        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}


-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
--beautiful.init("~/.config/awesome/themes/molokai/theme.lua")
beautiful.init(awful.util.getdir("config") .. "themes/default/theme.lua")
--path = awful.util.getdir("config") .. "blind/arrow/themeZilla.lua"
--path = awful.util.getdir("config") .. "blind/arrow/theme.lua"
--path = awful.util.getdir("config") .. "blind/arrow/themeSciFi.lua"
beautiful.init(path)
local theme = beautiful.get()


-- This is used later as the default terminal and editor to run.
terminal = os.getenv("TERM") or "xterm"
editor = os.getenv("EDITOR") or "nano"

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- }}}


-- {{{ Wallpaper
if beautiful.wallpaper then
    for s in screen do
       local g = s.geometry
       if g.width > g.height then
	  gears.wallpaper.tiled(beautiful.wallpaper[1], s.index, { x = -1200, y = -720} )
       else
	   gears.wallpaper.tiled(beautiful.wallpaper[2], s.index)
       end
    end
end
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
-- [[
--tags = {}
--for s = 1, screen.count() do
    -- Each screen has its own tag table.
    --if s == 1 then
       --tags[s] = awful.tag({ "emacs", "qtcreator2" }, s, layouts[10])
    --elseif s == 2 then
    --   tags[s] = awful.tag({ "web", "qtcreator", "terminal", "files", "various" }, s, layouts[10])
   -- else 
  --     tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, layouts[1])
 --   end
--end
--]]

tyrannical.tags = {
    {
        name        = "Emacs",                 -- Call the tag "Term"
        init        = true,                   -- Load the tag on startup
        exclusive   = true,                   -- Refuse any other type of clients (by classes)
	force_screen= true,
        screen      = 1,                  -- Create this tag on screen 1 and screen 2
        layout      = awful.layout.suit.max, -- Use the tile layout
        class       = { --Accept the following classes, refuse everything else (because of "exclusive=true")
	   "emacs"
        }
    },
    {
        name        = "Web",
        init        = true,
        exclusive   = true,
	force_screen= true,
        screen      = 2,
        layout      = awful.layout.suit.max,
        class = { "qutebrowser"    }
    },
    {
        name         = "QtCreator",
        init         = true,
        exclusive    = true,
	force_screen = true,
        screen       = 1,
	max_clients  = 1,
        layout       = awful.layout.suit.max,
        class ={  "qtcreator:left" }
    },
    {
        name         = "QtCreator",
        init         = true,
        exclusive    = true,
	force_screen = true,
        screen       = 2,
	max_clients  = 1,
        layout       = awful.layout.suit.max,
        class ={  "qtcreator:right" }
    },
    {
        name        = "Term",
        init        = true,
        exclusive   = true,
	force_screen = true,
        screen      = 2,
        layout      = awful.layout.suit.tile,
        class  = {
	   "xterm" , "urxvt" , "aterm","URxvt","XTerm","konsole","terminator","gnome-terminal",
	   "xfce4-terminal"
        }
    } ,
    {
        name        = "Files",
        init        = true,
        exclusive   = true,
	force_screen = true,
        screen      = 2,
        layout      = awful.layout.suit.tile,
        class  = {
            "Thunar", "Konqueror", "Dolphin", "ark", "Nautilus","emelfm", "nemo"
        }
    } ,
    {
        name         = "various",
        init         = true,
        fallback     = true,
	force_screen = true,
        screen       = 2,
        layout       = awful.layout.suit.max,
        class  = {
	   "evince", "epdfview", "Epdfview", "backend"
        }
    } ,
}



-- Ignore the tag "exclusive" property for the following clients (matched by classes)
tyrannical.properties.intrusive = {
    "ksnapshot"     , "pinentry"       , "gtksu"     , "kcalc"        , "xcalc"               ,
    "feh"           , "Gradient editor", "About KDE" , "Paste Special", "Background color"    ,
    "kcolorchooser" , "plasmoidviewer" , "Xephyr"    , "kruler"       , "plasmaengineexplorer",
}

-- Ignore the tiled layout for the matching clients
tyrannical.properties.floating = {
    "MPlayer"      , "pinentry"        , "ksnapshot"  , "pinentry"     , "gtksu"          ,
    "xine"         , "feh"             , "kmix"       , "kcalc"        , "xcalc"          ,
    "yakuake"      , "Select Color$"   , "kruler"     , "kcolorchooser", "Paste Special"  ,
    "New Form"     , "Insert Picture"  , "kcharselect", "mythfrontend" , "plasmoidviewer" 
}

-- Make the matching clients (by classes) on top of the default layout
tyrannical.properties.ontop = {
    "Xephyr"       , "ksnapshot"       , "kruler"
}

-- Force the matching clients (by classes) to be centered on the screen on init
tyrannical.properties.placement = {
    kcalc = awful.placement.centered
}

tyrannical.settings.block_children_focus_stealing = true --Block popups ()
tyrannical.settings.group_children = true --Force popups/dialogs to have the same tags as the parent client

-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibox
-- Create a textclock widget


-- Activate the given keyboard layout
function keyboard_switch( layout )
  local t = kbdcfg.layout[ layout ]
  kbdcfg.widget:set_text( " " .. t[3] .. " " )
  os.execute( kbdcfg.cmd .. " " .. t[1] .. " " .. t[2] )
end


-- Keyboard map indicator and changer
kbdcfg = {}
kbdcfg.cmd = "setxkbmap"
kbdcfg.layout = { { "us", "-variant altgr-intl -option nodeadkey" , "US" }, { "us", "-variant colemak" , "CO" } } 
kbdcfg.current = 1  -- us is our default layout
kbdcfg.widget = wibox.widget.textbox()
kbdcfg.widget:set_text( " " .. kbdcfg.layout[kbdcfg.current][3] .. " " )
kbdcfg.switch = function ()
  kbdcfg.current = kbdcfg.current % #(kbdcfg.layout) + 1
  keyboard_switch( kbdcfg.current )
end
-- Ensuring, that the first is selected
keyboard_switch( 1 )

 -- Mouse bindings
kbdcfg.widget:buttons(
 awful.util.table.join(awful.button({ }, 1, function () kbdcfg.switch() end))
)

require( "status_bar" )

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen.index].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        local tag = awful.tag.gettags(screen)[i]
                        if tag then
                           awful.tag.viewonly(tag)
                        end
                  end),
        -- Toggle tag.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      local tag = awful.tag.gettags(screen)[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.movetotag(tag)
                          end
                     end
                  end),
        -- Toggle tag.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.toggletag(tag)
                          end
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

require ("modal_keybindings")

-- Set keys
root.keys(globalkeys)
-- }}}

qtcreator_distributor = true;
-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    {
        rule = { class = "QtCreator" },
        callback = function(c)
	    if qtcreator_distributor then
		awful.client.property.set(c, "overwrite_class", "qtcreator:right")
	    else
		awful.client.property.set(c, "overwrite_class", "qtcreator:left")
	    end
	    qtcreator_distributor = false
        end
    },
    {
        rule = { class = "qtcreator-bin" },
        callback = function(c)
	    if qtcreator_distributor then
		awful.client.property.set(c, "overwrite_class", "qtcreator:right")
	    else
		awful.client.property.set(c, "overwrite_class", "qtcreator:left")
	    end
	    qtcreator_distributor = false
        end
    }
}
-- }}}

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
        client.focus = c
    end
end)

function spawn(command, wm_cl)
    local matcher = function (c)
	return awful.rules.match( c, {class = "Emacs" } )
    end
    awful.client.run_or_raise( "emacs", matcher )
end

autostart( 'qtcreator' )
autostart( "qutebrowser" )
autostart( "nemo" )
autostart( "Emacs" )
autostart( settings.Terminal )

client.connect_signal("focus",
		      function(c)
			 c.border_color = beautiful.border_focus
	              end)
client.connect_signal("unfocus",
		      function(c)
			 c.border_color = beautiful.border_normal
                      end)


-- }}}

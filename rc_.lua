-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
awful.autofocus = require("awful.autofocus")

local settings = require("settings")
local dump = require("dump")
local helpers = require("lain.helpers")
-- Load the widget.
local screenshot = require("screenshot")

os.execute("~/.screenlayout/default.sh")
os.execute("echo 'test' > ~/awesome.log")
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
        gears.wallpaper.tiled(beautiful.wallpaper[s.index], s.index, { x = -g.x, y = -g.y - 350} )
    end
end
-- }}}

-- {{ Tags
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

local left = 2
local middle = 1
local right = 3

tyrannical.tags = {
    {
        name        = "Code",                 -- Call the tag "Term"
        init        = true,                   -- Load the tag on startup
        exclusive   = true,                   -- Refuse any other type of clients (by classes)
	force_screen= true,
        screen      = left,                  -- Create this tag on screen 1 and screen 2
        layout      = awful.layout.suit.max, -- Use the tile layout
	master_width_factor   = 0.21,
        class       = { --Accept the following classes, refuse everything else (because of "exclusive=true")
	   "emacs", "Code"
        }
    },
    {
        name        = "Ediff",                 -- Call the tag "Term"
        init        = false,                   -- Load the tag on startup
        exclusive   = true,                   -- Refuse any other type of clients (by classes)
	force_screen= true,
        screen      = left,                  -- Create this tag on screen 1 and screen 2
        layout      = awful.layout.suit.max, -- Use the tile layout
        class       = { --Accept the following classes, refuse everything else (because of "exclusive=true")
	   "Ediff",
        }
    },
    {
        name         = "GameEditor",
        init         = false,
        fallback     = true,
	force_screen = true,
        screen       = left,
        layout       = awful.layout.suit.max,
        class  = {
	   "gameeditor_scripts"
        }
    },
    {
        name        = "Web",
        init        = true,
        exclusive   = true,
	force_screen= true,
        screen      = middle,
        layout      = awful.layout.suit.max,
        class = { "qutebrowser", "firefox", "firefox-esr", "google-chrome", "Google-chrome" }
    },
    {
        name         = "QtCreator",
        init         = false,
        exclusive    = true,
	force_screen = true,
        screen       = left,
	max_clients  = 1,
        layout       = awful.layout.suit.max,
        class ={  "qtcreator:left" }
    },
    {
        name         = "QtCreator",
        init         = true,
        exclusive    = true,
	force_screen = true,
        screen       = middle,
	max_clients  = 1,
        layout       = awful.layout.suit.max,
        class ={  "qtcreator:right", "qtcreator" }
    },
    {
        name        = "Term",
        init        = true,
        exclusive   = true,
	force_screen = true,
        screen      = middle,
        layout      = awful.layout.suit.tile,
        class  = {
	   "xterm" , "urxvt" , "aterm","URxvt","XTerm","konsole","terminator","gnome-terminal",
	   "xfce4-terminal"
        }
    },
    {
        name        = "duolito",
        init        = false,
        exclusive   = true,
	force_screen = true,
        screen      = middle,
        layout      = awful.layout.suit.fair,
        class  = {
	   "duolito"
        }
    },
    {
        name        = "headless",
        init        = false,
        exclusive   = true,
	force_screen = true,
        screen      = middle,
        layout      = awful.layout.suit.fair,
        class  = {
	   "headless"
        }
    },
    {
        name        = "Files",
        init        = true,
        exclusive   = true,
	force_screen = true,
        screen      = middle,
        layout      = awful.layout.suit.tile,
        class  = {
            "Thunar", "Konqueror", "Dolphin", "ark", "Nautilus","emelfm", "nemo"
        }
    } ,
    {
        name         = "eclipse",
        init         = false,
        fallback     = true,
	force_screen = true,
        screen       = middle,
        layout       = awful.layout.suit.max,
        class  = {
	   "eclipse"
        }
    },
    {
        name         = "GameEditor",
        init         = false,
        fallback     = true,
	force_screen = true,
        screen       = middle,
        layout       = awful.layout.suit.max,
        class  = {
	   "gameeditor", "psmtec/GameEditor", "gameeditor_main"
        }
    },
    {
        name         = "various",
        init         = true,
        fallback     = true,
	force_screen = true,
        screen       = middle,
        layout       = awful.layout.suit.max,
        class  = {
	   "evince", "epdfview", "Epdfview", "backend"
        }
    } ,
    {
        name         = "okular",
        init         = false,
        exclusive    = true,
	force_screen = true,
        screen       = middle,
        layout       = awful.layout.suit.max,
        class  = {
	   "okular", "Okular"
        }
    } ,
    {
        name         = "libreoffice",
        init         = false,
        exclusive    = true,
	force_screen = true,
        screen       = middle,
        layout       = awful.layout.suit.max,
        class  = {
	   "libreoffice", "libreoffice-calc"
        }
    } ,
    {
        name         = "email",
        init         = true,
        exclusive    = true,
	force_screen = true,
        screen       = right,
        layout       = awful.layout.suit.max,
        class  = {
	   "thunderbird", "E-Mail"
        }
    } ,
    {
        name         = "email-intern",
        init         = true,
        exclusive    = true,
	force_screen = true,
        screen       = right,
        layout       = awful.layout.suit.max,
        class  = {
	   "davmail-DavGateway"
        }
    },
    {
        name         = "skype",
        init         = true,
        exclusive    = true,
	force_screen = true,
        screen       = right,
        layout       = awful.layout.suit.max,
        class  = {
	   "Skype"
        }
    },
    {
        name         = "git",
        init         = false,
	force_screen = true,
        screen       = right,
        layout       = awful.layout.suit.max,
        class  = {
}
}}
exit()
  --local t = kbdcfg.layout[ layout ]
  --kbdcfg.widget:set_text( " " .. t[3] .. " " )
  --os.execute( kbdcfg.cmd .. " " .. t[1] .. " " .. t[2] )
--end


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

    -- Screenshot hotkeys.
    awful.key({ }, "Print", scrot_full,
	{description = "Take a screenshot of entire screen", group = "screenshot"}),
    awful.key({ modkey, }, "Print", scrot_selection,
	{description = "Take a screenshot of selection", group = "screenshot"}),
    awful.key({ "Shift" }, "Print", scrot_window,
	{description = "Take a screenshot of focused window", group = "screenshot"}),
    awful.key({ "Ctrl" }, "Print", scrot_delay,
	{description = "Take a screenshot of delay", group = "screenshot"}),

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
    { 
        rule = { },
        properties = 
        { 
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            floating = false
        } 
    },
    { 
        rule = { class = "XCalc" },
        properties = {
            floating = true
        }
    },
    { 
        rule = { class = "Godot" },
        properties = {
            floating = true
        }
    },
    {
        rule = { name = "OPC" },
        callback = function(c)
	        c.overwrite_class = "gl_server"
        end
    },
    { 
        rule = { class = "psmtec/GameEditor" },
        callback = function(c)
            if string.match(c.name, "Ausführungslisten") then
                c.overwrite_class = "gameeditor_scripts"
            elseif  string.match(c.name, "Ausführungsliste Namen") then
                c.overwrite_class = "gameeditor_scripts"
                c.floating = true
            elseif  string.match(c.name, "Dialog") or
                    string.match(c.name, "Object Namen") or
                    string.match(c.name, "Szene Namen") then
                c.overwrite_class = "gameeditor_main"
                c.floating = true
            elseif  string.match(c.name, "Projekt") or
                    string.match(c.name, "Game Editor") then
                c.overwrite_class = "gameeditor_main"
            else
                c.overwrite_class = "gameeditor_secondary"
            end
        end
    },
    {
       rule = { class = "Gitkraken" },
       properties = {
           screen = right,
           floating = false
       }
    },
    {
        rule = { class = "QtCreator" },
        callback = function(client)
	    local nameChanged = function(c)
	        local nameParts = {}
	        local test = ""
		if c.name ~= nil then
		    local branch,project,qt = string.match( c.name, "%[(.+)%] %- (.*) %- (.*)" )
		    if branch ~= nil and
		       project ~= nil and
		       qt ~= nil then
			c.name = project .. " [" .. branch .. "]"
		    end
		end
	    end
	    client:connect_signal( "property::name", nameChanged)
	    nameChanged(client)
	end
    },
    {
        rule = { class = "Firefox-esr" },
        callback = function(client)
	    local nameChanged = function(c)
	        local nameParts = {}
	        local test = ""
		if c.name ~= nil then
		    local name = string.match( c.name, "(.+) %- Mozilla Firefox" )
		    if name ~= nil then
			c.name = name
		    end
		end
	    end
	    client:connect_signal( "property::name", nameChanged)
	    nameChanged(client)
	end
    },
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
autostart( "firefox-esr" )
autostart( "nemo" )
autostart( "Emacs" )
autostart( "thunderbird" )
autostart( "davmail", "davmail" )
autostart( settings.Terminal )
autostart( "skypeforlinux" )

client.connect_signal("focus",
		      function(c)
			 c.border_color = beautiful.border_focus
	              end)
client.connect_signal("unfocus",
		      function(c)
			 c.border_color = beautiful.border_normal
end)

function check_mail()
  cmd = awful.util.getdir("config") .. "/thunderbird_unread_emails"
  awful.spawn.easy_async( cmd,
			  function( stdout, stderr, reason, exit_code)
			     num = tonumber(stdout)
			     if num ~= 0 then
				naughty.notify {
				   text = "New emails received (" .. num .. ")",
				   width = 250,
				   height = 100
				}
			     end
  end)
end

helpers.newtimer("mail", 2, check_mail)


-- }}}

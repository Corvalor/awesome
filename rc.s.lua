-- default rc.lua for shifty
--
-- Standard awesome library
require("awful")
require("awful.autofocus")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")
-- shifty - dynamic tagging library
require("shifty")
-- menubar - dwmenu-like application menu
require("menubar")

-- useful for debugging, marks the beginning of rc.lua exec
print("Entered rc.lua: " .. os.time())

require("menubar")
menubar.cache_entries = true
menubar.app_folders = { "/usr/share/applications/" }
menubar.show_categories = false   -- Change to false if you want only programs to appear in the menu
menubar.set_icon_theme("theme name")

-- Variable definitions
-- Themes define colours, icons, and wallpapers
-- The default is a dark theme
--  theme_path = "/usr/share/awesome/themes/default/theme.lua"
-- Uncommment this for a lighter theme
-- theme_path = "/usr/share/awesome/themes/sky/theme"
-- Molokai theme
 theme_path = os.getenv("HOME") .. "/.config/awesome/themes/molokai/theme.lua"

-- Load Custom theme
beautiful.init( theme_path )

-- This is used later as the default terminal and editor to run.
browser = "flock -n ~/.locks/qutebrowser qutebrowser"
terminal = "flock -n ~/.locks/xfce4-terminal xfce4-terminal"
emacs = "flock -n ~/.locks/emacs emacs"
qtcreator = "flock -n ~/.locks/qtcreator qtcreator"
qtcreator2 = "flock -n ~/.locks/qtcreator2 qtcreator"
nemo = "flock -n ~/.locks/nemo nemo"
editor = os.getenv("EDITOR") or "nano"

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key, I suggest you to remap
-- Mod4 to another key using xmodmap or other tools.  However, you can use
-- another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
    awful.layout.suit.floating
}

-- Define if we want to use titlebar on all applications.
use_titlebar = false

-- Shifty configured tags.
shifty.config.tags = {
    emacs = {
        layout    = awful.layout.suit.max,
        screen    = 1,
        position  = 1,
        exclusive = false,
        init      = true,
        slave     = true,
	spawn     = emacs
    },
    qtcreator = {
        layout      = awful.layout.suit.max,
	screen      = 1,
        position    = 2,
        exclusive   = false,
        init        = true,
        slave       = true,
        spawn       = qtcreator,
	nopopup     = true,
    },
    web = {
        layout      = awful.layout.suit.max,
        screen      = 2,
        position    = 1,
        exclusive   = false,
        init        = true,
        slave       = true,
        spawn       = browser,
    },
    qtcreator2 = {
        layout      = awful.layout.suit.max,
	screen      = 2,
        position    = 2,
        exclusive   = false,
        init        = true,
        slave       = true,
        spawn       = qtcreator2,
	nopopup     = true,
    },
    terminal = {
        layout      = awful.layout.suit.max,
        screen      = 2,
        position    = 3,
        exclusive   = false,
        init        = true,
        slave       = true,
        spawn       = terminal,
	nopopup     = true,
    },
    nemo = {
        layout      = awful.layout.suit.max,
        screen      = 2,
        position    = 4,
        exclusive   = false,
        init        = true,
        slave       = true,
        spawn       = nemo,
	nopopup     = true,
    },
}

qtcreator_toggle = 0
function qtcreatortag()
   qtcreator_toggle = qtcreator_toggle + 1
      return "qtcreator" .. qtcreator_toggle
end
-- SHIFTY: application matching rules
-- order here matters, early rules will be applied first
-- shifty.config.apps = {
--     {
--         match = {
-- 	   "emacs"
--         },
--         tag = "emacs",
--     },
--     {
--         match = {
-- 	   "qutebrowser"
--         },
--         tag = "web",
--     },
--     {
--         match = {
-- 	   "qtcreator"
--         },
--         tag = { qtcreatortag() },
--     },
--     {
--         match = {
-- 	   "xterm",
-- 	   "xfce4-terminal",
-- 	   "terminal"
--         },
--         tag = "terminal",
--     },
--     {
--         match = {
-- 	   "nemo"
--         },
--         tag = "nemo",
--     },
-- }

awful.rule.rules = {
   { rule = { class = "emacs" }, properties = { tag = tags[1][1] } },
   { rule = { class = "xterm" }, properties = { tag = tags[2][3] } }
}

-- SHIFTY: default tag creation rules
-- parameter description
--  * floatBars : if floating clients should always have a titlebar
--  * guess_name : should shifty try and guess tag names when creating
--                 new (unconfigured) tags?
--  * guess_position: as above, but for position parameter
--  * run : function to exec when shifty creates a new tag
--  * all other parameters (e.g. layout, mwfact) follow awesome's tag API
shifty.config.defaults = {
    layout = awful.layout.suit.tile.bottom,
    ncol = 1,
    mwfact = 0.60,
    floatBars = true,
    guess_name = true,
    guess_position = true,
}

--  Wibox
-- Create a textbox widget
mytextclock = awful.widget.textclock({align = "right"})

-- Create a laucher widget and a main menu
myawesomemenu = {
    {"manual", terminal .. " -e man awesome"},
    {"restart", awesome.restart},
    {"quit", awesome.quit}
}

mymainmenu = awful.menu(
    {
        items = {
            {"awesome", myawesomemenu, beautiful.awesome_icon},
              {"open terminal", terminal}}
          })

mylauncher = awful.widget.launcher({image = image(beautiful.awesome_icon),
                                     menu = mymainmenu})

-- Create a systray
mysystray = widget({type = "systray", align = "right"})

-- Keyboard map indicator and changer
kbdcfg = {}
kbdcfg.cmd = "setxkbmap"
kbdcfg.layout = { { "us", "-variant altgr-intl -option nodeadkey" , "US" }, { "us", "-variant colemak" , "CO" } } 
kbdcfg.current = 1  -- us is our default layout
kbdcfg.widget = widget( { type = "textbox" } )
kbdcfg.widget.text = " " .. kbdcfg.layout[kbdcfg.current][3] .. " "
kbdcfg.switch = function ()
  kbdcfg.current = kbdcfg.current % #(kbdcfg.layout) + 1
  local t = kbdcfg.layout[kbdcfg.current]
  kbdcfg.widget.text = " " .. t[3] .. " "
  os.execute( kbdcfg.cmd .. " " .. t[1] .. " " .. t[2] )
end

 -- Mouse bindings
kbdcfg.widget:buttons(
 awful.util.table.join(awful.button({ }, 1, function () kbdcfg.switch() end))
)

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
    awful.button({}, 1, awful.tag.viewonly),
    awful.button({modkey}, 1, awful.client.movetotag),
    awful.button({}, 3, function(tag) tag.selected = not tag.selected end),
    awful.button({modkey}, 3, awful.client.toggletag),
    awful.button({}, 4, awful.tag.viewnext),
    awful.button({}, 5, awful.tag.viewprev)
    )

mytasklist = {}
mytasklist.buttons = awful.util.table.join(
    awful.button({}, 1, function(c)
        if not c:isvisible() then
            awful.tag.viewonly(c:tags()[1])
        end
        client.focus = c
        c:raise()
        end),
    awful.button({}, 3, function()
        if instance then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({width=250})
        end
        end),
    awful.button({}, 4, function()
        awful.client.focus.byidx(1)
        if client.focus then client.focus:raise() end
        end),
    awful.button({}, 5, function()
        awful.client.focus.byidx(-1)
        if client.focus then client.focus:raise() end
        end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] =
        awful.widget.prompt({layout = awful.widget.layout.leftright})
    -- Create an imagebox widget which will contains an icon indicating which
    -- layout we're using.  We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
            awful.button({}, 1, function() awful.layout.inc(layouts, 1) end),
            awful.button({}, 3, function() awful.layout.inc(layouts, -1) end),
            awful.button({}, 4, function() awful.layout.inc(layouts, 1) end),
            awful.button({}, 5, function() awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist.new(s,
                                            awful.widget.taglist.label.all,
                                            mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist.new(function(c)
                        return awful.widget.tasklist.label.currenttags(c, s)
                    end,
                                              mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({position = "top", screen = s})
    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = {
        {
            mylauncher,
            mytaglist[s],
            mypromptbox[s],
            layout = awful.widget.layout.horizontal.leftright
        },
        mylayoutbox[s],
	kbdcfg.widget,
        mytextclock,
        s == 1 and mysystray or nil,
        mytasklist[s],
        layout = awful.widget.layout.horizontal.rightleft
        }

    mywibox[s].screen = s
end

-- SHIFTY: initialize shifty
-- the assignment of shifty.taglist must always be after its actually
-- initialized with awful.widget.taglist.new()
shifty.taglist = mytaglist
shifty.init()

-- Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({}, 3, function() mymainmenu:show({keygrabber=true}) end),
    awful.button({}, 4, awful.tag.viewnext),
    awful.button({}, 5, awful.tag.viewprev)
))

-- Key bindings
globalkeys = awful.util.table.join(
    -- Tags
   awful.key({modkey}, "Left", function() awful.screen.focus_relative(-1) end),
      awful.key({modkey}, "Right", function() awful.screen.focus_relative( 1) end ),
    awful.key({modkey}, "Escape", awful.tag.history.restore),

    -- Shifty: keybindings specific to shifty
    awful.key({modkey, "Shift"}, "d", shifty.del), -- delete a tag
    awful.key({modkey, "Shift"}, "n", shifty.send_prev), -- client to prev tag
    awful.key({modkey}, "n", shifty.send_next), -- client to next tag
    awful.key({modkey, "Control"},
              "n",
              function()
                  local t = awful.tag.selected()
                  local s = awful.util.cycle(screen.count(), t.screen + 1)
                  awful.tag.history.restore()
                  t = shifty.tagtoscr(s, t)
                  awful.tag.viewonly(t)
              end),
    awful.key({modkey}, "a", shifty.add), -- creat a new tag
    awful.key({modkey,}, "r", shifty.rename), -- rename a tag
    awful.key({modkey, "Shift"}, "a", -- nopopup new tag
    function()
        shifty.add({nopopup = true})
    end),

    awful.key({modkey,}, "j",
    function()
        awful.client.focus.byidx(1)
        if client.focus then client.focus:raise() end
    end),
    awful.key({modkey,}, "k",
    function()
        awful.client.focus.byidx(-1)
        if client.focus then client.focus:raise() end
    end),
    awful.key({modkey,}, "w", function() mymainmenu:show(true) end),

    -- Layout manipulation
    awful.key({modkey, "Shift"}, "j",
        function() awful.client.swap.byidx(1) end),
    awful.key({modkey, "Shift"}, "k",
        function() awful.client.swap.byidx(-1) end),
    awful.key({modkey, "Control"}, "j", function() awful.screen.focus(1) end),
    awful.key({modkey, "Control"}, "k", function() awful.screen.focus(-1) end),
    awful.key({modkey,}, "u", awful.client.urgent.jumpto),
    awful.key({modkey,}, "Tab",
    function()
        awful.client.focus.history.previous()
        if client.focus then
            client.focus:raise()
        end
    end),

    -- Standard program
    awful.key({modkey,}, "Return", function() awful.util.spawn(terminal) end),
    awful.key({modkey, "Control"}, "r", awesome.restart),
    awful.key({modkey, "Shift"}, "q", awesome.quit),

    awful.key({modkey,}, "l", function() awful.tag.incmwfact(0.05) end),
    awful.key({modkey,}, "h", function() awful.tag.incmwfact(-0.05) end),
    awful.key({modkey, "Shift"}, "h", function() awful.tag.incnmaster(1) end),
    awful.key({modkey, "Shift"}, "l", function() awful.tag.incnmaster(-1) end),
    awful.key({modkey, "Control"}, "h", function() awful.tag.incncol(1) end),
    awful.key({modkey, "Control"}, "l", function() awful.tag.incncol(-1) end),
    awful.key({modkey,}, "space", function() awful.layout.inc(layouts, 1) end),
    awful.key({modkey, "Shift"}, "space",
        function() awful.layout.inc(layouts, -1) end),

    -- Prompt
    awful.key({modkey}, "F1", function()
        awful.prompt.run({prompt = "Run: "},
        mypromptbox[mouse.screen].widget,
        awful.util.spawn, awful.completion.shell,
        awful.util.getdir("cache") .. "/history")
        end),

    awful.key({modkey}, "F4", function()
        awful.prompt.run({prompt = "Run Lua code: "},
        mypromptbox[mouse.screen].widget,
        awful.util.eval, nil,
        awful.util.getdir("cache") .. "/history_eval")
        end)
    )

-- Client awful tagging: this is useful to tag some clients and then do stuff
-- like move to tag on them
clientkeys = awful.util.table.join(
    awful.key({modkey,}, "f", function(c) c.fullscreen = not c.fullscreen  end),
    awful.key({modkey, "Shift"}, "c", function(c) c:kill() end),
    awful.key({modkey, "Control"}, "space", awful.client.floating.toggle),
    awful.key({modkey, "Control"}, "Return",
        function(c) c:swap(awful.client.getmaster()) end),
    awful.key({modkey,}, "o", awful.client.movetoscreen),
    awful.key({modkey, "Shift"}, "r", function(c) c:redraw() end),
    awful.key({modkey}, "t", awful.client.togglemarked),
    awful.key({modkey,}, "m",
        function(c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- SHIFTY: assign client keys to shifty for use in
-- match() function(manage hook)
shifty.config.clientkeys = clientkeys
shifty.config.modkey = modkey

-- Compute the maximum number of digit we need, limited to 9
for i = 1, (shifty.config.maxtags or 9) do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({modkey}, i, function()
            local t =  awful.tag.viewonly(shifty.getpos(i))
            end),
        awful.key({modkey, "Control"}, i, function()
            local t = shifty.getpos(i)
            t.selected = not t.selected
            end),
        awful.key({modkey, "Control", "Shift"}, i, function()
            if client.focus then
                awful.client.toggletag(shifty.getpos(i))
            end
            end),
        -- move clients to other tags
        awful.key({modkey, "Shift"}, i, function()
            if client.focus then
                t = shifty.getpos(i)
                awful.client.movetotag(t)
                awful.tag.viewonly(t)
            end
        end))
    end

 --trigger client mode on Ctrl + w
 globalkeys = awful.util.table.join(globalkeys,
    awful.key( { "Control" }, "w", function(c)
      keygrabber.run(function(mod, key, event)
        awful.tag.setmwfact( 1.00)
        if event == "release" then
            return true
        end
        keygrabber.stop()
        if client_mode[key] then client_mode[key](c)
	elseif key == ";" then client_mode["menu"](c)
	elseif key == "1" then client_mode["d1"](c)
        elseif key == "2" then client_mode["d2"](c)
        elseif key == "3" then client_mode["d3"](c)
        elseif key == "4" then client_mode["d4"](c)
        elseif key == "5" then client_mode["d5"](c)
        elseif key == "6" then client_mode["d6"](c)
        elseif key == "7" then client_mode["d7"](c)
        elseif key == "8" then client_mode["d8"](c) else
	      passThrough()
	      simulateKey( key )
	end
        return true
      end)
  end)
 )

function passThrough()
    root.fake_input('key_release', 'Control_L')
    root.fake_input('key_release', 'Shift_L')
    root.fake_input('key_release', 'W')

    root.fake_input('key_press', 'Control_L')
    root.fake_input('key_press', 'Shift_L')
    root.fake_input('key_press', 'W')
    root.fake_input('key_release', 'W')
    root.fake_input('key_release', 'Shift_L')
    root.fake_input('key_release', 'Control_L')
end

function simulateKey( key )
    root.fake_input('key_release', key)
    root.fake_input('key_press', key)
    root.fake_input('key_release', key)
end

  -- mapping for modal client keys
    client_mode = {
      -- Switch tags
      d1 = function(c) awful.tag.viewonly(tags[mouse.screen][1]) end,
      d2 = function(c) awful.tag.viewonly(tags[mouse.screen][2]) end,
      d3 = function(c) awful.tag.viewonly(tags[mouse.screen][3]) end,
      d4 = function(c) awful.tag.viewonly(tags[mouse.screen][4]) end,
      d5 = function(c) awful.tag.viewonly(tags[mouse.screen][5]) end,
      d6 = function(c) awful.tag.viewonly(tags[mouse.screen][6]) end,
      d7 = function(c) awful.tag.viewonly(tags[mouse.screen][7]) end,
      d8 = function(c) awful.tag.viewonly(tags[mouse.screen][8]) end,
      d9 = function(c) awful.tag.viewonly(tags[mouse.screen][9]) end,
      -- Move left
      h = function ()
	 if client.focus.class == 'Emacs' then
	    passThrough()
	    simulateKey( 'h' )
	 else 
	     awful.screen.focus_relative( 1)
	 end
      end,
      -- Move right
      l = function ()
	 if client.focus.class == 'Emacs' then
	    passThrough()
	    simulateKey( 'l' )
	 else 
	     awful.screen.focus_relative(-1)
	 end
      end,
      -- Move down
      j = function (c)
	 if client.focus.class == 'Emacs' then
	    passThrough()
	    simulateKey( 'j' )
	 end
      end,
      -- Move down
      k = function (c)
	 if client.focus.class == 'Emacs' then
	     passThrough()
	     simulateKey( 'k' )
	 end
      end,
      -- Start qutebrowser
      z = function (c)
 	awful.util.spawn_with_shell( "qutebrowser" )
      end,
      menu = function() menubar.show() end
    }

-- Set keys
root.keys(globalkeys)

-- Hook function to execute when focusing a client.
client.add_signal("focus", function(c)
    if not awful.client.ismarked(c) then
        c.border_color = beautiful.border_focus
    end
end)

-- Hook function to execute when unfocusing a client.
client.add_signal("unfocus", function(c)
    if not awful.client.ismarked(c) then
        c.border_color = beautiful.border_normal
    end
end)

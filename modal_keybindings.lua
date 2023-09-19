local awful = require("awful")
awful.util = require("awful.util")
local lain = require("lain")
local markup = lain.util.markup
local beautiful = require("beautiful")
local help = require("help")
local dump = require("dump")

 --trigger client mode on Ctrl + w
 globalkeys = awful.util.table.join(globalkeys,
    awful.key.new( { "Control" }, "w", function(c)
      keygrabber.run(function(mod, key, event)
        --awful.tag.setmwfact( 1.00)
	-- Ignore Button release
        if event == "release" then return true end
	-- Ignore Shift
	if key == "Shift_R" then return true end
        keygrabber.stop()
        if client_mode[key] then client_mode[key].cb(c) else
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

function string.starts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end

current_task_id = nil;

client_mode = {
}
client_mode_order = {
}
function AddModularKeybinding( key, help, callback)
   client_mode[key] = { h = help,
			cb = callback };
   client_mode_order[#client_mode_order + 1] = key;
end

    -- Switch tags
      AddModularKeybinding( "1", "Switch to tag  1",
			    function(c) awful.tag.viewonly(awful.screen.focused().tags[1]) end )
      AddModularKeybinding( "2", "Switch to tag  2",
			    function(c) awful.tag.viewonly(awful.screen.focused().tags[2]) end )
      AddModularKeybinding( "3", "Switch to tag  3",
			    function(c) awful.tag.viewonly(awful.screen.focused().tags[3]) end )
      AddModularKeybinding( "4", "Switch to tag  4",
			    function(c) awful.tag.viewonly(awful.screen.focused().tags[4]) end )
      AddModularKeybinding( "5", "Switch to tag  5",
			    function(c) awful.tag.viewonly(awful.screen.focused().tags[5]) end )
      AddModularKeybinding( "6", "Switch to tag  6",
			    function(c) awful.tag.viewonly(awful.screen.focused().tags[6]) end )
      AddModularKeybinding( "7", "Switch to tag  7",
			    function(c) awful.tag.viewonly(awful.screen.focused().tags[7]) end )
      AddModularKeybinding( "8", "Switch to tag  8",
			    function(c) awful.tag.viewonly(awful.screen.focused().tags[8]) end )
      AddModularKeybinding( "9", "Switch to tag  9",
			    function(c) awful.tag.viewonly(awful.screen.focused().tags[9]) end )
      AddModularKeybinding( "0", "Switch to tag 10",
			    function(c) awful.tag.viewonly(awful.screen.focused().tags[10]) end )

      AddModularKeybinding( "h", "Move left",
			    function()
	 if client.focus and client.focus.class == 'Emacs' then
	    passThrough()
	    simulateKey( 'h' )
	 else 
	     awful.screen.focus_relative( 1)
	 end
      end)
      AddModularKeybinding( "l", "Move right",
			    function()
	 if client.focus and client.focus.class == 'Emacs' then
	    passThrough()
	    simulateKey( 'l' )
	 else 
	     awful.screen.focus_relative( -1)
	 end
      end)
      AddModularKeybinding( "j", "Move down",
			    function()
	 if client.focus and client.focus.class == 'Emacs' then
	    passThrough()
	    simulateKey( 'j' )
	 end
      end)
      AddModularKeybinding( "k", "Move up",
			    function()
	 if client.focus and client.focus.class == 'Emacs' then
	    passThrough()
	    simulateKey( 'k' )
	 end
      end)
      AddModularKeybinding( "z", "Start qutebrowser",
			    function()
	 local matcher = function (c)
	    return awful.rules.match( c, {class = "qutebrowser" } )
	 end
	 awful.client.run_or_raise( "qutebrowser", matcher )
      end)
      AddModularKeybinding( "e", "Start emacs",
			    function()
	 local matcher = function (c)
	    return awful.rules.match( c, {class = "Emacs" } )
	 end
	 awful.client.run_or_raise( "emacs", matcher )
      end)
      AddModularKeybinding( "t", "Start terminal",
			    function()
	 local matcher = function (c)
	    return awful.rules.match( c, {class = "Lxterminal" } )
	 end
	 awful.client.run_or_raise( "lxterminal", matcher )
      end)
      AddModularKeybinding( "n", "Start Nemo",
			    function()
	 local matcher = function (c)
	    return awful.rules.match( c, {class = "Nemo" } )
	 end
	 awful.client.run_or_raise( "nemo", matcher )
      end)
      AddModularKeybinding( "q", "Start QtCreator",
			    function()
	 local matcher = function (c)
	    return awful.rules.match( c, {class = "QtCreator" } )
	 end
	 awful.client.run_or_raise( "qtcreator", matcher )
      end)
      AddModularKeybinding( "d", "Kill current windows",
			    function()
	 if client.focus then
	    client.focus:kill()
	 else
	    tag.selected_tag:delete()
	end
      end)
      AddModularKeybinding( "c", "Show calendar",
			    function()
			       lain.widget.calendar.show(7)
      end)
      AddModularKeybinding( "f", "Add task",
			    function()
			       awful.prompt.run {
				  prompt = "Add Task: ",
				  textbox = mypromptbox[mouse.screen.index].widget,
				  exe_callback = function (new_task)
				     os.execute( "task add " .. new_task )
				  end,
				  history_path = awful.util.getdir("cache") .. "/history_add_task"
			       }
      end)
      AddModularKeybinding( "r", "Remove task",
			    function()
			       lain.widget.contrib.task.show();
			       awful.prompt.run {
				  prompt = "Remove Task: ",
				  textbox = mypromptbox[mouse.screen.index].widget,
				  exe_callback = function (task_id)
				     os.execute( "task delete " .. task_id )
				     lain.widget.contrib.task.show();
				  end,
				  history_path = awful.util.getdir("cache") .. "/history_remove_task"
			       }
      end )
      AddModularKeybinding( "v", "Show tasklist",
			    function()
					--mytask:emit_signal("toggle");
			       lain.widget.contrib.task.toggle();
      end )
      AddModularKeybinding( "i", "xwininfo",
		function()
			awful.spawn.easy_async( "xprop",
				function( stdout, stderr, reason, exit_code)
					ignore = false
					lines = {}
					for s in stdout:gmatch("[^\r\n]+") do
						if string.starts(s, "_NET_WM_ICON") then
							ignore = true
						elseif string.starts(s, "_") or string.starts(s,"W") then
							ignore = false
						end
						if ignore == false then
							table.insert(lines, s)
						end
					end
					dump.run(table.concat(lines, "\n"))
				end)
		end)
      AddModularKeybinding( "s", "Complete a task",
			    function()
	 lain.widget.contrib.task.show();
	 awful.prompt.run {
	    prompt = "Complete Task: ",
	    textbox = mypromptbox[mouse.screen.index].widget,
	    exe_callback = function (task_id)
		os.execute( "task done " .. task_id )
		lain.widget.contrib.task.show();
	    end,
	    history_path = awful.util.getdir("cache") .. "/history_complete_task"
	 }
      end )
      AddModularKeybinding( "g", "Start a task",
			    function()
			       lain.widget.contrib.task.show();
			       awful.prompt.run {
				  prompt = "Start Task: ",
				  textbox = mypromptbox[mouse.screen.index].widget,
				  exe_callback = function (task_id)
				     os.execute( "task start " .. task_id )
				     lain.widget.contrib.task.show();
				     current_task_id = task_id;
				  end,
				  history_path = awful.util.getdir("cache") .. "/history_start_task"
			       }
      end )
      AddModularKeybinding( "x", "Stop a task",
			    function()
	 if current_task_id then
	    os.execute( "task stop " .. current_task_id )
	    current_task_id = nil;
	 end
      end )
      AddModularKeybinding( "p", "Move tag to other screen",
			    function()
	 local t = awful.screen.focused() and awful.screen.focused().selected_tag or nil
	 if t then
	    for s in screen do
	       if not (s == t.screen) then
		  local old_s = t.screen;
		  awful.tag.viewnone(s);
		  t.screen = s;
		  awful.tag.viewnext(old_s);
		  return;
	       end
	    end
	 end
      end )
      AddModularKeybinding( "[", "Move client to other screen",
			    function()
	 local c = client.focus
	 if c then
		c:move_to_screen()
	 end
      end )
      AddModularKeybinding( ";", "Open dmenu (execute applications)",
			    function()
			       awful.util.spawn("dmenu_run -i -p 'Run command:' -nb '" ..
						   beautiful.bg_normal .. "' -nf '" .. beautiful.fg_normal ..
						   "' -sb '" .. beautiful.bg_focus ..
						   "' -sf '" .. beautiful.fg_focus .. "'") 
      end )
      AddModularKeybinding( "?", "Show help",
			    function()
			       help.centered_menu()
      end )

return nil

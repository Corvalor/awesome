---------------------------
-- molokai awesome theme --
---------------------------

-- Forked from copycatkiller's powerarrow-darker.

-- theme = {}

--  Molokai colors
-- theme.molokai_bkgd  = "#1B1D1E"
-- theme.black         = "#232526"
-- theme.white         = "#F8F8F0"

-- theme.red           = "#FF0000"
-- theme.orange        = "#FD971F"
-- theme.magenta       = "#F92672"
-- theme.cyan          = "#66D9EF"
-- theme.green         = "#A6E22E"



-- theme.font                          = "Dina 8"

-- theme.bg_normal                     = theme.molokai_bkgd
-- theme.bg_focus                      = theme.orange
-- theme.bg_urgent                     = theme.cyan
-- theme.bg_minimize                   = theme.molokai_bkgd
-- theme.bg_systray                    = theme.bg_normal

-- theme.fg_normal                     = theme.magenta
-- theme.fg_focus                      = theme.molokai_bkgd
-- theme.fg_urgent                     = theme.black
-- theme.fg_minimize                   = theme.green

-- theme.border_width                  = 1
-- theme.border_normal                 = theme.black
-- theme.border_focus                  = theme.orange
-- theme.border_marked                 = theme.magenta

-- theme.taglist_fg_focus              = theme.molokai_bkgd
-- theme.taglist_bg_focus              = theme.magenta
-- theme.taglist_fg_urgent             = theme.fg_urgent
-- theme.taglist_bg_urgent             = theme.bg_urgent

-- theme.tasklist_fg_focus             = theme.fg_focus
-- theme.tasklist_bg_focus             = theme.bg_focus
-- theme.tasklist_fg_urgent            = theme.fg_urgent
-- theme.tasklist_bg_urgent            = theme.bg_urgent

-- theme.textbox_widget_margin_top = 1

-- theme.notify_fg = theme.green
-- theme.notify_bg = theme.bg_normal
-- theme.notify_border = theme.magenta

-- theme.awful_widget_height = 14
-- theme.awful_widget_margin_top = 2

-- theme.menu_height = 15
-- theme.menu_width  = 100

-- themes_dir                          = os.getenv("HOME") .. "/.config/awesome/themes/molokai"
-- theme.wallpaper_cmd                 = { "feh --bg-scale " .. themes_dir .. "/background.jpg" }
-- theme.menu_submenu_icon             = themes_dir .. "/icons/submenu.png"
-- theme.taglist_squares_sel           = themes_dir .. "/icons/square_sel.png"
-- theme.taglist_squares_unsel         = themes_dir .. "/icons/square_unsel.png"

-- theme.layout_tile                   = themes_dir .. "/icons/tile.png"
-- theme.layout_tilegaps               = themes_dir .. "/icons/tilegaps.png"
-- theme.layout_tileleft               = themes_dir .. "/icons/tileleft.png"
-- theme.layout_tilebottom             = themes_dir .. "/icons/tilebottom.png"
-- theme.layout_tiletop                = themes_dir .. "/icons/tiletop.png"
-- theme.layout_fairv                  = themes_dir .. "/icons/fairv.png"
-- theme.layout_fairh                  = themes_dir .. "/icons/fairh.png"
-- theme.layout_spiral                 = themes_dir .. "/icons/spiral.png"
-- theme.layout_dwindle                = themes_dir .. "/icons/dwindle.png"
-- theme.layout_max                    = themes_dir .. "/icons/max.png"
-- theme.layout_fullscreen             = themes_dir .. "/icons/fullscreen.png"
-- theme.layout_magnifier              = themes_dir .. "/icons/magnifier.png"
-- theme.layout_floating               = themes_dir .. "/icons/floating.png"

-- theme.arrl                          = themes_dir .. "/icons/arrl.png"
-- theme.arrl_dl                       = themes_dir .. "/icons/arrl_dl.png"
-- theme.arrl_ld                       = themes_dir .. "/icons/arrl_ld.png"

-- theme.widget_ac                     = themes_dir .. "/icons/ac.png"
-- theme.widget_battery                = themes_dir .. "/icons/battery.png"
-- theme.widget_battery_low            = themes_dir .. "/icons/battery_low.png"
-- theme.widget_battery_empty          = themes_dir .. "/icons/battery_empty.png"
-- theme.widget_mem                    = themes_dir .. "/icons/mem.png"
-- theme.widget_cpu                    = themes_dir .. "/icons/cpu.png"
-- theme.widget_temp                   = themes_dir .. "/icons/temp.png"
-- theme.widget_net                    = themes_dir .. "/icons/net_transparent.png"
-- theme.widget_hdd                    = themes_dir .. "/icons/hdd.png"
-- theme.widget_music                  = themes_dir .. "/icons/note_transparent.png"
-- theme.widget_music_on               = themes_dir .. "/icons/note_on_transparent.png"
-- theme.widget_vol                    = themes_dir .. "/icons/vol.png"
-- theme.widget_vol_low                = themes_dir .. "/icons/vol_low.png"
-- theme.widget_vol_no                 = themes_dir .. "/icons/vol_no.png"
-- theme.widget_vol_mute               = themes_dir .. "/icons/vol_mute.png"
-- theme.widget_mail                   = themes_dir .. "/icons/mail.png"
-- theme.widget_mail_on                = themes_dir .. "/icons/mail_on.png"

-- theme.tasklist_disable_icon         = true
-- theme.tasklist_floating             = "▀ "
-- theme.tasklist_maximized_horizontal = "="
-- theme.tasklist_maximized_vertical   = "| "

-- -- Lain icons
-- theme.lain_icons                    = os.getenv("HOME") ..
--                                       "/.config/awesome/lain/icons/layout/default/"
-- theme.layout_termfair               = theme.lain_icons .. "termfairw.png"
-- theme.layout_centerfair             = theme.lain_icons .. "centerfairw.png"
-- theme.layout_cascade                = theme.lain_icons .. "cascadew.png"
-- theme.layout_cascadetile            = theme.lain_icons .. "cascadetilew.png"
-- theme.layout_centerwork             = theme.lain_icons .. "centerworkw.png"


-- theme.font          = "sans 8"

-- theme.bg_normal     = "#222222"
-- theme.bg_focus      = "#535d6c"
-- theme.bg_urgent     = "#ff0000"
-- theme.bg_minimize   = "#444444"

-- theme.fg_normal     = "#aaaaaa"
-- theme.fg_focus      = "#ffffff"
-- theme.fg_urgent     = "#ffffff"
-- theme.fg_minimize   = "#ffffff"

-- theme.border_width  = "1"
-- theme.border_normal = "#000000"
-- theme.border_focus  = "#535d6c"
-- theme.border_marked = "#91231c"

-- -- There are other variable sets
-- -- overriding the default one when
-- -- defined, the sets are:
-- -- [taglist|tasklist]_[bg|fg]_[focus|urgent]
-- -- titlebar_[bg|fg]_[normal|focus]
-- -- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- -- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- -- Example:
-- --theme.taglist_bg_focus = "#ff0000"

-- -- Display the taglist squares
-- theme.taglist_squares_sel   = "/usr/share/awesome/themes/default/taglist/squarefw.png"
-- theme.taglist_squares_unsel = "/usr/share/awesome/themes/default/taglist/squarew.png"

-- theme.tasklist_floating_icon = "/usr/share/awesome/themes/default/tasklist/floatingw.png"

-- -- Variables set for theming the menu:
-- -- menu_[bg|fg]_[normal|focus]
-- -- menu_[border_color|border_width]
-- theme.menu_submenu_icon = "/usr/share/awesome/themes/default/submenu.png"
-- theme.menu_height = "15"
-- theme.menu_width  = "100"

-- -- You can add as many variables as
-- -- you wish and access them by using
-- -- beautiful.variable in your rc.lua
-- --theme.bg_widget = "#cc0000"

-- -- Define the image to load
-- theme.titlebar_close_button_normal = "/usr/share/awesome/themes/default/titlebar/close_normal.png"
-- theme.titlebar_close_button_focus  = "/usr/share/awesome/themes/default/titlebar/close_focus.png"

-- theme.titlebar_ontop_button_normal_inactive = "/usr/share/awesome/themes/default/titlebar/ontop_normal_inactive.png"
-- theme.titlebar_ontop_button_focus_inactive  = "/usr/share/awesome/themes/default/titlebar/ontop_focus_inactive.png"
-- theme.titlebar_ontop_button_normal_active = "/usr/share/awesome/themes/default/titlebar/ontop_normal_active.png"
-- theme.titlebar_ontop_button_focus_active  = "/usr/share/awesome/themes/default/titlebar/ontop_focus_active.png"

-- theme.titlebar_sticky_button_normal_inactive = "/usr/share/awesome/themes/default/titlebar/sticky_normal_inactive.png"
-- theme.titlebar_sticky_button_focus_inactive  = "/usr/share/awesome/themes/default/titlebar/sticky_focus_inactive.png"
-- theme.titlebar_sticky_button_normal_active = "/usr/share/awesome/themes/default/titlebar/sticky_normal_active.png"
-- theme.titlebar_sticky_button_focus_active  = "/usr/share/awesome/themes/default/titlebar/sticky_focus_active.png"

-- theme.titlebar_floating_button_normal_inactive = "/usr/share/awesome/themes/default/titlebar/floating_normal_inactive.png"
-- theme.titlebar_floating_button_focus_inactive  = "/usr/share/awesome/themes/default/titlebar/floating_focus_inactive.png"
-- theme.titlebar_floating_button_normal_active = "/usr/share/awesome/themes/default/titlebar/floating_normal_active.png"
-- theme.titlebar_floating_button_focus_active  = "/usr/share/awesome/themes/default/titlebar/floating_focus_active.png"

-- theme.titlebar_maximized_button_normal_inactive = "/usr/share/awesome/themes/default/titlebar/maximized_normal_inactive.png"
-- theme.titlebar_maximized_button_focus_inactive  = "/usr/share/awesome/themes/default/titlebar/maximized_focus_inactive.png"
-- theme.titlebar_maximized_button_normal_active = "/usr/share/awesome/themes/default/titlebar/maximized_normal_active.png"
-- theme.titlebar_maximized_button_focus_active  = "/usr/share/awesome/themes/default/titlebar/maximized_focus_active.png"

-- -- You can use your own command to set your wallpaper
-- theme.wallpaper_cmd = { "awsetbg /usr/share/awesome/themes/default/background.png" }

-- -- You can use your own layout icons like this:
-- theme.layout_fairh = "/usr/share/awesome/themes/default/layouts/fairhw.png"
-- theme.layout_fairv = "/usr/share/awesome/themes/default/layouts/fairvw.png"
-- theme.layout_floating  = "/usr/share/awesome/themes/default/layouts/floatingw.png"
-- theme.layout_magnifier = "/usr/share/awesome/themes/default/layouts/magnifierw.png"
-- theme.layout_max = "/usr/share/awesome/themes/default/layouts/maxw.png"
-- theme.layout_fullscreen = "/usr/share/awesome/themes/default/layouts/fullscreenw.png"
-- theme.layout_tilebottom = "/usr/share/awesome/themes/default/layouts/tilebottomw.png"
-- theme.layout_tileleft   = "/usr/share/awesome/themes/default/layouts/tileleftw.png"
-- theme.layout_tile = "/usr/share/awesome/themes/default/layouts/tilew.png"
-- theme.layout_tiletop = "/usr/share/awesome/themes/default/layouts/tiletopw.png"
-- theme.layout_spiral  = "/usr/share/awesome/themes/default/layouts/spiralw.png"
-- theme.layout_dwindle = "/usr/share/awesome/themes/default/layouts/dwindlew.png"

-- theme.awesome_icon = "/usr/share/awesome/icons/awesome16.png"

-- return theme

---------------------------
-- Default awesome theme --
---------------------------

theme = {}

theme.font          = "sans 8"

theme.bg_normal     = "#222222"
theme.bg_focus      = "#535d6c"
theme.bg_urgent     = "#ff0000"
theme.bg_minimize   = "#444444"

theme.fg_normal     = "#aaaaaa"
theme.fg_focus      = "#ffffff"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#ffffff"

theme.border_width  = "1"
theme.border_normal = "#000000"
theme.border_focus  = "#535d6c"
theme.border_marked = "#91231c"

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

-- Display the taglist squares
theme.taglist_squares_sel   = "/usr/share/awesome/themes/default/taglist/squarefw.png"
theme.taglist_squares_unsel = "/usr/share/awesome/themes/default/taglist/squarew.png"

theme.tasklist_floating_icon = "/usr/share/awesome/themes/default/tasklist/floatingw.png"

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = "/usr/share/awesome/themes/default/submenu.png"
theme.menu_height = "15"
theme.menu_width  = "100"

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
theme.titlebar_close_button_normal = "/usr/share/awesome/themes/default/titlebar/close_normal.png"
theme.titlebar_close_button_focus  = "/usr/share/awesome/themes/default/titlebar/close_focus.png"

theme.titlebar_ontop_button_normal_inactive = "/usr/share/awesome/themes/default/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = "/usr/share/awesome/themes/default/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = "/usr/share/awesome/themes/default/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active  = "/usr/share/awesome/themes/default/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = "/usr/share/awesome/themes/default/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  = "/usr/share/awesome/themes/default/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = "/usr/share/awesome/themes/default/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active  = "/usr/share/awesome/themes/default/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = "/usr/share/awesome/themes/default/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive  = "/usr/share/awesome/themes/default/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = "/usr/share/awesome/themes/default/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active  = "/usr/share/awesome/themes/default/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = "/usr/share/awesome/themes/default/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = "/usr/share/awesome/themes/default/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = "/usr/share/awesome/themes/default/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active  = "/usr/share/awesome/themes/default/titlebar/maximized_focus_active.png"

-- You can use your own command to set your wallpaper
themes_dir                          = os.getenv("HOME") .. "/.config/awesome/themes/molokai"
--theme.wallpaper_cmd = { "awsetbg -a ".. themes_dir .. "/background.jpg" }
theme.wallpaper_cmd                 = { "feh --bg-scale --xinerama-index 0 " .. themes_dir .. "/background_rot.jpg && \
                                         feh --bg-scale --xinerama-index 1 " .. themes_dir .. "/background.jpg" }

-- You can use your own layout icons like this:
theme.layout_fairh = "/usr/share/awesome/themes/default/layouts/fairhw.png"
theme.layout_fairv = "/usr/share/awesome/themes/default/layouts/fairvw.png"
theme.layout_floating  = "/usr/share/awesome/themes/default/layouts/floatingw.png"
theme.layout_magnifier = "/usr/share/awesome/themes/default/layouts/magnifierw.png"
theme.layout_max = "/usr/share/awesome/themes/default/layouts/maxw.png"
theme.layout_fullscreen = "/usr/share/awesome/themes/default/layouts/fullscreenw.png"
theme.layout_tilebottom = "/usr/share/awesome/themes/default/layouts/tilebottomw.png"
theme.layout_tileleft   = "/usr/share/awesome/themes/default/layouts/tileleftw.png"
theme.layout_tile = "/usr/share/awesome/themes/default/layouts/tilew.png"
theme.layout_tiletop = "/usr/share/awesome/themes/default/layouts/tiletopw.png"
theme.layout_spiral  = "/usr/share/awesome/themes/default/layouts/spiralw.png"
theme.layout_dwindle = "/usr/share/awesome/themes/default/layouts/dwindlew.png"

theme.awesome_icon = "/usr/share/awesome/icons/awesome16.png"

return theme
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80

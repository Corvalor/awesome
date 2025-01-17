
--[[
                                             
     Powerarrow Darker Awesome WM config 2.0 
     github.com/copycat-killer               
                                             
--]]

theme                               = {}

themes_dir                          = os.getenv("HOME") .. "/.config/awesome/themes/default"
theme.path                          =  themes_dir .. "/"
theme.icon_path                     =  theme.path .. "icons/"
theme.wallpaper = {}
theme.wallpaper[1]                  = themes_dir .. "/wall.png"
theme.wallpaper[2]                  = themes_dir .. "/wall.png"

theme.font                          = "Consolas 10"
theme.fg_normal                     = "#aaaaaa"
theme.fg_focus                      = "#ffffff"
theme.fg_urgent                     = "#ffffff"
theme.bg_normal_outer               = "#000000"
theme.bg_normal_inner               = "#222222"
theme.bg_normal_gradient            = "linear:0,0:0,22:0,"..theme.bg_normal_outer..":0.5,"..theme.bg_normal_inner..":2,"..theme.bg_normal_outer
theme.bg_normal                     = "#111111"
theme.bg_alternate_outer            = "#1A1A1A"
theme.bg_alternate_inner            = "#3C3C3C"
theme.bg_alternate                  = "linear:0,0:0,22:0,"..theme.bg_alternate_outer..":0.5,"..theme.bg_alternate_inner..":2,"..theme.bg_alternate_outer
theme.bg_focus_outer                = "#333333"
theme.bg_focus_inner                = "#555555"
theme.bg_focus_gradient             = "linear:0,0:0,22:0,"..theme.bg_focus_outer..":0.5,"..theme.bg_focus_inner..":2,"..theme.bg_focus_outer
theme.bg_focus                      = "#444444"
theme.bg_urgent                     = "#1A1A1A"
theme.border_width                  = 1
theme.border_normal                 = "#3F3F3F"
theme.border_focus                  = "#A00000"
theme.border_marked                 = "#CC9393"
theme.titlebar_bg_focus             = "#FFFFFF"
theme.titlebar_bg_normal            = "#FFFFFF"
theme.taglist_bg_focus              = theme.bg_focus
theme.taglist_fg_focus              = "#9999FF"
theme.tasklist_bg_focus             = theme.bg_focus
theme.tasklist_fg_focus             = "#9999FF"
theme.textbox_widget_margin_top     = 1
theme.notify_fg                     = theme.fg_normal
theme.notify_bg                     = theme.bg_normal
theme.notify_border                 = theme.border_focus
theme.notification_margin           = 10
theme.awful_widget_height           = 14
theme.awful_widget_margin_top       = 2
theme.mouse_finder_color            = "#CC9393"
theme.menu_height                   = "20"
theme.menu_width                    = "400"

theme.submenu_icon                  = themes_dir .. "/icons/submenu.png"
theme.taglist_squares_sel           = themes_dir .. "/icons/square_sel.png"
theme.taglist_squares_unsel         = themes_dir .. "/icons/square_unsel.png"
theme.taglist_bg_focus              = "png:" .. themes_dir .. "/icons/taglist_bg_focus.png"
--theme.taglist_bg_focus                      = "#003131"

theme.layout_tile                   = themes_dir .. "/icons/tile.png"
theme.layout_tilegaps               = themes_dir .. "/icons/tilegaps.png"
theme.layout_tileleft               = themes_dir .. "/icons/tileleft.png"
theme.layout_tilebottom             = themes_dir .. "/icons/tilebottom.png"
theme.layout_tiletop                = themes_dir .. "/icons/tiletop.png"
theme.layout_fairv                  = themes_dir .. "/icons/fairv.png"
theme.layout_fairh                  = themes_dir .. "/icons/fairh.png"
theme.layout_spiral                 = themes_dir .. "/icons/spiral.png"
theme.layout_dwindle                = themes_dir .. "/icons/dwindle.png"
theme.layout_max                    = themes_dir .. "/icons/max.png"
theme.layout_fullscreen             = themes_dir .. "/icons/fullscreen.png"
theme.layout_magnifier              = themes_dir .. "/icons/magnifier.png"
theme.layout_floating               = themes_dir .. "/icons/floating.png"

theme.arrl                          = themes_dir .. "/icons/arrl.png"
theme.arrl_dl                       = themes_dir .. "/icons/arrl_dl.png"
theme.arrl_ld                       = themes_dir .. "/icons/arrl_ld.png"
theme.arrr                          = themes_dir .. "/icons/arrr.png"

theme.widget_ac                     = themes_dir .. "/icons/ac.png"
theme.widget_battery                = themes_dir .. "/icons/battery.png"
theme.widget_battery_low            = themes_dir .. "/icons/battery_low.png"
theme.widget_battery_empty          = themes_dir .. "/icons/battery_empty.png"
theme.widget_mem                    = themes_dir .. "/icons/mem.png"
theme.widget_cpu                    = themes_dir .. "/icons/cpu.png"
theme.widget_temp                   = themes_dir .. "/icons/temp.png"
theme.widget_net                    = themes_dir .. "/icons/net.png"
theme.widget_hdd                    = themes_dir .. "/icons/hdd.png"
theme.widget_music                  = themes_dir .. "/icons/note.png"
theme.widget_music_on               = themes_dir .. "/icons/note_on.png"
theme.widget_vol                    = themes_dir .. "/icons/vol.png"
theme.widget_vol_low                = themes_dir .. "/icons/vol_low.png"
theme.widget_vol_no                 = themes_dir .. "/icons/vol_no.png"
theme.widget_vol_mute               = themes_dir .. "/icons/vol_mute.png"
theme.widget_mail                   = themes_dir .. "/icons/mail.png"
theme.widget_mail_on                = themes_dir .. "/icons/mail_on.png"

--theme.tasklist_disable_icon         = true
theme.tasklist_floating             = ""
theme.tasklist_maximized_horizontal = ""
theme.tasklist_maximized_vertical   = ""

theme.org_todo                      = "#FFFF00"
theme.org_level_1                   = "#FD971F"
theme.org_level_2                   = "#EF5939"
theme.org_level_3                   = "#F92672"
theme.org_level_4                   = "#960050"
theme.org_level_5                   = "#AE81FF"

theme.useless_gap = 0.35

return theme

---------------------
---- MY PROGRAMS ----
---------------------

local mod = "SUPER"
local terminal = "ghostty"
local fileManager = "dolphin"
local browser = "zen-beta"
local lockScreen = "noctalia msg session lock"
local screenshot = "noctalia msg screenshot-" -- "screenshot-region" or "screenshot-fullscreen"
local launcher = "noctalia msg panel-toggle launcher"


-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
    hl.exec_cmd("noctalia")
    hl.exec_cmd("/run/current-system/sw/libexec/polkit-kde-authentication-agent-1")
    hl.exec_cmd("systemctl --user restart wireplumber")
    hl.exec_cmd("[workspace 1 silent] " .. browser)
    hl.exec_cmd("[workspace 2 silent] " .. terminal)
end)


-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 20,
        border_size = 2,

        col = {
            active_border = "rgba(33ccffee)",
            inactive_border = "rgba(595959aa)",
        },

        resize_on_border = false,
        allow_tearing = false,
        layout = "dwindle",
    },

    decoration = {
        rounding = 10,

        active_opacity = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled = false,
        },

        blur = {
            enabled = true,
            ignore_opacity = true,
        },
    },

    animations = {
        enabled = false,
    },

    misc = {
        force_default_wallpaper = -1,
        disable_hyprland_logo = false,
        middle_click_paste = false,
    },
})

hl.layer_rule({
  name = "noctalia",
  match = {
    namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd|window-switcher)$",
  },
  ignore_alpha = 0.0,
  blur = true,
  blur_popups = true,
  xray = true,
})


---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout = "us",
        repeat_delay = 250,
        follow_mouse = 1,
        sensitivity = 0,

        touchpad = {
            natural_scroll = true,
            scroll_factor = 0.4,
        },
    },
})

-- Gestures
hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})


-----------------
---- MONITOR ----
-----------------

hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = 1.6,
    bitdepth = 10,
})


-------------------
---- ECOSYSTEM ----
-------------------

hl.config({
    ecosystem = {
        no_update_news = true,
        no_donation_nag = true,
    },
})


---------------------
---- KEYBINDINGS ----
---------------------

-- Window management
hl.bind(mod .. " + C", hl.dsp.window.close())
hl.bind(mod .. " + SHIFT + L", hl.dsp.exec_cmd(lockScreen))
hl.bind(mod .. " + M", hl.dsp.exit())

-- Navigation
hl.bind(mod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + J", hl.dsp.focus({ direction = "down" }))
hl.bind(mod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + L", hl.dsp.focus({ direction = "right" }))

-- Workspaces
for i = 1, 10 do
    local key = i % 10  -- 10 maps to key 0
    hl.bind(mod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Apps
hl.bind(mod .. " + SPACE", hl.dsp.exec_cmd(launcher))
hl.bind(mod .. " + Q", hl.dsp.exec_cmd(terminal))
hl.bind(mod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mod .. " + Z", hl.dsp.exec_cmd(browser))

-- Screenshots
hl.bind(mod .. " + CTRL + SHIFT + 2", hl.dsp.exec_cmd(screenshot .. "fullscreen"))
hl.bind(mod .. " + CTRL + SHIFT + 4", hl.dsp.exec_cmd(screenshot .. "region"))

-- Mouse
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind(mod .. " + ALT + mouse:272", hl.dsp.window.resize(), { mouse = true })

-- Media keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -n2 set 5%-"), { locked = true, repeating = true })
hl.bind(mod .. " + XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl --device=tpacpi::kbd_backlight -e4 set 15%+"), { locked = true, repeating = true })
hl.bind(mod .. " + XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl --device=tpacpi::kbd_backlight -e4 set 15%-"), { locked = true, repeating = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })


--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

hl.window_rule({
  match = { class = "nm-connection-editor" },
  float = true,
  size = { 600, 400 },
  move = { "monitor_w - window_w - 20", "40" },
})

hl.window_rule({
    name = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

-- Smart gaps
hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
hl.workspace_rule({ workspace = "f[1]", gaps_out = 0, gaps_in = 0 })
hl.window_rule({
    name = "no-gaps-wtv1",
    match = { float = false, workspace = "w[tv1]" },
    border_size = 0,
    rounding = 0,
})
hl.window_rule({
    name = "no-gaps-f1",
    match = { float = false, workspace = "f[1]" },
    border_size = 0,
    rounding = 0,
})

{
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
    settings = {
      "$mod" = "SUPER";
      "$terminal" = "ghostty";
      "$fileManager" = "dolphin";
      "$browser" = "zen-beta";
      "$lockScreen" = "swaylock";

      exec-once = [
        "waybar"
        "swayidle"
        "[workspace 1 silent] $browser"
        "[workspace 2 silent] $terminal"
      ];

      animations = {
        enabled = false;
      };

      bind = [
       "$mod, C, killactive,"
       "$mod SHIFT, L, exec, $lockScreen"
       "$mod, M, exit,"
       "$mod, H, movefocus, l" 
       "$mod, J, movefocus, d" 
       "$mod, K, movefocus, u" 
       "$mod, L, movefocus, r" 
       "$mod, 1, workspace, 1"
       "$mod, 2, workspace, 2"
       "$mod, 3, workspace, 3"
       "$mod, 4, workspace, 4"
       "$mod, 5, workspace, 5"
       "$mod, 6, workspace, 6"
       "$mod, 7, workspace, 7"
       "$mod, 8, workspace, 8"
       "$mod, 9, workspace, 9"
       "$mod, 0, workspace, 10"
       "$mod SHIFT, 1, movetoworkspace, 1"
       "$mod SHIFT, 2, movetoworkspace, 2"
       "$mod SHIFT, 3, movetoworkspace, 3"
       "$mod SHIFT, 4, movetoworkspace, 4"
       "$mod SHIFT, 5, movetoworkspace, 5"
       "$mod SHIFT, 6, movetoworkspace, 6"
       "$mod SHIFT, 7, movetoworkspace, 7"
       "$mod SHIFT, 8, movetoworkspace, 8"
       "$mod SHIFT, 9, movetoworkspace, 9"
       "$mod SHIFT, 0, movetoworkspace, 10"
       "$mod, Q, exec, $terminal"
       "$mod, E, exec, $fileManager"
       "$mod, Z, exec, $browser"
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
        "$mod ALT, mouse:272, resizewindow"
      ];

      bindel = [
        ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+"
        ",XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"
        "$mod, XF86MonBrightnessUp, exec, brightnessctl --device=kbd_backlight -e4 set 15%+"
        "$mod, XF86MonBrightnessDown, exec, brightnessctl --device=kbd_backlight -e4 set 15%-"
      ];

      bindl = [
        ",XF86AudioNext, exec, playerctl next"
        ",XF86AudioPause, exec, playerctl play-pause"
        ",XF86AudioPlay, exec, playerctl play-pause"
        ",XF86AudioPrev, exec, playerctl previous"
      ];

      input = {
        kb_layout = "us";
        repeat_delay = 250;
        follow_mouse = 1;
        sensitivity = 0;
        touchpad = {
          natural_scroll = true;
          scroll_factor = 0.4;
        };
      };
      gesture = [
        "3, horizontal, workspace"
      ];

      monitor = ",preferred,auto,1.6,bitdepth,10";

      ecosystem = {
        no_update_news = 1;
        no_donation_nag = 1;
      };

      windowrule = [
        "suppressevent maximize, class:.*"
      ];
    };
  };
}

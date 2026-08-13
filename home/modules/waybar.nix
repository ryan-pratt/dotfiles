{
  programs.waybar = {
    enable = true;
    style = ./assets/waybar.css;
    settings = {
      main = {
        layer = "top";
        position = "top";
        height = 28;
        margin-top = 4;
        margin-bottom = 4;
        margin-left = 8;
        margin-right = 8;

        modules-left = [
          "hyprland/workspaces"
        ];

        modules-right = [
          "pulseaudio"
          "network"
          "cpu"
          "memory"
          "battery"
          "clock"
        ];

        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = false;
          format = "{icon}";
          format-icons = {
            default = "";
            focused = "";
            urgent = "";
          };
        };

        pulseaudio = {
          format = "{volume}% {icon}";
          format-bluetooth = "{volume}% {icon}";
          format-muted = "";
          format-icons = {
            default = ["" ""];
          };
          # on-click = "pavucontrol";
        };
        clock = {
          # format-alt = "{:%Y-%m-%d}";
          format = "{:%I:%M %p}";
          format-alt = "{:%a %b %d %R}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
	  calendar = {
            mode = "month";
            mode-mon-col = 3;
            weeks-pos = "left";
            on-scroll = 1;
            on-click-right = "mode";
            format = {
              months =   "<span color='#ffead3'><b>{}</b></span>";
              days =     "<span color='#ecc6d9'><b>{}</b></span>";
              weeks =    "<span color='#99ffdd'><b>W{}</b></span>";
              weekdays = "<span color='#ffcc66'><b>{}</b></span>";
              today =    "<span color='#ff6699'><b><u>{}</u></b></span>";
            };
	  };
        };
        cpu = {
          format = "{usage}% ";
        };
        memory = {
          format = "{}% ";
        };
        battery = {
          states = {
            good = 95;
            warning = 25;
            critical = 15;
          };
          format = "{capacity}% {icon}";
          format-charging = "{capacity}% 󰂄";
          format-plugged = "{capacity}% ";
          format-icons = ["" "" "" "" ""];
        };
        network = {
          format-wifi = "";
          format-ethernet = "";
          format-disconnected = "⚠";
          tooltip-format-wifi = "{essid} ({signalStrength}%)";
          tooltip-format-ethernet = "{ifname}";
          on-click = "ghostty -e nmtui";
        };
      };
    };
  };
}

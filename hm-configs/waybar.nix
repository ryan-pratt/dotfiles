{
  programs.waybar = {
    enable = true;
    settings = {
      main = {
        layer = "top";
        position = "top";
        height = 24;
        margin-top = 4;
        margin-bottom = -4;
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
      };
    };
  };
}

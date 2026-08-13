{
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
    configType = "lua";
  };

  xdg.configFile."hypr/hyprland.lua" = {
    source = ./hyprland.lua;
    force = true;
  };
}

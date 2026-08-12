{
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
    
    # Use Lua configuration format
    configType = "lua";
  };

  # Place the Lua config, forcing overwrite if needed
  xdg.configFile."hypr/hyprland.lua" = {
    source = ./hyprland.lua;
    force = true;
  };
}

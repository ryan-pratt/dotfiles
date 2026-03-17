{ config, pkgs, system, inputs, ... }:

{
  imports = [
    ./hm-configs/hyprland.nix
    ./hm-configs/waybar.nix
  ];

  home.username = "rpratt";
  home.homeDirectory = "/home/rpratt";

  home.packages = with pkgs; [
    pkgs.nerd-fonts.fira-code
    inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".default
  ];

  programs.keepassxc = {
    enable = true;
    autostart = true;
    settings = {
      FdoSecrets.Enabled = true;
      GUI.MinimizeOnStartup = true;
    };
  };

  programs.swaylock.enable = true;
  services.swaync.enable = true;
  services.swayidle = {
    enable = true;
    timeouts = [
      { timeout = 300; command = "${pkgs.swaylock}/bin/swaylock"; }
    ];
    events = [
      { event = "before-sleep"; command = "${pkgs.swaylock}/bin/swaylock"; }
    ];
  };

  fonts.fontconfig.enable = true;

  xdg.autostart.enable = true;

  programs.home-manager.enable = true;

  home.stateVersion = "25.11";
}

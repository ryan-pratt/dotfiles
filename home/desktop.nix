{ config, pkgs, inputs, ... }:

{
  imports = [
    ./base.nix
    ./modules/hyprland.nix
    ./modules/waybar.nix
  ];

  home.packages = with pkgs; [
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
    events = {
      before-sleep = "${pkgs.swaylock}/bin/swaylock";
    };
  };
}

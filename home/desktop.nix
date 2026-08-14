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

  services.gnome-keyring = {
    enable = true;
    components = [ "pkcs11" "secrets" ];
  };

  programs.swaylock.enable = true;
  services.swaync.enable = true;
  services.swayidle = {
    enable = true;
    timeouts = [
      { timeout = 300; command = "${pkgs.swaylock}/bin/swaylock -fF"; }
    ];
    events = {
      before-sleep = "${pkgs.swaylock}/bin/swaylock -fF";
    };
  };
}

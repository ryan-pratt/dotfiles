{ config, pkgs, inputs, ... }:

{
  imports = [
    ./base.nix
    ./modules/hyprland.nix
  ];

  home.packages = with pkgs; [
    inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".default
    inputs.noctalia.packages.${pkgs.system}.default
    libnotify
    obsidian
    wl-clipboard
  ];

  services.gnome-keyring = {
    enable = true;
    components = [ "pkcs11" "secrets" ];
  };

  home.file."wallpapers/.keep".text = "";
}

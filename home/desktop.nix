{ config, pkgs, inputs, ... }:

{
  imports = [
    ./base.nix
    ./modules/hyprland.nix
  ];

  home.packages = with pkgs; [
    inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".default
    obsidian
    telegram-desktop
    thunderbird
  ];

  services.gnome-keyring = {
    enable = true;
    components = [ "pkcs11" "secrets" ];
  };

  home.file."wallpapers/.keep".text = "";
}

{ config, inputs, lib, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true; # obsidian

  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  services.displayManager.enable = true;
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-user-session --asterisks --sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions";
        user = "greeter";
      };
    };
  };

  services.dbus = {
    enable = true;
    implementation = "broker";
  };

  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".default

    bibata-cursors
    brightnessctl
    ghostty
    gnome-keyring
    libnotify
    mpv
    obsidian
    playerctl
    proton-vpn
    seahorse
    swayimg
    telegram-desktop
    wl-clipboard

    kdePackages.dolphin
    kdePackages.qtsvg
    kdePackages.kio
    kdePackages.kio-extras
    kdePackages.kio-fuse
    kdePackages.polkit-kde-agent-1
  ];

  home-manager.users.rpratt = {
    imports = [ ./features/hyprland.nix ];

    home.file."wallpapers/.keep".text = "";
  };
}

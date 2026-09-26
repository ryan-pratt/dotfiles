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

  services.gnome.gcr-ssh-agent.enable = false;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services = {
    greetd.fprintAuth = true; # if true, gnome-keyring must have blank password
    greetd.enableGnomeKeyring = true;
  };

  environment.systemPackages = with pkgs; [
    bibata-cursors
    brightnessctl
    ghostty
    gnome-keyring
    libnotify
    mpv
    playerctl
    proton-vpn
    seahorse
    swayimg
    wl-clipboard

    kdePackages.dolphin
    kdePackages.qtsvg
    kdePackages.kio
    kdePackages.kio-extras
    kdePackages.kio-fuse
    kdePackages.polkit-kde-agent-1
  ];
}

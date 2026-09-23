{ config, inputs, lib, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true; # obsidian

  imports = [
    inputs.noctalia-greeter.nixosModules.default
  ];

  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  services.displayManager.noctalia-greeter = {
    enable = true;
    passwordless-sync-users = [ "rpratt" ];
  };

  services.dbus = {
    enable = true;
    implementation = "broker";
  };

  programs.firefox.enable = true;

  services.gnome.gcr-ssh-agent.enable = false;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services = {
    greetd.fprintAuth = false; # can't do fprint and keyring :/
    greetd.enableGnomeKeyring = true;
  };

  environment.systemPackages = with pkgs; [
    bibata-cursors
    brightnessctl
    ghostty
    gnome-keyring
    libnotify
    playerctl
    proton-vpn
    protonmail-bridge
    seahorse
    wl-clipboard

    kdePackages.dolphin
    kdePackages.qtsvg
    kdePackages.kio
    kdePackages.kio-extras
    kdePackages.kio-fuse
    kdePackages.polkit-kde-agent-1
  ];

  systemd.user.services.protonmail-bridge = {
    description = "Proton Mail Bridge";
    wants = [ "network-online.target" "gnome-keyring-daemon.service" ];
    after = [ "network-online.target" "gnome-keyring-daemon.service" ];
    wantedBy = [ "default.target" ];

    serviceConfig = {
      ExecStart = "${pkgs.protonmail-bridge}/bin/protonmail-bridge --noninteractive";
      Restart = "on-failure";
      RestartSec = "10s";
    };
  };
}

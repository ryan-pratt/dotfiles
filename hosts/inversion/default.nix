{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/base.nix
    ../../modules/desktop.nix
  ];

  networking.hostName = "inversion";

  boot.loader.limine = {
    enable = true;
    secureBoot.enable = true;
  };
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.systemd = {
    enable = true;
    tpm2.enable = true;
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024;
    }
  ];

  networking.networkmanager.enable = true;

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # 1: allow non-root to toggle mic mute LED
  # 2: grant serial access for qFlipper
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="leds", KERNEL=="platform::micmute", RUN+="/bin/sh -c 'chgrp users /sys/class/leds/platform::micmute/brightness && chmod g+w /sys/class/leds/platform::micmute/brightness'"
    SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTR{idVendor}=="0483", ATTR{idProduct}=="5740", GROUP="dialout", MODE="0660"
  '';

  services.fprintd = {
    enable = true;
    tod = {
      enable = true;
      driver = pkgs.libfprint-2-tod1-goodix;
    };
  };

  services.logind.settings.Login.HandlePowerKey = "lock";

  environment.systemPackages = with pkgs; [
    moonlight-qt
    openvpn
    samba
    sbctl
    update-resolv-conf
  ];

  services.openssh.enable = true;

  programs.steam.enable = true;

  # Fix for OpenVPN update-resolve-conf
  environment.etc.openvpn.source = "${pkgs.update-resolv-conf}/libexec/openvpn";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. Don't change this.
  system.stateVersion = "26.05";
}


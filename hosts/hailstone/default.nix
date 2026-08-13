{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/base.nix
    ../../modules/desktop.nix
  ];

  networking.hostName = "hailstone";

  boot.kernelParams = [ "appledrm.show_notch=1" ];
  boot.initrd.network.flushBeforeStage2 = true;

  hardware.asahi = {
    enable = true;
    peripheralFirmwareDirectory = ./firmware;
  };

  # wpa_supplicant didn't work in 26.05
  networking.wireless.iwd = {
    enable = true;
    settings.General.EnableNetworkConfiguration = true;
  };
  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd";
  };

  environment.systemPackages = with pkgs; [
    docker
    lazydocker
    openvpn
    samba
    update-resolv-conf
  ];

  # Fix for touchpad disable while typing
  environment.etc."libinput/local-overrides.quirks".text = ''
    [xremap]
    MatchUdevType=keyboard
    MatchName=xremap
    AttrKeyboardIntegration=internal
  '';

  # Fix for OpenVPN update-resolve-conf
  environment.etc.openvpn.source = "${pkgs.update-resolv-conf}/libexec/openvpn";
}

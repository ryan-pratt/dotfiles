{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/base.nix
    ../../modules/desktop.nix
  ];

  networking.hostName = "hailstone";

  # TODO: integrate with DE
  # - exec-once blueman-applet in hyprland
  # - use blueman-manager GUI to manage connections
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

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
    moonlight-qt
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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. Don't change this.
  system.stateVersion = "25.11";
}

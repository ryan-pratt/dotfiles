{ config, pkgs, system, inputs, ... }:

{
  home.username = "rpratt";
  home.homeDirectory = "/home/rpratt";

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

  xdg.autostart.enable = true;

  programs.home-manager.enable = true;

  home.stateVersion = "25.11";
}

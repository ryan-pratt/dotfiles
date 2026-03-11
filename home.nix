{ config, pkgs, system, inputs, ... }:

{
  home.username = "rpratt";
  home.homeDirectory = "/home/rpratt";

  home.packages = with pkgs; [
    inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".default
  ];

  programs.home-manager.enable = true;

  home.stateVersion = "25.11";
}

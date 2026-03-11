{ config, pkgs, ... }:

{
  home.username = "rpratt";
  home.homeDirectory = "/home/rpratt";

  programs.home-manager.enable = true;

  home.stateVersion = "25.11";
}

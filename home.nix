{ config, pkgs, system, inputs, ... }:

{
  imports = [
    ./hm-configs/hyprland.nix
    ./hm-configs/waybar.nix
  ];

  home.username = "rpratt";
  home.homeDirectory = "/home/rpratt";

  home.file = let
    dotfilesContent = builtins.attrNames (builtins.readDir ./dotfiles);

    mapDotfiles = filename: {
      name = filename;
      value = {
        source = ./dotfiles/${filename};
        recursive = true;
      };
    };
  in
    builtins.listToAttrs (map (mapDotfiles) dotfilesContent);

  home.packages = with pkgs; [
    pkgs.nerd-fonts.fira-code
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

  programs.swaylock.enable = true;
  services.swaync.enable = true;
  services.swayidle = {
    enable = true;
    timeouts = [
      { timeout = 300; command = "${pkgs.swaylock}/bin/swaylock"; }
    ];
    events = {
      before-sleep = "${pkgs.swaylock}/bin/swaylock";
    };
  };

  fonts.fontconfig.enable = true;

  xdg.autostart.enable = true;

  programs.home-manager.enable = true;

  home.stateVersion = "25.11";
}

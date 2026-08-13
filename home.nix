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
    builtins.listToAttrs (map (mapDotfiles) dotfilesContent) // {
      ".config/git/allowed-signers".text = ''
        ryan.pratt@live.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILT0TbEeh/NUprEai8/7BsxS64ayqlqPDRvdCuA+lz2l
      '';
    };

  home.packages = with pkgs; [
    pkgs.nerd-fonts.fira-code
    inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".default
  ];

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.git = {
    enable = true;
    lfs.enable = true;

    signing = {
      key = "~/.ssh/id_ed25519.pub";
      signByDefault = true;
    };

    settings = {
      user.name = "Ryan Pratt";
      user.email = "ryan.pratt@live.com";
      gpg.format = "ssh";
      "gpg \"ssh\"".allowedSignersFile = "~/.config/git/allowed-signers";
      tag.gpgsign = true;
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
      features = "decorations";
      side-by-side = true;
      line-numbers = true;
    };
  };

  programs.keepassxc = {
    enable = true;
    autostart = true;
    settings = {
      FdoSecrets.Enabled = true;
      GUI.MinimizeOnStartup = true;
    };
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
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

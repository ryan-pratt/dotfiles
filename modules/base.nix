{ config, lib, pkgs, inputs, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = lib.mkDefault false;

  time.timeZone = "America/Denver";

  i18n.defaultLocale = "en_US.UTF-8";

  users.users.rpratt = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" ];
  };

  programs.zsh.enable = true;

  programs.ssh = {
    startAgent = true;
    extraConfig = ''
      Host github.com
        Hostname ssh.github.com
        Port 443
        User git
    '';
  };

  environment.systemPackages =
    (with pkgs; [
      bat
      delta
      dig
      eza
      fzf
      gcc
      git
      git-lfs
      htop
      lazygit
      neovim
      nodejs_22
      ripgrep
      starship
      tree-sitter
      unp
      vim
      wget
    ])
    ++
    (with inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}; [
      pi
    ]);

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  nix.optimise = {
    automatic = true;
    dates = [ "weekly" ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. Don't change this.
  system.stateVersion = "25.11";
}

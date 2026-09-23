{ config, lib, pkgs, inputs, ... }:

{
  time.timeZone = "America/Denver";

  i18n.defaultLocale = "en_US.UTF-8";

  networking = {
    firewall.checkReversePath = false;
    networkmanager.plugins = with pkgs; [
      networkmanager-openvpn
    ];
  };

  users.users.rpratt = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "input" "networkmanager" "uinput" "wheel" ];
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

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    publish.userServices = true;
  };

  services.printing = {
    enable = true;
    drivers = with pkgs; [
      cups-filters
      cups-browsed
    ];
  };

  services.upower.enable = true;

  services.power-profiles-daemon.enable = true;

  environment.systemPackages =
    (with pkgs; [
      bat
      delta
      dig
      eza
      fzf
      gcc
      gh
      git
      git-lfs
      htop
      lazygit
      neovim
      nodejs_22
      openssl
      parted
      proton-vpn-cli
      ripgrep
      starship
      tmux
      tree-sitter
      unp
      vim
      wget
      yubikey-manager
    ])
    ++
    (with inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}; [
      pi
    ]);

  programs.localsend = {
    enable = true;
    openFirewall = true;
  };

  # fix neovim lsp in dev shell
  programs.nix-ld.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

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
}

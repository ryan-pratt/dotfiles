{ config, lib, pkgs, ... }:

{
  time.timeZone = "America/Denver";

  i18n.defaultLocale = "en_US.UTF-8";

  users.users.marten = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "docker"
      "wheel"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIhU+bHZeTW/DgyjgwCIrukQ/PcwtCnLmwG2KgCGwqF6 ryan.pratt@live.com"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEFpcJXb4u6QJ9+cT3C3FQ3AwHSX+T/Xt8c5RKG20H2n ipad@termix"
    ];
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  networking = {
    useNetworkd = true;
    useDHCP = false;
    nftables.enable = true;
    firewall = {
      backend = "nftables";
      checkReversePath = false;
      trustedInterfaces = [ "tailscale0" ];
      extraInputRules = ''
        ip saddr 10.1.2.0/24 accept
        ip6 saddr fc00::/7 accept
      '';
    };
  };

  systemd.network = {
    enable = true;
    networks."10-eno1" = {
      matchConfig.Name = "eno1";
      address = [ "10.1.2.10/24" ];
      routes = [ { Gateway = "10.1.2.1"; } ];
      dns = [ "10.1.2.1" ];
      networkConfig.IPv6AcceptRA = true;
    };
  };

  services.resolved.enable = true;

  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;

  services.zfs = {
    autoScrub = {
      enable = true;
      pools = [ "tornado" ];
    };
  };

  services.smartd.enable = true;

  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";
  };

  services.tailscale = {
    enable = true;
    openFirewall = true;
  };

  services.samba = {
    enable = true;
    settings = {
      global = {
        workgroup = "WORKGROUP";
        security = "user";
        "load printers" = "no";
        "disable spoolss" = "yes";
      };
      nas = {
        path = "/tornado/nas";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0664";
        "directory mask" = "0775";
      };
    };
  };

  services.samba-wsdd.enable = true;

  systemd.services.samba-smbd = {
    after = [ "zfs-mount.service" ];
    wants = [ "zfs-mount.service" ];
  };

  programs.zsh.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.nix-ld.enable = true;

  environment.systemPackages = with pkgs; [
    bat
    btrfs-progs
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
    opencode
    openssl
    parted
    ripgrep
    smartmontools
    starship
    tmux
    tree-sitter
    unp
    vim
    wget
    zfs
  ];

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "root" "@wheel" ];
  };

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

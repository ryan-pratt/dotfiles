# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, inputs, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;
  boot.kernelParams = [ "appledrm.show_notch=1" ];

  # Initrd stage 1 holds a lock on the network card in 26.05
  boot.initrd.network.flushBeforeStage2 = true;

  hardware.asahi = {
    enable = true;
    peripheralFirmwareDirectory = ./firmware;
  };

  networking.hostName = "nixos-macbook";

  networking.wireless.iwd = {
    enable = true;
    settings.General.EnableNetworkConfiguration = true;
  };
  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd";
  };

  time.timeZone = "America/Denver";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;


  

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      cups-filters
      cups-browsed
    ];
  };

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    rpratt = {
      isNormalUser = true;
      shell = pkgs.zsh;
      extraGroups = [ "wheel" ]; # 'wheel' enables ‘sudo’ for the user.
    };
  };

  programs.firefox.enable = true;
  # programs.thunar.enable = true;
  programs.zsh.enable = true;
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    # xwayland.enable = true;
  };

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages =
    (with pkgs; [
      bat
      brightnessctl
      delta
      dig
      docker
      eza
      fzf
      ghostty
      git
      git-lfs
      htop
      keepassxc
      lazydocker
      lazygit
      neovim
      nodejs_22
      openvpn
      playerctl
      ripgrep
      samba
      starship
      update-resolv-conf
      vim
      wget

      kdePackages.dolphin
      kdePackages.qtsvg
      kdePackages.kio
      kdePackages.kio-extras
      kdePackages.kio-fuse
    ])
    ++
    (with inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}; [
      pi
    ]);

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Fix for touchpad disable while typing
  environment.etc."libinput/local-overrides.quirks".text = ''
    [xremap]
    MatchUdevType=keyboard
    MatchName=xremap
    AttrKeyboardIntegration=internal
  '';

  # Fix for OpenVPN update-resolve-conf
  environment.etc.openvpn.source = "${pkgs.update-resolv-conf}/libexec/openvpn";

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  services.dbus = {
    enable = true;
    implementation = "broker";
  };

  programs.ssh = {
    startAgent = true;
    extraConfig = ''
      Host github.com
        Hostname ssh.github.com
        Port 443
        User git
    '';
  };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}


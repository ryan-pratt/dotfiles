{ config, inputs, lib, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true; # obsidian

  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  services.displayManager.enable = true;
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-user-session --asterisks --sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions";
        user = "greeter";
      };
    };
  };

  services.dbus = {
    enable = true;
    implementation = "broker";
  };

  programs.firefox.enable = true;

  services.gnome.gcr-ssh-agent.enable = false;
  services.gnome.gnome-keyring.enable = true;

  security.pam.services = {
    greetd = {
      enableGnomeKeyring = true; # make PAM tell gnome-keyring to start
      fprintAuth = true; # if used, gnome-keyring must have blank password
      u2f = { # yubikey
        enable = true;
        control = "required";
      };
      rules.auth = { # config for `(fingerprint || password) && yubikey`
        fprintd.control = lib.mkForce "[success=1 default=ignore]"; # skip password on successful fingerprint
        unix.control = lib.mkForce "[success=ok default=bad]"; # continue as normal if password used
        u2f.order = lib.mkForce 12910; # make yubikey come after fprint/pw (see `/etc/pam.d/greetd`)
        deny.enable = false; # remove deny from end of stack since no single module is `sufficient`
        unix-early.enable = lib.mkForce false; # remove this from auth stack so it doesn't interfere
        gnome_keyring.enable = lib.mkForce false; # remove this from auth stack so it doesn't interfere
      };
    };
  };

  environment.systemPackages = with pkgs; [
    inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".default

    bibata-cursors
    brightnessctl
    ghostty
    gnome-keyring
    libnotify
    mpv
    obsidian
    playerctl
    proton-vpn
    seahorse
    swayimg
    telegram-desktop
    wl-clipboard

    kdePackages.dolphin
    kdePackages.qtsvg
    kdePackages.kio
    kdePackages.kio-extras
    kdePackages.kio-fuse
    kdePackages.polkit-kde-agent-1
  ];

  home-manager.users.rpratt = {
    imports = [ ./features/hyprland.nix ];

    services.gnome-keyring = {
      enable = true;
      components = [ "pkcs11" "secrets" ];
    };

    home.file."wallpapers/.keep".text = "";
  };
}

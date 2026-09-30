{ lib, ... }:

let
  # config for `(fingerprint || password) && yubikey`
  pamAuth = {
    u2f = {
      enable = true;
      control = "required";
    };

    rules.auth = {
      # skip password on successful fingerprint (if reader available) - gnome-keyring must have blank password
      fprintd.control = lib.mkForce "[success=1 default=ignore]";
      # continue as normal if password used
      unix.control = lib.mkForce "[success=ok default=bad]";
      # make yubikey come after fprint/pw (see `/etc/pam.d/login`)
      u2f.order = lib.mkForce 12910;
      # remove deny from end of stack since no single module is `sufficient`
      deny.enable = false;
      # remove these from auth stack so they doesn't interfere
      unix-early.enable = lib.mkForce false;
      gnome_keyring.enable = lib.mkForce false;
    };
  };
in
{
  services.gnome.gcr-ssh-agent.enable = false;
  services.gnome.gnome-keyring.enable = true;

  security.pam.services = lib.genAttrs [ "login" "greetd" ] (_: pamAuth // {
    enableGnomeKeyring = true; # make PAM tell gnome-keyring to start
  });

  home-manager.users.rpratt.services.gnome-keyring = {
    enable = true;
    components = [ "pkcs11" "secrets" ];
  };
}

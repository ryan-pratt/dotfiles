{ config, pkgs, inputs, ... }:

let
  swaylock-wallpaper = pkgs.writeShellScriptBin "swaylock-wallpaper" ''
    wallpapers=$(${pkgs.awww}/bin/awww query 2>/dev/null)
    images=$(echo "$wallpapers" | grep -oP 'image: \K.*')
    if [[ -z "$images" ]]; then
      ${pkgs.swaylock-effects}/bin/swaylock -fF
    else
      args=()
      while IFS= read -r image; do
        args+=("--image" "$image")
      done <<< "$images"
      ${pkgs.swaylock-effects}/bin/swaylock -f "''${args[@]}"
    fi
  '';

  wallpaper-rotate = pkgs.writeShellScriptBin "wallpaper-rotate" ''
    WALLPAPER_DIR="$HOME/wallpapers"
    if [[ ! -d "$WALLPAPER_DIR" ]]; then
      echo "Directory $WALLPAPER_DIR does not exist"
      exit 1
    fi

    images=($(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) 2>/dev/null))
    if [[ ''${#images[@]} -eq 0 ]]; then
      echo "No images in $WALLPAPER_DIR"
      exit 1
    fi

    random_image="''${images[RANDOM % ''${#images[@]}]}"
    ${pkgs.awww}/bin/awww img "$random_image" --transition-type fade --transition-duration 2
  '';
in

{
  imports = [
    ./base.nix
    ./modules/hyprland.nix
    ./modules/waybar.nix
  ];

  home.packages = with pkgs; [
    inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".default
    awww
    networkmanagerapplet
    swaylock-wallpaper
    wallpaper-rotate
  ];

  services.gnome-keyring = {
    enable = true;
    components = [ "pkcs11" "secrets" ];
  };

  services.network-manager-applet.enable = true;

  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      show-failed-attempts = true;
      scaling = "fill";
      effect-blur = "7x5";
      clock = true;
      timestr = "%I:%M %p";
      datestr = "%A, %B %e";
      color = "000000cc";
      indicator = true;
      indicator-radius = 100;
      indicator-thickness = 10;
      ring-color = "ffffff22";
      ring-clear-color = "88c0d0aa";
      ring-ver-color = "81a1c1aa";
      ring-wrong-color = "bf616aaa";
      key-hl-color = "a3be8caa";
      bs-hl-color = "bf616aaa";
      text-color = "ffffffee";
      text-clear-color = "ffffffee";
      text-ver-color = "ffffffee";
      text-wrong-color = "ffffffee";
      inside-color = "00000088";
      inside-clear-color = "88c0d033";
      inside-ver-color = "81a1c133";
      inside-wrong-color = "bf616a33";
      separator-color = "00000000";
      line-color = "00000000";
      line-clear-color = "00000000";
      line-ver-color = "00000000";
      line-wrong-color = "00000000";
      layout-text-color = "ffffffaa";
    };
  };

  services.swaync.enable = true;

  services.swayidle = {
    enable = true;
    timeouts = [
      { timeout = 300; command = "${swaylock-wallpaper}/bin/swaylock-wallpaper"; }
    ];
    events = {
      before-sleep = "${swaylock-wallpaper}/bin/swaylock-wallpaper";
    };
  };

  home.file."wallpapers/.keep".text = "";
}

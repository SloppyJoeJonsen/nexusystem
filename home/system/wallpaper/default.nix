{ lib, config, pkgs, ... }:

let
  helpers = import ../../../helpers { inherit lib; };
  backgroundImage = config.theme.backgroundImage;
  isStatic = helpers.isStaticImage backgroundImage;
  isAnimated = !isStatic && !helpers.isEmpty backgroundImage;
in {
  # Use hyprpaper for static images
  services.hyprpaper = lib.mkIf isStatic {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;
      splash_offset = 2.0;
    };
  };

  # Set the hyprpaper unit order after the graphical session starts
  systemd.user.services.hyprpaper.Unit.After =
    lib.mkIf isStatic (lib.mkForce "graphical-session.target");

  # Use mpvpaper for animated backgrounds
  home.packages = with pkgs; lib.mkIf isAnimated [ mpvpaper ];

  # wayland.windowManager.hyprland.settings.exec-once = lib.mkIf isAnimated [''
  #   mpvpaper -o "no-audio --loop --panscan=1.0" ALL ${
  #     toString backgroundImage
  #   } & echo $! > /tmp/mpvpaper.pid
  # ''];

  # Image rotation in case somebody wants it
 wayland.windowManager.hyprland.settings.exec-once = lib.mkIf isAnimated [
  (pkgs.writeShellScript "rotate-wallpaper" ''
    # Define wallpapers for each monitor
    monitor1_wallpapers=(
      "${./dandadan.mp4}"
      "${./berserk.mp4}"
      "${./pink-lofi.mp4}"
      "${./minecraft.mp4}"
      "${./bakugo.mp4}"
    )
    
    monitor2_wallpapers=(
      "${./berserk-eclipse.mp4}"
      "${./galaxy-cat.mp4}"
      "${./touch-grass.mp4}"
    )
    
    monitor3_wallpapers=(
      "${./minecraft.mp4}"
      "${./initial-d.mp4}"
      "${./bakugo.mp4}"
      "${./dandadan.mp4}"
    )
    
    # Function to rotate wallpapers on a specific monitor
    rotate_monitor() {
      local monitor=$1
      shift
      local wallpapers=("$@")
      local index=0
      
      while true; do
        mpvpaper -o "no-audio --loop --panscan=1.0" "$monitor" "''${wallpapers[$index]}" &
        sleep 300
        pkill -f "mpvpaper.*$monitor"
        index=$(( (index + 1) % ''${#wallpapers[@]} ))
      done
    }
    
    # Start rotation for each monitor in background
    rotate_monitor "DP-1" "''${monitor1_wallpapers[@]}" &
    rotate_monitor "DP-2" "''${monitor2_wallpapers[@]}" &
    rotate_monitor "DP-3" "''${monitor3_wallpapers[@]}" &
    
    wait
  '')
];

  # Disable hyprpaper when using animated backgrounds
  stylix.targets.hyprland.hyprpaper.enable = lib.mkIf isAnimated false;

  home.file.".config/wallpaper/${builtins.baseNameOf backgroundImage}".source =
    backgroundImage;
}

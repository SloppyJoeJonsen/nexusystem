{ pkgs, ... }: {
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      obs-backgroundremoval
      obs-pipewire-audio-capture
      obs-composite-blur
      obs-vkcapture
    ];
  };
  
  wayland.windowManager.hyprland.settings = {
    exec-once = [
      "sleep 5 && rm -rf ~/.config/obs-studio/.sentinel && env QT_QPA_PLATFORM=xcb obs --startreplaybuffer --minimize-to-tray"
    ];
    
    bind = [
      "ALT, F10, exec, ${pkgs.obs-cmd}/bin/obs-cmd -w obsws://localhost:4455 replay save"
    ];
  };
  
  home.packages = [ pkgs.obs-cmd ];
}
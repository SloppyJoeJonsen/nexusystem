{ pkgs, ... }: {
  home.packages = [
    pkgs.gpu-screen-recorder
    pkgs.psmisc
    
    (pkgs.writeShellScriptBin "save-replay" ''
      ${pkgs.psmisc}/bin/killall -SIGUSR1 gpu-screen-recorder
    '')
  ];

  wayland.windowManager.hyprland.settings = {
    exec-once = [
      ''
            sleep 10 && gpu-screen-recorder \
          -w DP-2 \
          -f 60 \
          -a "default_output" \
          -a "default_input" \
          -r 60 \
          -c mp4 \
          -o "/storage/games/Vids" &
      ''
    ];

    bind = [
      "ALT, F10, exec, save-replay"
    ];
  };
}
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
        gpu-screen-recorder \
          -w DP-2 \
          -f 60 \
          -a "default_output" \
          -a "alsa_input.usb-Trust_USB_microphone_Trust_USB_microphone-00.analog-stereo" \
          -r 60 \
          -c mp4 \
          -o "/storage/games/Vids"
      ''
    ];

    bind = [
      "ALT, F10, exec, save-replay"
    ];
  };
}
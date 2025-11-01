{
  security.rtkit.enable = true;
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    
    # Fix audio crackling during gaming/high load
    extraConfig.pipewire = {
      "10-clock-rate" = {
        "context.properties" = {
          "default.clock.rate" = 48000;
          "default.clock.quantum" = 1024;
          "default.clock.min-quantum" = 1024;
          "default.clock.max-quantum" = 2048;
        };
      };
      # Disable automatic gain control
      "10-disable-agc" = {
        "context.modules" = [
          {
            name = "libpipewire-module-echo-cancel";
            args = {
              "aec.args" = {
                "webrtc.gain_control" = false;
              };
            };
          }
        ];
      };
    };
    
    wireplumber = {
      enable = true;
      extraConfig = {
        "10-disable-camera" = {
          "wireplumber.profiles" = { 
            main."monitor.libcamera" = "disabled"; 
          };
        };
      };
    };
  };
  
  # Disable PCIe power management - common cause of audio crackling
  boot.kernelParams = [ "pcie_aspm=off" ];
  
  # Optional: Set CPU to performance mode (uncomment if crackling persists)
  powerManagement.cpuFreqGovernor = "performance";
}
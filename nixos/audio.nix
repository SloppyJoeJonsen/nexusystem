{ config, pkgs, ... }:

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
    };
    
    # Block applications from adjusting microphone volume
        extraConfig.pipewire-pulse."92-block-mic-volume" = {
          "pulse.rules" = [
        {
              matches = [
                      { "application.process.binary" = "chromium"; }
                      { "application.process.binary" = "chrome"; }
                      { "application.name" = "~Chromium.*"; }
                     ];
           actions = { quirks = [ "block-source-volume" ]; };
       }
    {
      matches = [
        { "application.process.binary" = "vesktop"; }  # Changed from "Discord"
      ];
      actions = { quirks = [ "block-source-volume" ]; };
    }
        {
         matches = [
            { "application.process.binary" = "teams"; }
            { "application.process.binary" = "teams-insiders"; }
            { "application.process.binary" = "zoom"; }
                    ];
              actions = { quirks = [ "block-source-volume" ]; };
       }
    {
      matches = [ { "application.process.binary" = "firefox"; } ];
      actions = { quirks = [ "remove-capture-dont-move" ]; };
    }
  ];
};
    
    wireplumber = {
      enable = true;
      extraConfig = {
        "10-disable-camera" = {
          "wireplumber.profiles" = { main."monitor.libcamera" = "disabled"; };
        };
      };
    };
  };
  
  # Disable PCIe power management - common cause of audio crackling
  boot.kernelParams = [ "pcie_aspm=off" ];
  
  # Optional: Set CPU to performance mode (uncomment if crackling persists)
  powerManagement.cpuFreqGovernor = "performance";
}
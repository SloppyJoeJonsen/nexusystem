{ config, pkgs, ... }: {
  imports =
    [ ./variables.nix 
    ../../nixos/shared.nix 
    ./hardware-configuration.nix ];

  home-manager.users."${config.var.username}" = import ./home.nix;

  # Mount the 2TB NVMe drive
  fileSystems."/mnt/games" = {
    device = "/dev/disk/by-uuid/3f91c9cf-fa1d-4e04-a801-3cec77623768";
    fsType = "ext4";
  };

  # CoreCtrl for AMD GPU overclocking
  programs.corectrl = {
    enable = true;
    gpuOverclock = {
      enable = true;
      ppfeaturemask = "0xffffffff";  # Unlock all features for RDNA3
    };
  };

  # Add user to corectrl group
  users.users."${config.var.username}".extraGroups = [ "corectrl" ];

  # Enable the D-Bus helper service for CoreCtrl
  services.dbus.packages = [ pkgs.corectrl ];

  # Enable ALSA state restoration
  hardware.alsa.enablePersistence = true;

  # ALSA restore that waits for PipeWire to be ready
  systemd.services.alsa-restore-after-pipewire = {
    description = "Restore Sound Card State After PipeWire";
    wantedBy = [ "multi-user.target" ];
    after = [ "sound.target" "alsa-store.service" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "restore-alsa-smart" ''
        # Wait for PipeWire user service to be active (max 60 seconds)
        for i in {1..60}; do
          if systemctl --user -M ${config.var.username}@ is-active pipewire.service >/dev/null 2>&1; then
            echo "PipeWire is active, waiting 3 more seconds for full initialization..."
            sleep 3
            ${pkgs.alsa-utils}/bin/alsactl restore
            echo "ALSA state restored!"
            exit 0
          fi
          echo "Waiting for PipeWire... ($i/60)"
          sleep 1
        done
        echo "Timeout waiting for PipeWire, restoring anyway..."
        ${pkgs.alsa-utils}/bin/alsactl restore
      '';
      RemainAfterExit = true;
    };
  };

  services.udev.extraRules = ''
    # OBS virtual camera
    KERNEL=="video[0-9]*", GROUP="video", MODE="0666"
    # Logitech devices for Solaar
    SUBSYSTEM=="usb", ATTRS{idVendor}=="046d", MODE="0666"
    SUBSYSTEM=="hidraw", ATTRS{idVendor}=="046d", MODE="0666"
    # Aquacomputer devices
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0c70", MODE="0666"
    KERNEL=="hidraw*", ATTRS{idVendor}=="0c70", MODE="0666"
    # Sound Blaster Creative always as card 0
    SUBSYSTEM=="sound", KERNEL=="card*", ATTRS{vendor}=="0x1102", ATTR{number}="0"
    # AMD Navi HDMI as card 1
    SUBSYSTEM=="sound", KERNEL=="card*", DEVPATH=="*/0000:03:00.1/*", ATTR{number}="1"
    # AMD Rembrandt HDMI as card 2
    SUBSYSTEM=="sound", KERNEL=="card*", DEVPATH=="*/0000:13:00.1/*", ATTR{number}="2"
    # AMD HD Audio as card 3
    SUBSYSTEM=="sound", KERNEL=="card*", DEVPATH=="*/0000:13:00.6/*", ATTR{number}="3"
  '';

  # Don't touch this
  system.stateVersion = "24.05";
}
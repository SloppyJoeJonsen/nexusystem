{ config, lib, ... }: {
  # imports = [ ../../themes/initial-d.nix ];
  imports = [ ../../themes/initial-d.nix ];

  options.var = lib.mkOption {
    type = lib.types.attrs;
    default = {
      hostname = "sloppy";
      username = "sloppyjoe";
      configDirectory = "/home/" + config.var.username
        + "/nexusystem"; # The path of the nixos configuration directory

      browsers = [ "zen" ];

      editors = [ "nvim" "vscode" ];

      musicApps = [ "youtube-music" ];

      keyboardLayout = "de";
      extraKeyboardLayouts = ",us";

      location = "Berlin";
      timeZone = "Europe/Berlin";
      defaultLocale = "en_US.UTF-8";
      extraLocale = "de_DE.UTF-8";

      gpu = {
        type = "amd";
        dedicated = true;
      };

      git = {
        username = "SloppyJoeJonsen";
        email = "ati_64@hotmail.de";
        signingKey = null;
      };

      autoUpgrade = false;
      autoGarbageCollector = true;
      isLaptop = false;
      withGames = true;

      monitorConfig = [
        "desc:LG Electronics LG ULTRAGEAR 307MAHUA7U25,2560x1440@164.96,4480x0,1.0"
        "desc:Dell Inc. AW2725DF FXY4ZZ3,2560x1440@359.98,1920x0,1.0"
        "desc:Acer Technologies KG272 S 0x1371FF23,1920x1080@59.94,0x0,1.0"
      ];
    };
  };
}

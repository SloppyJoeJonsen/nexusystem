{ pkgs, ... }: {
  # Modify this to your hearts content.
  # This is where you should define what programs to install etc.
  # You can find programs here:
  # https://search.nixos.org/packages
  # home-manager-options.extranix.com/?query=&release=master

  imports = [
    #./programs/photogimp # Gimp with photoshop like UI
    ./programs/btop
    ./system/php # Laravel <3
    ./programs/gpu-screen
  ];

  home.packages = with pkgs; [
    vlc
    obsidian # Note taking app
    gnome-calendar # Calendar
    gnome-clocks
    calibre # ebooks
    onlyoffice-desktopeditors # Office stuff
    #kdePackages.kdenlive # Video editor
    #kdePackages.breeze # Dark mode and theming with stylix for kdenlive
    solaar # Logitech device manager
    pavucontrol #sound
    openlinkhub #ka
    liquidctl #Watercooling
    corectrl #actually keine ahnung mehr was das ist
    prismlauncher #Minecraft
    ryubing #Switch emulator
    r2modman
    vesktop
    flatpak
    bazaar
    xclicker
    winetricks
    wineWow64Packages.stable
    unrar
  ];
}

{ pkgs, ... }: {
  # Modify this to your hearts content.
  # This is where you should define what programs to install etc.
  # You can find programs here:
  # https://search.nixos.org/packages
  # home-manager-options.extranix.com/?query=&release=master

  imports = [
    ./programs/discord
    ./programs/lazygit
    ./programs/photogimp # Gimp with photoshop like UI
    ./programs/btop
    ./system/php # Laravel <3
    ./programs/gpu-screen
  ];

  home.packages = with pkgs; [
    vlc
    blanket # White-noise app
    obsidian # Note taking app
    gnome-calendar # Calendar
    gnome-clocks
    dbgate # DBMS
    croc # for sending files across devices
    # Dev
    nodejs
    python3
    pnpm
    calibre # ebooks
    onlyoffice-bin # Office stuff
    kdePackages.kdenlive # Video editor
    kdePackages.breeze # Dark mode and theming with stylix for kdenlive
    solaar # Logitech device manager
    aider-chat # AI
    godot_4 # Gamedev
    lazydocker
    bruno # rest client
    bruno-cli # cli for bruno, needed for bruno.nvim
    crush
    wineWowPackages.stable
    winetricks
    pavucontrol #sound
    openlinkhub #ka
    liquidctl #Watercooling
    corectrl #actually keine ahnung mehr was das ist
    prismlauncher #Minecraft
    vdhcoapp #Auch keine ahnung
    ryubing #Switch emulator
    protontricks
    nexusmods-app-unfree
    # ranger # terminal file explorer
    # screenkey # shows keypresses on screen
    # textpieces # Manipulate texts
    # curtail # Compress images
    # Just cool visuals
    # peaclock
    # cbonsai
    # pipesnex
    # cmatrix
    # nyancat
  ];
}

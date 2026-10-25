{
  config,
  pkgs,
  pkgs-stable,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "jeff-os"; # Define your hostname.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Copenhagen";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_DK.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "da_DK.UTF-8";
    LC_IDENTIFICATION = "da_DK.UTF-8";
    LC_MEASUREMENT = "da_DK.UTF-8";
    LC_MONETARY = "da_DK.UTF-8";
    LC_NAME = "da_DK.UTF-8";
    LC_NUMERIC = "da_DK.UTF-8";
    LC_PAPER = "da_DK.UTF-8";
    LC_TELEPHONE = "da_DK.UTF-8";
    LC_TIME = "da_DK.UTF-8";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # SDDM
  services.displayManager.sddm = {
    enable = true;
    theme = "where_is_my_sddm_theme";
  };

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.defaultSession = "plasma";
  services.desktopManager.plasma6.enable = true;

  # Enable Niri
  programs.niri.enable = true;
  programs.xwayland.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "dk";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "dk-latin1";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    # jack.enable = true;
  };

  # Kernel: use the default
  boot.kernelPackages = pkgs.linuxPackages;

  # Nvidia
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # Needed for hearthstone
  };
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    open = true; # needs Turing (GTX 16xx / RTX 20xx) or newer
    modesetting.enable = true; # needed for Wayland on Plasma 6
    nvidiaSettings = true; # optional: installs the nvidia-settings GUI
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  programs.gamemode.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."jeff" = {
    isNormalUser = true;
    description = "jeff";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [
      discord
      spotify
      localsend
      pkgs-stable.lutris # for hearthstone
      zathura
      vlc
    ];
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];
  fonts.fontconfig.defaultFonts.monospace = [
    "JetBrainsMono Nerd Font"
  ];

  # Install firefox.
  programs.firefox.enable = true;

  # Install steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  # Open localsend firewall
  networking.firewall = {
    allowedTCPPorts = [ 53317 ];
    allowedUDPPorts = [ 53317 ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  environment.systemPackages = with pkgs; [
    git
    vim
    neovim
    ripgrep
    wget
    wl-clipboard
    foot
    xwayland-satellite
    waybar
    fuzzel
    swaybg
    swaylock
    playerctl
    tree-sitter
    gcc
    cargo
    btop
    unzip
    thunar
    (where-is-my-sddm-theme.override {
      themeConfig.General = {
        showSessionsByDefault = true;
        showUserRealNameByDefault = true;
      };
    })
  ];

  environment.sessionVariables = {
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?

}

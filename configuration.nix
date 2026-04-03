{ config, pkgs, ... }:

{
  imports = [ 
    ./hardware-configuration.nix
  ];

  # ============================================================================
  # СИСТЕМА И ЗАГРУЗКА
  # ============================================================================

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.kernelModules = [ "tun" ];

  # ============================================================================
  # ГРАФИКА И ДРАЙВЕРЫ NVIDIA
  # ============================================================================

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = true; # RTX 3060 отлично работает с открытым модулем ядра NVIDIA
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  system.stateVersion = "25.11"; 

  documentation.nixos.enable = false;

  nixpkgs.config.allowUnfree = true;

  # ============================================================================
  # ЛОКАЛИЗАЦИЯ И ВРЕМЯ
  # ============================================================================

  time.timeZone = "Europe/Moscow";
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ru_RU.UTF-8";
    LC_IDENTIFICATION = "ru_RU.UTF-8";
    LC_MEASUREMENT = "ru_RU.UTF-8";
    LC_MONETARY = "ru_RU.UTF-8";
    LC_NAME = "ru_RU.UTF-8";
    LC_NUMERIC = "ru_RU.UTF-8";
    LC_PAPER = "ru_RU.UTF-8";
    LC_TELEPHONE = "ru_RU.UTF-8";
    LC_TIME = "ru_RU.UTF-8";
  };

  # ============================================================================
  # СЕТЬ
  # ============================================================================

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  programs.amnezia-vpn.enable = true;

  # ============================================================================
  # ГРАФИЧЕСКАЯ ОБОЛОЧКА (GNOME)
  # ============================================================================

  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
    
  services.xserver.xkb = {
    layout = "us,ru";
    variant = ",";
    options = "grp:alt_shift_toggle";
  };

  services.gnome.core-apps.enable = false;
  
  environment.gnome.excludePackages = with pkgs; [
    gnome-photos
    gnome-tour
    gedit
    gnome-music
    epiphany
    geary
    evince
  ];

  services.xserver.excludePackages = [ pkgs.xterm ];

  # Настройка основного монитора для GDM
  systemd.tmpfiles.rules = [
    "L+ /var/lib/gdm/.config/monitors.xml - - - - /home/menlize/.config/monitors.xml"
  ];

  # ============================================================================
  # ШРИФТЫ
  # ============================================================================

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  # ============================================================================
  # СЕРВИСЫ (Звук, Печать, Flatpak, GameMode)
  # ============================================================================

  boot.kernel.sysctl = {
    "vm.max_map_count" = 2147483642; # Ускоряет запуск и стабильность тяжелых игр
    "fs.inotify.max_user_watches" = 524288;
  };

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.printing.enable = false;
  services.flatpak.enable = true;
  zramSwap.enable = true;

  programs.gamemode.enable = true;
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    remotePlay.openFirewall = true; # Для Steam Link
    dedicatedServer.openFirewall = true;
  };
  programs.gamescope.enable = true;

  # ============================================================================
  # ПОЛЬЗОВАТЕЛИ
  # ============================================================================

  users.users.menlize = {
    isNormalUser = true;
    description = "menlize";
    extraGroups = [ "networkmanager" "wheel" "gamemode" ];
    shell = pkgs.fish;
  };

  programs.fish.enable = true;

  # ============================================================================
  # СИСТЕМНЫЕ ПАКЕТЫ
  # ============================================================================

  environment.systemPackages = with pkgs; [
    wget # Оставляем системно для экстренных случаев
    git  # Тоже полезен системно
  ];

}

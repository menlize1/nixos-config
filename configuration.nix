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

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelModules = [ "tun" ];

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

  # ============================================================================
  # СЕРВИСЫ (Звук, Печать, Flatpak, GameMode)
  # ============================================================================

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
  programs.gamemode.enable = true;

  # ============================================================================
  # ПОЛЬЗОВАТЕЛИ
  # ============================================================================

  users.users.menlize = {
    isNormalUser = true;
    description = "menlize";
    extraGroups = [ "networkmanager" "wheel" "gamemode" ];
  };

  # ============================================================================
  # СИСТЕМНЫЕ ПАКЕТЫ
  # ============================================================================

  environment.systemPackages = with pkgs; [
    wget # Оставляем системно для экстренных случаев
    git  # Тоже полезен системно
  ];

}

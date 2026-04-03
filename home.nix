{ config, pkgs, inputs, ... }:

{
  home.username = "menlize";
  home.homeDirectory = "/home/menlize";
  home.stateVersion = "25.11";

  # Пакеты пользователя
  home.packages = with pkgs; [
    gnome-secrets
    ptyxis
    firefox
    nautilus
    nodejs
    gh
    inputs.freesm.packages.${pkgs.system}.freesmlauncher
    
    # Игровые утилиты
    protonup-qt
    lutris
    mangohud

    # Современные утилиты CLI
    eza      # замена ls
    bat      # замена cat
    btop     # замена htop
    fd       # быстрый поиск файлов
    ripgrep  # быстрый поиск по тексту
  ];

  # Настройка Fish
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Отключаем приветствие при входе
      fish_add_path $HOME/.npm-global/bin
    '';
    shellAbbrs = {
      # Системные
      nrs = "sudo nixos-rebuild switch --flake ~/dotfiles";
      hms = "home-manager switch --flake ~/dotfiles";
      
      # Утилиты
      ls = "eza --icons --group-directories-first";
      ll = "eza -l --icons --group-directories-first";
      la = "eza -la --icons --group-directories-first";
      cat = "bat";
      top = "btop";
      
      # Git (если нужно)
      gs = "git status";
      gp = "git push";
    };
  };

  # Красивый промпт (Starship)
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  # Умный cd (Zoxide)
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  # Поиск по истории (FZF)
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  # Автоматическая активация окружений (Direnv)
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Настройка VS Code
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      bbenoist.nix
      ms-python.python
    ];
  };

  # Переменные окружения
  home.sessionPath = [
    "${config.home.homeDirectory}/.npm-global/bin"
  ];

  # Управление Bash (на всякий случай оставляем совместимость)
  programs.bash.enable = true;
  
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}

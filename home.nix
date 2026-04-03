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
    # Добавьте сюда другие пакеты
  ];

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
    "$HOME/.npm-global/bin"
  ];


  # Let Home Manager install and manage itself.
  programs.bash.enable = true;
  programs.home-manager.enable = true;
}

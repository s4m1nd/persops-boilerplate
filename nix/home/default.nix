# home/default.nix

{ config, pkgs, system, ... }:
let
  isNixOS = pkgs.stdenv.hostPlatform.isLinux;
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
in
{
  home.stateVersion = "25.05";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    wget
    curl
    git
    tmux
    starship
    vim
    eza
    fd
    fzf
    ripgrep
    jq
    htop
    _1password-cli
    unrar
    tmux-sessionizer
    lazygit
    # programming
    deno
    nodejs
    # nodejs_22
    nodePackages.prettier
    nodePackages.npm
    nodePackages.yarn
    go
    (python312.withPackages (ps: with ps; [
      aiohttp
      beautifulsoup4
      build
      ipython
      jupyter
      matplotlib
      numpy
      pandas
      pip
      pipx
      pwntools
      requests
      ropgadget
      setuptools
      z3
    ]))
    uv
  ];

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting ""
      fish_vi_key_bindings

      # use <space> instead of tab to accept shell suggestions
      # bind -M insert '  ' accept-autosuggestion

      starship init fish | source
    '';
    shellAliases = {
      vim = "nvim";
      ls = "eza";
      ll = "eza -l";
      la = "eza -la";
      l = "eza --classify --group-directories-first";
    };
    plugins = with pkgs;
      [
        { name = "colored-man-pages"; src = fishPlugins.colored-man-pages.src; }
        { name = "done"; src = fishPlugins.done.src; }
        { name = "fzf"; src = fishPlugins.fzf.src; }
        { name = "puffer"; src = fishPlugins.puffer.src; }
        { name = "z"; src = fishPlugins.z.src; }
      ];
  };

  programs.tmux = {
    enable = true;
    shell = "${pkgs.fish}/bin/fish";
    sensibleOnTop = false;
    historyLimit = 1000000;
    prefix = "C-a";
    terminal = "xterm-256color";
    mouse = true;
    plugins = with pkgs;
      [
        tmuxPlugins.tmux-thumbs
        tmuxPlugins.vim-tmux-navigator
        tmuxPlugins.sensible
        tmuxPlugins.pain-control
        tmuxPlugins.yank
        tmuxPlugins.tmux-fzf
      ];
    extraConfig = ''
      set -g escape-time 0
      set -g renumber-windows on
      set-window-option -g mode-keys vi
      bind-key -T copy-mode-vi v send -X begin-selection
      bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "pbcopy"
      bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "pbcopy"
      bind-key -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel "pbcopy"
      set -s escape-time 0
      set -g status-right "#{?pane_synchronized,#[bg=green] synced ,}#{?window_zoomed_flag,#[fg=red] zoomed ,}#{?window_list,#{window_list}}#{?pane_current_command,, #[fg=white]#[bg=red] #H #[fg=white]#[bg=default]}"
      set -g status-style fg=yellow,bg=default
      set -g prefix C-a
      set -s escape-time 0
      set -g mouse on
      bind -n WheelUpPane if-shell -Ft= '#{mouse_any_flag}' 'send-keys -M' 'copy-mode -e; send-keys -M'
      bind-key -n 'M-j' copy-mode
      bind-key -n 'M-k' copy-mode
      bind-key y select-layout even-horizontal
      bind-key u select-layout even-vertical
      bind-key / copy-mode \; send-key ?
      setw -g aggressive-resize on
      set -g renumber-windows on
      setw -g monitor-activity on
      set -g visual-activity on
      bind C-x setw synchronize-panes
      bind r source-file ~/.config/tmux/tmux.conf \; display-message "Config reloaded..."
      bind f display-popup -E "tms"
      bind s display-popup -E "tms switch"
      bind w display-popup -E "tms windows"
      bind-key h select-pane -L
      bind-key j select-pane -D
      bind-key k select-pane -U
      bind-key l select-pane -R
    '';
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  # shared config files
  home.file = {
    ".config/nvim" = {
      source = ../programs/nvim;
      recursive = true;
    };
    ".config/ghostty/config" = {
      source = ../programs/ghostty/config;
    };
  } // (if isDarwin then {
    # mac config files
    ".config/tms/config.toml" = {
      source = ../programs/tmux/tms-mac.toml;
    };
  } else if isNixOS then {
    ".config/tms/config.toml" = {
      source = ../programs/tmux/tms-linux.toml;
    };
  } else {});
}

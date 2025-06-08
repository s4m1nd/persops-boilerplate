{ pkgs, lib, inputs, ... }:
{
  imports = [
    ../common
  ];

  system.stateVersion = 4;

  system.primaryUser = "s4m1nd";

  ids.gids.nixbld = 350;

  programs.zsh.enable = true;

  homebrew = {
    enable = true;
    taps = [];
    brews = [
      "rust"
      "rust-analyzer"
      "rustc-completion"
      "protobuf"
      "protoc-gen-go"
      "lua"
      "luarocks"
      "helm"
      "binwalk"
      "ffmpeg"
      "certbot"
      "sad"
      "stripe"
      "julia"
      "ansible"
      "sshpass"
      "glab"
      "glances"
      "smctemp"
    ];
    casks = [
      "ghostty"
      "vmware-fusion"
      "hashicorp-vagrant"
      "vagrant-vmware-utility"
      "flutter"
    ];
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set -gx GOPATH ~/path/to/go
      set -gx GOROOT (dirname (dirname (readlink -f (which go))))
      set -gx GEM_PATH $HOME/.gem/ruby/3.3.0/bin
      set -gx LBIN ~/.local/bin
      set -gx VMW /Applications/VMware Fusion.app/Contents/Library
      set -gx DENO_INSTALL $HOME/.deno
      set -gx PATH $PATH $ANDROID_HOME/emulator $ANDROID_HOME/platform-tools $HOME/miniconda3/bin $HOME/.cargo/bin $FLUTTER_PATH $GOROOT/bin $GOPATH/bin $LBIN $VMW $DENO_INSTALL $GEM_PATH
      set -gx PATH /opt/homebrew/bin $PATH
    '';
  };

  # system config
  environment.shells = [ pkgs.fish ];
  security.pam.services.sudo_local.touchIdAuth = true;

  environment = {
    systemPackages = [
      pkgs.pam-reattach
      pkgs.rectangle
      pkgs.postman
      pkgs.tableplus
      pkgs.code-cursor
      pkgs.deno
      pkgs.bun
      pkgs.ruby
      pkgs.colima
      pkgs.utm
      pkgs.docker
      pkgs.docker-compose
      pkgs.docker-credential-helpers
      pkgs.jmeter
      pkgs.kubectx
      pkgs.kubectl
      pkgs.k9s
      pkgs.kubernetes-helm
      pkgs.jsonnet
      pkgs.jsonnet-bundler
      pkgs.terraform
      pkgs.opentofu
      pkgs.tanka
      pkgs.arc-browser
      pkgs.slack
      pkgs.raycast
    ];
    etc."pam.d/sudo_local".text = ''
      auth       optional       ${pkgs.pam-reattach}/lib/pam/pam_reattach.so ignore_ssh
      auth       sufficient     pam_tid.so
    '';
  };

  system = {
    defaults = {
      dock = {
        autohide = true;
        orientation = "right";
        showhidden = true;
      };
    };
  };

  users.users.s4m1nd = {
    name = "s4m1nd";
    home = "/Users/s4m1nd";
    shell = "/run/current-system/sw/bin/fish";
  };
}

# ─────────────────────────────────────────────
#  home.nix — Home Manager user configuration
#  Dotfiles, shell, DE configs, user tools
# ─────────────────────────────────────────────
{ config, pkgs, inputs, ... }:

{
  home.username    = "ipriyansh";
  home.homeDirectory= "/home/ipriyansh";
  home.stateVersion = "24.11";

  #nixpkgs.config.allowUnfree = true;

  # ── User-level packages ───────────────────
  home.packages = with pkgs; [
    glow slides presenterm
    zathura imv mpv
    discord telegram-desktop
    obsidian zotero
    go golangci-lint
    pyenv uv
  ];

  # ── ZSH ───────────────────────────────────
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;

    shellAliases = {
      ll   = "eza -la --icons --git";
      lt   = "eza -T --icons";
      cat  = "bat";
      grep = "rg";
      find = "fd";

      # Nix rebuild shortcuts
      nrs   = "sudo nixos-rebuild switch --flake ~/nixos-config#nixos";
      nrt   = "sudo nixos-rebuild test   --flake ~/nixos-config#nixos";
      nrb   = "sudo nixos-rebuild boot   --flake ~/nixos-config#nixos";
      nhome = "home-manager switch       --flake ~/nixos-config#ipriyansh";
      nfu   = "nix flake update ~/nixos-config";
      nclean= "sudo nix-collect-garbage -d";

      # Docker
      dps    = "docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'";
      dclean = "docker system prune -af";

      # Git
      gs  = "git status";
      gaa = "git add -A";
      gcm = "git commit -m";
      gp  = "git push";
    };

    initContent = ''
      export PATH="$HOME/go/bin:$HOME/.local/bin:$HOME/.cargo/bin:$PATH"
      export GOPATH="$HOME/go"
      export WORDLISTS="/usr/share/wordlists"
      export LHOST="$(hostname -I | awk '{print $1}')"

      export PYENV_ROOT="$HOME/.pyenv"
      [[ -d "$PYENV_ROOT/bin" ]] && export PATH="$PYENV_ROOT/bin:$PATH"
      eval "$(pyenv init -)" 2>/dev/null || true

      HISTSIZE=50000
      SAVEHIST=50000
      setopt HIST_IGNORE_DUPS HIST_IGNORE_SPACE SHARE_HISTORY

      bindkey '^R' history-incremental-search-backward
    '';
  };

  # ── Starship prompt ───────────────────────
  programs.starship = {
    enable = true;
    settings = {
      format = "$username@$hostname $directory$git_branch$git_status$cmd_duration\n$character";
      character = {
        success_symbol = "[❯](bold green)";
        error_symbol   = "[❯](bold red)";
      };
      directory = { style = "bold cyan"; truncation_length = 4; };
      git_branch.style  = "bold purple";
      git_status.style  = "bold yellow";
      cmd_duration = { min_time = 2000; style = "bold yellow"; };
    };
  };

  # ── Tmux ──────────────────────────────────
  programs.tmux = {
    enable       = true;
    prefix       = "C-a";
    baseIndex    = 1;
    escapeTime   = 0;
    historyLimit = 50000;
    terminal     = "screen-256color";
    extraConfig = ''
      set -g mouse on
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      set -g status-bg "#1e1e2e"
      set -g status-fg "#cdd6f4"
      set -g status-left "#[bold fg=#89b4fa] #{session_name} "
      set -g status-right "#[fg=#a6e3a1] %H:%M #[fg=#f38ba8]%d-%b "
      set -g automatic-rename on
      set -g status-interval 5
    '';
  };

  # ── Git ───────────────────────────────────
  programs.git = {
    enable    = true;
    userName  = "rootwithkhandal";
    userEmail = "i.priyanshkhandal@gmail.com";
    extraConfig = {
      core.editor         = "nvim";
      pull.rebase         = false;
      init.defaultBranch  = "main";
    };
    aliases.lg = "log --oneline --graph --decorate --all";
  };

  # ── Kitty terminal ─────────────────────────
  programs.kitty = {
    enable = true;
    font = { name = "JetBrainsMono Nerd Font"; size = 13; };
    settings = {
      background = "#1e1e2e"; foreground = "#cdd6f4";
      cursor = "#f5e0dc"; selection_background = "#585b70";
      color0 = "#45475a"; color8  = "#585b70";
      color1 = "#f38ba8"; color9  = "#f38ba8";
      color2 = "#a6e3a1"; color10 = "#a6e3a1";
      color3 = "#f9e2af"; color11 = "#f9e2af";
      color4 = "#89b4fa"; color12 = "#89b4fa";
      color5 = "#f5c2e7"; color13 = "#f5c2e7";
      color6 = "#94e2d5"; color14 = "#94e2d5";
      color7 = "#bac2de"; color15 = "#a6adc8";
      window_padding_width = 8;
      confirm_os_window_close = 0;
      enable_audio_bell = false;
    };
  };

  # ── Hyprland ──────────────────────────────
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      monitor = ",preferred,auto,1";
      general = {
        gaps_in = 5; gaps_out = 10; border_size = 2;
        "col.active_border"   = "rgba(89b4faee) rgba(cba6f7ee) 45deg";
        "col.inactive_border" = "rgba(45475aee)";
        layout = "dwindle";
      };
      decoration = {
        rounding = 10;
        blur.enabled = true; blur.size = 6; blur.passes = 3;
        drop_shadow = true; shadow_range = 8;
      };
      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows,     1, 7,  myBezier"
          "windowsOut,  1, 7,  default, popin 80%"
          "border,      1, 10, default"
          "fade,        1, 7,  default"
          "workspaces,  1, 6,  default"
        ];
      };
      input = {
        kb_layout = "us"; follow_mouse = 1;
        touchpad.natural_scroll = true;
      };
      "$mod" = "SUPER";
      bind = [
        "$mod, Return, exec, kitty"
        "$mod, Q,      killactive"
        "$mod, M,      exit"
        "$mod, F,      fullscreen"
        "$mod, Space,  exec, wofi --show drun"
        "$mod, V,      togglefloating"
        "$mod, 1, workspace, 1"  "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"  "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod, H, movefocus, l"  "$mod, J, movefocus, d"
        "$mod, K, movefocus, u"  "$mod, L, movefocus, r"
        ", Print, exec, grim -g \"$(slurp)\" - | wl-copy"
        "SHIFT, Print, exec, grim ~/Pictures/Screenshots/$(date +%Y%m%d_%H%M%S).png"
      ];
      exec-once = [
        "swww init && swww img ~/Pictures/wallpaper.jpg"
        "waybar" "mako"
        "wl-paste --type text --watch cliphist store"
      ];
    };
  };

  # ── niri config ────────────────────────────
  xdg.configFile."niri/config.kdl".text = ''
    input {
      keyboard { xkb { layout "us" } }
      touchpad { tap; natural-scroll; }
    }
    layout {
      gaps 8
      border { width 2; active-color "#89b4fa"; inactive-color "#45475a"; }
      preset-column-widths {
        proportion 0.333; proportion 0.5; proportion 0.667;
      }
      default-column-width { proportion 0.5; }
    }
    spawn-at-startup "waybar"
    spawn-at-startup "mako"
    spawn-at-startup "swww" "init"
    prefer-no-csd
    binds {
      Mod+Return { spawn "kitty"; }
      Mod+D      { spawn "wofi" "--show" "drun"; }
      Mod+Q      { close-window; }
      Mod+H { focus-column-left; }   Mod+L { focus-column-right; }
      Mod+J { focus-window-down; }   Mod+K { focus-window-up; }
      Mod+Shift+H { move-column-left; }
      Mod+Shift+L { move-column-right; }
      Mod+1 { focus-workspace 1; }   Mod+Shift+1 { move-window-to-workspace 1; }
      Mod+2 { focus-workspace 2; }   Mod+Shift+2 { move-window-to-workspace 2; }
      Mod+3 { focus-workspace 3; }   Mod+Shift+3 { move-window-to-workspace 3; }
      Mod+4 { focus-workspace 4; }   Mod+Shift+4 { move-window-to-workspace 4; }
      Mod+5 { focus-workspace 5; }   Mod+Shift+5 { move-window-to-workspace 5; }
      Print         { screenshot-screen; }
      Mod+Shift+S   { screenshot; }
    }
  '';

  # ── GTK theme ─────────────────────────────
  gtk = {
    enable = true;
    theme         = { name = "Catppuccin-Mocha-Standard-Blue-Dark"; package = pkgs.catppuccin-gtk; };
    iconTheme     = { name = "Papirus-Dark"; package = pkgs.papirus-icon-theme; };
    cursorTheme   = { name = "Catppuccin-Mocha-Dark-Cursors"; package = pkgs.catppuccin-cursors.mochaDark; };
  };

  # ── XDG user directories ──────────────────
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    desktop   = "$HOME/Desktop";
    documents = "$HOME/Documents";
    download  = "$HOME/Downloads";
    pictures  = "$HOME/Pictures";
    videos    = "$HOME/Videos";
    extraConfig = {
      XDG_PROJECTS_DIR  = "$HOME/Projects";
      XDG_PENTEST_DIR   = "$HOME/Projects/pentest";
      XDG_DFIR_DIR      = "$HOME/Projects/dfir";
      XDG_MALWARE_DIR   = "$HOME/Projects/malware";
      XDG_BUGBOUNTY_DIR = "$HOME/Projects/bugbounty";
    };
  };

  programs.home-manager.enable = true;
}

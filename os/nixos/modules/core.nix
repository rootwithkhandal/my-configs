# ─────────────────────────────────────────────
#  core.nix — base system settings
# ─────────────────────────────────────────────
{ config, pkgs, ... }:

{
  # ── Bootloader ────────────────────────────
  boot = {
    loader = {
      systemd-boot.enable = false;
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        configurationLimit = 3;
        efiSupport = true;
        device = "nodev";
        theme = pkgs.catppuccin-grub;
        gfxmodeEfi = "1920x1080";
      };
    };
    kernelPackages = pkgs.linuxPackages_latest;
  };
  #boot.loader.systemd-boot.enable      = true;
  #boot.loader.efi.canTouchEfiVariables = true;

  # Latest kernel — required for modern hardware & some RE tools
  #boot.kernelPackages = pkgs.linuxPackages_latest;

  # Extra kernel modules useful for analysis / forensics
  boot.kernelModules = [ "loop" "nbd" "vhci-hcd" ];

  #boot.loader.grub.configurationLimit = 3;

  # ── Locale / Time ─────────────────────────
  time.timeZone                  = "Asia/Kolkata";   # keep timestamps forensically clean
  i18n.defaultLocale             = "en_US.UTF-8";

  # ── User ──────────────────────────────────
  users.users.ipriyansh = {
    isNormalUser = true;
    shell        = pkgs.zsh;
    extraGroups  = [
      "wheel"        # sudo
      "networkmanager"
      "docker"
      "libvirtd"
      "wireshark"    # capture without root
      "dialout"      # serial / hardware hacking
      "video"
      "audio"
    ];
  };

  # ── Base system packages ───────────────────
  environment.systemPackages = with pkgs; [
    # Shell / terminal
    zsh fish tmux kitty alacritty starship

    # Core utilities
    git curl wget jq yq ripgrep fd bat eza fzf
    htop btop fastfetch unzip p7zip file hexyl

    # Editors
    neovim vscode zed-editor

    # Network basics (non-security)
    iproute2 traceroute bind dnsutils

    # Hardware info
    pciutils usbutils lshw

    # Clipboard / notifications (multi-DE safe)
    wl-clipboard libnotify

    # cursors
    rose-pine-cursor apple-cursor

    # gnome
    gnome-tweaks gnome-extension-manager
  ];

  # ── Fonts ─────────────────────────────────
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    noto-fonts
    #noto-fonts-emoji
  ];

  # ── Programs ──────────────────────────────
  programs.zsh.enable  = true;
  programs.git.enable  = true;
  programs.neovim.enable = true;

  # Allow unfree (Burp Suite, IDA Free, etc.)
  nixpkgs.config.allowUnfree = true;

  # ── Nix settings ──────────────────────────
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store   = true;
    };
    gc = {
      automatic = true;
      dates     = "daily";
      options   = "--delete-older-than 3d";
    };
  };

  system.stateVersion = "24.11";

  # ── Catppuccin TTY (systemd-boot renders here) ────
  catppuccin.tty = {
    enable = true;
    flavor = "mocha";   # or: latte / frappe / macchiato
  };
}

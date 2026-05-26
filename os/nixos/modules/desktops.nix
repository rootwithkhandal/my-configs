# ─────────────────────────────────────────────
#  desktops.nix — niri + Hyprland + GNOME
#  All three DEs available at login
# ─────────────────────────────────────────────
{ config, pkgs, inputs, ... }:

{
  # ── Display Manager ───────────────────────
  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;

  # ── GNOME ──────────────────────────────────
  services.desktopManager.gnome.enable = true;

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-maps
    gnome-contacts
    gnome-weather
    gnome-music
    totem
    cheese
  ];

  # ── Hyprland ──────────────────────────────
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    xwayland.enable = true;
  };

  # ── niri ──────────────────────────────────
  programs.niri = {
    enable = true;
    package = inputs.niri.packages.${pkgs.stdenv.hostPlatform.system}.niri;
  };

  # ── XDG Portals (FIXED) ───────────────────
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };

  # ── System packages ───────────────────────
  environment.systemPackages = with pkgs; [
    # Bars
    waybar
    eww

    # Launchers
    rofi
    wofi
    fuzzel

    # Notifications
    mako
    dunst

    # Wallpaper
    awww
    hyprpaper

    # Screen lock
    swaylock-effects
    hyprlock

    # Screenshots
    grim
    slurp
    satty
    swappy

    # Clipboard
    wl-clipboard
    cliphist

    # Audio
    pavucontrol
    wireplumber
    pipewire

    # Theme / appearance
    gtk3
    gtk4
    gnome-themes-extra
    papirus-icon-theme
    catppuccin-gtk

    # GNOME Extensions
    gnomeExtensions.appindicator
    gnomeExtensions.dash-to-panel
    gnomeExtensions.blur-my-shell
    gnomeExtensions.just-perfection
  ];

  # ── Pipewire audio ────────────────────────
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = true;
  };
}

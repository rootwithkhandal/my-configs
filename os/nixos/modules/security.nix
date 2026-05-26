# ─────────────────────────────────────────────
#  security.nix — hardening without breaking
#  your own tooling
# ─────────────────────────────────────────────
{ config, pkgs, ... }:

{
  # ── Sudo ──────────────────────────────────
  security.sudo = {
    enable          = true;
    wheelNeedsPassword = true;
    extraConfig     = ''
      Defaults        timestamp_timeout=15
      Defaults        lecture=never
    '';
  };

  # ── Polkit ────────────────────────────────
  security.polkit.enable = true;

  # ── AppArmor (on, but in complain mode for
  #    tools that need broad syscall access) ──
  security.apparmor = {
    enable         = true;
    killUnconfinedConfinables = false;  # don't kill unconfined apps
  };

  # ── PAM / login ───────────────────────────
  security.pam.loginLimits = [
    { domain = "*"; type = "soft"; item = "nofile"; value = "65536"; }
    { domain = "*"; type = "hard"; item = "nofile"; value = "524288"; }
  ];

  # ── Kernel hardening (balanced) ───────────
  boot.kernel.sysctl = {
    # Restrict dmesg to root — avoids info leak from kernel ring buffer
    "kernel.dmesg_restrict"       = 1;

    # Prevent PTRACE of arbitrary processes (still works for your own procs)
    "kernel.yama.ptrace_scope"    = 1;

    # Network hardening
    "net.ipv4.conf.all.rp_filter"    = 1;
    "net.ipv4.conf.default.rp_filter"= 1;
    "net.ipv4.tcp_syncookies"        = 1;
    "net.ipv4.conf.all.accept_redirects"    = 0;
    "net.ipv6.conf.all.accept_redirects"    = 0;
    "net.ipv4.conf.all.send_redirects"      = 0;
    "net.ipv4.icmp_echo_ignore_broadcasts"  = 1;

    # Allow unprivileged user namespaces — needed by Burp, Chromium sandbox, etc.
    "kernel.unprivileged_userns_clone" = 1;

    # Core dumps — disable for prod, enable per-session when debugging malware
    "fs.suid_dumpable" = 0;
  };

  # ── Wireshark (capture without root) ──────
  programs.wireshark = {
    enable  = true;
    package = pkgs.wireshark;
  };

  # ── GPG ───────────────────────────────────
  programs.gnupg.agent = {
    enable           = true;
    enableSSHSupport = true;
  };

  # ── Firejail for sandboxing untrusted bins ─
  programs.firejail.enable = true;
}

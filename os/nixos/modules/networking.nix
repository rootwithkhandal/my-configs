# ─────────────────────────────────────────────
#  networking.nix — flexible networking for
#  pentest / DFIR / BB workflows
# ─────────────────────────────────────────────
{ config, pkgs, ... }:

{
  networking = {
    hostName        = "nixos";
    networkmanager.enable = true;

    # Firewall — permissive enough for tools, restrictive enough to be sane
    firewall = {
      enable              = true;
      allowPing           = true;
      allowedTCPPorts     = [ 22 80 443 8080 8443 4444 9090 ];
      allowedUDPPorts     = [ 53 ];

      # Allow packet capture on all ifaces
      extraCommands = ''
        iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
      '';
    };

    # Enable IP forwarding for routing / MITM scenarios
    # Set to true only when needed, or manage per-session:
    #   sudo sysctl -w net.ipv4.ip_forward=1
    enableIPv6 = true;
  };

  # ── VPN ───────────────────────────────────
  services.openvpn.servers = {};   # add VPN configs here
  networking.wireguard.enable = true;

  # ── DNS (dnsmasq for lab use) ──────────────
  # Uncomment for local lab DNS spoofing
  # services.dnsmasq = {
  #   enable = true;
  #   settings = { server = [ "8.8.8.8" "1.1.1.1" ]; };
  # };

  # ── Proxy tools (system-level) ────────────
  environment.systemPackages = with pkgs; [
    # Packet analysis
    wireshark-cli tshark tcpdump nmap netcat-gnu
    masscan zmap arp-scan

    # Traffic manipulation
    mitmproxy proxychains-ng

    # DNS tools
    dnsutils dig whois

    # SSL/TLS
    openssl sslscan #sslyze

    # Wireless
    aircrack-ng kismet #hostapd-wpe

    # Tunnel / proxy
    chisel ligolo-ng socat
  ];
}

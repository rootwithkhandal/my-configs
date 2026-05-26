# ─────────────────────────────────────────────
#  dfir.nix — Digital Forensics & Incident
#  Response toolchain
# ─────────────────────────────────────────────
{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # ── Disk & filesystem forensics ──────────
    sleuthkit        # autopsy backend (TSK)
    testdisk         # partition recovery
    extundelete      # ext2/3/4 file recovery
    foremost         # file carving
    scalpel          # fast file carver
    ddrescue         # disk imaging
    dcfldd           # forensic dd

    # ── Memory forensics ─────────────────────
    # Volatility 3 — install via pipx or Docker
    # volatility3 not in nixpkgs, use wrapper below

    # ── Network forensics ────────────────────
    wireshark tshark tcpdump zeek suricata
    #networkMiner     # if available, else use Docker image

    # ── Log analysis ─────────────────────────
    lnav             # log navigator
    goaccess         # web log analyzer
    chainsaw         # EVTX/Windows log hunting

    # ── Timeline & artifact analysis ─────────
    #plaso            # log2timeline
    #timesketch-cli   # timeline sketching

    # ── Hash / integrity ─────────────────────
    hashdeep         # recursive hash sets
    #md5sum sha256sum sha512sum

    # ── Hex / binary inspection ──────────────
    hexyl xxd binwalk

    # ── File identification ───────────────────
    file exiftool #libmagic

    # ── Yara ─────────────────────────────────
    yara             # pattern matching engine

    # ── Reporting / case management ──────────
    #timesketch-cli
    cherrytree obsidian
  ];

  # ── Volatility 3 wrapper (pipx install) ───
  # Run: pipx install volatility3
  # Or use the Docker image:
  #   docker run -v /evidence:/evidence volatilityfoundation/volatility3

  # ── YARA rules directory ──────────────────
  environment.variables = {
    YARA_RULES_DIR = "/opt/yara-rules";
  };

  system.activationScripts.yaraDir = ''
    mkdir -p /opt/yara-rules
    chown root:root /opt/yara-rules
    chmod 755 /opt/yara-rules
  '';
}

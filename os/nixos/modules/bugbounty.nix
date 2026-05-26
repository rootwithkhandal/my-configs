# ─────────────────────────────────────────────
#  bugbounty.nix — Bug Bounty Hunting tools
# ─────────────────────────────────────────────
{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # ── Recon & OSINT ────────────────────────
    amass subfinder assetfinder 
    theharvester 
    #shodan
    nmap rustscan masscan
    httpx httprobe
    waybackurls

    # ── Subdomain & directory brute-forcing ──
    gobuster ffuf feroxbuster #dirsearch
    wfuzz

    # ── Web proxy ────────────────────────────
    # Burp Suite Pro → commercial, download from portswigger.net
    # Burp Suite Community:
    burpsuite

    # ── Web fingerprinting ───────────────────
    whatweb #wappalyzer

    # ── Vulnerability scanning ────────────────
    nuclei nikto
    dalfox           # XSS scanner
    sqlmap           # SQLi automation
    commix           # command injection tester

    # ── Parameter discovery ───────────────────
    # arjun — install via pip: pip install arjun
    # x8    — cargo install x8

    # ── JavaScript analysis ───────────────────
    # LinkFinder, SecretFinder → install via pip

    # ── Cloud recon ──────────────────────────
    awscli2
    # CloudEnum, S3Scanner → install via pip

    # ── Collaboration & notes ─────────────────
    obsidian         # markdown-based knowledge base
    cherrytree       # hierarchical notes

    # ── Browsers for testing ──────────────────
    firefox
    chromium
    # Caido — download from caido.io

    # ── Misc utilities ────────────────────────
    gf               # grep patterns for hacking
    #anew             # append new lines only
    qsreplace        # URL parameter replacement
    unfurl           # URL parsing

    # programming lang
    go
  ];

  # ── Go tools — install at user level ──────
  # Many BB tools are Go-based. Recommend:
  #   go install github.com/tomnomnom/waybackurls@latest
  #   go install github.com/hakluke/hakrawler@latest
  #   go install github.com/lc/gau/v2/cmd/gau@latest
  #   go install github.com/projectdiscovery/katana/cmd/katana@latest

  #programs.go = {
  #  enable = true;
  #  goPath = "go";
  #};
}

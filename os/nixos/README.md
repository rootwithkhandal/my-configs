# NixOS Security Workstation Configuration

Modular NixOS flake configuration for a full-spectrum security workstation:
**Pentesting · Red Teaming · Bug Bounty · Blue Team / DFIR · Malware Analysis / RE**

Multi-DE: **niri + Hyprland + GNOME** (all three available at login)
System packages via `nixos` modules + user dotfiles via **Home Manager**.

---

## Directory Structure

```
nixos-config/
├── flake.nix                  # Entry point — inputs & outputs
├── hardware-configuration.nix # Your hardware config (keep existing)
├── modules/
│   ├── core.nix               # Base system, user, kernel, fonts
│   ├── desktops.nix           # niri + Hyprland + GNOME + shared Wayland deps
│   ├── security.nix           # Kernel hardening, AppArmor, firejail, sudo
│   ├── virtualization.nix     # KVM/QEMU, Docker, Podman
│   ├── networking.nix         # Firewall, VPN, network tools
│   ├── pentesting.nix         # Red team / pentest toolchain
│   ├── dfir.nix               # Forensics & incident response tools
│   ├── malware.nix            # RE / malware analysis + isolated bridge
│   └── bugbounty.nix          # Bug bounty recon & web testing tools
└── home/
    └── home.nix               # Home Manager — shell, DEs, dotfiles, aliases
```

---

## Quick Start

### 1. Clone into your system config location

```bash
git clone <this-repo> ~/nixos-config
cd ~/nixos-config
```

### 2. Bring in your existing hardware config

```bash
cp /etc/nixos/hardware-configuration.nix ~/nixos-config/
```

### 3. Rename placeholders

Replace all occurrences of `your-hostname` and `your-username`:

```bash
# Preview what needs changing
grep -rn "your-hostname\|your-username\|your-name\|your-email" .

# Then edit each file (core.nix, networking.nix, home.nix)
```

### 4. Apply system configuration

```bash
sudo nixos-rebuild switch --flake ~/nixos-config#your-hostname
```

### 5. Apply Home Manager configuration

```bash
home-manager switch --flake ~/nixos-config#your-username
```

---

## Aliases Reference

These are set in `home/home.nix` under `programs.zsh.shellAliases`:

| Alias    | Command                                                              |
|----------|----------------------------------------------------------------------|
| `nrs`    | `sudo nixos-rebuild switch --flake ~/nixos-config#your-hostname`    |
| `nrt`    | `sudo nixos-rebuild test   --flake ~/nixos-config#your-hostname`    |
| `nrb`    | `sudo nixos-rebuild boot   --flake ~/nixos-config#your-hostname`    |
| `nhome`  | `home-manager switch       --flake ~/nixos-config#your-username`    |
| `nfu`    | `nix flake update ~/nixos-config`                                   |
| `nclean` | `sudo nix-collect-garbage -d`                                        |

---

## Desktop Environments

All three DEs are installed. Select at the GDM login screen.

| DE         | Type                    | Config location                         |
|------------|-------------------------|-----------------------------------------|
| GNOME      | Full desktop            | GNOME Settings / dconf                  |
| Hyprland   | Tiling Wayland WM       | `home.nix` → `wayland.windowManager`    |
| niri       | Scrollable-tiling WM    | `~/.config/niri/config.kdl`             |

### Shared keybinds (Hyprland & niri)

| Key                | Action                  |
|--------------------|-------------------------|
| `Super + Return`   | Open terminal (kitty)   |
| `Super + Space`    | App launcher (wofi)     |
| `Super + Q`        | Close window            |
| `Super + H/J/K/L`  | Focus pane (vim-style)  |
| `Super + 1–5`      | Switch workspace        |
| `Super+Shift + 1–5`| Move window to workspace|
| `Print`            | Screenshot              |
| `Shift + Print`    | Region screenshot       |

---

## Module Overview

### `modules/core.nix`
- Latest kernel (`linuxPackages_latest`)
- User creation with groups: `wheel`, `docker`, `libvirtd`, `wireshark`, `dialout`
- Shell: zsh · Editors: neovim + vscode
- Nerd fonts (JetBrains Mono, Fira Code)
- Nix flakes + weekly garbage collection

### `modules/desktops.nix`
- GDM display manager (Wayland)
- GNOME with curated extensions (AppIndicator, Dash-to-Panel, Blur, Just Perfection)
- Hyprland from upstream flake
- niri from upstream flake
- Waybar, wofi, mako, swww, grim/slurp for screenshots
- Pipewire audio (ALSA + PulseAudio + JACK)

### `modules/security.nix`
- Kernel hardening via sysctl (dmesg restrict, YAMA ptrace, network filters)
- AppArmor (complain mode — won't break tools)
- Firejail for sandboxing untrusted binaries
- Wireshark with group-based capture (no root needed)
- PAM file descriptor limits raised for large captures / fuzzing

### `modules/virtualization.nix`
- KVM/QEMU with UEFI (OVMF) and TPM (swtpm)
- `virt-manager` for GUI VM management
- Docker + Podman (both available, no socket conflict)
- USB/SPICE passthrough for hardware hacking VMs

### `modules/networking.nix`
- NetworkManager
- WireGuard enabled
- Firewall open: 22, 80, 443, 8080, 8443, 4444 (reverse shell), 9090
- Packet capture tools: tcpdump, tshark, wireshark-cli
- Network attack tools: nmap, masscan, mitmproxy, bettercap, aircrack-ng
- Tunnel tools: chisel, ligolo-ng, socat

### `modules/pentesting.nix`
- Recon: nmap, rustscan, masscan, amass, subfinder, gobuster, ffuf, nuclei, httpx
- Exploitation: metasploit (with postgresql backend)
- Web: sqlmap, nikto, wfuzz, dirb
- Password: john, hashcat, hydra, wordlists, crunch, cewl
- Post-exploitation: pwndbg, pwntools
- MITM: bettercap, ettercap, responder
- Notes: cherrytree, obsidian

### `modules/dfir.nix`
- Disk forensics: sleuthkit (TSK), testdisk, foremost, scalpel, ddrescue, dcfldd
- Memory: Volatility 3 via Docker (see below)
- Network forensics: zeek, suricata, tshark
- Log analysis: lnav, chainsaw (EVTX hunting), plaso (log2timeline)
- Hash/integrity: hashdeep
- YARA: yara + `/opt/yara-rules/` directory
- Audit logging: auditd enabled

### `modules/malware.nix`
- Disassembly: ghidra, radare2 (+ iaito GUI)
- Debugging: gdb + pwndbg, edb-debugger, lldb
- Tracing: strace, ltrace, frida-tools
- Binary inspection: binwalk, binutils, hexyl, pev
- Python RE libs: pwntools, capstone, keystone-engine, ropper, angr
- Emulation: unicorn
- **Isolated malware bridge** (`malware-br0`, `192.168.100.1/24`) — internet blocked at firewall
- Audit logging for exec/open syscalls

### `modules/bugbounty.nix`
- Recon: amass, subfinder, assetfinder, theharvester, shodan-cli
- HTTP: httpx, httprobe, waybackurls
- Fuzzing: gobuster, ffuf, feroxbuster, wfuzz
- Web proxy: burpsuite (community)
- Vuln scanning: nuclei, nikto, dalfox (XSS), sqlmap, commix
- Cloud: awscli2
- Go toolchain enabled for user-installed tools

---

## Tools NOT in nixpkgs (install manually)

These require manual download or pip/cargo/go install:

| Tool                   | Install method                                          |
|------------------------|---------------------------------------------------------|
| Burp Suite Pro         | Download from portswigger.net                           |
| IDA Pro / Binary Ninja | Commercial — download from vendor                       |
| Volatility 3           | `pipx install volatility3` or Docker                    |
| Sliver / Havoc C2      | Docker container (keep off host)                        |
| arjun                  | `pip install arjun`                                     |
| x8 (param discovery)   | `cargo install x8`                                      |
| LinkFinder             | `pip install linkfinder`                                |
| hakrawler / gau / katana | `go install ...@latest` (use `go/bin` already in PATH)|
| CAPE Sandbox           | Docker — never run on host                              |

---

## Malware Analysis Safety

> ⚠️ **Never execute malware samples on the host system.**

The recommended workflow:

1. Use **virt-manager** to create a disposable VM (Windows or Linux)
2. Place it on the `malware-br0` bridge — internet is **blocked** by firewall rules
3. Use **shared folders** or a separate host-only network for sample transfer
4. Use **snapshots** — revert after each analysis session
5. Analyse captures, memory dumps, and logs on the **host** only

```bash
# Snapshot before analysis
virsh snapshot-create-as --domain malware-vm clean-snapshot

# Revert after
virsh snapshot-revert --domain malware-vm clean-snapshot
```

---

## Volatility 3 via Docker

```bash
# Pull
docker pull volatilityfoundation/volatility3

# Analyse a memory dump
docker run --rm -v /path/to/evidence:/evidence \
  volatilityfoundation/volatility3 \
  -f /evidence/memory.dmp windows.pslist
```

---

## Go Tools Bootstrap

After first rebuild, install common Go-based tools:

```bash
go install github.com/tomnomnom/waybackurls@latest
go install github.com/hakluke/hakrawler@latest
go install github.com/lc/gau/v2/cmd/gau@latest
go install github.com/projectdiscovery/katana/cmd/katana@latest
go install github.com/projectdiscovery/dnsx/cmd/dnsx@latest
go install github.com/tomnomnom/anew@latest
go install github.com/tomnomnom/qsreplace@latest
go install github.com/tomnomnom/unfurl@latest
```

---

## Updating

```bash
# Update all flake inputs (nixpkgs, HM, Hyprland, niri)
nfu   # alias for: nix flake update ~/nixos-config

# Rebuild system
nrs

# Rebuild home
nhome

# Garbage collect old generations (weekly via systemd timer too)
nclean
```

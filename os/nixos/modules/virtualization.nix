# ─────────────────────────────────────────────
#  virtualization.nix — KVM/QEMU, Docker,
#  and isolated analysis environments
# ─────────────────────────────────────────────
{ config, pkgs, ... }:

{
  # ── KVM / QEMU / libvirt ──────────────────
  virtualisation.libvirtd = {
    enable       = true;
    qemu = {
      package        = pkgs.qemu_kvm;
      # ovmf.enable    = true;   # UEFI VMs
      swtpm.enable   = true;   # TPM emulation
    };
  };

  programs.virt-manager.enable = true;

  # ── Docker (for tool containers) ──────────
  virtualisation.docker = {
    enable            = true;
    enableOnBoot      = true;
    autoPrune.enable  = true;
    # Rootless alternative — uncomment if preferred
    # rootless.enable           = true;
    # rootless.setSocketVariable = true;
  };

  # ── Podman (OCI / rootless containers) ────
  virtualisation.podman = {
    enable              = true;
    dockerCompat        = false;  # avoid conflict with Docker socket
    defaultNetwork.settings.dns_enabled = true;
  };

  # ── SPICE / USB passthrough ───────────────
  services.spice-vdagentd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  # ── System packages ───────────────────────
  environment.systemPackages = with pkgs; [
    qemu_kvm
    virt-manager
    virt-viewer
    spice-gtk
    docker-compose
    podman-compose
    dive           # explore Docker image layers
    lazydocker     # TUI for Docker
  ];

  # ── Networking for VMs ────────────────────
  networking.firewall.trustedInterfaces = [ "virbr0" "docker0" ];
}

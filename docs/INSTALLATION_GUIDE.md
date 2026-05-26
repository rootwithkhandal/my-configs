# Installation Guide

Complete step-by-step guide for using the modular dotfiles installer.

## Prerequisites

1. **Supported Operating Systems**:
   - Debian 10+
   - Ubuntu 20.04+
   - Arch Linux
   - Fedora 35+

2. **Requirements**:
   - Python 3.6 or higher
   - sudo/root access
   - Internet connection
   - At least 5GB free disk space

## Installation Steps

### Step 1: Clone Repository

```bash
cd ~
git clone https://github.com/rootwithkhandal/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

### Step 2: Install Python Dependencies

```bash
pip3 install -r requirements.txt
```

Or if you prefer using the system package manager:

```bash
# Debian/Ubuntu
sudo apt install python3-yaml

# Arch
sudo pacman -S python-yaml

# Fedora
sudo dnf install python3-pyyaml
```

### Step 3: Review Configuration (Optional)

Before running, you may want to review what will be installed:

```bash
# View applications
cat config/apps.yaml

# View VSCode extensions
cat config/vscode_extensions.yaml

# View services and firewall rules
cat config/settings.yaml
```

### Step 4: Dry Run (Recommended)

Preview what will be installed without making changes:

```bash
sudo python3 install.py --dry-run --verbose
```

### Step 5: Run Installation

Full installation with all components:

```bash
sudo python3 install.py
```

Or customize what gets installed:

```bash
# Skip Flatpak apps
sudo python3 install.py --skip-flatpak

# Skip Docker setup
sudo python3 install.py --skip-docker

# Skip VSCode extensions
sudo python3 install.py --skip-vscode

# Use Ghostty instead of WezTerm
sudo python3 install.py --terminal ghostty

# Combine multiple options
sudo python3 install.py --skip-flatpak --skip-docker --verbose
```

### Step 6: Post-Installation

1. **Reboot** (recommended for all changes to take effect):
   ```bash
   sudo reboot
   ```

2. **Verify Docker** (if installed):
   ```bash
   docker --version
   docker ps
   ```

3. **Check Flatpak apps** (if installed):
   ```bash
   flatpak list
   ```

4. **Verify VSCode extensions** (if installed):
   ```bash
   code --list-extensions
   ```

5. **Test terminal patching**:
   - Open any terminal application from the app menu
   - It should open in WezTerm or Ghostty

## Installation Time Estimates

- **Dependencies**: 5-10 minutes
- **Applications**: 10-20 minutes
- **Flatpak apps**: 5-10 minutes
- **VSCode extensions**: 5-15 minutes
- **Docker setup**: 2-5 minutes
- **Total**: 30-60 minutes (depending on internet speed)

## Selective Installation Examples

### Minimal Installation (No extras)

```bash
sudo python3 install.py \
  --skip-flatpak \
  --skip-docker \
  --skip-vscode \
  --skip-terminal-patch \
  --skip-firewall
```

### Developer Setup (No security tools)

Edit `config/apps.yaml` and comment out the `security_tools` section, then:

```bash
sudo python3 install.py
```

### Security/Pentesting Setup

```bash
sudo python3 install.py --skip-flatpak
```

### Just VSCode Extensions

```bash
# After main installation
python3 -c "from modules.vscode import VSCodeManager; from utils.logger import Logger; VSCodeManager(Logger()).install_extensions()"
```

## Customization Before Installation

### 1. Modify Package Lists

Edit `config/apps.yaml`:

```yaml
applications:
  editors:
    - neovim
    # - nano  # Comment out to skip
  
  # Add your own category
  my_tools:
    - htop
    - tmux
```

### 2. Modify Flatpak Apps

Edit `config/apps.yaml`:

```yaml
flatpak_apps:
  - com.spotify.Client
  # - org.telegram.desktop  # Comment out to skip
  - your.custom.App  # Add your own
```

### 3. Modify VSCode Extensions

Edit `config/vscode_extensions.yaml`:

```yaml
vscode_extensions:
  - ms-python.python
  # - github.copilot  # Comment out if you don't have Copilot
  - your.extension
```

### 4. Modify Firewall Rules

Edit `config/settings.yaml`:

```yaml
firewall:
  rules:
    - "disable"  # Start disabled
    - "allow 22/tcp"
    - "allow 8080/tcp"  # Add custom port
    - "enable"
```

## Troubleshooting Installation

### Issue: "Permission denied"

**Solution**: Always run with sudo:
```bash
sudo python3 install.py
```

### Issue: "Package not found" or "No installation candidate"

**Solution**: 
1. Check `install.log` for details:
   ```bash
   ./scripts/view_errors.sh
   ```
2. Some packages have different names on different distros
3. Edit `config/apps.yaml` and remove or rename the problematic package
4. Common issues:
   - `appmenu-qt5` - Not available on all Ubuntu versions
   - `rust-all` - Use `rustc` on some distros
   - `7zip` - Use `p7zip-full` on Debian/Ubuntu

### Issue: "code command not found"

**Solution**: 
1. Install VSCode first
2. Open VSCode → Ctrl+Shift+P → "Shell Command: Install 'code' command in PATH"
3. Re-run the installer

### Issue: Installation hangs

**Solution**: 
- Press Ctrl+C to cancel
- Check your internet connection
- Run with `--verbose` to see where it's stuck
- Skip the problematic component with `--skip-*` flags

### Issue: Flatpak apps not appearing

**Solution**:
```bash
# Update Flatpak
flatpak update

# Restart your session
logout and login again
```

### Issue: Docker permission denied

**Solution**:
```bash
# Add your user to docker group
sudo usermod -aG docker $USER

# Logout and login again, or run:
newgrp docker
```

## Uninstallation

To remove installed packages (use with caution):

```bash
# Remove Flatpak apps
flatpak list --app | awk '{print $1}' | xargs flatpak uninstall -y

# Remove Docker
sudo apt remove docker.io docker-compose  # Debian/Ubuntu
sudo pacman -R docker docker-compose      # Arch
sudo dnf remove docker docker-compose     # Fedora

# Remove VSCode extensions
code --list-extensions | xargs -L 1 code --uninstall-extension

# Restore terminal settings
rm -rf ~/.local/share/applications
```

## Getting Help

1. Check the main [README.md](README.md)
2. Review configuration files in `config/`
3. Run with `--verbose` flag for detailed output
4. Check logs for specific error messages

## Next Steps

After installation:
1. Configure your shell (zsh, bash, fish)
2. Set up your dotfiles with GNU Stow
3. Configure your terminal emulator
4. Set up your development environment
5. Customize VSCode settings

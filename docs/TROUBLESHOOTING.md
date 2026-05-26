# Troubleshooting Guide

Common issues and solutions for the dotfiles installer.

## Repository GPG Key Errors

### Symptoms
```
Sub-process /usr/bin/sqv returned an error code (1)
Error: Failed to parse keyring "/etc/apt/keyrings/wezterm-fury.gpg"
Missing key F0271FCF712CF2E39901F1A30E61D3BBAAEE37FE
The repository is not signed
```

### Solution

**Quick Fix:**
```bash
sudo ./scripts/fix_repo_keys.sh
```

**Manual Fix:**

1. **WezTerm Repository:**
```bash
sudo rm -f /etc/apt/sources.list.d/wezterm.list
sudo rm -f /etc/apt/keyrings/wezterm-fury.gpg
curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /etc/apt/keyrings/wezterm.gpg
sudo chmod 644 /etc/apt/keyrings/wezterm.gpg
echo 'deb [signed-by=/etc/apt/keyrings/wezterm.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
```

2. **Ngrok Repository:**
```bash
sudo rm -f /etc/apt/sources.list.d/ngrok.list
sudo rm -f /etc/apt/keyrings/ngrok.gpg
curl -fsSL https://ngrok-agent.s3.amazonaws.com/ngrok.asc | sudo gpg --yes --dearmor -o /etc/apt/keyrings/ngrok.gpg
sudo chmod 644 /etc/apt/keyrings/ngrok.gpg
echo 'deb [signed-by=/etc/apt/keyrings/ngrok.gpg] https://ngrok-agent.s3.amazonaws.com buster main' | sudo tee /etc/apt/sources.list.d/ngrok.list
```

3. **Sublime Text Repository (Removed):**
```bash
# Sublime Text is now disabled by default
# If you have it installed and want to remove it:
sudo apt remove sublime-text
sudo rm -f /etc/apt/sources.list.d/sublime-text.list
sudo rm -f /etc/apt/keyrings/sublime-text.gpg
```

4. **Update package lists:**
```bash
sudo apt update
```

### Why This Happens

- GPG keys not properly imported
- Wrong keyring file permissions (must be 644)
- Missing `signed-by` directive in repository configuration
- Old repository format using deprecated methods

## Package Installation Errors

### "Package has no installation candidate"

**Cause:** Package not available in your distribution's repositories.

**Solution:**
1. Check `install.log` for details:
   ```bash
   ./scripts/view_errors.sh
   ```

2. See [PACKAGE_NOTES.md](PACKAGE_NOTES.md) for alternatives

3. Remove problematic packages from `config/apps.yaml`

### "Unable to locate package"

**Cause:** Package name differs on your distribution.

**Solution:**
```bash
# Search for the package
apt search package-name

# Check if it exists
apt-cache policy package-name
```

## Flatpak Issues

### "'CompletedProcess' object has no attribute 'strip'"

**Status:** Fixed in latest version

**Solution:** Update to latest code or manually fix:
```bash
git pull origin main
```

### Flatpak apps not appearing

**Solution:**
```bash
# Update Flatpak
flatpak update

# Restart your session
logout and login
```

## VSCode Extension Errors

### "code command not found"

**Solution:**
1. Open VSCode
2. Press `Ctrl+Shift+P`
3. Run: "Shell Command: Install 'code' command in PATH"
4. Re-run installer

### Extensions fail to install

**Check:**
```bash
# Verify VSCode is installed
which code

# Try installing manually
code --install-extension ms-python.python
```

## Docker Issues

### "Permission denied" when running docker

**Solution:**
```bash
# Add user to docker group
sudo usermod -aG docker $USER

# Logout and login, or run:
newgrp docker

# Test
docker ps
```

### Docker service not starting

**Solution:**
```bash
# Check status
sudo systemctl status docker

# Start service
sudo systemctl start docker

# Enable on boot
sudo systemctl enable docker
```

## Terminal Patching Issues

### Terminal apps not opening in WezTerm/Ghostty

**Solution:**
```bash
# Re-run patching script
./scripts/patch_wezterm.sh
# or
./scripts/patch_ghostty.sh

# Update desktop database
update-desktop-database ~/.local/share/applications
```

### Applications still use default terminal

**Check:**
```bash
# Verify patched files exist
ls -la ~/.local/share/applications/

# Check a specific app
cat ~/.local/share/applications/htop.desktop | grep Exec
```

## Installation Hangs

### Symptoms
Installation stops and doesn't progress.

### Solutions

1. **Check internet connection:**
   ```bash
   ping -c 3 google.com
   ```

2. **Run with verbose output:**
   ```bash
   sudo python3 install.py --verbose
   ```

3. **Check for prompts:**
   - Some packages may ask for confirmation
   - Press `Y` and Enter if prompted

4. **Cancel and retry:**
   ```bash
   # Press Ctrl+C to cancel
   # Then retry with specific profile
   sudo python3 install.py --profile dependencies
   ```

## System-Specific Issues

### Debian Trixie / Testing

- Some packages may not be available yet
- Use `--skip-*` flags to skip problematic components
- Check backports: `sudo apt -t trixie-backports install package-name`

### Kali Linux

- Most security tools already installed
- May conflict with existing packages
- Use profile-based installation:
  ```bash
  sudo python3 install.py --profile developer
  ```

### Ubuntu 22.04+

- Most packages work out of the box
- Some GNOME extensions may not be available
- Use alternatives from PACKAGE_NOTES.md

## Getting More Help

1. **Check logs:**
   ```bash
   cat install.log
   ./scripts/view_errors.sh
   ```

2. **Run diagnostics:**
   ```bash
   # Check system info
   cat /etc/os-release
   
   # Check package manager
   which apt dpkg
   
   # Check Python version
   python3 --version
   ```

3. **Dry run to see what would happen:**
   ```bash
   sudo python3 install.py --dry-run --verbose
   ```

4. **Test specific component:**
   ```bash
   sudo python3 install.py --profile dependencies --dry-run
   ```

## Clean Slate

If everything is broken, start fresh:

```bash
# Remove all custom repositories
sudo rm -f /etc/apt/sources.list.d/wezterm.list
sudo rm -f /etc/apt/sources.list.d/ngrok.list
sudo rm -f /etc/apt/sources.list.d/sublime-text.list

# Remove keyrings
sudo rm -f /etc/apt/keyrings/wezterm*.gpg
sudo rm -f /etc/apt/keyrings/ngrok.gpg
sudo rm -f /etc/apt/keyrings/sublime*.gpg

# Update
sudo apt update

# Re-run installer
sudo python3 install.py
```

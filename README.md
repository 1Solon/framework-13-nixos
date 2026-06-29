<div align="center">

<img src="https://raw.githubusercontent.com/homarr-labs/dashboard-icons/150279bb788cf84fc94a8b79cfcd47857cac50e2/svg/nixos.svg" align="center" width="144px" height="144px"/>

## Solon's Framework 13 Nix Configuration

_My NixOS setup for Framework 13 (AMD Ryzen AI 300) with Home Manager and Flakes_

</div>

<div align="center">

![GitHub Repo stars](https://img.shields.io/github/stars/1Solon/framework-13-nixos?style=for-the-badge)
![GitHub forks](https://img.shields.io/github/forks/1Solon/framework-13-nixos?style=for-the-badge)

</div>

# 🧊💻 Framework 13 NixOS Configuration

This repository contains a NixOS configuration tailored for the Framework 13 (AMD Ryzen AI 300 series). It uses Nix Flakes and Home Manager for a reproducible workstation setup with KDE Plasma, Steam, Zen Browser, and 1Password integration.

## 📁 Files

- `configuration.nix` — System-wide NixOS configuration
- `home.nix` — User environment (Home Manager) configuration
- `flake.nix` — Flake inputs and NixOS configuration wiring

## 🚀 Getting Started

### ✅ Prerequisites
- A Framework 13 AMD AI 300-series laptop
- NixOS installed and booting (UEFI)
- `/etc/nixos/hardware-configuration.nix` present (from installation)
- Internet access and git

### 🏗️ Install

1) Clone the repo:
```bash
git clone https://github.com/1Solon/framework-13-nixos.git
cd framework-13-nixos
```

2) Review and adjust as needed:
- Hostname: `configuration.nix` `networking.hostName`
- Username: `configuration.nix` `users.users` and `home.nix` `home.username`
- Time zone and locale
- Flake outputs name: `flake.nix` `nixosConfigurations.sauls-laptop`

3) Build and switch:
```bash
sudo nixos-rebuild switch --flake .#sauls-laptop # Change this to your hostname
```

4) Log in and verify KDE Plasma, audio, network, and packages.

Note: This configuration includes a repo-local `hardware-configuration.nix` generated for this machine. Regenerate or update it if disk UUIDs or hardware change.

## 🔄 Updating

Update inputs and apply:
```bash
nix flake update
sudo nixos-rebuild switch --flake .#sauls-laptop
```

The zsh alias `update` is available after the first switch:
```bash
update
```

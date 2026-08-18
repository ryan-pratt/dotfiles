# Dotfiles

This repository contains my NixOS flake and my dotfiles.

## Layout

```
dotfiles/
├── flake.nix
├── hosts/
│   ├── hailstone/                     # M2 MacBook Air
│   │   ├── default.nix
│   │   ├── hardware-configuration.nix
│   │   └── firmware/                  # Asahi firmware
│   └── microburst/                    # Desktop
│       ├── default.nix
│       └── hardware-configuration.nix
├── modules/                           # Reusable system modules
│   ├── base.nix
│   └── desktop.nix                    # Desktop environment (Hyprland, SDDM)
├── home/                              # Home-Manager configs
│   ├── base.nix
│   ├── desktop.nix
│   └── modules/
│       ├── hyprland.nix
│       └── waybar.nix
└── dotfiles/
```

## Deployment

### NixOS System Configuration

```bash
sudo nixos-rebuild switch --flake .#hostname
```

### Dotfiles (with Home-Manager or GNU Stow)

```bash
cd ~/dotfiles   # repo root
stow -d dotfiles -t "$HOME" .
```

## Git LFS

This repository uses Git LFS for large firmware files in the `hosts/hailstone/firmware/` directory. After cloning:

```bash
git lfs install
git lfs pull
```

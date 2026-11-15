# Dotfiles

This repository contains my NixOS flake and my dotfiles.

## Layout

```
dotfiles/
├── flake.nix
├── hosts/
│   ├── inversion/                     # ThinkPad
│   │   ├── default.nix
│   │   └── hardware-configuration.nix
│   ├── mesocyclone/                   # Home server
│   │   ├── default.nix
│   │   ├── disko.nix                  # Declarative disk layout
│   │   └── hardware-configuration.nix
│   └── microburst/                    # Desktop
│       ├── default.nix
│       └── hardware-configuration.nix
├── modules/                           # Reusable system modules
│   ├── base.nix
│   ├── desktop.nix                    # Desktop environment (Hyprland, Noctalia)
│   └── server.nix                     # Headless server (NAS, ZFS, tailscale)
├── home/                              # Home-Manager configs
│   ├── base.nix
│   ├── desktop.nix
│   └── modules/
│       └── hyprland.nix
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

**Note:** This is only relevant for `hailstone`, which is no longer in my fleet.

This repository uses Git LFS for large firmware files in the `hosts/hailstone/firmware/` directory. After cloning:

```bash
git lfs install
git lfs pull
```

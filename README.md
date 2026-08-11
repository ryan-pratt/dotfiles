# Dotfiles

This repository contains my NixOS flake and my dotfiles.

## Layout

```
dotfiles/                          (repo root)
├── flake.nix                      # NixOS flake configuration
├── flake.lock
├── configuration.nix              # System configuration
├── home.nix                       # Home Manager configuration
├── hardware-configuration.nix     # Machine-specific hardware config
├── hm-configs/                    # Additional home-manager configs
├── apple-silicon-support/         # Asahi Linux support
├── firmware/                      # LFS-tracked firmware files
├── .gitattributes                 # Git LFS rules for firmware
└── dotfiles/                      # Personal dotfiles (stow-managed)
    ├── .zshrc
    ├── .tmux.conf
    ├── .aerospace.toml
    ├── .config/
    ├── Mononoki Nerd Font Regular.ttf
    └── ...
```

## Deployment

### NixOS System Configuration

```bash
sudo nixos-rebuild switch --flake /home/rpratt/dotfiles#nixos-macbook
```

### Dotfiles (with GNU Stow)

```bash
cd ~/dotfiles   # repo root
stow -d dotfiles -t "$HOME" .
```

The `.stow-local-ignore` file in `dotfiles/` controls which files are excluded from stowing.

## Git LFS

This repository uses Git LFS for large firmware files in the `firmware/` directory. After cloning:

```bash
git lfs install
git lfs pull
```

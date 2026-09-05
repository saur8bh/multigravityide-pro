#!/usr/bin/env bash
set -euo pipefail

BASE="${MULTIGRAVITY_HOME:-$HOME/AntigravityProfiles}"
FORCE=false

for arg in "$@"; do
  case "$arg" in
    -y|--yes|--force)
      FORCE=true
      ;;
  esac
done

echo "=========================================="
echo "   Multigravity IDE Pro - Uninstaller    "
echo "=========================================="
echo ""
echo "This will remove:"
echo "  1. Multigravity CLI binary and icon files"
echo "  2. Application launchers & desktop shortcuts"
echo "  3. ALL profile data & templates in $BASE"
echo ""

if [ "$FORCE" != "true" ]; then
  printf "Are you sure you want to completely uninstall Multigravity and DELETE ALL profiles? [y/N] "
  read -r confirm
  case "$confirm" in
    [yY]|[yY][eE][sS])
      ;;
    *)
      echo "Uninstall cancelled. Nothing was removed."
      exit 0
      ;;
  esac
fi

# 1. Remove macOS shortcuts
if [ -d "$HOME/Applications" ]; then
  for app in "$HOME/Applications"/Multigravity\ *.app; do
    if [ -d "$app" ]; then
      rm -rf "$app"
      echo "  Removed shortcut: $app"
    fi
  done
fi

# 2. Remove Linux launchers & shortcuts
if [ -d "$HOME/.local/share/multigravity" ]; then
  rm -rf "$HOME/.local/share/multigravity"
  echo "  Removed: $HOME/.local/share/multigravity"
fi
for desktop in "$HOME/.local/share/applications"/multigravity-*.desktop; do
  if [ -f "$desktop" ]; then
    rm -f "$desktop"
    echo "  Removed desktop file: $desktop"
  fi
done

# 3. Remove Profiles Directory
if [ -d "$BASE" ]; then
  echo "Removing all profiles and templates in $BASE..."
  rm -rf "$BASE"
  echo "  Removed: $BASE"
fi

# 4. Remove Binary & Icon Files
for bin_dir in "/usr/local/bin" "$HOME/.local/bin"; do
  if [ -f "$bin_dir/multigravity" ]; then
    rm -f "$bin_dir/multigravity"
    echo "  Removed: $bin_dir/multigravity"
  fi
  if [ -f "$bin_dir/icon.icns" ]; then
    rm -f "$bin_dir/icon.icns"
    echo "  Removed: $bin_dir/icon.icns"
  fi
done

echo ""
echo "✓ Multigravity IDE Pro has been completely uninstalled."

#!/bin/sh
set -eu

usage() {
  cat <<'EOF'
usage: ./bootstrap.sh [configuration]

Repair Nix if a macOS reboot left /nix unavailable, then build and activate
the requested nix-darwin configuration. The configuration defaults to macbook.
EOF
}

case "${1:-}" in
  -h|--help)
    usage
    exit 0
    ;;
esac

configuration="${1:-${DARWIN_CONFIGURATION:-macbook}}"
case "$configuration" in
  *[!A-Za-z0-9._-]*|'')
    printf 'Invalid configuration name: %s\n' "$configuration" >&2
    exit 2
    ;;
esac

if [ "$(uname -s)" != "Darwin" ]; then
  printf 'This bootstrap script currently supports macOS only.\n' >&2
  exit 1
fi

repo_dir=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd -P)
repair_script="$repo_dir/bin/nix-repair-boot"

find_nix() {
  if command -v nix >/dev/null 2>&1; then
    command -v nix
  elif [ -x /nix/var/nix/profiles/default/bin/nix ]; then
    printf '%s\n' /nix/var/nix/profiles/default/bin/nix
  else
    return 1
  fi
}

nix_is_healthy() {
  [ -d /nix/store ] || return 1
  [ -S /nix/var/nix/daemon-socket/socket ] || return 1
  nix_bin=$(find_nix) || return 1
  "$nix_bin" store info >/dev/null 2>&1
}

if ! nix_is_healthy; then
  if [ ! -x "$repair_script" ]; then
    printf 'Nix is unavailable and the repair helper is missing: %s\n' \
      "$repair_script" >&2
    exit 1
  fi

  printf 'Nix is unavailable; repairing the APFS store and launch daemons...\n' >&2
  "$repair_script"
fi

if ! nix_is_healthy; then
  cat >&2 <<'EOF'
Nix is still unavailable. If this is a fresh machine, install Nix first:

  curl --proto '=https' --tlsv1.2 -sSf -L \
    https://install.determinate.systems/nix | sh -s -- install

If Nix is already installed, enable the `sh` background items in:
System Settings -> General -> Login Items & Extensions.
EOF
  exit 1
fi

if [ ! -x /opt/homebrew/bin/brew ]; then
  cat >&2 <<'EOF'
Homebrew is required by this nix-darwin configuration but is not installed.
Install it, then run this script again:

  /bin/bash -c "$(curl -fsSL \
    https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
EOF
  exit 1
fi

printf 'Building nix-darwin configuration %s as %s...\n' \
  "$configuration" "$(id -un)" >&2
system_path=$(
  cd "$repo_dir"
  "$nix_bin" \
    --extra-experimental-features 'nix-command flakes' \
    build --no-link --print-out-paths \
    ".#darwinConfigurations.${configuration}.system"
)

if [ ! -x "$system_path/activate" ]; then
  printf 'Build did not produce an activatable system: %s\n' "$system_path" >&2
  exit 1
fi

nix_env=/nix/var/nix/profiles/default/bin/nix-env
if [ ! -x "$nix_env" ]; then
  nix_env=$(command -v nix-env || true)
fi
if [ ! -x "${nix_env:-}" ]; then
  printf 'Cannot find nix-env to update the system profile.\n' >&2
  exit 1
fi

printf 'Activating %s (sudo is required only for this step)...\n' \
  "$system_path" >&2
sudo -H "$nix_env" -p /nix/var/nix/profiles/system --set "$system_path"
sudo -H "$system_path/activate"

current_system=$(readlink /run/current-system 2>/dev/null || true)
if [ "$current_system" != "$system_path" ]; then
  printf 'Activation finished, but /run/current-system points to %s\n' \
    "${current_system:-nothing}" >&2
  exit 1
fi

"$nix_bin" store info >/dev/null
printf 'Nix is healthy; %s is active.\n' "$configuration"
printf 'to start kanata, manually run:'
printf 'launchctl kickstart -k gui/$(id -u)/org.spike.kanata'

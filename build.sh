#!/bin/sh
set -eu

repo_dir=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd -P)
exec "$repo_dir/bootstrap.sh" "$@"

#!/bin/sh
printf '\033c\033]0;%s\a' wisp-godot
base_path="$(dirname "$(realpath "$0")")"
"$base_path/wisp-godot.x86_64" "$@"

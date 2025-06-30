#!/usr/bin/env sh

set -e -o pipefail

cmd_exists() { type "$1" > /dev/null; }

xres() {
  local xres_nix="../../../modules/xresources.home.nix"
  if [ -f "$xres_nix" ] && cmd_exists nix; then
    nix eval --impure --json --expr "(import $xres_nix {}).xresources.properties" | \
      jq -r 'to_entries | map(.key + ": " + .value) | join("\n")'
  else
    xrdb -q;
  fi
}

to_c_source() {
  sed -e 's/[*.]\+\(.*\):/_\1 /g' | awk '{print "#define Xres_" $1 " \"" $2 "\""}';
}

(xres | to_c_source) > xresources.h


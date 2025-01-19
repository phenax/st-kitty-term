#!/usr/bin/env sh

set -e -o pipefail

xres() {
  xrdb -q;
}

to_c_source() {
  sed -e 's/[*.]\+\(.*\):/_\1 /g' | awk '{print "#define Xres_" $1 " \"" $2 "\""}';
}

(xres | to_c_source) > xresources.h


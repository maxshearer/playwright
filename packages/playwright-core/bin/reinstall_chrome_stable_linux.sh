#!/bin/bash
set -e
set -x

if [[ $(arch) == "aarch64" ]]; then
  echo "ERROR: not supported on Linux Arm64"
  exit 1
fi

is_user_root () { [ "${EUID:-$(id -u)}" -eq 0 ]; }
if is_user_root; then
  maybesudo=""
else
  maybesudo="sudo"
fi


# 1. make sure to remove old stable if any.
if dpkg --get-selections | grep -q "^google-chrome[[:space:]]*install$" >/dev/null; then
  $maybesudo apt-get remove -y google-chrome
fi

if ! command -v curl >/dev/null; then
  $maybesudo apt-get install -y curl
fi

# 2. download chrome stable from dl.google.com and install it.
cd /tmp
curl -O https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
$maybesudo apt-get install -y ./google-chrome-stable_current_amd64.deb
rm -rf ./google-chrome-stable_current_amd64.deb
cd -
google-chrome --version

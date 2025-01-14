#!/bin/bash
set -e
set +x

if [[ ($1 == '--help') || ($1 == '-h') || ($1 == '') || ($2 == '') ]]; then
  echo "usage: $(basename $0) {bionic,focal} playwright:localbuild-focal"
  echo
  echo "Build Playwright docker image and tag it as 'playwright:localbuild-focal'."
  echo "Once image is built, you can run it with"
  echo ""
  echo "  docker run --rm -it playwright:localbuild-focal /bin/bash"
  echo ""
  echo "NOTE: this requires on Playwright dependencies to be installed with 'npm install'"
  echo "      and Playwright itself being built with 'npm run build'"
  echo ""
  exit 0
fi

function cleanup() {
  rm -f "playwright.tar.gz"
}

trap "cleanup; cd $(pwd -P)" EXIT
cd "$(dirname "$0")"

# We rely on `./playwright-core.tar.gz` to download browsers into the docker
# image.
node ../../utils/pack_package.js playwright-core ./playwright-core.tar.gz

docker build -t "$2" -f "Dockerfile.$1" .

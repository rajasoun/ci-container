#!/usr/bin/env bash

# Workaround for Path Limitations in Windows
function _docker() {
  export MSYS_NO_PATHCONV=1
  export MSYS2_ARG_CONV_EXCL='*'

  case "$OSTYPE" in
      *msys*|*cygwin*) os="$(uname -o)" ;;
      *) os="$(uname)";;
  esac

  if [[ "$os" == "Msys" ]] || [[ "$os" == "Cygwin" ]]; then
      # shellcheck disable=SC2230
      realdocker="$(which -a docker | grep -v "$(readlink -f "$0")" | head -1)"
      printf "%s\0" "$@" > /tmp/args.txt
      # --tty or -t requires winpty
      if grep -ZE '^--tty|^-[^-].*t|^-t.*' /tmp/args.txt; then
          #exec winpty /bin/bash -c "xargs -0a /tmp/args.txt '$realdocker'"
          winpty /bin/bash -c "xargs -0a /tmp/args.txt '$realdocker'"
          return 0
      fi
  fi
  docker "$@"
  return 0
}

# VERSION=$(git describe --tags --abbrev=0 | sed -Ee 's/^v|-.*//')
VERSION=$(cat .devcontainer/version.txt)

echo "Dev Container Version: $VERSION"
_docker run --rm -it --name nix-shell \
        --sig-proxy=false \
        -a STDOUT -a STDERR \
        --entrypoint=/bin/zsh \
        --user vscode  \
        --mount type=bind,source="${PWD}",target=/workspaces/ci-container,consistency=cached \
        --mount source=/var/run/docker.sock,target=/var/run/docker-host.sock,type=bind \
        --mount type=volume,src=vscode,dst=/vscode -l vsch.local.folder="${PWD}" \
        -l vsch.quality=stable -l vsch.remote.devPort=0 \
        -w "/workspaces/ci-container" \
        "rajasoun/ci-container:$VERSION"

#!/usr/bin/env bash

set -e

eval "$(op signin)"
PAT="$(op item get 'GitHub PAT - github-package-token' --fields 'label=token' --reveal)"

echo "${PAT}" | docker login ghcr.io -u cyberops7 --password-stdin

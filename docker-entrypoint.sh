#!/usr/bin/env bash

set -Eeo pipefail

if [[ "$1" == "-h" ]] || [[ "$1" == "ss" ]] || [[ "$1" == "id" ]] || [[ "$1" == "status" ]] || [[ "$1" == "deploy" ]]; then
    exec "deployer" "$@"
else
    exec "$@"
fi

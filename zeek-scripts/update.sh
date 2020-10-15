#!/usr/bin/env bash
set -euo pipefail

nix flake update --update-input nixpkgs && nix-build

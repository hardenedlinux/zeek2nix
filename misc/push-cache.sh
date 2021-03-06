#!/usr/bin/env bash
set -euo pipefail

nix develop --profile zeek-profile && cachix push nsm-data-analysis ./zeek-profile

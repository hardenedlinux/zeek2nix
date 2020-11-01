#!/usr/bin/env bash
current_dir=$(dirname "$0")
dir=$($current_dir/result/bin/zeek-config --zeek_dist)

export ZEEKPATH="$dir/share/zeek:$dir/share/zeek/policy:$dir/share/zeek/site"
export ZEEK_PLUGIN_PATH="$dir/lib/zeek/plugins"

# The packet filter and loaded scripts are disabled because they emit either
# timeless logs or logs with timestamp set to execution time rather than time
# of capture.
exec "$dir/bin/zeek" "$current_dir/brim_scripts.zeek" \
  -C -r - \
  --exec "event zeek_init() { Log::disable_stream(PacketFilter::LOG); Log::disable_stream(LoadedScripts::LOG); }" \
  local

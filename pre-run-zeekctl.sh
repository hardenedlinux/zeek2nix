#!/usr/bin/env bash
set -euo pipefail



if [[ ! -d "/var/lib/zeek" ]];then
    mkdir -p /var/lib/zeek/policy \
        /var/lib/zeek/spool \
        /var/lib/zeek/logs \
        /var/lib/zeek/scripts\
        /var/lib/zeek/etc
    cp ./module/* /var/lib/zeek/etc
    cp -r $(./result/bin/zeek-config --zeek_dist)/share/zeekctl/scripts/* /var/lib/zeek/scripts/
fi

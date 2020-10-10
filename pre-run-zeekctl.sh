#!/usr/bin/env bash
set -euo pipefail



if [ ! -d "/var/lib/zeek" ];then
    mkdir -p /var/lib/zeek/policy \
        /var/lib/zeek/spool \
        /var/lib/zeek/logs \
        /var/lib/zeek/scripts\
        /var/lib/zeek/etc
    cp ./module/node.cfg /var/lib/zeek/etc
    cp ./module/networks.cfg /var/lib/zeek/etc
    cp -r $(./result/bin/zeek-config --zeek_dist)/share/zeekctl/scripts/helpers /var/lib/zeek/scripts/
    cp -r $(./result/bin/zeek-config --zeek_dist)/share/zeekctl/scripts/postprocessors /var/lib/zeek/scripts/
    cp -r $(./result/bin/zeek-config --zeek_dist)/share/zeek/site/local.zeek /var/lib/zeek/policy
    for i in  run-zeek crash-diag         expire-logs        post-terminate     run-zeek-on-trace  stats-to-csv        check-config       expire-crash       make-archive-name  run-zeek           set-zeek-path             archive-log        delete-log     send-mail
    do
        ln -sf $(./result/bin/zeek-config --zeek_dist)/share/zeekctl/scripts/$i /var/lib/zeek/scripts/
   done
fi

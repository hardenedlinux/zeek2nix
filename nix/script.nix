{coreutils, rsync, openssh }:
''
   sed -i 's|/bin/rm|${coreutils}/bin/rm|' scripts/policy/misc/trim-trace-file.zeek
   sed -i 's|/bin/rm|${coreutils}/bin/rm|' scripts/base/frameworks/notice/main.zeek
   sed -i 's|/bin/rm|${coreutils}/bin/rm|' scripts/base/frameworks/logging/postprocessors/sftp.zeek

   sed -i 's|/bin/cat|${coreutils}/bin/cat|' scripts/base/frameworks/notice/actions/pp-alarms.zeek
   sed -i 's|/bin/cat|${coreutils}/bin/cat|' scripts/base/frameworks/notice/main.zeek

   sed -i 's|rsync %s|${rsync}/bin/rsync %s|' auxil/zeekctl/ZeekControl/execute.py

   substituteInPlace zeek-config.in --subst-var ZEEK_DIST

   export ZEEK_SRC=$(pwd)
''

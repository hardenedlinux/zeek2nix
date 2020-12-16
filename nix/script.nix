{coreutils}:
''
   sed -i 's|/bin/mv|${coreutils}/bin/mv|' scripts/base/frameworks/logging/writers/ascii.zeek
   sed -i 's|/bin/mv|${coreutils}/bin/mv|' scripts/policy/misc/trim-trace-file.zeek
   sed -i 's|/bin/cat|${coreutils}/bin/cat|' scripts/base/frameworks/notice/actions/pp-alarms.zeek
   sed -i 's|/bin/cat|${coreutils}/bin/cat|' scripts/base/frameworks/notice/main.zeek

   substituteInPlace zeek-config.in --subst-var ZEEK_DIST

   export ZEEK_SRC=$(pwd)
''

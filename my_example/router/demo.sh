#! /bin/sh -f
router/tb/scripts/compile.sh -LINEDEBUG
irun "$@" -append_log

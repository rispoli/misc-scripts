#!/usr/bin/env bash

set -o errexit                              # Force exit at the first error
set -o nounset                              # Treat unset variables as an error
set -o pipefail

export PS4='+ ${FUNCNAME[0]:+${FUNCNAME[0]}():}line ${LINENO}: '
syslogname="$(basename "$0")[$$]"
exec 3<> "/tmp/$0.$$.log"
BASH_XTRACEFD=3
echo "Tracing to syslog as $syslogname"
unset syslogname

debug() { echo "$@" >&3; }

set -x

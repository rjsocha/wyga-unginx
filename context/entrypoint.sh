#!/bin/sh
set -eu
if [ -n "${1-}" ]; then
  if [ "${1::1}" = "@" ]; then
    cmd="${1:1}"
    shift
    exec "${cmd}" "${@}"
  fi
fi
home-config
unginx-config
auth-config
exec /.entrypoint/nginx-slim "$@" || printf -- "::ERROR: chain loading error\n"
exit 1

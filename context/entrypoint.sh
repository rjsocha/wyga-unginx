#!/bin/sh
set -eu
home-config
unginx-config
auth-config
exec /.entrypoint/nginx-slim "$@" || printf -- "::ERROR: chain loading error\n"
exit 1

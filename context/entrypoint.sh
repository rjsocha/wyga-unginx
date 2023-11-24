#!/bin/sh
set -eu
configus-config
auth-config
exec /.entrypoint/nginx-slim "$@" || printf -- "::ERROR: chain loading error\n"
exit 1

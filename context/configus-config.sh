#!/bin/sh
set -eu
if [ -n "${CONFIGUS:-}" ]
then
  export CONFIGUS_ENDPOINT="${CONFIGUS_ENDPOINT:-configus}"
  printf -- "UNGINX RUNTIME: 1.0.0 (%s/%s) CONFIGUS: %s\n" "$(id -u)" "$(id -g)" "${CONFIGUS}" >&2 || true
  exec config-service "${CONFIGUS}"
fi

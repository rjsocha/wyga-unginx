#!/bin/sh
set -eu
if [ -n "${CONFIGUS:-}" ]; then
  export CONFIGUS_ENDPOINT="${CONFIGUS_ENDPOINT:-configus}"
  printf -- "UNGINX RUNTIME: 1.0.0 (%s/%s) CONFIGUS: %s\n" "$(id -u)" "$(id -g)" "${CONFIGUS}" >&2 || true
  exec config-service "${CONFIGUS}"
fi
if [ -n "${PROFILE:-}" ]; then
  if [ -f "/config/nginx/profile/${PROFILE}" ]; then
    cp -- "/config/nginx/profile/${PROFILE}" "/config/nginx/site/default"
  else
    printf -- "PROFILE NOT FOUND: %s\n" "${PROFILE}"
  fi
fi

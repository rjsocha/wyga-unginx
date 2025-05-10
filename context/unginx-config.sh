#!/bin/sh
set -eu
if [ -n "${CONFIGUS:-}" ]; then
  export CONFIGUS_ENDPOINT="${CONFIGUS_ENDPOINT:-configus}"
  printf -- "UNGINX RUNTIME: 1.0.0 (%s/%s) CONFIGUS: %s\n" "$(id -u)" "$(id -g)" "${CONFIGUS}" >&2 || true
  exec config-service "${CONFIGUS}"
fi
if [ -n "${UNGINX_PROFILE:-}" ]; then
  if [ -f "/config/nginx/profile/${UNGINX_PROFILE}" ]; then
    printf -- "PROFILE: %s\n" "${UNGINX_PROFILE}"
    cp -- "/config/nginx/profile/${UNGINX_PROFILE}" "/config/nginx/site/default"
  else
    printf -- "PROFILE: <MISSING>%s\n"
  fi
fi

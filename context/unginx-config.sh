#!/bin/sh
set -eu
if [ -n "${CONFIGUS:-}" ]; then
  export CONFIGUS_ENDPOINT="${CONFIGUS_ENDPOINT:-configus}"
  printf -- "UNGINX RUNTIME: 1.0.0 (%s/%s) CONFIGUS: %s\n" "$(id -u)" "$(id -g)" "${CONFIGUS}" >&2 || true
  exec config-service "${CONFIGUS}"
fi
if [ -n "${PROFILE-}" ] && [ "${PROFILE-}" != "none" ]; then
  if ! template-engine "${PROFILE}" "/config/nginx/site/default"; then
    rc=$?
    echo RC: $rc
    printf -- "ERROR: unable to render profile: %s\n" "${PROFILE}" >&2
    exit 100
  fi
fi

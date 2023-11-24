#!/bin/sh
set -euf
if [ -n "${USER_AUTH:-}" ]
then
  if [ -w "/config/nginx/password.db" ] && echo -n "${USER_AUTH}" | base64 -d >/dev/null 2>/dev/null
  then
    echo -n "${USER_AUTH}" | base64 -d >> "/config/nginx/password.db"
  fi
fi

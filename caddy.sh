#! /bin/bash -eu

echo "Run aria2c"

case $ENABLE_AUTH in
true)
  echo "Using Basic Auth config file "
  export CADDY_FILE=/usr/local/caddy/SecureCaddyfile
  ;;
*)
  echo "Using caddy without Basic Auth"
  export CADDY_FILE=/usr/local/caddy/Caddyfile
  ;;
esac

/usr/local/bin/caddy run -config ${CADDY_FILE} -adapter=caddyfile

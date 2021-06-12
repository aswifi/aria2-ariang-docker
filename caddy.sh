#! /bin/bash -eu

echo "Run aria2c and ariaNG"

echo "**** Generate basic auth password for caddy ****"
ARIA2_PWD_ENCRYPT=$(caddy hash-password -plaintext ${ARIA2_PWD})

case $ENABLE_AUTH in
true)
  echo "Using Basic Auth config file "
  export CADDY_FILE=/usr/local/caddy/SecureCaddyfile
  sed -i 's/ARIA2_USER/'"${ARIA2_USER}"'/g' ${CADDY_FILE}
  sed -i 's/ARIA2_PWD_ENCRYPT/'"${ARIA2_PWD_ENCRYPT}"'/g' ${CADDY_FILE}
  ;;
*)
  echo "Using caddy without Basic Auth"
  export CADDY_FILE=/usr/local/caddy/Caddyfile
  ;;
esac

/usr/local/bin/caddy run -config ${CADDY_FILE} -adapter=caddyfile

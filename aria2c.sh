#! /bin/bash -eu

if [ "$ARIA2_SSL" = "true" ]; then
echo "Start aria2 with secure config"

/usr/bin/aria2c --conf-path="/app/conf/aria2.conf" \
--enable-rpc --rpc-listen-all \
--rpc-certificate=/app/conf/key/aria2.crt \
--rpc-private-key=/app/conf/key/aria2.key \
--rpc-secret="$RPC_SECRET" --rpc-secure \

else

echo "Start aria2 with standard mode"
/usr/bin/aria2c --conf-path="/app/conf/aria2.conf" --enable-rpc --rpc-listen-all

fi

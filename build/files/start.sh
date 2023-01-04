#!/bin/bash

JWT_TOKEN="/goerli/geth/jwttoken"
until $(curl --silent --fail "http://dappmanager.my.ava.do/jwttoken.txt" --output "${JWT_TOKEN}"); do
  echo "Waiting for the JWT Token"
  sleep 5
done

export GETH_CMD="/usr/local/bin/geth \
    --datadir /goerli \
    --goerli \
    --port 39303 \
    --http \
    --http.addr=\"0.0.0.0\" \
    --http.corsdomain=\"*\" \
    --http.vhosts=\"*\" \
    --ws \
    --ws.origins=\"*\" \
    --ws.addr=\"0.0.0.0\" \
    --authrpc.vhosts=\"*\" \
    --authrpc.addr=\"0.0.0.0\" \
    --authrpc.port=\"8551\" \
    --authrpc.jwtsecret=\"${JWT_TOKEN}\" \
    ${EXTRA_OPTS}"

echo "EXTRA_OPTS=${EXTRA_OPTS}"
echo "GETH_CMD=$GETH_CMD"

# Print version to the log
/usr/local/bin/geth version

# Start supervisor
# (using exec: https://madflojo.medium.com/shutdown-signals-with-docker-entry-point-scripts-5e560f4e2d45)
exec /usr/bin/supervisord -c /etc/supervisord.conf

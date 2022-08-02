#!/bin/bash

# Create JWTToken if it does not exist yet
JWT_TOKEN="/goerli/geth/jwttoken"
if [ ! -f ${JWT_TOKEN} ]; then
    echo "Creating JWT Token"
    openssl rand -hex 32 | tr -d "\n" >${JWT_TOKEN}
    cat ${JWT_TOKEN}
fi

# make JWT token available via nginx
mkdir -p /usr/share/nginx/wizard/
cat ${JWT_TOKEN} | tail -1 >/usr/share/nginx/wizard/jwttoken
chmod 644 /usr/share/nginx/wizard/jwttoken

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
/usr/bin/supervisord -c /etc/supervisord.conf

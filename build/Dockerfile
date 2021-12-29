FROM ethereum/client-go:v1.10.14 as geth

# Pull Geth into a second stage deploy alpine container
FROM alpine:edge

RUN apk add --no-cache ca-certificates
COPY --from=geth /usr/local/bin/geth /usr/local/bin/geth

ENTRYPOINT geth --datadir /goerli --goerli --port 39303 --http --http.addr 0.0.0.0 --http.corsdomain "*" --http.vhosts "*" --ws --ws.origins "*" --ws.addr 0.0.0.0 $EXTRA_OPTS

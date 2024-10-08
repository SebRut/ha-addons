# copied from teddycloud
FROM ubuntu:latest as buildenv

RUN apt-get update \
    && apt-get install -y --no-install-recommends gcc protobuf-c-compiler build-essential git zip curl

COPY ./teddycloud /buildenv
WORKDIR /buildenv

RUN curl -f https://raw.githubusercontent.com/toniebox-reverse-engineering/tonies-json/release/tonies.json -o /buildenv/contrib/config/tonies.json || true
RUN curl -f https://raw.githubusercontent.com/toniebox-reverse-engineering/tonies-json/release/tonieboxes.json -o /buildenv/contrib/config/tonieboxes.json || true
RUN make zip

FROM ubuntu:latest
EXPOSE 80 443

RUN apt-get update \
    && apt-get install -y --no-install-recommends libubsan1 ffmpeg curl ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN update-ca-certificates

RUN mkdir -p /teddycloud/certs \
    && mkdir /teddycloud/config \
    && mkdir -p /teddycloud/data/content/default \
    && mkdir -p /teddycloud/data/library \
    && mkdir -p /teddycloud/data/firmware  \
    && mkdir -p /teddycloud/data/www \
    && mkdir -p /teddycloud/data/cache \
    && mkdir -p /tmp

COPY --from=buildenv \
    /buildenv/install/pre/certs/ /teddycloud/certs/
COPY --from=buildenv \
    /buildenv/install/pre/data/www/ /teddycloud/data/www/

COPY --from=buildenv \
    /buildenv/install/pre/*.sh /usr/local/bin/
COPY --from=buildenv \
    /buildenv/install/pre/teddycloud /usr/local/bin/teddycloud

COPY --from=buildenv /buildenv/install/zip/release.zip /tmp/teddycloud.zip

COPY teddycloud/docker/docker-entrypoint.sh /
RUN chmod +rx /docker-entrypoint.sh

# custom start
COPY entrypoint.sh /
RUN chmod +rx /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

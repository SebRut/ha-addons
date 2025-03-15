# copied from teddycloud
FROM ubuntu:22.04 AS buildenv

RUN apt-get update \
    && apt-get install -y --no-install-recommends gcc protobuf-c-compiler build-essential git zip curl ca-certificates

RUN update-ca-certificates

RUN git clone --depth 1 --recursive --branch tc_v0.6.4 https://github.com/toniebox-reverse-engineering/teddycloud.git buildenv/

WORKDIR /buildenv
RUN curl -f https://raw.githubusercontent.com/toniebox-reverse-engineering/tonies-json/release/tonies.json -o /buildenv/contrib/config/tonies.json || true
RUN curl -f https://raw.githubusercontent.com/toniebox-reverse-engineering/tonies-json/release/tonieboxes.json -o /buildenv/contrib/config/tonieboxes.json || true
RUN make zip

FROM ubuntu:24.04
EXPOSE 80 443 8443

RUN apt-get update \
    && apt-get install -y --no-install-recommends libubsan1 strace ffmpeg curl ca-certificates \
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

COPY --from=buildenv /buildenv/docker/docker-entrypoint.sh /
RUN chmod +rx /docker-entrypoint.sh

# custom start
COPY entrypoint.sh /
RUN chmod +rx /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

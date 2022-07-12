FROM alpine:latest
LABEL MAINTAINER="Daniel Isaac <daniel@sdunixgeek.com>"
ENV OC_VERSION=9.01

RUN set -ex \
    # 1. Refersh apk index
    && apk --update --no-progress upgrade \
    && apk add --no-progress ca-certificates \
    # 1. build and install openconnect (ref: https://github.com/gzm55/docker-vpn-client)
    ## 1.1 install runtime and build dependencies
    && apk add --no-progress --virtual .openconnect-run-deps \
    gnutls dirmngr gnutls-utils iptables libev libintl \
    libnl3 libseccomp linux-pam lz4 lz4-libs openssl \
    libxml2 nmap-ncat socat openssh-client \
    && apk add --no-progress --virtual .openconnect-build-deps \
    curl file g++ gnutls-dev dirmngr gpgme gzip libev-dev \
    libnl3-dev libseccomp-dev libxml2-dev linux-headers \
    linux-pam-dev lz4-dev lz4-libs make readline-dev tar \
    sed readline procps \
    ## 1.2 download vpnc-script
    && mkdir -p /etc/vpnc \
    && curl http://git.infradead.org/users/dwmw2/vpnc-scripts.git/blob_plain/HEAD:/vpnc-script -o /etc/vpnc/vpnc-script \
    && chmod 750 /etc/vpnc/vpnc-script \
    ## 1.3 create build dir, download, verify and decompress OC package to build dir
    && gpg --keyserver pgp.mit.edu --recv-key 0xbe07d9fd54809ab2c4b0ff5f63762cda67e2f359 \
    && mkdir -p /tmp/build/openconnect \
    && curl -SL "ftp://ftp.infradead.org/pub/openconnect/openconnect-$OC_VERSION.tar.gz" -o /tmp/openconnect.tar.gz \
    && curl -SL "ftp://ftp.infradead.org/pub/openconnect/openconnect-$OC_VERSION.tar.gz.asc" -o /tmp/openconnect.tar.gz.asc \
    && gpg --verify /tmp/openconnect.tar.gz.asc \
    && tar -xf /tmp/openconnect.tar.gz -C /tmp/build/openconnect --strip-components=1 \
    ## 1.4 build and install
    && cd /tmp/build/openconnect \
    && ./configure \
    && make \
    && make install \
    && cd / \
    # 2. cleanup
    && apk del .openconnect-build-deps \
    && rm -rf /var/cache/apk/* /tmp/* ~/.gnupg

RUN set -ex \
    # 1. Refersh apk index
    && apk --update --no-progress upgrade \
    && apk add --no-progress lftp

COPY scripts/entrypoint.sh /usr/local/bin/entrypoint.sh

VOLUME [ "/records" ]

ENV oc_vpnUser=""
ENV oc_vpnPass=""
ENV oc_serverCert=""
ENV oc_vpnServer=""
ENV oc_vpnProtocol=""
ENV oc_vpnPIDFile=""
ENV oc_ftpUser=""
ENV oc_ftpPass=""
ENV oc_ftpHost=""
ENV oc_ftpRemDir=""
ENV oc_ftpHostDir=""
ENV oc_ftpParallel=""
ENV oc_ftpUpdatePassword=""
ENV oc_ftpUpdatePassTransfer=""
ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]

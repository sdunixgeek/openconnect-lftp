FROM okampfer/openconnect-client
LABEL MAINTAINER="Daniel Isaac <daniel@sdunixgeek.com>"


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

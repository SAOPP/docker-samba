ARG SAMBA_VERSION=4.14.5

FROM alpine:3.14

ENV TZ="UTC"

ARG SAMBA_VERSION
ARG SAMBA_RELEASE
RUN apk --update --no-cache add \
    bash \
    coreutils \
    jq \
    samba=${SAMBA_VERSION}-r0 \
    shadow \
    tzdata \
    yq \
  && rm -rf /tmp/*

COPY entrypoint.sh /entrypoint.sh

EXPOSE 445

VOLUME [ "/data" ]

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "smbd", "-FS", "--no-process-group" ]

HEALTHCHECK --interval=120s --timeout=45s \
  CMD smbclient -L \\localhost -U % -m SMB3

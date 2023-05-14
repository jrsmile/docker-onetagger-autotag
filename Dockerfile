FROM alpine
ARG S6_OVERLAY_VERSION=3.1.5.0
ARG ONETAGGER_VERSION=1.6.0

ADD https://github.com/Marekkon5/onetagger/releases/download/${ONETAGGER_VERSION}/OneTagger-linux-cli.tar.gz /tmp
RUN tar -C / -xzf /tmp/OneTagger-linux-cli.tar.gz
CMD ["/tmp/./onetagger-cli","authorize-spotify","--client-id", "--client-secret"]
#audiofeatures --path <PATH> --config <CONFIG> --client-id <CLIENT_ID> --client-secret <CLIENT_SECRET>

ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-x86_64.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-x86_64.tar.xz
ENTRYPOINT ["/init"]
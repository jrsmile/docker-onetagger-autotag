FROM ubuntu
ARG S6_OVERLAY_VERSION=3.1.5.0
ARG ONETAGGER_VERSION=1.6.0

RUN apt-get update -y && apt-get upgrade -y && apt-get install tar xz-utils libasound2 -y

ADD https://github.com/Marekkon5/onetagger/releases/download/${ONETAGGER_VERSION}/OneTagger-linux-cli.tar.gz /tmp
RUN tar -C /usr/bin/ -xzf /tmp/OneTagger-linux-cli.tar.gz
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-x86_64.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-x86_64.tar.xz
ADD main /tmp
RUN --mount=type=secret,id=SPOTIFY_CLIENT_ID,required \
 --mount=type=secret,id=SPOTIFY_CLIENT_SECRET,required \
 cat /run/secrets/SPOTIFY_CLIENT_ID >> /tmp/cl_id && \
 cat /run/secrets/SPOTIFY_CLIENT_SECRET >> /tmp/cl_tk
RUN chmod +x /tmp/main
CMD ["/tmp/main"]
ENTRYPOINT ["/init"]
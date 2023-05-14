FROM ubuntu
ARG S6_OVERLAY_VERSION=3.1.5.0
ARG ONETAGGER_VERSION=1.6.0

RUN DEBIAN_FRONTEND=noninteractive apt-get -qq update -y && DEBIAN_FRONTEND=noninteractive apt-get -oDpkg::Use-Pty=false -qq upgrade -y && DEBIAN_FRONTEND=noninteractive apt-get -oDpkg::Use-Pty=false -qq install tar xz-utils libasound2 curl -y

ADD https://github.com/Marekkon5/onetagger/releases/download/${ONETAGGER_VERSION}/OneTagger-linux-cli.tar.gz /tmp
RUN tar -C /usr/bin/ -xzf /tmp/OneTagger-linux-cli.tar.gz
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-x86_64.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-x86_64.tar.xz
ADD main /tmp
ADD splogin /usr/bin
ADD autotag /usr/bin
RUN --mount=type=secret,id=SPOTIFY_CLIENT_ID,required \
 --mount=type=secret,id=SPOTIFY_CLIENT_SECRET,required \
 cat /run/secrets/SPOTIFY_CLIENT_ID > /tmp/cl && \
 echo -n ":" >> /tmp/cl &&\
 cat /run/secrets/SPOTIFY_CLIENT_SECRET >> /tmp/cl
RUN mkdir -p /root/.config/onetagger && \
  /usr/bin/./onetagger-cli --audiofeatures-config > /root/.config/onetagger/config.json
RUN chmod +x /tmp/main
RUN chmod +x /usr/bin/splogin
RUN chmod +x /usr/bin/autotag
CMD ["/tmp/main"]
ENTRYPOINT ["/init"]
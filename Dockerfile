FROM golang:alpine AS build-forego

RUN apk add --no-cache git openssh

WORKDIR /app

RUN git clone https://github.com/wahyd4/forego.git \
    && cd forego \
    && git checkout 20180216151118 \
    && go mod init \
    && go mod vendor \
    && go mod download \
    && go build -o forego \
    && chmod +x forego

FROM alpine:edge

LABEL AUTHOR=Junv<wahyd4@gmail.com>

WORKDIR /app

ENV RPC_SECRET=""
ENV ENABLE_AUTH=false
ENV ENABLE_RCLONE=false
ENV DOMAIN=:80
ENV ARIA2_SSL=false
ENV ARIA2_EXTERNAL_PORT=80
ENV PUID=1000
ENV PGID=1000
ENV CADDYPATH=/app
ENV XDG_DATA_HOME=/app/.caddy/data
ENV XDG_CONFIG_HOME=/app/.caddy/config

ADD install.sh aria2c.sh caddy.sh Procfile init.sh start.sh /app/
ADD conf /app/conf
ADD Caddyfile SecureCaddyfile /usr/local/caddy/

COPY --from=build-forego /app/forego/forego /app

RUN ./install.sh

RUN rm ./install.sh

# folder for storing ssl keys
VOLUME /app/conf/key

# file downloading folder
VOLUME /downloads

EXPOSE 80 443

HEALTHCHECK --interval=1m --timeout=3s \
  CMD curl -f http://localhost || exit 1

CMD ["./start.sh"]

#! /bin/sh -eux

echo "Set variables for $(arch)"

caddy_version=2.4.5
filebrowser_version=v2.17.2

case "$(arch)" in

   x86_64)
      platform=linux-amd64
      caddy_file=caddy_${caddy_version}_linux_amd64.tar.gz
     ;;
   armv7l)
     platform=linux-armv7
     caddy_file=caddy_${caddy_version}_linux_armv7.tar.gz
     ;;

   aarch64)
     platform=linux-arm64
     caddy_file=caddy_${caddy_version}_linux_arm64.tar.gz
     ;;

   *)
     echo "unsupported arch $(arch), exit now"
     exit 1
     ;;
esac

filebrowser_file=${platform}-filebrowser.tar.gz

adduser -D -u 1000 junv \
  && apk update \
  && apk add runit shadow wget bash curl openrc gnupg aria2 tar mailcap --no-cache \
  && wget -N https://github.com/caddyserver/caddy/releases/download/v${caddy_version}/${caddy_file} \
  && tar -zxf ${caddy_file} \
  && mv caddy /usr/local/bin/ \
  && rm -rf ${caddy_file} \
  && platform=linux-amd64 \
  && wget -N https://github.com/filebrowser/filebrowser/releases/download/${filebrowser_version}/${filebrowser_file} \
  && tar -zxf ${filebrowser_file} \
  && rm -rf ${filebrowser_file} \
  && rm LICENSE README.md CHANGELOG.md \
  && mkdir -p /usr/local/www \
  && mkdir -p /usr/local/www/aria2 \
  && rm -rf init /app/*.txt \
  && mkdir /usr/local/www/aria2/Download \
  && cd /usr/local/www/aria2 \
  && chmod +rw /app/conf/aria2.session \
  && wget -N --no-check-certificate https://github.com/aswifi/WebGL_temp/raw/main/WebGL_temp-1.0.zip \
  && unzip WebGL_temp-1.0.zip \
  && rm WebGL_temp-1.0.zip \
  && chmod -R 755 /usr/local/www/aria2

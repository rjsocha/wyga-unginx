# syntax=docker/dockerfile:1
ARG UPSTREAM=wyga/nginx-slim:latest
ARG CONFIGUS=wyga/configus:latest
FROM ${CONFIGUS} AS configus
FROM alpine:3 AS runtime

WORKDIR /dist/sbin
WORKDIR /dist/.entrypoint
WORKDIR /dist/etc/nginx
WORKDIR /dist/usr/share/nginx/404
WORKDIR /dist/.metadata
WORKDIR /

COPY --from=configus /client/config-service /dist/sbin/config-service
COPY --chmod=0755 entrypoint.sh /dist/.entrypoint/unginx
COPY --chmod=0755 home-config.sh /dist/sbin/home-config
COPY --chmod=0755 auth-config.sh /dist/sbin/auth-config
COPY --chmod=0755 unginx-config.sh /dist/sbin/unginx-config
COPY --chmod=0755 template-engine /dist/sbin/template-engine
COPY --chmod=0444 404.html /dist/usr/share/nginx/404/404.html
COPY --chmod=0444 configus.meta /dist/.metadata/configus
# Configuration
COPY --chmod=0644 nginx.conf /dist/etc/nginx/nginx.conf

WORKDIR /dist/config/nginx
WORKDIR /dist/config/nginx/http
WORKDIR /dist/config/nginx/stream
WORKDIR /dist/config/nginx/global
WORKDIR /dist/config/nginx/auth
WORKDIR /dist/config/nginx/depot
WORKDIR /dist/config/nginx/site
WORKDIR /dist/config/nginx/profile

COPY profile/ /dist/config/nginx/profile/

WORKDIR /dist/config/nginx
COPY --chmod=0666 http.conf    /dist/config/nginx/http/default
COPY --chmod=0666 empty.conf   /dist/config/nginx/stream/default
COPY --chmod=0666 global.conf  /dist/config/nginx/global/default
RUN chmod 0777 site http stream global auth depot
WORKDIR /

FROM ${UPSTREAM} AS mold
COPY --from=runtime /dist/ /
RUN rm -rf /etc/nginx/conf.d && chmod 777 /var/log/nginx /var/cache/nginx

FROM scratch
COPY --from=mold / /
STOPSIGNAL SIGQUIT
EXPOSE 8080
ENV LISTEN=8080
ENV PROFILE=default
ENV PATH=/bin:/sbin:/usr/sbin:/usr/bin
ENV HOME=/dev/shm/.home
USER 35000:35000
CMD ["nginx", "-g", "daemon off;" ]
ENTRYPOINT [ "/.entrypoint/unginx" ]

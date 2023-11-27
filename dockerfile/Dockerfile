# syntax=docker/dockerfile:1.6
ARG UPSTREAM
ARG CONFIGUS
FROM ${CONFIGUS} AS configus
FROM alpine as runtime
COPY --from=configus /client/config-service /dist/sbin/config-service
COPY --chmod=0755 entrypoint.sh /dist/.entrypoint/unginx
COPY --chmod=0755 auth-config.sh /dist/sbin/auth-config
COPY --chmod=0755 configus-config.sh /dist/sbin/configus-config
COPY 404.html /dist/usr/share/nginx/404/404.html
# Configuration
COPY --chmod=0666 http.conf /dist/config/nginx/http/default
COPY --chmod=0666 empty.conf /dist/config/nginx/stream/default
COPY --chmod=0666 global.conf /dist/config/nginx/global/default
COPY --chmod=0666 default.conf /dist/config/nginx/site/default
COPY --chmod=0644 nginx.conf /dist/etc/nginx/nginx.conf
RUN chmod 777 /dist/config/site /dist/config/nginx/http /dist/config/nginx/stream /dist/config/nginx/global

FROM ${UPSTREAM} AS mold
COPY --from=runtime /dist/ /
RUN rm -rf /etc/nginx/conf.d && chmod 777 /var/log/nginx /var/cache/nginx

FROM scratch
COPY --from=mold / /
EXPOSE 80
STOPSIGNAL SIGQUIT
USER 35000:35000
CMD ["nginx", "-g", "daemon off;" ]
ENTRYPOINT [ "/.entrypoint/unginx" ]

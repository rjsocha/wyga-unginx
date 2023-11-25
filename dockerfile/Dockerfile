# syntax=docker/dockerfile:1.6
ARG UPSTREAM
FROM alpine as runtime
COPY --from=wyga/configus:1.6.1 /client/config-service /dist/sbin/config-service
COPY --chmod=0755 entrypoint.sh /dist/.entrypoint/unginx
COPY --chmod=0755 auth-config.sh /dist/sbin/auth-config
COPY --chmod=0755 configus-config.sh /dist/sbin/configus-config
COPY 404.html /dist/usr/share/nginx/404/404.html
COPY --chmod=0666 default.conf /dist/config/nginx/http/default
COPY empty.conf /dist/config/nginx/stream/default
COPY --chmod=0666 main.conf /dist/config/nginx/main/default
COPY --chmod=0666 nginx.conf /dist/etc/nginx/nginx.conf
RUN chmod 777 /dist/config/nginx /dist/config/nginx/http /dist/config/nginx/stream/ /dist/config/nginx/main/

FROM ${UPSTREAM} AS mold
COPY --from=runtime /dist/ /
RUN rm -rf /etc/nginx/conf.d && chmod 777 /var/log/nginx /var/cache/nginx

FROM scratch
COPY --from=mold / /
EXPOSE 80
STOPSIGNAL SIGQUIT
CMD ["nginx", "-g", "daemon off;" ]
ENTRYPOINT [ "/.entrypoint/unginx" ]

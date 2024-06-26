# syntax=docker/dockerfile:1.6
ARG UPSTREAM
ARG CONFIGUS
FROM ${CONFIGUS} AS configus
FROM alpine as runtime
COPY --from=configus /client/config-service /dist/sbin/config-service
COPY --chmod=0755 entrypoint.sh /dist/.entrypoint/unginx
COPY --chmod=0755 home-config.sh /dist/sbin/home-config
COPY --chmod=0755 auth-config.sh /dist/sbin/auth-config
COPY --chmod=0755 configus-config.sh /dist/sbin/configus-config
COPY 404.html /dist/usr/share/nginx/404/404.html
COPY --chmod=0444 configus.meta /dist/.metadata/configus
# Configuration
COPY --chmod=0666 http.conf /dist/config/nginx/http/default
COPY --chmod=0666 empty.conf /dist/config/nginx/stream/default
COPY --chmod=0666 global.conf /dist/config/nginx/global/default
COPY --chmod=0666 default.conf /dist/config/nginx/site/default
COPY --chmod=0644 nginx.conf /dist/etc/nginx/nginx.conf
WORKDIR /dist/config/nginx
RUN mkdir -p depot auth mold
RUN chmod 777 site http stream global depot auth mold

FROM ${UPSTREAM} AS mold
COPY --from=runtime /dist/ /
RUN rm -rf /etc/nginx/conf.d && chmod 777 /var/log/nginx /var/cache/nginx

FROM scratch
COPY --from=mold / /
EXPOSE 80
STOPSIGNAL SIGQUIT
ENV PATH=/bin:/sbin:/usr/sbin:/usr/bin
ENV HOME=/dev/shm/.home
USER 35000:35000
CMD ["nginx", "-g", "daemon off;" ]
ENTRYPOINT [ "/.entrypoint/unginx" ]

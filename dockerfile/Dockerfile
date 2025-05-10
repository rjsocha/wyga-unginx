# syntax=docker/dockerfile:1.9
ARG UPSTREAM
ARG CONFIGUS
FROM ${CONFIGUS} AS configus
FROM alpine as runtime
COPY --from=configus /client/config-service /dist/sbin/config-service
COPY --chmod=0755 entrypoint.sh /dist/.entrypoint/unginx
COPY --chmod=0755 home-config.sh /dist/sbin/home-config
COPY --chmod=0755 auth-config.sh /dist/sbin/auth-config
COPY --chmod=0755 unginx-config.sh /dist/sbin/unginx-config
COPY --chmod=0444 404.html /dist/usr/share/nginx/404/404.html
COPY --chmod=0444 configus.meta /dist/.metadata/configus
# Configuration
COPY --chmod=0644 nginx.conf /dist/etc/nginx/nginx.conf
WORKDIR /dist/config/nginx
COPY --chmod=0666 http.conf    http/default
COPY --chmod=0666 empty.conf   stream/default
COPY --chmod=0666 global.conf  global/default
COPY --chmod=0666 default.conf site/default
COPY --chmod=0644 profile/ profile/
WORKDIR /dist/config/nginx/auth
WORKDIR /dist/config/nginx/depot
WORKDIR /dist/config/nginx/mold
WORKDIR /dist/config/nginx
RUN chmod 777 site http stream global depot auth mold
RUN echo "1" && ls -l /

FROM ${UPSTREAM} AS mold
COPY --from=runtime /dist/ /
RUN rm -rf /etc/nginx/conf.d && chmod 777 /var/log/nginx /var/cache/nginx
RUN echo "2" && ls -l /

FROM scratch
COPY --from=mold / /
RUN echo "3" && ls -l /
EXPOSE  
STOPSIGNAL SIGQUIT
ENV PATH=/bin:/sbin:/usr/sbin:/usr/bin
ENV HOME=/dev/shm/.home
USER 35000:35000
CMD ["nginx", "-g", "daemon off;" ]
ENTRYPOINT [ "/.entrypoint/unginx" ]

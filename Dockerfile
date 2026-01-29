FROM alpine:latest

ENV ORGANISATION_NAME="Planet Express, Inc."
ENV SUFFIX="dc=planetexpress,dc=com"
ENV ROOT_USER="admin"
ENV ROOT_PW="GoodNewsEveryone"

ENV LOG_LEVEL="stats"
RUN apk update --no-cache \
 && apk upgrade --no-cache \
 && apk add --no-cache --update "libssl3>3.5.4" "libcrypto3>3.5.4" gettext openldap openldap-clients openldap-back-mdb openldap-passwd-pbkdf2 openldap-overlay-memberof openldap-overlay-ppolicy openldap-overlay-refint \
 && mkdir -p /run/openldap /var/lib/openldap/openldap-data
RUN install -m 755 -o ldap -g ldap -d /var/lib/openldap/run
RUN apk add --no-cache "libssl3>3.5.4" "libxml2>2.13.9"
COPY ldif /ldif
COPY scripts/* /etc/openldap/
COPY docker-entrypoint.sh /

EXPOSE 389
EXPOSE 636

ENTRYPOINT ["/docker-entrypoint.sh"]

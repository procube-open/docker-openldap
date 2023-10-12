FROM alpine:3.18

RUN  apk update \
  && apk add gettext openldap openldap-clients openldap-back-mdb openldap-passwd-pbkdf2 openldap-overlay-memberof openldap-overlay-ppolicy openldap-overlay-refint supervisor openssl openldap-passwd-sha2 \
  && rm -rf /var/cache/apk/* \
  && mkdir -p /ldap

EXPOSE 389
EXPOSE 636

WORKDIR /root
RUN cp /etc/openldap/slapd.conf . \
  && echo "moduleload pw-sha2.so" >> slapd.conf

RUN mkdir /etc/openldap/slapd.d \
  && slaptest -f slapd.conf -F /etc/openldap/slapd.d \
  || chown -R ldap:ldap /etc/openldap/slapd.d \
  && chmod -R 000 /etc/openldap/slapd.d \
  && chmod -R u+rwX /etc/openldap/slapd.d \
  && rm /etc/openldap/slapd.conf \
  && mkdir /var/lib/openldap/run \
  && chown ldap:ldap /var/lib/openldap/run

COPY start-slapd.sh /var/lib/openldap/start-slapd.sh
COPY restore.sh /var/lib/openldap/restore.sh
COPY restore-config.sh /var/lib/openldap/restore-config.sh
RUN chmod +x /var/lib/openldap/*.sh
COPY supervisord.slapd.ini /etc/supervisor.d/slapd.ini

ENTRYPOINT [ "/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf" ]

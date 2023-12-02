FROM ubuntu:22.04

LABEL maintainer="lex_admin <andrey@best-home.xyz>" \
  name="pgpro" description="PostgresPro Standart"

ARG VERSION=std-16

ARG BINDIR=/opt/pgpro/${VERSION}/bin
ARG PGDATA=/var/lib/pgpro/${VERSION}/data
ARG LANG=ru_RU.UTF-8

ARG UID=1000
ARG GID=1000

ENV UID=${UID}
ENV GID=${GID}
ENV VERSION=${VERSION}

ENV PATH=${BINDIR}:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:
ENV BINDIR=${BINDIR}
ENV PGDATA=${PGDATA}
ENV LANG=${LANG}

RUN apt-get update && apt-get install -y wget &&\
    wget https://repo.postgrespro.ru/${VERSION}/keys/pgpro-repo-add.sh &&\
    sh pgpro-repo-add.sh && apt update &&\
    apt-get install -y postgrespro-${VERSION}-contrib locales ca-certificates language-pack-ru language-pack-ru-base &&\
    echo "ru_RU.UTF-8 UTF-8" >> /etc/locale.gen && echo "LANG=ru_RU.UTF-8\nLANGUAGE=ru_RU\n" > /etc/default/locale && echo $PATH > /etc/environment &&\
    update-locale && locale-gen && apt clean && rm -rfd /var/cache/apt

COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh


VOLUME [ "/var/lib/pgpro", "/tmp" ]
EXPOSE 5432/tcp

ENTRYPOINT [ "entrypoint.sh" ]
CMD [ "start" ]
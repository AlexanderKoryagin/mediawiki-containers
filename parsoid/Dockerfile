FROM wikimedia/nodejs

ARG http_proxy
ARG https_proxy

ENV http_proxy ${http_proxy}
ENV https_proxy ${https_proxy}


# https://www.mediawiki.org/wiki/Parsoid/Setup
RUN apt-key advanced --keyserver keys.gnupg.net --recv-keys 90E9F83F22250DD7
RUN echo "deb https://releases.wikimedia.org/debian jessie-mediawiki main" >> /etc/apt/sources.list.d/parsoid.list

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
        parsoid \
        ;

COPY docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD ["tail", "-f", "/var/log/parsoid/parsoid.log"]

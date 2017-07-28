FROM ubuntu:16.04

ARG MEDIAWIKI_VERSION
ARG http_proxy
ARG https_proxy

ENV MEDIAWIKI_VERSION ${MEDIAWIKI_VERSION}
ENV http_proxy ${http_proxy}
ENV https_proxy ${https_proxy}


# Upgrade
RUN apt-get update && apt-get upgrade -y;

# Utilities
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        netcat \
        git \
        ca-certificates \
        curl \
        software-properties-common \
        apt-utils \
        vim \
        imagemagick \
        ;

# PHP
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        php-mysql \
        php-cli \
        php-gd \
        php-curl \
        php-mbstring \
        php-xml \
        php-ldap \
        php-memcache \
        php-imagick \
        php-intl \
        ;

# Apache2
RUN set -x ;\
    apt-get update && \
    apt-get install -y --no-install-recommends \
        apache2 \
        libapache2-mod-php ;\
    rm -rf /var/lib/apt/lists/* ;\
    rm -rf /var/cache/apt/archives/* ;\
    a2enmod rewrite ;\
    a2enmod proxy ;\
    a2enmod proxy_http ;\
    # Remove the default Debian index page.
    rm /var/www/html/index.html ;
RUN apache2ctl restart

RUN \
    set -x ;\
    GITHUB='https://github.com/wikimedia' ;\
    GITCLONE="git clone -v --progress -b ${MEDIAWIKI_VERSION}" ;\
    mkdir -p /usr/src ;\
    ${GITCLONE} -b ${MEDIAWIKI_VERSION} ${GITHUB}/mediawiki.git /usr/src/mediawiki ;\
    cd /usr/src/mediawiki ;\
    # skin + vendor
    ${GITCLONE} ${GITHUB}/mediawiki-skins-Vector.git ./skins/Vector ;\
    ${GITCLONE} ${GITHUB}/mediawiki-vendor.git ./vendor ;\
    # VisualEditor
    ${GITCLONE} ${GITHUB}/mediawiki-extensions-VisualEditor.git ./extensions/VisualEditor ;\
    cd ./extensions/VisualEditor; git submodule update --init ; cd ../.. ;\
    # Extensions
    ${GITCLONE} ${GITHUB}/mediawiki-extensions-WikiEditor.git ./extensions/WikiEditor ;\
    ${GITCLONE} ${GITHUB}/mediawiki-extensions-SyntaxHighlight_GeSHi.git ./extensions/SyntaxHighlight_GeSHi ;\
    ${GITCLONE} ${GITHUB}/mediawiki-extensions-ParserFunctions.git ./extensions/ParserFunctions ;\
    ${GITCLONE} ${GITHUB}/mediawiki-extensions-PageImages.git ./extensions/PageImages ;\
    ${GITCLONE} ${GITHUB}/mediawiki-extensions-Nuke.git ./extensions/Nuke ;\
    ${GITCLONE} ${GITHUB}/mediawiki-extensions-Cite.git ./extensions/Cite ;\
    ${GITCLONE} ${GITHUB}/mediawiki-extensions-CodeEditor.git ./extensions/CodeEditor ;\
    ${GITCLONE} ${GITHUB}/mediawiki-extensions-LdapAuthentication.git ./extensions/LdapAuthentication ;

# Custom Config
# TODO need to get PHP version (7.0) from container
COPY custom_cfg/php.ini /etc/php/7.0/cli/conf.d/mediawiki.ini
RUN apache2ctl restart

COPY custom_cfg/apache/mediawiki.conf /etc/apache2/
RUN echo "Include /etc/apache2/mediawiki.conf" >> /etc/apache2/apache2.conf

COPY docker-entrypoint.sh /entrypoint.sh

EXPOSE 80 443
ENTRYPOINT ["/entrypoint.sh"]
CMD ["apachectl", "-e", "info", "-D", "FOREGROUND"]

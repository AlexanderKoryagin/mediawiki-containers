# MediaWiki is not yet fully compatible with PHP 7.1
# FastCGI Process Manager
FROM php:fpm

ARG MEDIAWIKI_VERSION
ARG http_proxy
ARG https_proxy

ENV MEDIAWIKI_VERSION ${MEDIAWIKI_VERSION}
ENV http_proxy ${http_proxy}
ENV https_proxy ${https_proxy}

ENV MW_DIR /data/sites/wiki


## Utilities
RUN apt-get update && \
    apt-get upgrade -y && \
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

## PHP Extensions
RUN apt-get update && \
    apt-get install -y \
        libicu-dev \
        libldap2-dev \
        ;\
    # MySQL
    docker-php-ext-install mysqli ;\
    # intl PECL extension for Unicode normalization
    docker-php-ext-install intl ;\
    # LDAP
    rm -rf /var/lib/apt/lists/* ;\
    docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ ;\
    docker-php-ext-install ldap ;\
    # APCu
    pear config-set http_proxy ${http_proxy} ;\
    docker-php-ext-install opcache &&\
    pecl channel-update pecl.php.net &&\
    yes 'n' | pecl install apcu &&\
    docker-php-ext-enable apcu \
    ;

## Clone MediaWiki
WORKDIR ${MW_DIR}
RUN set -x ;\
    GITHUB='https://github.com/wikimedia' ;\
    GITCLONE="git clone -v --progress --single-branch --branch ${MEDIAWIKI_VERSION}" ;\
    # Mediawiki
    ${GITCLONE} ${GITHUB}/mediawiki.git ${MW_DIR} ;\
    # Skin + Vendor
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

# Custom PHP Config
COPY ./php_cfg_mediawiki.ini /usr/local/etc/php/conf.d/mediawiki.ini


COPY docker-entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["php-fpm", "-F"]

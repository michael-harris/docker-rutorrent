FROM neosar/docker-rtorrent-base:latest

# set env
ENV PKG_CONFIG_PATH=/usr/local/lib/pkgconfig
ENV LD_LIBRARY_PATH=/usr/local/lib
ENV CONTEXT_PATH=/
    
RUN NB_CORES=${BUILD_CORES-`getconf _NPROCESSORS_CONF`} && \
  apk update && \
  apk upgrade && \
  apk add --no-cache \
    bash-completion \
    ca-certificates \
    fcgi \
    ffmpeg \
    geoip \
    gzip \
    logrotate \
    nginx \
    dtach \
    tar \
    unrar \
    unzip \
    sox \
    wget \
    irssi \
    irssi-perl \
    zlib \
    zlib-dev \
    libxml2-dev \
    perl-archive-zip \
    perl-net-ssleay \
    perl-digest-sha1 \
    git \
    libressl \
    binutils \
    findutils \
    zip \
    php7 \
    php7-cgi \
    php7-fpm \
    php7-json  \
    php7-mbstring \
    php7-sockets \
    php7-pear && \
# install build packages
  apk add -X http://dl-cdn.alpinelinux.org/alpine/v3.6/main --no-cache --virtual=build-dependencies \
    autoconf \
    automake \
    cppunit-dev \
    perl-dev \
    file \
    g++ \
    gcc \
    libtool \
    make \
    ncurses-dev \
    build-base \
    libtool \
    subversion \
    cppunit-dev \
    linux-headers \
    curl-dev \
    libressl-dev && \
# install webui
  mkdir -p \
    /usr/share/webapps/rutorrent \
    /defaults/rutorrent-conf && \
  git clone https://github.com/Novik/ruTorrent.git /usr/share/webapps/rutorrent/ && \
  mv /usr/share/webapps/rutorrent/conf/* /defaults/rutorrent-conf/ && \
  rm -rf /defaults/rutorrent-conf/users && \
# install webui extras
# QuickBox Theme
  git clone https://github.com/QuickBox/club-QuickBox /usr/share/webapps/rutorrent/plugins/theme/themes/club-QuickBox && \
  git clone https://github.com/Phlooo/ruTorrent-MaterialDesign /usr/share/webapps/rutorrent/plugins/theme/themes/MaterialDesign && \
# ruTorrent plugins
  cd /usr/share/webapps/rutorrent/plugins/ && \
  git clone https://github.com/orobardet/rutorrent-force_save_session force_save_session && \
  git clone https://github.com/AceP1983/ruTorrent-plugins  && \
  mv ruTorrent-plugins/* . && \
  rm -rf ruTorrent-plugins && \
  apk add --no-cache cksfv && \
  git clone https://github.com/nelu/rutorrent-thirdparty-plugins.git && \
  mv rutorrent-thirdparty-plugins/* . && \
  rm -rf rutorrent-thirdparty-plugins && \
  cd /usr/share/webapps/rutorrent/ && \
  chmod 755 plugins/filemanager/scripts/* && \
  rm -rf plugins/fileupload && \
  cd /tmp && \
  git clone https://github.com/mcrapet/plowshare.git && \
  cd plowshare/ && \
  make install && \
  cd .. && \
  rm -rf plowshare* && \
  apk add --no-cache unzip bzip2 && \
  cd /tmp && \
  wget http://www.rarlab.com/rar/rarlinux-x64-5.4.0.tar.gz && \
  tar zxvf rarlinux-x64-5.4.0.tar.gz && \
  mv rar/rar /usr/bin && \
  mv rar/unrar /usr/bin && \
  rm -rf rar && \
  rm rarlinux-* && \
  cd /usr/share/webapps/rutorrent/plugins/ && \
  git clone https://github.com/Gyran/rutorrent-pausewebui pausewebui && \
  git clone https://github.com/Gyran/rutorrent-ratiocolor ratiocolor && \
  sed -i 's/changeWhat = "cell-background";/changeWhat = "font";/g' /usr/share/webapps/rutorrent/plugins/ratiocolor/init.js && \
  git clone https://github.com/Gyran/rutorrent-instantsearch instantsearch && \
  git clone https://github.com/xombiemp/rutorrentMobile && \
  git clone https://github.com/dioltas/AddZip && \
# install autodl-irssi perl modules
  perl -MCPAN -e 'my $c = "CPAN::HandleConfig"; $c->load(doit => 1, autoconfig => 1); $c->edit(prerequisites_policy => "follow"); $c->edit(build_requires_install_policy => "yes"); $c->commit' && \
  curl -L http://cpanmin.us | perl - App::cpanminus && \
  cpanm HTML::Entities XML::LibXML JSON JSON::XS && \
# cleanup
  apk del --purge build-dependencies && \
  apk del -X http://dl-cdn.alpinelinux.org/alpine/v3.6/main cppunit-dev && \
  rm -rf /tmp/*

# add local files
COPY includes/ /

# ports and volumes
EXPOSE 80 51415 6882
VOLUME /config /downloads /socket

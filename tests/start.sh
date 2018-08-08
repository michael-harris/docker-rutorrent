docker run -it \
--rm \
--name rutorrent \
--mount source=rtorrent-socket,target=/socket \
--mount source=rtorrent-downloads,target=/downloads \
--mount source=rtorrent-config,target=/config \
-e PUID=1000 \
-e PGID=1000 \
-p 80:80 \
neosar/docker-rutorrent \
/bin/bash

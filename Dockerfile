FROM ubuntu:latest

ENV PUID=1100
ENV PGID=1100

ENV STEAM_CMD_DIR="/opt/steamcmd"
ENV ARK_FOLDER="/home/dark/arkserver"

ENV TINI_VERSION=v0.19.0

# Install dependencies
RUN \
	dpkg --add-architecture i386; \
 	apt-get update -y; \
  	apt-get install -y lib32gcc-s1; \
        apt-get install -y --no-install-recommends jq curl wget tar unzip nano gzip iproute2 procps software-properties-common dbus lib32gcc-s1; \

        apt-get clean; \
	rm -rf /var/lib/apt/lists/* 

# Install steamcmd
RUN mkdir $STEAM_CMD_DIR
WORKDIR $STEAM_CMD_DIR
RUN \
	wget -qO- https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz | tar zxvf -; \
 	chmod +x $STEAM_CMD_DIR/steamcmd.sh; \
  	chmod +x $STEAM_CMD_DIR/linux32/steamcmd; \
   	chown -R $PUID:$PGID $STEAM_CMD_DIR

# Add user
RUN \
	groupadd -g $PGID dark; \
	useradd -b /home/dark -g $PGID -u $PUID -G users -m dark; \
	mkdir $ARK_FOLDER; \
	chown $PUID:$PGID $ARK_FOLDER


# Install TINI
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

# Copy over scripts to image
COPY --chown=dark:dark scripts/ /home/dark/scripts
RUN chmod +x /home/dark/scripts/*.sh

USER dark
WORKDIR /home/dark

ENTRYPOINT ["/tini", "--", "/home/dark/scripts/Update_ark.sh"]

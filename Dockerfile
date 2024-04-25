FROM ubuntu:latest

ENV PUID=1100
ENV PGID=1100

ENV STEAM_CMD_DIR="/opt/steamcmd"
ENV ARK_FOLDER="/home/dark/arkserver"

ENV TINI_VERSION=v0.19.0

# Install dependencies
RUN <<EOF
	add-apt-repository multiverse
	dpkg --add-architecture i386
        apt-get install -y --no-install-recommends jq curl wget tar unzip nano gzip iproute2 procps software-properties-common dbus lib32gcc-s1

        apt-get clean
	rm -rf /var/lib/apt/lists/*
EOF

# Install steamcmd
RUN <<EOF
	mkdir ${STEAM_CMD_DIR}
	chown $PUID:$PGID ${STEAM_CMD_DIR}
EOF
WORKDIR ${STEAM_CMD_DIR}
RUN <<EOF	
	curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -
EOF

# Add user
RUN <<EOF
	groupadd -g $PGID
	useradd -b /home/dark -g $PGID -u $PUID -G users -m dark
	mkdir $ARK_FOLDER
	chown $PUID:$PGID $ARK_FOLDER
EOF

# Install TINI
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

scripts
COPY --chown=dark:dark scripts/ /home/dark/scripts
RUN chmod +x /home/dark/scripts/*.sh

USER dark
WORKDIR /home/dark

ENTRYPOINT ["/tini", "--", "/home/dark/scripts/Update_ark.sh"]

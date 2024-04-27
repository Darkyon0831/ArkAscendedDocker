# MIT License

# Copyright (c) 2024 Adrian Rondahl

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.


FROM ubuntu:latest

ENV PUID=1005
ENV PGID=1005

ENV STEAM_CMD_DIR="/opt/steamcmd"
ENV ARK_FOLDER="/home/dark/arkserver"

ENV TINI_VERSION=v0.19.0

# Install dependencies
RUN \
	dpkg --add-architecture i386; \
 	apt-get update -y; \
  	apt-get install -y lib32gcc-s1; \
    apt-get install -y --no-install-recommends jq xvfb wine64 curl wget tar unzip nano gzip iproute2 procps software-properties-common dbus lib32gcc-s1; \

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

ENTRYPOINT ["/tini", "--", "/home/dark/scripts/Start_ark.sh"]

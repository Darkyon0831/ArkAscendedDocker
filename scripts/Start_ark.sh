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

#!/bin/bash
ServerName="$SESSION_NAME"
MapName="$MAP_NAME"
Port_="$Port"
ServerPassword="lolipop"
RconPort=27020

Xvfb :1 -screen 0 1024x768x16 &

./scripts/Update_ark.sh

BATTLEEYE_ARG=""
MODS_ARG=""
CLUSTER_ID_ARG=""

if [ $BATTLEYE = "FALSE" ]; then
    BATTLEEYE_ARG="-NoBattlEye"
fi 

if [ -n $MOD_IDS ]; then
    echo "Here"
    MODS_ARG="-mods=$MOD_IDS"
fi

if [ -n $CLUSTER_ID ]; then
    CLUSTER_ID_ARG="-clusterID=$CLUSTER_ID"
fi

echo "$CLUSTER_ID_ARG"

DISPLAY=:1 wine "$ARK_FOLDER"/ShooterGame/Binaries/Win64/ArkAscendedServer.exe "$MAP_NAME"?listen?SessionName="$SESSION_NAME"?MaxPlayers="$MAX_PLAYERS"?ServerPassword="$SERVER_PASSWORD"?ServerAdminPassword="$SERVER_ADMIN_PASSWORD"?RCONEnabled=True?RCONPort="$RconPort""$CUSTOM_ARGS" -Port="$Port" -log "$BATTLEEYE_ARG" -WinLiveMaxPlayers="$MAX_PLAYERS" "$MODS_ARG" "$CLUSTER_ID_ARG"

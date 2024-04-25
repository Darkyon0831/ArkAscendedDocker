#!/bin/bash
echo $ARK_FOLDER
$STEAM_CMD_DIR/steamcmd.sh +force_install_dir "$ARK_FOLDER" +login anonymous +@sSteamCmdForcePlatformType windows +app_update 2430930 +quit
while true
do

done

#!/bin/bash
echo $ARK_FOLDER
$STEAM_CMD_DIR/steamcmd.sh +force_install_dir "$ARK_FOLDER" +login anonymous +@sSteamCmdForcePlatformType windows +app_update 2430930 +quit
cat /home/dark/dark/Steam/steamapps/appmanifest_2430930.acf
find "/home/dark/dark/Steam/steamapps/common/ARK Survival Ascended Dedicated Server" -type f -printf "%f\n"
ls "/home/dark/dark/Steam/steamapps/common/ARK Survival Ascended Dedicated Server"
ls "/home/dark/arkserver"

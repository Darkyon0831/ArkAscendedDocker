#!/bin/bash
echo $ARK_FOLDER
$STEAM_CMD_DIR/steamcmd.sh +@sSteamCmdForcePlatformType windows +force_install_dir /home/dark/arkserver +login anonymous +app_update 2430930 +quit
echo "\nManifest"
cat /home/dark/dark/Steam/steamapps/appmanifest_2430930.acf

echo "\nFind"
find "/home/dark/dark/Steam/steamapps/common/ARK Survival Ascended Dedicated Server" -type f -printf "%f\n"

echo "\nSteam"
ls "/home/dark/dark/Steam/steamapps/common/ARK Survival Ascended Dedicated Server"

echo "\nArkserver"
ls "/home/dark/arkserver"

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
ls /home/dark/scripts
source /home/dark/scripts/common.sh

ServerName="$SESSION_NAME"
MapName="$MAP_NAME"
Port_="$Port"
ServerPassword="lolipop"
RconPort=27020
Pid_File="/home/dark/.server.pid"

Xvfb :1 -screen 0 1024x768x16 &

/home/dark/scripts/Update_ark.sh

BATTLEEYE_ARG=""
MODS_ARG=""
CLUSTER_ID_ARG=""

if [ $BATTLEYE = "FALSE" ]; then
    BATTLEEYE_ARG="-NoBattlEye"
fi 

if [  $MOD_IDS != ""  ] && [ $MOD_IDS != " " ]; then
    echo "Here"
    echo $MOD_IDS
    MODS_ARG="-mods=$MOD_IDS"
fi

if [  $CLUSTER_ID != ""  ] && [ $CLUSTER_ID != " " ]; then
    CLUSTER_ID_ARG="-clusterID=$CLUSTER_ID"
fi

server_command="DISPLAY=:1 wine $ARK_FOLDER/ShooterGame/Binaries/Win64/ArkAscendedServer.exe $MAP_NAME?listen?SessionName=$SESSION_NAME?MaxPlayers=$MAX_PLAYERS?ServerPassword=$SERVER_PASSWORD?ServerAdminPassword=$SERVER_ADMIN_PASSWORD?RCONEnabled=True?RCONPort=$RconPort$CUSTOM_ARGS -Port=$Port -log $BATTLEEYE_ARG -WinLiveMaxPlayers=$MAX_PLAYERS $MODS_ARG $CLUSTER_ID_ARG"

if [ -f "$ARK_FOLDER/ShooterGame/Saved/Logs/ShooterGame.log" ]; then
    rm "$ARK_FOLDER/ShooterGame/Saved/Logs/ShooterGame.log"
fi

print_message_color_space "Starting server using wine...."
bash -c "$server_command" &

Server_Pid=$!

print_message_color_space "Server process started with PID: $Server_Pid"

if [ -f "$Pid_File" ]; then
    rm "$Pid_File"
fi

touch "$Pid_File"
echo "$Server_Pid" > "$Pid_File"

print_message "PID $Server_Pid written to $Pid_File"

timeout=30
elapsed=0
print_message_color_space "Waiting for ShooterGame.log to be created..."
while [ ! -f "$ARK_FOLDER/ShooterGame/Saved/Logs/ShooterGame.log" ]; do
    if [ $elapsed -ge $timeout ]; then
        print_message "Error: ShooterGame.log not created within the specified timeout. Server may have failed to start."
        print_message "Please check the server logs for more information."
        kill $Server_Pid
        exit 1
    fi
    sleep 2
    ls "$ARK_FOLDER/ShooterGame/Saved/Logs"
    elapsed=$((elapsed + 2))
done

print_message_color_space "Found ShooterGame.log file, will now tail :D"
cat "$ARK_FOLDER/ShooterGame/Saved/Logs/ShooterGame.log"
tail -f "$ARK_FOLDER/ShooterGame/Saved/Logs/ShooterGame.log" &
Tail_Pid=$!

elapsed=0
while [ $elapsed -lt $timeout ]; do
    if [ -f "$ARK_FOLDER/ShooterGame/Saved/Logs/ShooterGame.log" ] && grep -q "Server started" "$ARK_FOLDER/ShooterGame/Saved/Logs/ShooterGame.log"; then
        print_message_color_space "Server started successfully. PID: $SERVER_PID"
        break
    fi
    sleep 10
    elapsed=$((elapsed + 10))
done

wait "$Server_Pid"
print_message "Server stopped"
kill "$Tail_Pid"
print_message "Stopped tailing ShooterGame.log."


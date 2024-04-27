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
ServerName="Darkyon test server"
MapName="ScorchedEarth_WP"
Port=7780
ServerPassword="lolipop"
RconPort="27020"

./scripts/Update_ark.sh

wine $ARK_FOLDER/ShooterGame/Binaries/Win64/ArkAscendedServer.exe "$MapName"?listen?SessionName="$ServerName"?Port="$Port"?MaxPlayers=5?ServerPassword="$ServerPassword" -log -NoBattleEye -WinLiveMaxPlayers=5 & >> .server.pid
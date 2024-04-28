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

# Stop_ark.sh <time_to_wait? default is 0 >

#!/bin/bash
time_to_wait="$1"

if [ "$time_to_wait" = "" ]; then 
    time_to_wait=0 
fi

if [ "$time_to_wait" -gt 0 ]; then
    /home/dark/scripts/rcon_command "Broadcast Server shutdown started...\nTime to shutdown: $time_to_wait secconds"
    sleep "$time_to_wait"
    /home/dark/scripts/rcon_command "SaveWorld"
else
    /home/dark/scripts/rcon_command "Broadcast Server immidiate shutdown started..."
    /home/dark/scripts/rcon_command "SaveWorld"
fi

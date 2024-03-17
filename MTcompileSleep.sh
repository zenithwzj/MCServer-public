#! /bin/bash
# $ From <MTcompileSLeep.bat>:Synchronous


# Aligned to source:0

g++ src/cpTimer.cpp -o ./Timer > TCPLE.log 2>&1
sudo bash -c ./Timer &
g++ src/Sleep.cpp -o ./sleep >>TCPLE.log 2>&1
sudo apt-get install libjsoncpp-dev -y >>TCPLE.log 2>&1 ; g++ -o WriteSecret src/WriteSecret.cpp -I"/usr/include/jsoncpp" -ljsoncpp >>TCPLE.log 2>&1
g++ -o ReplaceSecret src/ReplaceSecret.cpp >>TCPLE.log 2>&1
echo '[MTcompileSleep] Compiling finished:3 programs' >>./TCPLE.log 2>&1
./sleep 255 >>./TCPLE.log 2>&1
echo '[MTcompileSleep] Sleep.exe initialization finished' >>./TCPLE.log 2>&1
exit
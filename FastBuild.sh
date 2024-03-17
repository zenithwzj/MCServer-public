#! /bin/bash
# $ From <FastBuild>:Synchronous


# Aligned to source:0

# echo '[INFO][FastBuild] Restoring token ...'
# ./WriteSecret "$1" "$PWD/openp2p.config.json" ; echo "$1" "$PWD/openp2p.config.json"
echo '[INFO][FastBuild] Creating workspace(WKSPC) ...'
2>/dev/null mkdir -p WKSPC
cd WKSPC

echo '[INFO][FastBuild] Downloading Prebuilt spigot-1.20.1.jar ...'
curl -Ls https://github.com/zenithwzj/Spigot-1.20.1-Server-Prebuilt/releases/download/main/spigot-1.20.1.jar -ospigot-1.20.1.jar --parallel-max 100
if ! [ -f spigot-1.20.1.jar ]; then 
    >&2 echo '[ERROR][FastBuild] Failed to download spigot-1.20.1.jar! The script is going to exit...'
    exit
fi 

echo '[INFO][FastBuild] Downloading openjdk21.zip ...'
curl -Ls https://download.java.net/java/GA/jdk21.0.2/f2283984656d49d69e91c558476027ac/13/GPL/openjdk-21.0.2_linux-x64_bin.tar.gz -oopenjdk21.tar.gz --parallel-max 100
if ! [ -f openjdk21.tar.gz ]; then
    >&2 echo '[ERROR][FastBuild] Failed to download openjdk21.tar.gz! The script is going to exit...'
    exit
fi 
echo '[INFO][FastBuild] Unpacking openjdk21.tar.gz ...'
tar -zxf openjdk21.tar.gz
rm -f openjdk21.tar.gz

echo '[INFO][FastBuild] Downloading openp2p.tar.gz v3.15.3 @ openp2p.cn ...'
curl -Ls https://openp2p.cn/download/v1/3.15.3/openp2p-latest.linux-amd64.tar.gz -oopenp2p.tar.gz --parallel-max 100
if ! [ -f openp2p.tar.gz ]; then 
    >&2 echo '[ERROR][FastBuild] Failed to download openp2p.tar.gz! The script is going to exit...'
    exit
fi 
echo '[INFO][FastBuild] Unpacking openp2p ...'
tar -zxf openp2p.tar.gz
rm -f openp2p.tar.gz

echo '[INFO][FastBuild] Copying config.json for openp2p.exe ...'
mv -f ../openp2p.config.json ./config.json
# echo '[INFO][FastBuild] Starting openp2p ...'
# bash -c ./openp2p & # src:36 Logical Change(+): output to console

echo '[INFO][FastBuild] Creating workspace for Minecraft Server ...'
2>/dev/null mkdir -p server
echo '[INFO][FastBuild] Preparing workspace for Minecraft Server ...'
mv -f spigot-1.20.1.jar server
mv -f ../archive.zip server/server.zip
cd server
echo '[INFO][FastBuild] Unpacking game archive ...'
tar -xf server.zip
cd ..
rm -f server/server.zip

cd server

# src:51 Logical Change(-): omit unnecessary output: openp2p outputs to console
echo '[INFO][FastBuild] Starting Minecraft Server ...'
bash -c "../jdk-21.0.2/bin/java -Xms1G -Xmx4G -jar spigot-1.20.1.jar nogui" & # src:53 Logical Restructure: The transcribed command uses a new structure but does the same thing to the source file.
cd .. ; timeout -s 15 10h bash -c ./openp2p ; cd server
echo '[INFO][FastBuild] openp2p stopped! ...'
echo '[INFO][FastBuild] Checking java process status ...'
ps -lwFC java
echo '[INFO][FastBuild] Killing java (Output reserved only if succeed)...'
pkill -ein --signal 15 java 2>/dev/null
cd ..

echo '[INFO][FastBuild] Preparing to upload logs ...'
2>/dev/null mkdir -p packwork/server
cp -f log/openp2p.log ../openp2p.log
if [ -f ../openp2p.log ]; then 
    rm -rf log
else >&2 echo '[ERROR][FastBuild] Error Copying openp2p.log!' ; fi

echo '[INFO][FastBuild] Preparing to upload configs ...'
cp -fp config.json packwork

echo '[INFO][FastBuild] Copying server ...'
2>/dev/null mkdir -p packwork/server ; cp -fprt packwork server # src:73 Logical Restructure: The transcribed command uses a new structure but does the same thing to the source file.
echo '[INFO][FastBuild] Packing server ...'
rm -f packwork/server/spigot-1.20.1.jar
cd packwork/server ; rm -rf bundler ; tar -cf ../server.zip ./* ; cd ../..

echo '[INFO][FastBuild] Removing token ...'
cd ..
if [ -f WriteSecret ]; then ./WriteSecret 00000000000000000000 ./WKSPC/packwork/config.json ; fi
# ./ReplaceSecret $1 ./openp2p.log 00000000000000000000 ./Wopenp2p.log
# echo '[INFO][FastBuild] Packing logs.gz ...'
# tar -czf ./WKSPC/packwork/logs.gz ./TCPLE.log ./Ttimer.log ./Wopenp2p.log &
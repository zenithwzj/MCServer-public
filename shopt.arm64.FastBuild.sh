#! /bin/bash
# $ From <FastBuild>:Synchronous
# Aligned to source:0

echo '[INFO][FastBuild] Creating workspace(WKSPC) ...'
2>/dev/null mkdir -p WKSPC
cd WKSPC

echo '[INFO][FastBuild] Downloading Prebuilt spigot-1.20.1.jar ...'
curl -Ls https://github.com/zenithwzj/Spigot-1.20.1-Server-Prebuilt/releases/download/main/spigot-1.20.1.jar -ospigot-1.20.1.jar --parallel-max 100
if ! [ -f spigot-1.20.1.jar ]; then 
    >&2 echo '[ERROR][FastBuild] Failed to download spigot-1.20.1.jar! The script is going to exit...'
    exit
fi 











echo '[INFO][FastBuild] Downloading openp2p.tar.gz v3.15.3 @ openp2p.cn ...'
curl -Ls https://openp2p.cn/download/v1/3.15.3/openp2p-latest.linux-arm64.tar.gz -oopenp2p.tar.gz --parallel-max 100
if ! [ -f openp2p.tar.gz ]; then 
    >&2 echo '[ERROR][FastBuild] Failed to download openp2p.tar.gz! The script is going to exit...'
    exit
fi 
echo '[INFO][FastBuild] Unpacking openp2p ...'
tar -zxf openp2p.tar.gz
rm -f openp2p.tar.gz

echo '[INFO][FastBuild] Copying config.json for openp2p.exe ...'
mv -f ../openp2p.config.json ./config.json
echo '[INFO][FastBuild] Starting openp2p ...'
bash -c ./openp2p & # src:36 Logical Change(+): output to console

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
timeout -s 9 10h bash -c "java -Xms1G -Xmx4G -jar spigot-1.20.1.jar nogui" # src:53 Logical Restructure: The transcribed command uses a new structure but does the same thing to the source file.
echo '[INFO][FastBuild] Minecraft Server stopped! ...'
echo '[INFO][FastBuild] Checking openp2p process status ...'
ps -lwFC openp2p
echo '[INFO][FastBuild] Killing openp2p (Output reserved only if succeed)...'
pkill -ein --signal 9 openp2p 2>/dev/null
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
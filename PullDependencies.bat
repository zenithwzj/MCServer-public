@echo off
echo [PullDependencies.bat] Compiling Sleep.cpp (with default) ...
g++ src\Sleep.cpp -o sleep.exe
echo [PullDependencies.bat] Sleep.exe initializing...
sleep 0
echo [PullDependencies.bat] Creating workspace(WKSPC) ...
2>nul md WKSPC
cd WKSPC

echo [PullDependencies.bat] Downloading BuildTools.jar ...
curl -L https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar --output BuildTools.jar
if not exist BuildTools.jar (
    echo [PullDependencies.bat] Failed to download BuildTools.jar! The script is going to exit...
    exit
)

echo [PullDependencies.bat] Downloading openjdk21.zip ...
curl -L https://download.java.net/java/GA/jdk21.0.2/f2283984656d49d69e91c558476027ac/13/GPL/openjdk-21.0.2_windows-x64_bin.zip --output openjdk21.zip
if not exist openjdk21.zip (
    echo [PullDependencies.bat] Failed to download openjdk21.zip! The script is going to exit...
    exit
)
echo [PullDependencies.bat] Unpacking openjdk21.zip ...
tar -xf openjdk21.zip
del /F /Q openjdk21.zip
echo [PullDependencies.bat] Creating workspace for Spigot Builder ...
2>nul md SPBuild
move /Y BuildTools.jar SPBuild >nul
cd SPBuild
echo [PullDependencies.bat] Building Spigot in a new thread...
start /wait ..\jdk-21.0.2\bin\java -jar BuildTools.jar --rev 1.20.1 
echo [PullDependencies.bat] Builder terminated!
if not exist spigot-1.20.1.jar (
    echo [PullDependencies.bat] Error Building Spigot! The script is going to exit...
    exit
) else echo [PullDependencies.bat] Build success!
cd ..
echo [PullDependencies.bat] Exporting built artifacts ...
move /Y SPBuild\spigot-1.20.1.jar .\ >nul
echo [PullDependencies.bat] Removing src ...
rd /S /Q SPBuild

@REM *Dir: .: jdk-21.0.2[D] {.:openjdk21.zip(JUNK)} .:spigot-1.20.1.jar {.:SPBuild[D](JUNK)} 

@REM pull openp2p-cn
echo [PullDependencies.bat] Downloading openp2p.zip v3.15.3 @ openp2p.cn ...
@REM curl -L https://github.com/openp2p-cn/openp2p/releases/download/v3.12.0/openp2p3.12.0.windows-amd64.zip --output openp2p.zip
curl -L https://openp2p.cn/download/v1/3.15.3/openp2p-latest.windows-amd64.zip --output openp2p.zip
if not exist openp2p.zip (
    echo Failed to download openp2p.zip! The script is going to exit...
    exit
)
echo [PullDependencies.bat] Unpacking openp2p.exe ...
tar -xf openp2p.zip
del /F /Q openp2p.zip
@REM *Dir: .: jdk-21.0.2[D] {.:openjdk21.zip(JUNK)} .:spigot-1.20.1.jar {.:SPBuild[D](JUNK)} .:openp2p.exe{,zip} 

echo [PullDependencies.bat] Copying config.json for openp2p.exe ...
copy /Y ..\openp2p.config.json .\config.json >nul
echo [PullDependencies.bat] Starting openp2p ...
@REM openp2p.exe 
@REM echo [PullDependencies.bat] openp2p terminated, restarting it in another thread.
start openp2p.exe

echo [PullDependencies.bat] Creating workspace for Minecraft Server ...
2>nul md server
echo [PullDependencies.bat] Preparing workspace for Minecraft Server ...
move /Y spigot-1.20.1.jar server >nul
if exist ..\server.zip (
    echo [PullDependencies.bat] using ..\server.zip!
    copy /Y ..\server.zip server >nul
    cd server & tar -xf server.zip & cd ..
    del /F /S /Q server\server.zip
) else move /Y ..\EULA.txt server >nul
cd server
echo [PullDependencies.bat] Starting Minecraft Server as well as SleepKill(new thread) ...
start cmd /c "..\SleepKill.bat & exit"
..\jdk-21.0.2\bin\java -Xms1G -Xmx4G -jar spigot-1.20.1.jar nogui
echo [PullDependencies.bat] Minecraft Server terminated!
@REM powershell netstat -ano | findstr :5899
2>nul taskkill /IM openp2p.exe /F
cd ..


echo [PullDependencies.bat] Preparing to upload logs ...
@REM CD=\WKSPC\;pLopenp2p=\WKSPC\log;pLserver=\WKSPC\server\logs
2>nul md packwork\server
copy /Y log\openp2p.log packwork\ 

echo [PullDependencies.bat] Preparing to upload configs ...
copy /Y config.json packwork\ > nul


echo [PullDependencies.bat] Copying server ...
xcopy server packwork\server /E /I /Q /H /Y >nul
echo [PullDependencies.bat] Packing server ...
@REM del /F /S /Q packwork\server\spigot-1.20.1.jar
move /Y packwork\server\spigot-1.20.1.jar packwork\ >nul
cd packwork\server & tar -cf ..\server.zip .\* & cd ..\..
rd /S /Q packwork\server
@REM Artifacts: 
@REM     \WKSPC\packwork\openp2p.log 
@REM     \WKSPC\packwork\config.json openp2p-config
@REM     \WKSPC\packwork\server.zip
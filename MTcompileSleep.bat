@echo off
g++ src\cpTimer.cpp -o Timer > TCPLE.log 2>&1
start Timer.exe
g++ src\Sleep.cpp -o sleep >>TCPLE.log 2>&1
g++ -o WriteSecret src\WriteSecret.cpp -I"%cd%\jsoncpp\include" -ljsoncpp -L"%cd%\jsoncpp\lib" >>TCPLE.log 2>&1
g++ -o ReplaceSecret src\ReplaceSecret.cpp >>TCPLE.log 2>&1
echo [MTcompileSleep.bat - Thread CPLE] Compiling finished:3 programs >>TCPLE.log 2>&1
sleep 255  >>TCPLE.log 2>&1
echo [MTcompileSleep.bat - Thread CPLE] Sleep.exe initialization finished >>TCPLE.log 2>&1
exit
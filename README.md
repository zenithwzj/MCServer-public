# Minecraft-server
个人开服用
试图利用Github Actions 6小时的timeout开mc服务器

Server features:  
    1.CTRL+C can't terminate this server.  
    2.taskkill /F can kill this server.  
    3.taskkill-ing this server (or signal 9) reserves the block state at that moment.  
    4.As long as a player disconnect from the server by normal means, his/her coordinate and items holding can be recorded.  
    5.when an OP stops the server, player(s)' coordinates are recorded.  
  
Therefore, we recommend reconnecting when facing with scheduled server reboot.

For cpTimer.cpp, it's supposed that 2<= minTimeout <= 360 (2 means to stop immediately)

Major difference from regular script and SHOpt(Self-Hosted runners optimized) script: in SH environments with JDK21 already installed, invoke java directly without downloading from openjdk to save time.  
TODOs:  
    1. ~~Unify src files(C++) : src/Timer.linux.cpp(now renamed cpTimer.cpp)~~  
    2. Optimize approach to compress artifact to maximize CPU utilization.  
        Strategy:  
            on public servers: minimize CPU utilization , maximize network utilization  
            on self-hosted servers: minimize network utilization , maximize CPU utilization  
    3. ~~Update console output to adapt Github Action Logs~~  
    4. ~~Abandon Windows Platform~~ * Reserved for self-hosted runners  
    5. ~~Synchronize commits to FastBuild.sh~~  
    6. Add p2p token to repo secret ${{secrets.P2PTOKEN}}
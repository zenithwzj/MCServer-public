# MCServer-public 
This project uses [openp2p-cn](https://github.com/openp2p-cn)/[openp2p](https://github.com/openp2p-cn/openp2p) to connect the client(s) to the server.

steps to start a server on github actions:      
    1. Fork this repository.  
    2. Create a release on the tag 'archive', with file `server.zip` and `openp2p.config.json`, here is an [example](https://github.com/zenithwzj/MCServer-public/releases/tag/archive). You can copy them freely. The `server.zip` must include `eula.txt` ( `eula = true` ) so that the server can run.  
    3. Under your repository name, click **Settings**. If you cannot see the "Settings" tab, select the dropdown menu, then click **Settings**. In the **Security** section of the sidebar, select **Secrets and variables**, then click **Actions**. Click the **Secrets** tab. Click **New repository secret**. In the **Name** field, type `P2PTOKEN`(case insensitive). In the **Secret** field, enter your **openp2p token**[1]. Click **Add secret**. (guide from [**Github Docs**](https://docs.github.com/en/actions/security-guides/using-secrets-in-github-actions))  
    4. Commit a change to `ServerLaunchTrigger/build/Trigger.txt` or open an issue to your repository. The [workflow](https://github.com/zenithwzj/MCServer-public/actions/workflows/build.yml) will be automaticallly runned.  
    5. Your account have a quota of 2,000 minutes per month to run the server. If you would like more, try [self-hosted runners](https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners/about-self-hosted-runners)! The repository currently supports **Windows X64**. **ARM64** runners can be runned on android by [termux](https://github.com/termux/termux-app#github) + [tmoe](https://gitee.com/mo2/linux/). But the script haven't yet been updated and some security issues may exist when running on public repositories. However, please feel safe to run workflows on the current [**build.yml**](https://github.com/zenithwzj/MCServer-public/blob/main/.github/workflows/build.yml) and [**self-hosted.yml**](https://github.com/zenithwzj/MCServer-public/blob/main/.github/workflows/self-hosted.yml) in your public repository, your token won't leak!   
    6. Install openp2p and create a tunnel based on **TCP**, from node **Github-Actions**:5899, to your local machine:25565.  
    7. Open minecraft 1.20.1 and connect to [**localhost**](http://localhost)([**127.0.0.1**](http://127.0.0.1/),or [**::1**](https://::1/))  

Enjoy your game! xD

[1] **openp2p token** : after [**registering**](https://console.openp2p.cn/register), get it at [**openp2p console**](https://console.openp2p.cn/).  
*Tutorial on running self-hosted runners will be uploaded later.
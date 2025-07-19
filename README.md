# Setter DNS cloudflare in linux <img src="Assets/dns.png" width="50" height="50" align="right"/><br><br>
A desktop application for set system cloudflare DNS on linux with Yad tool that made graphical dialogs to shell script

<hr>
<p align="center">
  <img src="Assets/Preview_App.png" width="400" height="300" />
</p>
<hr>


Configuration

Before running the script, put the desktop file in path directory :

    Manjaro => /home/arjin/.local/share/applications/proxy_dns.desktop
    Ubunto => ~/.local/share/applications/proxy_dns.desktop


Istallation

You have to install Cloudflared in your OS :

    Manjaro : { yay -S cloudflared | pacman -S cloudflared }
    Ubunto : {
      curl -fsSL https://pkg.cloudflare.com/cloudflare-main.gpg | sudo gpg --dearmor -o /usr/share/keyrings/cloudflare-main-archive-keyring.gpg

      echo 'deb [signed-by=/usr/share/keyrings/cloudflare-main-archive-keyring.gpg] https://pkg.cloudflare.com/cloudflared stable main' | sudo tee /etc/apt/sources.list.d/cloudflared.list

      sudo apt update
      sudo apt install cloudflared
    }


Requirements

    cloudflared

    DOH Cloudflare Link

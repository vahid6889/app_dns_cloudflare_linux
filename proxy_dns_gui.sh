#!/bin/bash

# === Example DOH link => https://df654fsd6f4.cloudflare-gateway.com/dns-query
DOH_DEDICATED_LINK="YOUR_DOH_LINK"
DOH_BACKUP_LINK1=https://1.1.1.1/dns-query
DOH_BACKUP_LINK2=https://1.0.0.1/dns-query

CLOUDFLARE_PID="/tmp/cloudflared.pid"

# === Get password ===
if [[ "$1" == "exit" ]]; then

    run_as_root '
      sed -i "/127.0.0.1/d" /etc/resolv.conf
      sed -i "s/^#nameserver /nameserver /" /etc/resolv.conf
      kill $(cat $CLOUDFLARE_PID 2>/dev/null) 2>/dev/null
      rm -f $CLOUDFLARE_PID
    '

   pkill -f "cloudflared proxy-dns" 
   pkill -f "yad --notification"
   exit 0
fi

# === Function run command with password ===
run_as_root() {
    pkexec bash -c "$1"
}


# === Loop unlimit untile user dosen't exit | Check status DNS ===
while true; do

  if grep -q "127.0.0.1" /etc/resolv.conf; then
	STATUS="🟢 Active"
  else
	STATUS="🔴 Inactive"
  fi

# === Show form choose ===
  yad --title="Managment local DNS" \
	--text="Current status DNS: $STATUS" \
	--button="Activate!gtk-apply!enable":0 \
	--button="Deactivate!gtk-cancel!disable":1 \
	--button="Exit!gtk-close":2

  code=$?

  if [ "$code" -eq 0 ]; then

# === Activation ===
    	pkill -f "cloudflared proxy-dns"
	run_as_root '
  	sed -i "s/^\(nameserver .*[^#]\)/#\1/" /etc/resolv.conf
  	echo "nameserver 127.0.0.1" >> /etc/resolv.conf
  	nohup cloudflared proxy-dns --address localhost --port 53 --upstream $DOH_DEDICATED_LINK --upstream $DOH_BACKUP_LINK1 --upstream $DOH_BACKUP_LINK1 > /dev/null 2>&1 &
  	echo $! > $CLOUDFLARE_PID
	'
	yad --info --text="Local DNS enabled"

  elif [ "$code" -eq 1 ]; then

#nohup cloudflared proxy-dns > /dev/null 2>&1 &

# === Deactivation ===
	run_as_root '
  	sed -i "/127.0.0.1/d" /etc/resolv.conf
  	sed -i "s/^#nameserver /nameserver /" /etc/resolv.conf
  	kill $(cat $CLOUDFLARE_PID 2>/dev/null) 2>/dev/null
  	rm -f $CLOUDFLARE_PID
	'
	yad --info --text="❌ Local DNS has been disabled."

  else
    break
  fi
done


#!/bin/bash
USERNAME=$(cat /root/.master.info | cut -d: -f1)

if [[ -f /install/.headphones.lock ]]; then
  if grep -q PIDFile=/var/run/headphones/headphones.pid /etc/systemd/system/headphones.service; then
    cat > /etc/systemd/system/headphones.service <<HEADP
[Unit]
Description=Headphones
Wants=network.target network-online.target
After=network.target network-online.target

[Service]
ExecStart=/usr/bin/python2 /home/USER/.headphones/Headphones.py -d --pidfile /var/run/USER/headphones.pid --datadir /home/USER/.headphones --nolaunch --config /home/USER/.headphones/config.ini --port 8004
PIDFile=/var/run/USER/headphones.pid
Type=forking
User=USER
Group=USER

[Install]
WantedBy=multi-user.target
HEADP
    sed -i "s/USER/${USERNAME}/g" /etc/systemd/system/$APPNAME.service
    systemctl daemon-reload
  fi
fi
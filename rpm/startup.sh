echo "Starting system startup script..."
echo "dhclient reset for ens33...."

dhclient -r ens33
dhclient ens33

echo "ens33 setup"

/usr/local/bro/bin/broctl start

echo "Bro has been started, status:"

/usr/local/bro/bin/broctl status

echo "Restarting filebeat..."

systemctl restart filebeat

echo "Filebeat restarted! Status:"

systemctl status filebeat


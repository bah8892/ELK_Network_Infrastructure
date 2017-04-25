############ Installing Snort on Centos 6 #####################
  echo "[`date`] ========= Installing updates ========="
  yum update -y && yum upgrade -y
  yum install git vim curl -y

  # NTP Time Sync
  yum install ntp ntpdate ntp-doc -y
  systemctl enable ntpd
  systemctl start ntpd
  ntpdate pool.ntp.org || true

yum install git vim curl -y
yum install epel-release -y


################################## Install/Setup Snort ##################################

snortInterface=$(ip a | grep '2:' | grep 'en' | awk '{print $2}' |rev | cut -c 2- | rev)
yum install -y gcc flex bison zlib libpcap pcre libdnet libdnet-devel tcpdump
yum install -y https://www.snort.org/downloads/snort/daq-2.0.6-1.centos7.x86_64.rpm
yum install -y https://www.snort.org/downloads/snort/snort-2.9.9.0-1.centos7.x86_64.rpm
ldconfig

# Create directory
sudo mkdir /usr/local/lib/snort_dynamicrules

# Create files for white and black list rules and change permissions
touch /etc/snort/rules/white_list.rules /etc/snort/rules/black_list.rules /etc/snort/rules/local.rules
chmod -R 5775 /etc/snort
chmod -R 5775 /var/log/snort
chmod -R 5775 /usr/local/lib/snort_dynamicrules
chown -R snort:snort /etc/snort
chown -R snort:snort /var/log/snort
chown -R snort:snort /usr/local/lib/snort_dynamicrules

# Get snort community-rules
wget https://www.snort.org/rules/community -O ~/community.tar.gz
tar -xvf ~/community.tar.gz -C ~/
yes | cp ~/community-rules/* /etc/snort/rules
sed -i 's/include \$RULE\_PATH/#include \$RULE\_PATH/' /etc/snort/snort.conf

# Configure server IP and external addresses
sed -i "s/ipvar HOME_NET any/ipvar HOME_NET $(hostname -I)/g" /etc/snort/snort.conf
sed -i 's/ipvar EXTERNAL_NET any/ipvar EXTERNAL_NET !$HOME_NET/g' /etc/snort/snort.conf

# configure snort rule paths
sed -i 's#var RULE_PATH /etc/snort/rules#var RULE_PATH rules#g' /etc/snort/snort.conf
sed -i 's#var SO_RULE_PATH ../so_rules#var SO_RULE_PATH so_rules#g' /etc/snort/snort.conf
sed -i 's#var PREPROC_RULE_PATH ../preproc_rules#var PREPROC_RULE_PATH preproc_rules#g' /etc/snort/snort.conf
sed -i 's#var WHITE_LIST_PATH ../rules#var WHITE_LIST_PATH /etc/snort/rules#g' /etc/snort/snort.conf
sed -i 's#var BLACK_LIST_PATH ../rules#var BLACK_LIST_PATH /etc/snort/rules#g' /etc/snort/snort.conf

# Configure logging
sed -i 's/# output unified2: filename snort.log, limit 128, nostamp/output unified2: filename snort.log, limit 128, nostamp/g' /etc/snort/snort.conf
sed -i 's/output unified2: filename merged.log, limit 128, nostamp, mpls_event_types, vlan_event_types/output unified2: filename snort.log, limit 128, nostamp/g' /etc/snort/snort.conf

# Enable rule sets
sed -i 's?#include $RULE_PATH/local.rules?include $RULE_PATH/local.rules?g' /etc/snort/snort.conf
echo 'include $RULE_PATH/community.rules' >> /etc/snort/snort.conf

# Test snort config
sudo snort -T -c /etc/snort/snort.conf

# Setup snort logging
yum install -y python-pip
pip install --upgrade pip
pip install idstools

# Create logging user
useradd snortlogginguser -d /home/snortLoggingUser -s /bin/bash -g users

# Logging servie
cat > /etc/systemd/system/snortLogging.service << EOF
[Unit]
Description=idstools-u2json converting Snort binary logs into json
After=syslog.target network.target

[Service]
Type=simple
User=snort
Group=snort
ExecStart=/usr/bin/idstools-u2json  --snort-conf /etc/snort/snort.conf --directory /var/log/snort --prefix snort --follow  --output /var/log/snort/snort.json

[Install]
WantedBy=multi-user.target
EOF


# Create Snort SystemD service
cat > /etc/systemd/system/snort.service << EOF
[Unit]
Description=Snort NIDS Daemon
After=syslog.target network.target

[Service]
Type=simple
ExecStart=/usr/sbin/snort -q -u snort -g snort -c /etc/snort/snort.conf -i $snortInterface

[Install]
WantedBy=multi-user.target
EOF


# Start and enable snort on boot
systemctl enable snort
systemctl start snort

systemctl enable snortLogging
systemctl start snortLogging


# Just add config file
cat > /etc/filebeat/conf.d/snort.yml << EOF
filebeat.prospectors:
- input_type: log
  paths:
    - /var/log/snort/*.json
  fields:
    sensorID: $result
    sensorType: networksensor
  document_type: snort
EOF

systemctl restart filebeat

systemctl status snort
systemctl status snortLogging
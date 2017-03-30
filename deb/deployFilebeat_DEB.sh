## Install filebeat for bro logs on Ubuntu
sudo apt-get update

sudo wget https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-5.3.0-amd64.deb
sudo dpkg -i filebeat-5.3.0-amd64.deb

rm -rf /etc/filebeat
mkdir /etc/filebeat/conf.d/
cp /etc/filebeat/filebeat.yml /etc/filebeat/filebeat.yml.bak

cat > /etc/filebeat/filebeat.yml << EOF
filebeat:
  registry_file: /var/lib/filebeat/registry
  config_dir: /etc/filebeat/conf.d

## Change this to whatever your logstash server is running on
output.logstash:
  hosts: ["$1:5044"]
EOF


# Add in a config file for Bro(network monitor)
# You can change this to your liking, or add more then one
# Simply by changing the type, path, and fields.
cat > /etc/filebeat/conf.d/bro.yml << EOF
filebeat.prospectors:
- input_type: log
  paths:
      - /usr/local/bro/logs/current/conn.log
      - /usr/local/bro/logs/current/dhcp.log
      - /usr/local/bro/logs/current/http.log
      - /usr/local/bro/logs/current/ssl.log
      - /usr/local/bro/logs/current/dns.log
      - /usr/local/bro/logs/current/known_services.log
      - /usr/local/bro/logs/current/ssh.log
      - /usr/local/bro/logs/current/weird.log
  fields:
    sensorID: $result
    sensorType: networksensor
  document_type: bro
EOF

service filebeat restart


# Enable this service on start
sudo update-rc.d filebeat defaults 95 10


exit
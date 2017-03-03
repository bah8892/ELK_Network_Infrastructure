##### How to install filebeat on centos 7
#
## The things that I needed were barrowed from this:
## https://github.com/Benster900/CloudsOfHoneyManagementNode/blob/master/scripts/deploy_bro.sh#L130

sudo rpm --import https://packages.elastic.co/GPG-KEY-elasticsearch
cat > /etc/yum.repos.d/elastic.repo << EOF
[elastic-5.x]
name=Elastic repository for 5.x packages
baseurl=https://artifacts.elastic.co/packages/5.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOF

sudo yum install filebeat -y
systemctl enable filebeat
systemctl start filebeat

mkdir /etc/filebeat/conf.d/
cp /etc/filebeat/filebeat.yml /etc/filebeat/filebeat.yml.bak
cat > /etc/filebeat/filebeat.yml << EOF
filebeat:
  registry_file: /var/lib/filebeat/registry
  config_dir: /etc/filebeat/conf.d

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
    ## Enter the location to your log, like this
    ### - /usr/local/bro/logs/current/*.log
  fields:
    sensorID: $result
    sensorType: networksensor
  document_type: bro
EOF


echo "Don't forget to add your file paths!!"

systemctl restart filebeat

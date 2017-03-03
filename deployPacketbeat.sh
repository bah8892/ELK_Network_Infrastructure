## How to install packetbeat on Centos 7

sudo yum install libpcap
curl -L -O https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-5.2.2-x86_64.rpm
sudo rpm -vi packetbeat-5.2.2-x86_64.rpm

## That's really it, from here you need to change the configuration
# However you want to.

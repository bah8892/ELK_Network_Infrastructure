# This will Install packetbeat on Ubuntu

sudo apt-get update

sudo apt-get install libpcap0.8
sudo wget https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-5.3.0-amd64.deb
sudo dpkg -i packetbeat-5.3.0-amd64.deb

echo 'Make any changes to the packetbeat config in /etc/packetbeat/packetbeat.yml'

service packetbeat start

sudo update-rc.d packetbeat defaults 95 10

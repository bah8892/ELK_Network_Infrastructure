## This will install packetbeat on a raspberry pi, which honestly shouldnt work
# Dependencies may vary, here is a list of things that I installed, which may or may not effect oyu
# debhelper (>= 9) binpac (>= 0.43) btest 
# Libbind-dev
# libcurl4-openssl-dev
# libcurl-dev 
# libreadline-dev 
# libgeoip-dev libgoogle-perftools-dev libsqlite3-dev libssl1.0-dev libssl-dev libxml2-dev
# 
# INSTALL GO 

mkdir -p /usr/lib/go-1.7/src/github.com/elastic

#change to your username if not "root"
sudo chown -R root /usr/lib/got-1.7/src/github.com        

cd /usr/lib/go-1.7/src/github.com/elastic
# Clone in the repo into the elastic directory we just made
git clone https://github.com/elastic/beats
# set the GO ROOT 
export GOROOT=/usr/lib/go-1.7/

export GOPATH=/usr/lib/go-1.7/src/github.com/elastic/beats

cd /usr/lib.got-1.7/src/github.com/elastic/beats
cd filebeat      # Change this out for whatever beat you want to
make
sudo cp filebeat /usr/bin/    # Change this out for whatever beat you just made

cd ~
git clone https://github.com/bah8892/NetworkMonitorVis.git
cp NetworkMonitorVis/Configuration/filebeat /etc/

/usr/bin/filebeat -path.home /etc/filebeat
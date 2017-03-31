# Install bro on ubuntu
## This builds from source
# install dependencies
sudo apt-get install cmake make gcc g++ flex bison libpcap-dev libssl-dev python-dev swig zlib1g-dev git

# Build bro from source
cd /opt

sudo git clone --recursive git://git.bro.org/bro

cd bro

sudo ./configure
sudo make
sudo make install      <=== I just ran this at 9:10 AM

export PATH=/usr/local/bro/bin:$PATH

# start bro (theoretically)
/usr/local/bro/bin/broctl start


# Install filebeat for ARM, this way we can just forward our bro logs to a central logstash server, and not
# keep them on the SD card of the pi. To do this we will use filebeat

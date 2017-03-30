 echo 'deb-src http://download.opensuse.org/repositories/network:/bro/Debian_8.0/ /' \
  >> /etc/apt/sources.list.d/bro.list
 wget http://download.opensuse.org/repositories/network:bro/Debian_8.0/Release.key \
  -O - | apt-key add -

  apt-get update

  apt-get build-dep bro

  bison cmake cmake-data libarchive13 libbison-dev libpcap-dev libpython-dev
libpython2.7-dev libssl-dev python-dev python2.7-dev swig swig2.0


apt-get source --compile bro

dpkg -i bro_2.4.1-0_armhf.deb bro-core_2.4.1-0_armhf.deb \
broctl_2.4.1-0_armhf.deb libbroccoli_2.4.1-0_armhf.deb

 /opt/bro/bin/broctl 
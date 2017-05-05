#### Installing pulled pork ####

########## Install dependencies ###########
sudo yum install gcc flex bison zlib libpcap pcre libdnet libdnet-devel tcpdump

cd /root

wget https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/pulledpork/pulledpork-0.7.0.tar.gz

tar zxvf pulledpork-0.7.0.tar.gz

rm -rf pulledpork-0.7.0.tar.gz 

cd pulledpork-0.7.0/

sudo cp pulledpork.pl /usr/local/bin

sudo chmod +x /usr/local/bin/pulledpork.pl

sudo cp etc/*.conf /etc/snort


sudo mkdir /etc/snort/rules/iplists

sudo touch /etc/snort/rules/iplists/default.blacklist

/usr/local/bin/pulledpork.pl -V
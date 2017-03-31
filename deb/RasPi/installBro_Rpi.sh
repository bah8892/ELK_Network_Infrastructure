## Three options to install bro. I will try all of them, and see which one works. 

## You need to update the system no matter how you do this
sudo apt-get update
sudo apt-get upgrade


#########################################################################
#### Install from pre-built binaries
apt-get install vim
apt-get install curl

## Install bro from a pre-built binary
cd /opt

wget https://www.bro.org/downloads/bro-2.5.tar.gz 

tar -zxvf bro-2.5.tar.gz

./configure
make
make install

export PATH=/opt/bro/bin:$PATH

#########################################################################

#########################################################################
# install from apt
# Instructions are from www.bro.org
### https://www.bro.org/sphinx/install/install.html
# This half worked, worst case I will use this and ask someone to help me.
# Until I have someone aronud to help, I will be trying to do it from the git repo


# Get dependencies
sudo apt-get install cmake make gcc g++ flex bison libpcap-dev libssl-dev python-dev swig zlib1g-dev

# Get bro
apt-get install bro

bro -h

#get the home path of bro
export 

apt-get install broctl

apt-get update



## The this field to have an underscore instead of a period
## const default_scope_sep = "_" &redef;
## It is about 17% down in the file
vim /usr/share/bro/base/frameworks/logging/main.bro

#########################################################################
## Install bro from source ############################
sudo apt-get update
sudo apt-get upgrade
# Install dependences
sudo apt-get install cmake make gcc g++ flex bison libpcap-dev libssl-dev python-dev swig zlib1g-dev #done


cd /opt #done


git clone --recursive git://git.bro.org/bro  #done

## Compile bro
./configure    #done
make 			# started at 3
make install

# Configure the run-time enviornment
export PATH=/usr/local/bro/bin:$PATH


# that didn't work
# Error at 74% every time

## Now I should be  able to go into 

#########################################################################


############################################
## Now change your configuration files
# Enable bro JSON logging
vim /usr/share/bro/bro/base/frameworks/logging/writers/ascii.bro

# Set up the symbols in the bro output to be C# friendly
vim /usr/share/bro/bro/base/frameworks/logging/main.bro

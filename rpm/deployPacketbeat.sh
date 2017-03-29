## How to install packetbeat on Centos 7

sudo yum install libpcap
curl -L -O https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-5.2.2-x86_64.rpm
sudo rpm -vi packetbeat-5.2.2-x86_64.rpm

## That's really it, from here you need to change the configuration
# However you want to.
yum install vim
## Change the interface and type of packet capture
vim /etc/packetbeat/packetbeat.yml 

###################### EXAMPLE #######################
#============================== Network device ================================

# Select the network interface to sniff the data. On Linux, you can use the
# "any" keyword to sniff on all connected interfaces.
packetbeat.interfaces.device: any
packetbeat.interfaces.type: pcap
# If you want to us the af_packet style (which uses a lot of RAM, but is faster then PCAP)
#packetbeat.interfaces.type: af_packet
#packetbeat.interfaces.buffer_size_mb: 150
#
#================================== Flows =====================================

# Set `enabled: false` or comment out all options to disable flows reporting.
packetbeat.flows:
  # Set network flow timeout. Flow is killed if no packet is received before being
  # timed out.
  timeout: 30s

  # Configure reporting period. If set to -1, only killed flows will be reported
  period: 1s

#========================== Transaction protocols =============================

packetbeat.protocols.icmp:
  # Enable ICMPv4 and ICMPv6 monitoring. Default: false
  enabled: false


## Change the host to Logstash
########### Example  ######################
#----------------------------- Logstash output --------------------------------
output.logstash:
  # The Logstash hosts
  #   hosts: ["129.21.38.150:5044"]
  #
  #   # The Logstash hosts
  hosts: ["129.21.38.150:5044"]

### Testing Snort ####
### This will explain how to test snort to make sure that your JSON pasrser is working, and if
### snort is sending alerts based off of your rules in the first place.

## Add in local rules

cat >/etc/snort/rules/local.rules << EOF
alert icmp any any -> any any (msg:"ICMP Testing Rule"; sid:10000001; rev:1;)
alert udp any any -> any any (msg:"UDP Testing Rule"; sid:10000003; rev:1;)
EOF

## Run snort config test
snort -T -c /etc/snort/snort.conf

## if that test completes then you are good to move forward

## Start snort to see if it will actually alert you
systemctl start snort
systemctl start snortLoging

systemctl status snort
systemctl status snortLogging
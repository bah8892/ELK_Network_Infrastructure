# Things that I needed are copied from the following helper guide:
# https://github.com/Benster900/CloudsOfHoneyManagementNode/blob/master/scripts/install_elkstack.sh

##################################### Install Java ##################################
yum install wget -y

cd /opt
wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u102-b14/jre-8u102-linux-x64.rpm"
rpm -Uvh jre-8u102-linux-x64.rpm
rm -rf jre-8u102-linux-x64.rpm
yum install java-devel -y



##################################### Install/Setup Elasticsearch #####################################
sudo rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch

echo '[elasticsearch-5.x]
name=Elasticsearch repository for 5.x packages
baseurl=https://artifacts.elastic.co/packages/5.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
' | sudo tee /etc/yum.repos.d/elasticsearch.repo
sudo yum -y install elasticsearch

sed -i 's/#network.host: 192.168.0.1/network.host: localhost/g' /etc/elasticsearch/elasticsearch.yml

systemctl enable elasticsearch
systemctl start elasticsearch

##################################### Install/Setup Kibana #####################################
echo '[kibana-4.4]
name=Kibana repository for 4.4.x packages
baseurl=http://packages.elastic.co/kibana/4.4/centos
gpgcheck=1
gpgkey=http://packages.elastic.co/GPG-KEY-elasticsearch
enabled=1
' | sudo tee /etc/yum.repos.d/kibana.repo

sudo yum -y install kibana

sudo vi /opt/kibana/config/kibana.yml
## In the kibana config file, find the line that specifies server.host and replace the ip with "localhost"
## server.host: "localhost"


sudo systemctl start kibana
sudo chkconfig kibana on


##################################### Install/Setup Nginx #####################################
yum -y install epel-release
yum -y install nginx httpd-tools
sudo htpasswd -c /etc/nginx/htpasswdKibana.users kibanaadmin
cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak

# Delete server block  in default config
sed -i -e '38,87d' /etc/nginx/nginx.conf

mkdir /etc/nginx/conf.d

  cat > /etc/nginx/conf.d/kibana.conf << EOF
  server {
      listen 80;

      server_name example.com;

      auth_basic "Restricted Access";
      auth_basic_user_file /etc/nginx/htpasswd.users;

      location / {
          proxy_pass http://localhost:5601;
          proxy_http_version 1.1;
          proxy_set_header Upgrade $http_upgrade;
          proxy_set_header Connection 'upgrade';
          proxy_set_header Host $host;
          proxy_cache_bypass $http_upgrade;        
      }
  }
  EOF

sudo systemctl start nginx
sudo systemctl enable nginx
sudo setsebool -P httpd_can_network_connect 1


##################################### Install/Setup Logstash #####################################
echo '[logstash-5.x]
name=Elastic repository for 5.x packages
baseurl=https://artifacts.elastic.co/packages/5.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
' | sudo tee /etc/yum.repos.d/logstash.repo

sudo yum -y install logstash

systemctl restart logstash
systemctl enable logstash

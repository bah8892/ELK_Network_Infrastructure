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
echo '[kibana-5.x]
name=Kibana repository for 5.x packages
baseurl=https://artifacts.elastic.co/packages/5.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
' | sudo tee /etc/yum.repos.d/kibana.repo
sudo yum -y install kibana

sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable kibana.service
sudo systemctl start kibana.service


##################################### Install/Setup Nginx #####################################
yum -y install epel-release
yum -y install nginx httpd-tools
sudo htpasswd -c /etc/nginx/htpasswdKibana.users kibanaadmin
cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak

# Delete server block  in default config
sed -i -e '38,87d' /etc/nginx/nginx.conf

mkdir /etc/nginx/ssl
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt
  sudo openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048

  cat > /etc/nginx/conf.d/kibana.conf << EOF
  server {
          listen 9000 ssl;
          server_name _;

          root /usr/share/nginx/html;
          index index.html index.htm;

          ssl_certificate /etc/nginx/ssl/nginx.crt;
          ssl_certificate_key /etc/nginx/ssl/nginx.key;

          ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
          ssl_prefer_server_ciphers on;
          ssl_dhparam /etc/ssl/certs/dhparam.pem;
          ssl_ciphers 'ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-DSS-AES128-GCM-SHA256:kEDH+AESGCM:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-DSS-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-DSS-AES256-SHA:DHE-RSA-AES256-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:AES:CAMELLIA:DES-CBC3-SHA:!aNULL:!eNULL:!EXPORT:!DES:!RC4:!MD5:!PSK:!aECDH:!EDH-DSS-DES-CBC3-SHA:!EDH-RSA-DES-CBC3-SHA:!KRB5-DES-CBC3-SHA';
          ssl_session_timeout 1d;
          ssl_session_cache shared:SSL:50m;
          ssl_stapling on;
          ssl_stapling_verify on;
          add_header Strict-Transport-Security max-age=15768000;

          auth_basic "Restricted";
          auth_basic_user_file /etc/nginx/htpasswdKibana.users;

  	location / {
          	proxy_pass http://localhost:5601;
          	proxy_http_version 1.1;
          	proxy_set_header Upgrade \$http_upgrade;
          	proxy_set_header Connection 'upgrade';
          	proxy_set_header Host \$host;
          	proxy_cache_bypass \$http_upgrade;
      	}
  }
  EOF

  sudo systemctl start nginx
  sudo systemctl enable  nginx
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

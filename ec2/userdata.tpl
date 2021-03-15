#!/bin/bash
sudo apt-get update
sudo apt install apache2 -y
sudo apt install unzip -y
sudo apt-get install -y ruby
sudo apt-get install -y wget
#cd /home/ubuntu
openssl req -new -newkey rsa:4096 -nodes \
    -keyout /etc/ssl/private/apache-selfsigned.key -out /etc/ssl/certs/apache-selfsigned.csr \
    -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=www.example.com"
openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 \
    -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=www.example.com" \
    -keyout /etc/ssl/private/apache-selfsigned.key  -out /etc/ssl/certs/apache-selfsigned.crt           
sudo systemctl start apache2
cat <<EOF > /var/www/html/index.html
<html>
<head>
<title>Hello World</title>
</head>
<body>
<h1>Hello World!</h1>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
</body>
</html>
EOF
sudo ufw allow 'Apache'
sudo a2enmod ssl
sudo rm /etc/apache2/sites-available/default-ssl.conf
cat <<EOF > /etc/apache2/sites-available/000-default.conf                                                                                                                                                   
<VirtualHost _default_:443>
                ServerAdmin your_email@example.com
                ServerName test_server_domain

                DocumentRoot /var/www/html

                ErrorLog /var/log/apache2/error.log
                CustomLog /var/log/apache2/access.log combined

                SSLEngine on

                SSLCertificateFile      /etc/ssl/certs/apache-selfsigned.crt
                SSLCertificateKeyFile /etc/ssl/private/apache-selfsigned.key
</VirtualHost>
EOF
sudo systemctl restart apache2
sudo systemctl enable apache2
cd /home/ubuntu
wget https://aws-codedeploy-us-east-1.s3.us-east-1.amazonaws.com/latest/install
sudo chmod +x ./install
sudo ./install auto                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
sudo service codedeploy-agent start 
#echo "this is coming from terraform" >> /var/www/html/index.html
#service httpd start 
#chkconfig httpd on
#!/bin/bash
sudo apt-get update
sudo apt install apache2 -y
sudo apt install unzip -y
sudo apt-get install -y ruby
sudo apt-get install -y wget
cd /home/ubuntu
wget https://aws-codedeploy-us-east-1.s3.us-east-1.amazonaws.com/latest/install
sudo chmod +x ./install
sudo ./install auto
sudo service codedeploy-agent start
sudo ufw allow 'Apache'
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
sudo systemctl restart apache2
sudo systemctl enable apache2
#echo "this is coming from terraform" >> /var/www/html/index.html
#service httpd start 
#chkconfig httpd on
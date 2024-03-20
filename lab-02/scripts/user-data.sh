#!/bin/bash
sudo apt-get install nginx -y
sudo service nginx start
systemctl enable nginx
echo "Hello world from $(hostname -f)" > /var/www/html/index.html
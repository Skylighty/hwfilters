#!/bin/bash

apt-get install -y python3
apt-get install -y python3-pip
pip3 install -r requirements.txt
apt-get install -y nginx
cp hwfilters.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable hwfilters.service
cp hwfilters-site /etc/nginx/sites-available/
ln -s /etc/nginx/sites-available/hwfilters-site /etc/nginx/sites-enabled
nginx -t 
systemctl start hwfilters
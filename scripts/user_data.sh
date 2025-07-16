#!/bin/bash

# Update system
yum update -y

# Install dependencies
amazon-linux-extras install -y nginx1
yum install -y git python3 mysql

# Install Flask and other Python dependencies
pip3 install -r /home/ec2-user/app/requirements.txt

# Set environment variables for Flask app
export DB_HOST="${db_endpoint}"
export DB_USER="${db_username}"
export DB_PASS="${db_password}"
export DB_NAME="sportsstore"

# Configure Nginx
cat > /etc/nginx/conf.d/sportsstore.conf <<EOL
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://127.0.0.1:5000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
EOL

# Start services
systemctl start nginx
systemctl enable nginx

# Start Flask application
cd /home/ec2-user/app
nohup env DB_HOST=$DB_HOST DB_USER=$DB_USER DB_PASS=$DB_PASS DB_NAME=$DB_NAME python3 app.py > /var/log/flask-app.log 2>&1 &

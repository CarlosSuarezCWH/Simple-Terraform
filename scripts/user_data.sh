#!/bin/bash

# Update system
yum update -y

# Install dependencies
amazon-linux-extras install -y nginx1
yum install -y git python3 mysql

# Install Flask and other Python dependencies
pip3 install flask flask-mysql

# Clone the application repository
git clone https://github.com/yourusername/sports-store-app.git /var/www/sports-store-app

# Configure Nginx
cat > /etc/nginx/conf.d/sportsstore.conf <<EOL
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://127.0.0.1:5000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
    }
}
EOL

# Start services
systemctl start nginx
systemctl enable nginx

# Start Flask application
cd /var/www/sports-store-app
nohup python3 app.py > /var/log/flask-app.log 2>&1 &

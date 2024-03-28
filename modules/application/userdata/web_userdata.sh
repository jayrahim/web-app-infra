#!/bin/bash

set -e

sudo apt update
sudo apt install -y nginx awscli

if ! command -v aws &>/dev/null; then
    echo "AWS CLI is not installed. Exiting..." >> userdata_errors.log
    exit 1
fi

export NGINX_CONFIG_FILE="/etc/nginx/nginx.conf"
export APP_LB_DNS_NAME=$(aws elbv2 describe-load-balancers --names "${app_lb_name}" --region "${region}" --query 'LoadBalancers[0].DNSName' --output text)

if [ -z "$APP_LB_DNS_NAME" ]; then
    echo "Failed to retrieve internal load balancer DNS name. Exiting..." >> userdata_errors.log
    exit 1
fi

sudo bash -c "cat > $NGINX_CONFIG_FILE" <<EOF
worker_processes 1;
events {
  worker_connections  1024;
}
http {
  include       /etc/nginx/mime.types;
  default_type  application/octet-stream;
  sendfile        on;
  tcp_nopush     on;
  keepalive_timeout  65;
  gzip  on;
  server_tokens off;
  server {
    listen 80;
    server_name _;
    access_log off;
    location / {
      proxy_pass http://$APP_LB_DNS_NAME:${backend_port};
      proxy_set_header X-Forwarded-Host \$http_host;
      proxy_set_header X-Real-IP \$remote_addr;
      proxy_set_header X-Forwarded-Proto \$scheme;
      add_header P3P 'CP="ALL DSP COR PSAa PSDa OUR NOR ONL UNI COM NAV"';
    }
    location /health {
      return 200 "Healthy!\n"; 
    }
  }
}
EOF

sudo nginx -t

if [ $? -eq 0 ]; then
    sudo systemctl reload nginx
else
    echo "Nginx configuration test failed. Please check the configuration file." >> userdata_errors.log
fi
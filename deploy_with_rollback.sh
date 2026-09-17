#!/bin/bash
set -e

echo ">>> [1/4] Deploying broken version to GREEN (Port 5002)..."
docker stop app-green && docker rm app-green
# Launching a broken container returning 500 or failing
docker run -d --name app-green -p 5002:80 nginx:alpine sh -c "echo 'Internal Server Error' > /usr/share/nginx/html/index.html && nginx -g 'daemon off;'"

echo ">>> [2/4] Running automated health check on GREEN..."
sleep 2
HEALTH_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:5002/health || echo "500")

if [ "$HEALTH_CODE" != "200" ]; then
    echo ">>> [ALERT] Health check failed with code: $HEALTH_CODE"
    echo ">>> [3/4] Triggering AUTOMATIC ROLLBACK to BLUE (Port 5001)..."
    sudo sed -i 's/5002/5001/' /etc/nginx/sites-available/default
    sudo systemctl reload nginx
    echo ">>> [4/4] Rollback completed. Verifying production traffic on Port 80..."
    curl -I http://localhost/ | head -n 5
    echo ">>> Production restored to stable BLUE version successfully."
    exit 1
else
    echo ">>> Deployment verified successfully."
fi

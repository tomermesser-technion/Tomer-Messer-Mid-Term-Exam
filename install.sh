#!/usr/bin/env bash
##################
# Purpose: Installation script for the status-dashboard for root user.
# Developer: Tomer Messer - tomer.messer@campus.technion.ac.il
# Version: 0.0.1
# Date: 14.05.2026
##################

set -o errexit
set -o nounset
set -o pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VERSION="${VERSION:-1.0.0}"
PORT="${PORT:-5000}"

if [[ $EUID -ne 0 ]]; then
    echo "Error: run this script as root: sudo ./install.sh" >&2
    exit 1
fi

if [[ -z "${API_KEY:-}" ]]; then
    echo "Error: API_KEY environment variable is required" >&2
    exit 1
fi

echo -e "\n================================================"
echo "1. Building Docker image..."
docker build -t status-dashboard "$REPO_DIR"

echo -e "\n================================================"
echo "2. Removing existing container if present..."
docker rm -f status-dashboard 2>/dev/null || true

echo -e "\n================================================"
echo "3. Starting container..."
docker run -d \
    --name status-dashboard \
    --restart unless-stopped \
    -e API_KEY="$API_KEY" \
    -e VERSION="$VERSION" \
    -e PORT="$PORT" \
    -p 127.0.0.1:5000:"$PORT" \
    status-dashboard

echo -e "\n================================================"
echo "4. Setting up nginx..."
cp "$REPO_DIR/nginx/status-dashboard" /etc/nginx/sites-available/status-dashboard
ln -sf /etc/nginx/sites-available/status-dashboard /etc/nginx/sites-enabled/status-dashboard
rm -f /etc/nginx/sites-enabled/default
nginx -t
systemctl enable nginx
systemctl start nginx
systemctl reload nginx

echo -e "\n================================================"
echo "5. Service is up at http://$(hostname -I | awk '{print $1}')/"
sleep 1

echo -e "\n================================================"
echo "6. Checking status..."
curl -sL http://localhost/api/status

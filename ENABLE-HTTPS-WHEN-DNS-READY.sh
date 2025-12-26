#!/bin/bash

# Script to enable HTTPS once DNS is propagated
# Run this after grc2.doganlap.com resolves to 37.27.139.173

echo "=== Checking DNS resolution ==="
DNS_IP=$(dig grc2.doganlap.com +short | head -1)

if [ "$DNS_IP" != "37.27.139.173" ]; then
    echo "❌ DNS not ready yet!"
    echo "   grc2.doganlap.com resolves to: $DNS_IP"
    echo "   Expected: 37.27.139.173"
    echo ""
    echo "Please wait for DNS propagation and try again."
    exit 1
fi

echo "✅ DNS is working! grc2.doganlap.com → 37.27.139.173"
echo ""

echo "=== Getting SSL certificate from Let's Encrypt ==="
certbot --nginx -d grc2.doganlap.com --non-interactive --agree-tos --email admin@doganlap.com --redirect

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ HTTPS ENABLED!"
    echo ""
    echo "Your application is now available at:"
    echo "   https://grc2.doganlap.com"
    echo ""
    echo "SSL certificate will auto-renew every 90 days."
else
    echo ""
    echo "❌ SSL setup failed. Check certbot logs:"
    echo "   tail -50 /var/log/letsencrypt/letsencrypt.log"
fi

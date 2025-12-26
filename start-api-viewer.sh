#!/bin/bash

###############################################################################
# API Viewer Server Startup Script
# Starts a simple HTTP server on port 9876 to serve api-viewer.html
###############################################################################

PORT=9876
BIND_IP="0.0.0.0"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🚀 Starting API Viewer Server..."
echo "📁 Directory: $SCRIPT_DIR"
echo "🌐 Port: $PORT"
echo ""

# Check if port is already in use
if lsof -Pi :$PORT -sTCP:LISTEN -t >/dev/null 2>&1 || netstat -tuln 2>/dev/null | grep -q ":$PORT " || ss -tuln 2>/dev/null | grep -q ":$PORT "; then
    echo "⚠️  Port $PORT is already in use!"
    echo "   Stopping existing server..."
    pkill -f "http.server $PORT" 2>/dev/null
    sleep 2
fi

# Get server IP
SERVER_IP=$(hostname -I | awk '{print $1}')
if [ -z "$SERVER_IP" ]; then
    SERVER_IP=$(ip addr show | grep -E "inet.*global" | awk '{print $2}' | cut -d'/' -f1 | head -1)
fi

# Start server
cd "$SCRIPT_DIR"
nohup python3 -m http.server $PORT --bind $BIND_IP > /tmp/api-viewer-server.log 2>&1 &

# Wait for server to start
sleep 2

# Check if server started
if ps aux | grep -q "[h]ttp.server $PORT"; then
    echo "✅ Server started successfully!"
    echo ""
    echo "📊 Access the API Viewer at:"
    echo "   http://$SERVER_IP:$PORT/api-viewer.html"
    echo ""
    echo "🔗 Or from this machine:"
    echo "   http://localhost:$PORT/api-viewer.html"
    echo ""
    echo "📝 Logs: /tmp/api-viewer-server.log"
    echo "🛑 To stop: ./stop-api-viewer.sh"
else
    echo "❌ Failed to start server!"
    echo "   Check logs: /tmp/api-viewer-server.log"
    exit 1
fi


#!/bin/bash

###############################################################################
# API Viewer Server Stop Script
###############################################################################

PORT=9876

echo "🛑 Stopping API Viewer Server on port $PORT..."

pkill -f "http.server $PORT"

sleep 1

if ps aux | grep -q "[h]ttp.server $PORT"; then
    echo "⚠️  Server still running, force stopping..."
    pkill -9 -f "http.server $PORT"
    sleep 1
fi

if ps aux | grep -q "[h]ttp.server $PORT"; then
    echo "❌ Failed to stop server!"
    exit 1
else
    echo "✅ Server stopped successfully!"
fi


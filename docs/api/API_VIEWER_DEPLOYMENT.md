# 🚀 API Viewer Deployment Guide

**Deployed:** December 22, 2025  
**Port:** 9876 (Non-standard port)  
**Status:** ✅ Deployed

---

## 🌐 Access Information

### Server Details
- **Port:** `9876` (Non-standard, safe port)
- **Bind:** `0.0.0.0` (All interfaces)
- **Protocol:** HTTP

### Access URLs

**From any device on network:**
```
http://YOUR_SERVER_IP:9876/api-viewer.html
```

**From local machine:**
```
http://localhost:9876/api-viewer.html
```

---

## 🚀 Quick Start

### Start Server
```bash
cd /root/app.shahin-ai.com
./start-api-viewer.sh
```

### Stop Server
```bash
cd /root/app.shahin-ai.com
./stop-api-viewer.sh
```

### Check Status
```bash
ps aux | grep "http.server 9876"
```

---

## 📋 Manual Commands

### Start Manually
```bash
cd /root/app.shahin-ai.com
python3 -m http.server 9876 --bind 0.0.0.0
```

### Start in Background
```bash
cd /root/app.shahin-ai.com
nohup python3 -m http.server 9876 --bind 0.0.0.0 > /tmp/api-viewer.log 2>&1 &
```

### Stop Manually
```bash
pkill -f "http.server 9876"
```

---

## 🔍 Find Your Server IP

```bash
# Method 1
hostname -I | awk '{print $1}'

# Method 2
ip addr show | grep -E "inet.*global" | awk '{print $2}' | cut -d'/' -f1

# Method 3
ifconfig | grep "inet " | grep -v 127.0.0.1
```

---

## ✅ Verification

### Test Server
```bash
# Get your IP
SERVER_IP=$(hostname -I | awk '{print $1}')

# Test connection
curl -I http://$SERVER_IP:9876/api-viewer.html

# Or test locally
curl -I http://localhost:9876/api-viewer.html
```

### Expected Response
```
HTTP/1.0 200 OK
Server: SimpleHTTP/0.6 Python/3.x
Content-Type: text/html
```

---

## 🔒 Security Notes

### Port Selection
- **9876** - Non-standard port
- Not commonly used
- Less likely to conflict
- Safe for internal use

### Firewall
If you have a firewall, allow port 9876:
```bash
# UFW
sudo ufw allow 9876/tcp

# Firewalld
sudo firewall-cmd --add-port=9876/tcp --permanent
sudo firewall-cmd --reload

# iptables
sudo iptables -A INPUT -p tcp --dport 9876 -j ACCEPT
```

---

## 📊 Features

✅ **Standalone HTML page**  
✅ **No dependencies** (just Python)  
✅ **Accessible from network**  
✅ **Non-standard port (9876)**  
✅ **Easy start/stop scripts**  
✅ **Background operation**  

---

## 🛠️ Troubleshooting

### Port Already in Use?
```bash
# Find what's using the port
sudo lsof -i :9876
# or
sudo netstat -tlnp | grep 9876

# Kill the process
pkill -f "http.server 9876"
```

### Can't Access from Network?
1. Check firewall settings
2. Verify server IP is correct
3. Check server is bound to 0.0.0.0 (not 127.0.0.1)
4. Verify port is open

### Server Not Starting?
```bash
# Check logs
cat /tmp/api-viewer-server.log

# Check Python is installed
python3 --version

# Try different port
python3 -m http.server 9877 --bind 0.0.0.0
```

---

## 📝 Files Created

- ✅ `api-viewer.html` - The HTML page
- ✅ `start-api-viewer.sh` - Start script
- ✅ `stop-api-viewer.sh` - Stop script
- ✅ `API_VIEWER_DEPLOYMENT.md` - This file

---

## 🎯 Usage

1. **Start server:**
   ```bash
   ./start-api-viewer.sh
   ```

2. **Get your server IP:**
   ```bash
   hostname -I | awk '{print $1}'
   ```

3. **Open in browser:**
   ```
   http://YOUR_IP:9876/api-viewer.html
   ```

4. **Use the viewer:**
   - Click "Load Regulators"
   - View data in tables
   - Navigate with pagination

---

## ✅ Status

**Deployment:** ✅ Complete  
**Server:** ✅ Running  
**Port:** 9876  
**Access:** Network-wide  

**Ready to use!** 🎉


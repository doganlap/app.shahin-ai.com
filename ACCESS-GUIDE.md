# 🌐 Saudi GRC Platform - Access Guide

**Server IP:** 37.27.139.173  
**Status:** ✅ All Services Running  
**Framework:** .NET 9.0 + Angular 18

---

## 🔗 Application URLs

### Frontend Dashboard (Angular 18)
```
http://37.27.139.173:4200
```
**Features:**
- Interactive GRC Dashboard
- Compliance Framework Viewer
- Risk Management Interface
- Regulatory Requirements Browser

### Backend API (.NET 9)
```
Base URL: http://37.27.139.173:7000
```

**Key Endpoints:**

1. **Health Check**
   ```
   http://37.27.139.173:7000/health
   ```

2. **API Documentation (Swagger)**
   ```
   http://37.27.139.173:7000/swagger
   ```

3. **Regulators API**
   ```
   http://37.27.139.173:7000/api/app/regulator
   ```
   - Returns 116 Saudi & International Regulators
   - Supports filtering, sorting, pagination

4. **Frameworks API**
   ```
   http://37.27.139.173:7000/api/app/framework
   ```
   - Returns 39 Compliance Frameworks
   - Includes NCA ECC, SAMA, CITC, PDPL, etc.

5. **Controls API**
   ```
   http://37.27.139.173:7000/api/app/framework/{id}/controls
   ```

---

## 🔥 Firewall Configuration

**Ports Opened:**
- ✅ Port 4200 (Frontend) - ALLOW from Anywhere
- ✅ Port 7000 (Backend) - ALLOW from Anywhere

**Firewall Status:**
```bash
ufw status
```

**To close ports (if needed):**
```bash
sudo ufw delete allow 4200/tcp
sudo ufw delete allow 7000/tcp
sudo ufw reload
```

---

## 🧪 Testing the APIs

### Using cURL

**1. Health Check:**
```bash
curl http://37.27.139.173:7000/health
```

**2. Get Regulators (first 5):**
```bash
curl "http://37.27.139.173:7000/api/app/regulator?MaxResultCount=5"
```

**3. Get Frameworks (first 5):**
```bash
curl "http://37.27.139.173:7000/api/app/framework?MaxResultCount=5"
```

### Using Browser

Simply paste these URLs in your browser:

1. **Frontend Dashboard:**
   - http://37.27.139.173:4200

2. **API Documentation:**
   - http://37.27.139.173:7000/swagger

3. **Sample API Call:**
   - http://37.27.139.173:7000/api/app/regulator

---

## 🏗️ Architecture

```
┌─────────────────────────────────────┐
│   Frontend (Angular 18)             │
│   Port: 4200                        │
│   http://37.27.139.173:4200         │
└──────────────┬──────────────────────┘
               │
               │ REST API Calls
               ▼
┌─────────────────────────────────────┐
│   Backend (.NET 9 API)              │
│   Port: 7000                        │
│   http://37.27.139.173:7000         │
└──────────────┬──────────────────────┘
               │
               │ Data Access
               ▼
┌─────────────────────────────────────┐
│   PostgreSQL Database               │
│   - 116 Regulators                  │
│   - 39 Frameworks                   │
│   - 3,500+ Controls                 │
└─────────────────────────────────────┘
```

---

## 🔧 Infrastructure

**Backend Container:**
- Name: `grc-api-production`
- Image: `grc-api:production-net9`
- Runtime: .NET 9.0
- Status: Healthy

**Database:**
- PostgreSQL 16.11
- Connection: Healthy
- Records: 155+ total

**Cache:**
- Redis 7
- Connection: Healthy

**Storage:**
- MinIO S3-compatible
- Port: 9000 (internal)

---

## 📊 Available Data

**Regulators (116 total):**
- Saudi Regulators: SAMA, NCA, CITC, CMA, SDAIA, etc.
- International: GDPR, NIST, ISO, PCI-DSS, etc.

**Frameworks (39 total):**
- NCA Essential Cybersecurity Controls (ECC)
- SAMA Cyber Security Framework
- CITC Cloud Computing Framework
- PDPL (Personal Data Protection Law)
- ISO 27001, NIST CSF, PCI-DSS, etc.

**Controls:**
- 3,500+ individual controls
- Mapped to frameworks
- Arabic/English bilingual

---

## 🚀 Quick Start

### For End Users:

1. **Access Dashboard:**
   - Open: http://37.27.139.173:4200
   - Browse frameworks and regulators
   - View compliance requirements

2. **Explore API:**
   - Open: http://37.27.139.173:7000/swagger
   - Try out API endpoints
   - View data models

### For Developers:

**API Base URL:**
```javascript
const API_BASE = 'http://37.27.139.173:7000';
```

**Example API Call:**
```javascript
fetch('http://37.27.139.173:7000/api/app/regulator')
  .then(res => res.json())
  .then(data => console.log(data));
```

---

## ⚠️ Troubleshooting

### "Connection Refused" Error

**Possible Causes:**

1. **Local Firewall/Antivirus**
   - Check if your firewall is blocking outbound connections
   - Temporarily disable and test

2. **Corporate Network**
   - Company firewall may block non-standard ports
   - Try from personal network or use VPN

3. **ISP Blocking**
   - Some ISPs block certain ports
   - Try using mobile data or different network

**Verification Steps:**

1. **Test from server itself:**
   ```bash
   curl http://localhost:4200
   curl http://localhost:7000/health
   ```

2. **Test with external IP from server:**
   ```bash
   curl http://37.27.139.173:4200
   curl http://37.27.139.173:7000/health
   ```

3. **Check services are running:**
   ```bash
   docker ps | grep grc-api-production
   ps aux | grep "ng serve"
   ```

---

## 🔐 Security Notes

**Current Setup:**
- ⚠️ No HTTPS (development mode)
- ⚠️ No authentication on API endpoints
- ⚠️ Public access enabled

**For Production:**
1. Enable HTTPS with SSL certificates
2. Implement API authentication
3. Add rate limiting
4. Configure CORS properly
5. Use environment-specific configs

---

## 📞 Support

**Server Information:**
- IP: 37.27.139.173
- OS: Linux (Debian)
- Location: /root/app.shahin-ai.com

**Service Management:**

Stop/Start Angular:
```bash
# Stop
pkill -f "ng serve"

# Start
cd /root/app.shahin-ai.com/Shahin-ai/aspnet-core/angular
npm start &
```

Stop/Start Backend:
```bash
# Stop
docker stop grc-api-production

# Start
docker start grc-api-production
```

---

**Last Updated:** December 24, 2025  
**Version:** .NET 9.0 + Angular 18  
**Status:** ✅ Fully Operational

---

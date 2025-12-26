# 🚀 Saudi GRC Platform - Quick Start Guide

## ✅ Current Status

**Backend API**: ✅ RUNNING on http://localhost:5000
**Database**: ✅ CONNECTED (116 regulators, 39 frameworks, 3,500 controls)
**Swagger UI**: ✅ AVAILABLE at http://localhost:5000/swagger

---

## 🎯 Quick Access

### API Endpoints
```bash
# Swagger UI (Interactive API Documentation)
http://localhost:5000/swagger

# Health Check
curl http://localhost:5000/health

# List Regulators (116 total)
curl http://localhost:5000/api/app/regulator | jq '.totalCount'

# List Frameworks (39 total)
curl http://localhost:5000/api/app/framework | jq '.totalCount'
```

### Test Endpoints
```bash
# Get all regulators
curl -s http://localhost:5000/api/app/regulator | jq '.items[0:3]'

# Get seeding status
curl -s http://localhost:5000/api/admin/seed-status | jq '.'

# Get first regulator details
curl -s http://localhost:5000/api/app/regulator | jq '.items[0]'
```

---

## 🏃 Run Full Stack

### Option 1: Backend Only (Currently Running)
Backend is already running on port 5000.
Access Swagger: http://localhost:5000/swagger

### Option 2: Add Frontend
```bash
cd Shahin-ai/aspnet-core/angular
npm install
npm start
# Access at: http://localhost:4200
```

### Option 3: Fresh Start
```bash
# Stop current API
kill $(lsof -t -i:5000)

# Start API
cd Shahin-ai/aspnet-core
export $(cat .env | grep -v '^#' | xargs)
cd src/Grc.HttpApi.Host
dotnet run --no-build --configuration Release --urls "http://localhost:5000"

# In another terminal: Start Frontend
cd Shahin-ai/aspnet-core/angular
npm start
```

---

## 📝 Common Operations

### View API Logs
```bash
tail -f /tmp/grc-api.log
```

### Check API Process
```bash
ps aux | grep Grc.HttpApi.Host
lsof -i :5000
```

### Restart API
```bash
kill $(lsof -t -i:5000)
cd Shahin-ai/aspnet-core
./start-api.sh
```

### Seed Database (if needed)
```bash
curl -X POST http://localhost:5000/api/admin/seed-framework-library
```

---

## 🔍 Verify Installation

### 1. Check Backend Status
```bash
curl -s http://localhost:5000/ -I | head -5
# Expected: HTTP/1.1 302 Found (redirects to /swagger)
```

### 2. Check Database
```bash
curl -s http://localhost:5000/api/app/regulator | jq '.totalCount'
# Expected: 116
```

### 3. Check Frameworks
```bash
curl -s http://localhost:5000/api/app/framework | jq '.totalCount'
# Expected: 39
```

### 4. View Swagger
Open browser: http://localhost:5000/swagger

---

## 🐛 Troubleshooting

### Port Already in Use
```bash
# Find process
lsof -i :5000

# Kill process
kill -9 $(lsof -t -i:5000)

# Restart
./start-api.sh
```

### Database Connection Error
```bash
# Check environment variables
cat .env

# Verify connection string
echo $CONNECTION_STRINGS__DEFAULT
```

### Data Not Seeded
```bash
# Re-seed data
curl -X POST http://localhost:5000/api/admin/seed-framework-library

# Check count
curl -s http://localhost:5000/api/app/regulator | jq '.totalCount'
```

---

## 📚 Documentation

- **Main README**: [README.md](./README.md)
- **Deployment Status**: [DEPLOYMENT_STATUS.md](./DEPLOYMENT_STATUS.md)
- **Security Migration**: [SECRETS_MIGRATION.md](./SECRETS_MIGRATION.md)
- **Enhancements**: [ENHANCEMENTS_SUMMARY.md](./ENHANCEMENTS_SUMMARY.md)

---

## 🎯 What's Working

✅ Backend API (49+ endpoints)
✅ Database (PostgreSQL on Railway)
✅ Redis Cache (Railway)
✅ S3 Storage (Railway)
✅ Health Checks
✅ Swagger UI
✅ Data Seeding (3,655 records)
✅ Authentication endpoints
✅ Multi-tenancy support
✅ Localization (Arabic/English)

---

## ⚠️ Before Production

🔴 **CRITICAL**: Rotate all exposed credentials (see [SECRETS_MIGRATION.md](./SECRETS_MIGRATION.md))
🟡 Clean git history
🟢 Enable GitHub secret scanning
🟢 Configure monitoring
🟢 Set up alerting

---

## 🚀 Next Steps

1. **Test Full Stack**: Start frontend (`npm start` in angular directory)
2. **Integration Tests**: Test login, browsing, and CRUD operations
3. **Security**: Rotate credentials (see SECRETS_MIGRATION.md)
4. **Deploy**: Push to Railway for production

---

**Quick Links**:
- API: http://localhost:5000
- Swagger: http://localhost:5000/swagger
- Frontend (when started): http://localhost:4200

---

*Last Updated: December 23, 2025*

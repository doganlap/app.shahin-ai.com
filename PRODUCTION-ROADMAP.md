# 🚀 Production Deployment Roadmap

**Goal:** Production-ready GRC Platform with authentication and core features
**Timeline:** ASAP (Focused approach)
**Last Updated:** December 24, 2025

---

## 📋 Phase 1: Core Dashboard & Authentication (Week 1)

### Task 1.1: Create Dashboard API Endpoints ✅ STARTING NOW
**Priority:** CRITICAL
**Files to Create:**
- `Grc.Application.Contracts/Dashboard/DashboardDto.cs`
- `Grc.Application.Contracts/Dashboard/IDashboardAppService.cs`
- `Grc.Application/Dashboard/DashboardAppService.cs`

**Endpoints to Build:**
```csharp
GET /api/app/dashboard/overview
- activeAssessments: int
- totalControls: int
- completedControls: int
- overdueControls: int
- averageScore: decimal
- complianceLevel: string

GET /api/app/dashboard/my-controls
- Returns user's assigned controls with status

GET /api/app/dashboard/framework-progress
- Returns compliance progress per framework
```

**Data Sources:**
- Query Assessment domain for active assessments
- Query Control domain for control counts
- Calculate compliance percentages from assessment data

### Task 1.2: Enable Authentication
**Priority:** CRITICAL
**Changes Needed:**

1. **Re-enable Authorization in AppServices:**
   - Add `[Authorize]` back to FrameworkAppService
   - Add `[Authorize]` to all other AppServices
   - Define proper permissions

2. **Configure OpenIddict Server:**
   - Already configured in `GrcHttpApiHostModule`
   - Test token generation
   - Verify OAuth2 flows

3. **Update Angular OAuth Configuration:**
   - Enable OAuth interceptor
   - Configure token refresh
   - Add login page/component

4. **Test Authentication Flow:**
   - Login with admin credentials
   - Verify token generation
   - Test API access with bearer token

### Task 1.3: HTTPS/SSL Setup
**Priority:** HIGH
**Options:**

**Option A: Nginx Reverse Proxy (Recommended)**
```bash
# Install Nginx
apt-get install nginx certbot python3-certbot-nginx

# Configure reverse proxy
# /etc/nginx/sites-available/grc-platform

# Get SSL certificate
certbot --nginx -d yourdomain.com
```

**Option B: Use Cloudflare (Easier)**
- Point domain to 37.27.139.173
- Enable SSL/TLS in Cloudflare
- Use flexible or full SSL mode

---

## 📋 Phase 2: Assessment Management (Week 2)

### Task 2.1: Assessment API Enhancement
**Status:** Backend exists, needs testing

**Existing:**
- AssessmentAppService ✅
- ControlAssessmentAppService ✅
- Domain models complete ✅

**Todo:**
- Test API endpoints
- Verify CRUD operations
- Add bulk operations if needed

### Task 2.2: Build Angular Assessment Module
**Files to Create:**
```
/angular/src/app/features/assessments/
  - assessment-list/
  - assessment-detail/
  - assessment-create/
  - control-assessment/
  - services/assessment.service.ts
  - models/assessment.models.ts
  - assessments-routing.module.ts
  - assessments.module.ts
```

**Features:**
- List all assessments (table view)
- Create new assessment
- Assign framework to assessment
- View assessment details
- Assess individual controls
- Track progress

### Task 2.3: Control Assessment UI
**Features:**
- Control checklist
- Evidence upload
- Status tracking (Not Started, In Progress, Completed)
- Comments/notes
- Approval workflow

---

## 📋 Phase 3: Risk & Evidence Management (Week 3)

### Task 3.1: Risk Management UI
**Backend:** ✅ Ready (RiskAppService exists)

**Angular Components:**
```
/angular/src/app/features/risks/
  - risk-list/
  - risk-register/
  - risk-assessment/
  - risk-treatment/
```

**Features:**
- Risk register (list all risks)
- Create/edit risks
- Risk assessment matrix
- Link risks to controls
- Track mitigation actions

### Task 3.2: Evidence Management UI
**Backend:** ✅ Ready (EvidenceAppService exists)

**Angular Components:**
```
/angular/src/app/features/evidence/
  - evidence-library/
  - evidence-upload/
  - evidence-viewer/
```

**Features:**
- Upload evidence files
- Link to controls
- Evidence library/repository
- Track expiration dates
- Version control

---

## 📋 Phase 4: Production Security & Hardening

### Task 4.1: Security Checklist

**✅ Complete:**
- [x] .NET 9.0 (latest stable)
- [x] PostgreSQL with encryption
- [x] Redis caching
- [x] Health checks

**❌ Todo:**
- [ ] Enable HTTPS (SSL/TLS)
- [ ] Enable authentication/authorization
- [ ] Configure CORS properly
- [ ] Rate limiting
- [ ] API key management
- [ ] Input validation
- [ ] SQL injection prevention (EF Core handles this)
- [ ] XSS prevention
- [ ] CSRF protection
- [ ] Security headers

### Task 4.2: Environment Configuration

**Create Production Environment:**
```bash
# Angular production environment
/angular/src/environments/environment.prod.ts
```

**Update API URLs:**
```typescript
export const environment = {
  production: true,
  application: {
    name: 'GRC Platform',
    logoUrl: '/assets/logo.png',
  },
  oAuthConfig: {
    issuer: 'https://yourdomain.com',
    clientId: 'Grc_App',
    scope: 'offline_access Grc',
    requireHttps: true,  // ← ENABLE HTTPS
  },
  apis: {
    default: {
      url: 'https://yourdomain.com',  // ← HTTPS
    },
  },
};
```

**Backend Production Settings:**
```json
// appsettings.Production.json
{
  "App": {
    "SelfUrl": "https://yourdomain.com",
    "ClientUrl": "https://yourdomain.com",
    "CorsOrigins": "https://yourdomain.com"
  },
  "ConnectionStrings": {
    "Default": "Server=localhost;Database=GrcProd;..."
  }
}
```

### Task 4.3: Production Build

**Backend:**
```bash
cd /root/app.shahin-ai.com/Shahin-ai/aspnet-core
~/.dotnet/dotnet publish src/Grc.HttpApi.Host/Grc.HttpApi.Host.csproj \
  -c Release \
  -o /opt/grc-api-production

# Or Docker:
docker build -t grc-api:production .
```

**Frontend:**
```bash
cd /root/app.shahin-ai.com/Shahin-ai/aspnet-core/angular
npm run build -- --configuration production
```

### Task 4.4: Production Deployment

**Option A: Docker Compose (Recommended)**
```yaml
# docker-compose.production.yml
version: '3.8'
services:
  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
      - ./ssl:/etc/nginx/ssl

  api:
    image: grc-api:production
    environment:
      - ASPNETCORE_ENVIRONMENT=Production
      - ConnectionStrings__Default=${DB_CONNECTION}
    depends_on:
      - postgres
      - redis

  postgres:
    image: postgres:16
    volumes:
      - pgdata:/var/lib/postgresql/data

  redis:
    image: redis:7-alpine
```

**Option B: Systemd Service**
```bash
# /etc/systemd/system/grc-api.service
[Unit]
Description=GRC Platform API
After=network.target

[Service]
WorkingDirectory=/opt/grc-api-production
ExecStart=/usr/bin/dotnet Grc.HttpApi.Host.dll
Restart=always
Environment=ASPNETCORE_ENVIRONMENT=Production

[Install]
WantedBy=multi-user.target
```

---

## 📋 Phase 5: Testing & Validation

### Task 5.1: Security Testing
- [ ] Penetration testing
- [ ] OWASP Top 10 validation
- [ ] Authentication testing
- [ ] Authorization testing
- [ ] SQL injection testing
- [ ] XSS testing

### Task 5.2: Performance Testing
- [ ] Load testing (100+ concurrent users)
- [ ] API response times
- [ ] Database query optimization
- [ ] Caching effectiveness

### Task 5.3: User Acceptance Testing
- [ ] Dashboard functionality
- [ ] Assessment workflow
- [ ] Risk management
- [ ] Evidence upload
- [ ] Reports generation

---

## 📋 Phase 6: Documentation & Training

### Task 6.1: User Documentation
- [ ] User manual
- [ ] Admin guide
- [ ] API documentation
- [ ] Video tutorials

### Task 6.2: Technical Documentation
- [x] Architecture guide (COMPLETE-APPLICATION-GUIDE.md)
- [ ] Deployment guide
- [ ] Maintenance guide
- [ ] Troubleshooting guide

---

## 🎯 CRITICAL PATH (Production ASAP)

### Week 1 (Priority 1):
**Day 1-2:** Dashboard API + Authentication
- ✅ Create DashboardAppService with real data
- ✅ Enable OAuth2 authentication
- ✅ Test login flow

**Day 3-4:** HTTPS/SSL Setup
- ✅ Configure Nginx reverse proxy
- ✅ Install SSL certificate
- ✅ Update all URLs to HTTPS

**Day 5-7:** Security Hardening
- ✅ Enable authorization on all endpoints
- ✅ Configure CORS
- ✅ Add rate limiting
- ✅ Security testing

### Week 2 (Priority 2):
**Day 8-10:** Assessment Management UI
- Build Angular components
- Connect to backend APIs
- Test assessment workflow

**Day 11-14:** Risk Management UI
- Build risk components
- Test risk assessment flow
- Integration testing

### Week 3 (Priority 3):
**Day 15-17:** Evidence Management
- Build evidence upload UI
- Test file upload/storage
- Link evidence to controls

**Day 18-21:** Production Deployment
- Production build
- Deploy to production server
- Final testing
- Go-live!

---

## 📊 Success Metrics

### Phase 1 Complete When:
- ✅ Dashboard shows REAL data from database
- ✅ Users must login to access application
- ✅ All traffic encrypted with HTTPS
- ✅ No security vulnerabilities in top scan

### Phase 2 Complete When:
- ✅ Users can create assessments
- ✅ Users can assess controls
- ✅ Progress tracking works
- ✅ Evidence can be uploaded

### Production Ready When:
- ✅ All Phase 1 & 2 complete
- ✅ Security audit passed
- ✅ Performance testing passed
- ✅ User acceptance testing passed
- ✅ Documentation complete

---

## 🔧 Commands Reference

### Start Development:
```bash
# Backend
cd /root/app.shahin-ai.com/Shahin-ai/aspnet-core
docker start grc-api-production

# Frontend
cd /root/app.shahin-ai.com/Shahin-ai/aspnet-core/angular
npm start
```

### Production Build:
```bash
# Backend
docker build -t grc-api:production -f Dockerfile .

# Frontend
cd angular
npm run build --prod
```

### Deploy:
```bash
# Stop old containers
docker stop grc-api-production
docker rm grc-api-production

# Start new version
docker run -d \
  --name grc-api-production \
  -p 7000:7000 \
  --network grc-network \
  grc-api:production
```

---

**Next Action:** Start with Dashboard API implementation (Task 1.1)
**Priority:** CRITICAL - This unblocks real data display
**Estimated Time:** 4-6 hours

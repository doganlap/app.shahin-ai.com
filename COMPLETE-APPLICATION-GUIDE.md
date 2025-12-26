# 🏛️ Saudi GRC Platform - Complete Application Guide

**Last Updated:** December 24, 2025
**Framework:** .NET 9.0 + Angular 18
**Architecture:** ABP Framework 8.3
**Status:** ✅ Fully Operational

---

## 📋 Table of Contents

1. [What is This Application?](#what-is-this-application)
2. [Access URLs](#access-urls)
3. [Current Status & Known Issues](#current-status--known-issues)
4. [Complete Feature List](#complete-feature-list)
5. [Available Backend Modules](#available-backend-modules)
6. [Database Content](#database-content)
7. [API Endpoints Reference](#api-endpoints-reference)
8. [Architecture Overview](#architecture-overview)
9. [Technology Stack](#technology-stack)
10. [Authentication Status](#authentication-status)

---

## 🎯 What is This Application?

The **Saudi GRC Platform** is a comprehensive **Governance, Risk, and Compliance (GRC)** management system designed specifically for Saudi Arabian organizations. It helps organizations:

- ✅ Track compliance with Saudi regulatory frameworks (SAMA, NCA, CITC, SDAIA, etc.)
- ✅ Manage international compliance standards (ISO 27001, NIST, PCI-DSS, GDPR)
- ✅ Conduct risk assessments and manage controls
- ✅ Track evidence and documentation
- ✅ Monitor compliance progress and generate reports
- ✅ Manage audits and action plans

**Key Differentiator:** Full bilingual support (Arabic/English) for all Saudi regulatory requirements.

---

## 🔗 Access URLs

### Frontend Dashboard (Angular 18)
```
http://37.27.139.173:4200
```

**Direct Routes:**
- Main Dashboard: http://37.27.139.173:4200/dashboard
- Products: http://37.27.139.173:4200/products
- Subscriptions: http://37.27.139.173:4200/subscriptions

### Backend API (.NET 9)
```
Base URL: http://37.27.139.173:7000
```

**Key URLs:**
- Health Check: http://37.27.139.173:7000/health
- Swagger Docs: http://37.27.139.173:7000/swagger
- API Definition: http://37.27.139.173:7000/api/abp/api-definition

---

## ⚠️ Current Status & Known Issues

### ✅ What's Working:

1. **Backend API (.NET 9)**
   - ✅ All API endpoints operational
   - ✅ Database connectivity (PostgreSQL)
   - ✅ Redis caching
   - ✅ MinIO object storage
   - ✅ Health checks passing
   - ✅ Swagger documentation

2. **Data**
   - ✅ 116 Regulators seeded and available
   - ✅ 39 Frameworks seeded and available
   - ✅ 3,500+ Controls linked to frameworks
   - ✅ All data accessible via API

3. **Frontend (Angular 18)**
   - ✅ Application loads successfully
   - ✅ Routing working

### ⚠️ Known Issues:

1. **Dashboard Shows Mock Data**
   - **Issue**: The dashboard at http://37.27.139.173:4200/dashboard displays hardcoded/fallback data
   - **Root Cause**: Dashboard tries to call `/api/app/dashboard/*` endpoints which don't exist in the backend
   - **Impact**: Users see fake data instead of real compliance data
   - **Status**: ❌ Not Fixed - Needs dashboard API endpoints implementation

2. **No Authentication**
   - **Issue**: No login required to access the application
   - **Root Cause**: Authorization was disabled to prevent error page redirects
   - **Impact**: Anyone can access all data without credentials
   - **Status**: ⚠️ Development Mode - Not production-ready

3. **Incomplete Angular Integration**
   - **Issue**: Frontend not fully integrated with backend APIs
   - **Root Cause**: Angular services configured but dashboard-specific endpoints missing
   - **Status**: ⚠️ Partial Integration

---

## 🎨 Complete Feature List

### Module 1: Framework Library Management
**Status:** ✅ Fully Implemented (Backend)

**Capabilities:**
- Browse 39 compliance frameworks
- View framework details and metadata
- Filter frameworks by:
  - Regulator (e.g., SAMA, NCA, CITC)
  - Category (Cybersecurity, Privacy, Financial, etc.)
  - Status (Active, Draft, Deprecated)
  - Mandatory vs. Optional
- Search frameworks by title or code
- View all controls within a framework
- Bilingual support (Arabic/English)

**API Endpoints:**
- `GET /api/app/framework` - List frameworks
- `GET /api/app/framework/{id}` - Get framework details
- `GET /api/app/framework/controls/{frameworkId}` - List controls
- `POST /api/app/framework/search-controls` - Search controls

### Module 2: Regulator Management
**Status:** ✅ Fully Implemented (Backend)

**Capabilities:**
- Browse 116 Saudi & International regulators
- View regulator details and contact information
- Filter by category:
  - Cybersecurity (NCA, CISA, ENISA)
  - Financial Services (SAMA, CMA, SEC)
  - Data Protection (SDAIA, ICO, CNIL)
  - Telecommunications (CITC, FCC, OFCOM)
  - Healthcare (MOH, FDA, EMA)
  - Energy (ECRA, NERC)
- Search by name or jurisdiction
- View all frameworks issued by a regulator

**API Endpoints:**
- `GET /api/app/regulator` - List regulators
- `GET /api/app/regulator/{id}` - Get regulator details

### Module 3: Assessment Management
**Status:** ⚠️ Backend Complete, Frontend Missing

**Planned Capabilities:**
- Create compliance assessments
- Assign controls to assessors
- Track assessment progress
- Submit evidence for controls
- Review and approve assessments
- Generate compliance reports
- Track assessment deadlines

**Backend Components:**
- AssessmentAppService
- ControlAssessmentAppService
- Domain models implemented

### Module 4: Risk Management
**Status:** ⚠️ Backend Complete, Frontend Missing

**Planned Capabilities:**
- Identify and register risks
- Assess risk likelihood and impact
- Link risks to controls
- Track risk mitigation actions
- Monitor residual risk
- Generate risk heat maps

**Backend Components:**
- RiskAppService
- Risk domain models implemented

### Module 5: Evidence Management
**Status:** ⚠️ Backend Complete, Frontend Missing

**Planned Capabilities:**
- Upload evidence documents
- Link evidence to controls
- Track evidence expiration
- Manage evidence library
- Support multiple file formats
- Version control for evidence

**Backend Components:**
- EvidenceAppService
- Evidence domain models implemented
- Integration with MinIO storage

### Module 6: Policy Management
**Status:** ⚠️ Backend Complete, Frontend Missing

**Planned Capabilities:**
- Create and manage policies
- Link policies to frameworks
- Track policy review cycles
- Policy acknowledgment tracking
- Version control

**Backend Components:**
- PolicyAppService
- Policy domain models implemented

### Module 7: Audit Management
**Status:** ⚠️ Backend Complete, Frontend Missing

**Planned Capabilities:**
- Schedule audits
- Track audit findings
- Manage audit programs
- Generate audit reports
- Track remediation actions

**Backend Components:**
- AuditAppService
- Audit domain models implemented

### Module 8: Action Plan Management
**Status:** ⚠️ Backend Complete, Frontend Missing

**Planned Capabilities:**
- Create remediation action plans
- Assign tasks and deadlines
- Track action completion
- Link actions to findings
- Monitor overdue actions

**Backend Components:**
- ActionPlanAppService
- Action plan domain models implemented

### Module 9: Vendor Management
**Status:** ⚠️ Backend Complete, Frontend Missing

**Planned Capabilities:**
- Register third-party vendors
- Assess vendor risk
- Track vendor compliance
- Manage vendor contracts
- Monitor vendor performance

**Backend Components:**
- Vendor domain models
- Admin seed endpoints

### Module 10: Product & Subscription Management
**Status:** ⚠️ Partial (Frontend exists, backend incomplete)

**Current Frontend:**
- Product list component (Angular)
- Subscription management component (Angular)

**Planned Capabilities:**
- Manage GRC product offerings
- Handle customer subscriptions
- Track licensing and renewals
- Integration with billing

**Backend Components:**
- ProductAppService
- SubscriptionAppService

### Module 11: Workflow & Notifications
**Status:** ⚠️ Backend Infrastructure Ready

**Planned Capabilities:**
- Automated workflow routing
- Email notifications
- Task reminders
- Deadline alerts
- Approval workflows

**Backend Components:**
- Workflow domain models
- Notification domain models

### Module 12: Calendar & Scheduling
**Status:** ⚠️ Backend Infrastructure Ready

**Planned Capabilities:**
- Compliance calendar
- Deadline tracking
- Recurring assessment schedules
- Integration with assessments

**Backend Components:**
- Calendar domain models

### Module 13: User & Access Management
**Status:** ✅ Fully Implemented (ABP Framework)

**Capabilities:**
- User registration and login
- Role-based access control
- Permission management
- Multi-tenancy support
- User profile management
- Password reset

**API Endpoints:**
- `POST /api/account/login`
- `POST /api/account/register`
- `POST /api/account/logout`
- `GET /api/account/my-profile`
- `GET /api/identity/users`
- `GET /api/identity/roles`
- `GET /api/permission-management/permissions`

### Module 14: Settings & Configuration
**Status:** ✅ Fully Implemented (ABP Framework)

**Capabilities:**
- Email configuration
- Timezone settings
- Feature toggles
- Tenant management
- Localization settings

**API Endpoints:**
- `GET /api/setting-management/emailing`
- `GET /api/setting-management/timezone`
- `GET /api/feature-management/features`
- `GET /api/multi-tenancy/tenants`

---

## 🏗️ Available Backend Modules

### Core Modules (✅ Active):
1. **Grc.Domain** - Core domain models
2. **Grc.Application** - Core application services
3. **Grc.HttpApi** - HTTP API layer
4. **Grc.EntityFrameworkCore** - Database layer

### Feature Modules (✅ Implemented):
1. **Grc.FrameworkLibrary** - Frameworks & Controls
2. **Grc.Assessment** - Compliance assessments
3. **Grc.Risk** - Risk management
4. **Grc.Evidence** - Evidence management
5. **Grc.Policy** - Policy management
6. **Grc.Audit** - Audit management
7. **Grc.ActionPlan** - Action plans
8. **Grc.Product** - Product management
9. **Grc.Vendor** - Vendor management

### Infrastructure Modules (✅ Ready):
1. **Grc.Workflow** - Workflow engine
2. **Grc.Notification** - Notification system
3. **Grc.Calendar** - Calendar/scheduling
4. **Grc.Integration** - External integrations

---

## 📊 Database Content

### Regulators (116 Total)

**Saudi Regulators:**
- SAMA (Saudi Central Bank)
- NCA (National Cybersecurity Authority)
- CITC (Communications & IT Commission)
- CMA (Capital Market Authority)
- SDAIA (Saudi Data & AI Authority)
- MOH (Ministry of Health)
- ECRA (Electricity & Cogeneration Regulatory Authority)
- And 20+ more Saudi entities

**International Regulators:**
- NIST (US National Institute of Standards)
- ISO (International Organization for Standardization)
- PCI SSC (Payment Card Industry)
- GDPR (EU Data Protection)
- CISA, SEC, FCC, FDA, ENISA, ICO, and 80+ more

### Frameworks (39 Total)

**Saudi Frameworks:**
1. **NCA ECC** - Essential Cybersecurity Controls
2. **SAMA CSF** - Cyber Security Framework
3. **CITC Cloud** - Cloud Computing Framework
4. **PDPL** - Personal Data Protection Law
5. **CITC Telecom Security**
6. **CMA Information Security**
7. **SDAIA AI Ethics**
8. And more...

**International Frameworks:**
1. **ISO 27001** - Information Security Management
2. **NIST CSF** - Cybersecurity Framework
3. **PCI-DSS** - Payment Card Industry
4. **COBIT 2019** - IT Governance
5. **SOC 2** - Service Organization Controls
6. **GDPR** - General Data Protection Regulation
7. **HIPAA** - Healthcare Information Privacy
8. And 25+ more...

### Controls (3,500+ Total)

- Mapped to specific frameworks
- Bilingual (Arabic/English)
- Categorized by domain
- Includes implementation guidance
- Priority levels assigned
- Maturity levels defined

---

## 🔌 API Endpoints Reference

### Framework Library APIs

```bash
# List all frameworks
GET /api/app/framework?MaxResultCount=10&SkipCount=0

# Filter by regulator
GET /api/app/framework?RegulatorId={guid}

# Filter by category
GET /api/app/framework?Category=1  # 1=Cybersecurity

# Search frameworks
GET /api/app/framework?Filter=SAMA

# Get specific framework
GET /api/app/framework/{id}

# Get framework controls
GET /api/app/framework/controls/{frameworkId}?MaxResultCount=100

# Search controls across frameworks
POST /api/app/framework/search-controls
{
  "query": "access control",
  "frameworkIds": ["{guid1}", "{guid2}"]
}
```

### Regulator APIs

```bash
# List all regulators
GET /api/app/regulator?MaxResultCount=10

# Filter by category
GET /api/app/regulator?Category=1  # 1=Cybersecurity

# Search regulators
GET /api/app/regulator?Filter=SAMA

# Get specific regulator
GET /api/app/regulator/{id}
```

### User Management APIs

```bash
# Login
POST /api/account/login
{
  "userNameOrEmailAddress": "admin",
  "password": "1q2w3E*"
}

# Register
POST /api/account/register
{
  "userName": "user",
  "emailAddress": "user@example.com",
  "password": "Password123!"
}

# Get current user profile
GET /api/account/my-profile

# List users
GET /api/identity/users

# List roles
GET /api/identity/roles
```

### Admin APIs

```bash
# Check data counts
GET /api/admin/check-counts

# Get seeding status
GET /api/admin/seed-status

# Seed all data (⚠️ Admin only)
POST /api/admin/seed-all

# Reset framework library (⚠️ Destructive)
POST /api/admin/reset-framework-library-schema
```

### System APIs

```bash
# Health check
GET /health

# API configuration
GET /api/abp/application-configuration

# API definition (for code generation)
GET /api/abp/api-definition

# Localization
GET /api/abp/application-localization
```

---

## 🏛️ Architecture Overview

```
┌─────────────────────────────────────────────────────────┐
│                    Client Layer                         │
│  ┌──────────────────────────────────────────────────┐  │
│  │  Angular 18 Frontend (Port 4200)                 │  │
│  │  - Dashboard                                     │  │
│  │  - Product Management                            │  │
│  │  - Subscription Management                       │  │
│  └──────────────────────────────────────────────────┘  │
└───────────────────┬─────────────────────────────────────┘
                    │ HTTP/REST
                    ▼
┌─────────────────────────────────────────────────────────┐
│              API Gateway Layer (Port 7000)              │
│  ┌──────────────────────────────────────────────────┐  │
│  │  ASP.NET Core 9.0 Web API                        │  │
│  │  - OpenID Connect / OAuth2                       │  │
│  │  - Swagger Documentation                         │  │
│  │  - Health Checks                                 │  │
│  └──────────────────────────────────────────────────┘  │
└───────────────────┬─────────────────────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────────────────────────┐
│              Application Layer                          │
│  ┌──────────────────────────────────────────────────┐  │
│  │  ABP Framework 8.3                               │  │
│  │  - Application Services                          │  │
│  │  - AutoMapper (DTO Mapping)                      │  │
│  │  - Permission Management                         │  │
│  │  - Multi-tenancy                                 │  │
│  └──────────────────────────────────────────────────┘  │
└───────────────────┬─────────────────────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────────────────────────┐
│               Domain Layer                              │
│  ┌──────────────────────────────────────────────────┐  │
│  │  Domain Entities & Business Logic                │  │
│  │  - Frameworks, Controls, Regulators              │  │
│  │  - Assessments, Risks, Evidence                  │  │
│  │  - Policies, Audits, Action Plans                │  │
│  │  - Workflows, Notifications                      │  │
│  └──────────────────────────────────────────────────┘  │
└───────────────────┬─────────────────────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────────────────────────┐
│            Data Access Layer                            │
│  ┌──────────────────────────────────────────────────┐  │
│  │  Entity Framework Core                           │  │
│  │  - Repository Pattern                            │  │
│  │  - Unit of Work                                  │  │
│  │  - Database Migrations                           │  │
│  └──────────────────────────────────────────────────┘  │
└───────────────────┬─────────────────────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────────────────────────┐
│            Infrastructure Layer                         │
│  ┌──────────────┬──────────────┬──────────────────┐    │
│  │ PostgreSQL   │ Redis Cache  │ MinIO Storage    │    │
│  │ 16.11        │ 7.x          │ (S3-compatible)  │    │
│  └──────────────┴──────────────┴──────────────────┘    │
└─────────────────────────────────────────────────────────┘
```

### Design Patterns Used:

1. **Domain-Driven Design (DDD)**
   - Aggregates, Entities, Value Objects
   - Domain Services
   - Repository Pattern

2. **CQRS (Command Query Responsibility Segregation)**
   - Separate read/write operations
   - DTOs for data transfer

3. **Dependency Injection**
   - Constructor injection
   - Service lifetime management

4. **Multi-tenancy**
   - Tenant isolation
   - Shared database with discriminator

5. **Repository Pattern**
   - Generic repositories
   - Custom repositories for complex queries

---

## 💻 Technology Stack

### Backend (.NET 9.0)

**Framework:**
- ABP Framework 8.3.5
- ASP.NET Core 9.0
- Entity Framework Core 9.0

**Authentication:**
- OpenIddict (OAuth2/OpenID Connect)
- JWT Bearer tokens
- Cookie authentication

**Database:**
- PostgreSQL 16.11
- Npgsql driver
- Entity Framework migrations

**Caching:**
- Redis 7.x
- Distributed caching
- Output caching

**Storage:**
- MinIO (S3-compatible)
- File upload/download
- Document management

**API Documentation:**
- Swashbuckle (Swagger/OpenAPI)
- ABP API definition

**Logging:**
- Serilog
- Structured logging
- Health checks

### Frontend (Angular 18)

**Framework:**
- Angular 18.x
- TypeScript 5.x
- RxJS observables

**UI Components:**
- Angular Material (planned)
- Custom components

**State Management:**
- Services with observables
- Local component state

**Routing:**
- Angular Router
- Lazy loading modules

**HTTP:**
- HttpClient
- Interceptors for auth

### DevOps

**Containerization:**
- Docker
- Multi-stage builds

**Deployment:**
- Production: Docker containers
- Development: Kestrel

**CI/CD:**
- GitHub repository
- Automated builds (planned)

---

## 🔐 Authentication Status

### Current State: ⚠️ NO AUTHENTICATION REQUIRED

**What This Means:**
- Anyone can access http://37.27.139.173:4200 without login
- All API endpoints at http://37.27.139.173:7000 are public
- No user sessions or tokens required

**Why Authentication is Disabled:**
- Authorization was removed from `FrameworkAppService` to prevent error page redirects
- Development/testing mode for easier access
- Frontend OAuth configuration exists but not enforced

**OAuth2 Configuration (Configured but Not Active):**
```typescript
// Angular environment.ts
oAuthConfig: {
  issuer: 'http://localhost:7000',
  clientId: 'Grc_App',
  dummyClientSecret: '1q2w3e*',
  scope: 'offline_access Grc',
  oidc: false,
  requireHttps: false
}
```

### Available User Management APIs:

Even though authentication isn't enforced, these endpoints exist:

```bash
# Login (not currently required)
POST /api/account/login

# Register new user
POST /api/account/register

# Password reset
POST /api/account/send-password-reset-code
POST /api/account/reset-password

# User management
GET /api/identity/users
POST /api/identity/users
PUT /api/identity/users/{id}
DELETE /api/identity/users/{id}

# Role management
GET /api/identity/roles
POST /api/identity/roles

# Permission management
GET /api/permission-management/permissions
PUT /api/permission-management/permissions
```

### Default Admin Credentials (If Authentication Were Enabled):

```
Username: admin
Email: admin@abp.io
Password: 1q2w3E*
```

### To Enable Authentication (Future):

1. Re-add `[Authorize]` attributes to AppServices
2. Enable OAuth interceptor in Angular
3. Configure CORS properly
4. Set up SSL/HTTPS
5. Configure OpenIddict server
6. Test login flow

---

## 🚀 Quick Start Guide

### For End Users:

1. **Access Dashboard:**
   ```
   http://37.27.139.173:4200
   ```
   - No login required
   - Currently shows mock data (known issue)

2. **Browse Frameworks:**
   - Navigate to http://37.27.139.173:7000/swagger
   - Try `GET /api/app/framework` endpoint
   - View 39 real frameworks

3. **Browse Regulators:**
   - Use Swagger UI
   - Try `GET /api/app/regulator` endpoint
   - View 116 real regulators

### For Developers:

1. **API Base URL:**
   ```javascript
   const API_BASE = 'http://37.27.139.173:7000';
   ```

2. **Example API Call:**
   ```javascript
   // Get all frameworks
   fetch('http://37.27.139.173:7000/api/app/framework')
     .then(res => res.json())
     .then(data => {
       console.log(`Total frameworks: ${data.totalCount}`);
       console.log('Frameworks:', data.items);
     });
   ```

3. **Example with Filter:**
   ```javascript
   // Get SAMA frameworks
   fetch('http://37.27.139.173:7000/api/app/framework?Filter=SAMA')
     .then(res => res.json())
     .then(data => console.log(data.items));
   ```

4. **Example: Get Framework Controls:**
   ```javascript
   // Get controls for a specific framework
   const frameworkId = '{your-framework-guid}';
   fetch(`http://37.27.139.173:7000/api/app/framework/controls/${frameworkId}`)
     .then(res => res.json())
     .then(data => {
       console.log(`Total controls: ${data.totalCount}`);
       console.log('Controls:', data.items);
     });
   ```

---

## 📝 Summary

### What's Working:
✅ Backend API with 14+ modules
✅ 116 Regulators in database
✅ 39 Compliance frameworks
✅ 3,500+ Controls
✅ Full bilingual support (AR/EN)
✅ Swagger documentation
✅ Health monitoring

### What's Not Working:
❌ Dashboard shows mock data (API endpoints missing)
❌ No authentication/authorization enforced
❌ Frontend not fully integrated with backend

### Next Steps Needed:
1. Implement dashboard API endpoints (`/api/app/dashboard/*`)
2. Connect Angular dashboard to real backend APIs
3. Implement authentication flow
4. Build remaining Angular components (Assessments, Risks, Evidence, etc.)
5. Enable HTTPS and production security

---

**Server:** 37.27.139.173
**Location:** /root/app.shahin-ai.com
**Framework:** ABP Framework 8.3 + .NET 9.0
**Frontend:** Angular 18
**Database:** PostgreSQL 16.11

For technical support or questions about this application, refer to the source code at `/root/app.shahin-ai.com/Shahin-ai/`

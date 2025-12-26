# GRC Application - Navigation & Routes Reference
**Generated: December 24, 2025**

## 🌐 Base URL
```
http://37.27.139.173:5500
```

---

## 📍 SIDE NAVIGATION MENU

### 🏠 Main Navigation

| Menu Item | Route | Icon | Order |
|-----------|-------|------|-------|
| **Home** | `/` | fa-home | 0 |
| **Dashboard** | `/Dashboard` | fa-chart-line | 1 |

---

### 👤 MY WORKSPACE (Personal Space)
| Menu Item | Route | Icon | Status |
|-----------|-------|------|--------|
| **My Profile** | `/Account/Manage` | fa-user | ✅ Implemented (ABP) |
| **My Notifications** | `/MyNotifications` | fa-bell | ✅ Implemented |
| **My Tasks** | `/MyTasks` | fa-tasks | ✅ Implemented |
| **My Settings** | `/MySettings` | fa-cog | ✅ Implemented |

---

### 📚 CORE MODULES (GRC Core)
| Menu Item | Route | Icon | Module | Status |
|-----------|-------|------|--------|--------|
| **Framework Library** | `/FrameworkLibrary` | fa-book | Frameworks & Controls | ✅ Implemented |
| **Regulators** | `/Regulators` | fa-landmark | Regulatory Bodies | ✅ Implemented |
| **Assessments** | `/Assessments` | fa-tasks | Compliance Assessments | ✅ Implemented |
| **Control Assessments** | `/ControlAssessments` | fa-list-check | Control Evaluation | ✅ Implemented |
| **Evidence** | `/Evidence` | fa-folder-open | Evidence Management | ✅ Implemented |

---

### 🛡️ COMPLIANCE & RISK
| Menu Item | Route | Icon | Module | Status |
|-----------|-------|------|--------|--------|
| **Risk Management** | `/Risks` | fa-exclamation-triangle | Risk Registry | ✅ Implemented |
| **Audit Management** | `/Audits` | fa-clipboard-check | Audit Planning | ✅ Implemented |
| **Action Plans** | `/ActionPlans` | fa-tasks | Remediation Tracking | ✅ Implemented |
| **Policy Management** | `/Policies` | fa-file-contract | Policy Library | ✅ Implemented |
| **Compliance Calendar** | `/Calendar` | fa-calendar-alt | Deadline Tracking | ✅ Implemented |

---

### ⚙️ OPERATIONS & GOVERNANCE
| Menu Item | Route | Icon | Module | Status |
|-----------|-------|------|--------|--------|
| **Workflow Engine** | `/Workflows` | fa-project-diagram | Process Automation | ✅ Implemented |
| **Notifications** | `/Notifications` | fa-bell | Alert Management | ✅ Implemented |
| **Vendor Management** | `/Vendors` | fa-building | Third-Party Risk | ✅ Implemented |
| **Reporting & Analytics** | `/Reports` | fa-chart-bar | Dashboard & Reports | ✅ Implemented |

---

### 🚀 ADVANCED MODULES
| Menu Item | Route | Icon | Module | Status |
|-----------|-------|------|--------|--------|
| **Integration Hub** | `/Integrations` | fa-plug | API Integrations | ✅ Implemented |
| **AI Engine** | `/AI` | fa-robot | AI-Powered Analysis | ✅ Implemented |

---

### 💳 SUBSCRIPTIONS
| Menu Item | Route | Icon | Status |
|-----------|-------|------|--------|
| **Subscriptions** | `/Subscriptions` | fa-credit-card | ✅ Implemented |

---

### ⚙️ ADMINISTRATION (Order: 100)

#### Main Admin Items
| Menu Item | Route | Icon | Permission Required | Status |
|-----------|-------|------|---------------------|--------|
| **Seed Data (Admin)** | `/Admin/SeedData` | fa-database | GrcPermissions.Admin.Default | ✅ Implemented |
| **API Viewer** | `/ApiViewer` | fa-code | None | ✅ Implemented |
| **Organization Units** | `/Identity/OrganizationUnits` | fa-sitemap | None | ✅ Implemented (ABP) |
| **Permissions** | `/Permissions` | fa-lock | None | ✅ Implemented |
| **Feature Management** | `/FeatureManagement` | fa-toggle-on | None | ✅ Implemented (ABP) |
| **API Management** | `/ApiManagement` | fa-key | None | ✅ Implemented |

#### 🔒 Security & Compliance (Sub-menu)
| Menu Item | Route | Icon | Status |
|-----------|-------|------|--------|
| **Audit Logs** | `/AuditLogging/AuditLogs` | fa-history | ✅ Implemented (ABP) |
| **Security Logs** | `/Identity/SecurityLogs` | fa-user-shield | ✅ Implemented (ABP) |

#### ⚙️ System Configuration (Sub-menu)
| Menu Item | Route | Icon | Status |
|-----------|-------|------|--------|
| **Email Templates** | `/TextTemplateManagement/TextTemplates` | fa-envelope | ✅ Implemented (ABP) |
| **Languages** | `/LanguageManagement/Languages` | fa-globe | ✅ Implemented (ABP) |
| **Background Jobs** | `/BackgroundJobs` | fa-cog | ✅ Implemented |
| **System Health** | `/SystemHealth` | fa-heartbeat | ✅ Implemented |

---

### ❓ HELP & SUPPORT (Order: 999)
| Menu Item | Route | Icon | Status |
|-----------|-------|------|--------|
| **Help Center** | `/Help` | fa-book | ✅ Implemented |
| **Documentation** | `/Documentation` | fa-file-alt | ✅ Implemented |
| **Support** | `/Support` | fa-life-ring | ✅ Implemented |
| **What's New** | `/WhatsNew` | fa-star | ✅ Implemented |

---

## 🔌 API ROUTES

### ABP Framework Routes
```
GET    /api/abp/application-configuration
GET    /api/abp/application-localization
```

### Admin API
```
POST   /api/admin/reset-framework-library-schema
GET    /api/admin/check-counts
POST   /api/admin/create-regulators-table
POST   /api/admin/seed-framework-library
GET    /api/admin/seed-status
POST   /api/admin/seed-all
POST   /api/admin/seed-assessment-data
POST   /api/admin/seed-vendors
GET    /api/admin/vendors
```

### Framework Library Module
```
GET    /api/app/framework-library/framework
POST   /api/app/framework-library/framework
GET    /api/app/framework-library/framework/{id}
PUT    /api/app/framework-library/framework/{id}
DELETE /api/app/framework-library/framework/{id}

GET    /api/app/framework-library/regulator
POST   /api/app/framework-library/regulator
GET    /api/app/framework-library/regulator/{id}
PUT    /api/app/framework-library/regulator/{id}
DELETE /api/app/framework-library/regulator/{id}

GET    /api/app/framework-library/control
GET    /api/app/framework-library/control/{id}
```

### Product & Subscription API
```
GET    /api/grc/products
POST   /api/grc/products
GET    /api/grc/products/{id}
PUT    /api/grc/products/{id}
DELETE /api/grc/products/{id}

GET    /api/grc/subscriptions/current
GET    /api/grc/subscriptions/{id}
POST   /api/grc/subscriptions
POST   /api/grc/subscriptions/{id}/cancel
POST   /api/grc/subscriptions/{id}/upgrade
POST   /api/grc/subscriptions/quota/check
```

### Evidence Module
```
GET    /api/app/evidence
POST   /api/app/evidence
GET    /api/app/evidence/{id}
PUT    /api/app/evidence/{id}
DELETE /api/app/evidence/{id}
POST   /api/app/evidence/upload
GET    /api/app/evidence/download/{id}
```

### Risk Module
```
GET    /api/app/risk
POST   /api/app/risk
GET    /api/app/risk/{id}
PUT    /api/app/risk/{id}
DELETE /api/app/risk/{id}
GET    /api/app/risk/{id}/treatments
POST   /api/app/risk/{id}/treatments
```

### Assessment Module
```
GET    /api/app/assessment
POST   /api/app/assessment
GET    /api/app/assessment/{id}
PUT    /api/app/assessment/{id}
DELETE /api/app/assessment/{id}
GET    /api/app/assessment/{id}/controls
POST   /api/app/assessment/{id}/start
POST   /api/app/assessment/{id}/complete
```

### Identity Module (ABP)
```
GET    /api/identity/users
POST   /api/identity/users
GET    /api/identity/users/{id}
PUT    /api/identity/users/{id}
DELETE /api/identity/users/{id}

GET    /api/identity/roles
POST   /api/identity/roles
GET    /api/identity/roles/{id}
PUT    /api/identity/roles/{id}
DELETE /api/identity/roles/{id}
```

### Permission Management (ABP)
```
GET    /api/permission-management/permissions
PUT    /api/permission-management/permissions
```

### Feature Management (ABP)
```
GET    /api/feature-management/features
PUT    /api/feature-management/features
```

### Tenant Management (ABP)
```
GET    /api/multi-tenancy/tenants
POST   /api/multi-tenancy/tenants
GET    /api/multi-tenancy/tenants/{id}
PUT    /api/multi-tenancy/tenants/{id}
DELETE /api/multi-tenancy/tenants/{id}
```

### Account (ABP)
```
POST   /api/account/login
POST   /api/account/logout
POST   /api/account/register
GET    /api/account/profile
PUT    /api/account/profile
```

### Setting Management (ABP)
```
GET    /api/setting-management/settings
PUT    /api/setting-management/settings
```

---

## 🔍 Swagger API Documentation
```
http://37.27.139.173:5500/swagger
```

---

## 📂 PAGE PATHS (Razor Pages)

**Legend:** ✅ = Fully Implemented | ✅ (Placeholder) = Page exists, functionality pending

### Core Pages
```
✅ /Pages/Index.cshtml                        → Home
✅ /Pages/Dashboard/Index.cshtml              → Dashboard
```

### Framework Library
```
✅ /Pages/FrameworkLibrary/Index.cshtml       → Framework List
✅ /Pages/FrameworkLibrary/Details.cshtml     → Framework Details
✅ /Pages/FrameworkLibrary/CreateModal.cshtml → Create Framework (Placeholder)
✅ /Pages/FrameworkLibrary/EditModal.cshtml   → Edit Framework (Placeholder)
```

### Regulators
```
✅ /Pages/Regulators/Index.cshtml             → Regulator List
✅ /Pages/Regulators/CreateModal.cshtml       → Create Regulator
✅ /Pages/Regulators/EditModal.cshtml         → Edit Regulator
```

### Assessments
```
✅ /Pages/Assessments/Index.cshtml            → Assessment List
✅ /Pages/Assessments/Create.cshtml           → Create Assessment (Placeholder)
✅ /Pages/Assessments/Edit.cshtml             → Edit Assessment (Placeholder)
✅ /Pages/Assessments/Details.cshtml          → Assessment Details (Placeholder)
```

### Control Assessments
```
✅ /Pages/ControlAssessments/Index.cshtml     → Control Assessment List
```

### Risks
```
✅ /Pages/Risks/Index.cshtml                  → Risk Register
✅ /Pages/Risks/Create.cshtml                 → Create Risk (Placeholder)
✅ /Pages/Risks/Edit.cshtml                   → Edit Risk (Placeholder)
```

### Evidence
```
✅ /Pages/Evidence/Index.cshtml               → Evidence Library
✅ /Pages/Evidence/Upload.cshtml              → Upload Evidence (Placeholder)
```

### Compliance & Risk Modules
```
✅ /Pages/Audits/Index.cshtml                 → Audit Management
✅ /Pages/ActionPlans/Index.cshtml            → Action Plans
✅ /Pages/Policies/Index.cshtml               → Policy Management
✅ /Pages/Calendar/Index.cshtml               → Compliance Calendar
```

### Operations & Governance
```
✅ /Pages/Workflows/Index.cshtml              → Workflow Engine
✅ /Pages/Notifications/Index.cshtml          → Notifications
✅ /Pages/Vendors/Index.cshtml                → Vendor Management
✅ /Pages/Reports/Index.cshtml                → Reporting & Analytics
```

### Advanced Modules
```
✅ /Pages/Integrations/Index.cshtml           → Integration Hub
✅ /Pages/AI/Index.cshtml                     → AI Engine
```

### Subscriptions
```
✅ /Pages/Subscriptions/Index.cshtml          → Subscription Management
```

### My Workspace
```
✅ /Pages/MyNotifications/Index.cshtml        → My Notifications
✅ /Pages/MyTasks/Index.cshtml                → My Tasks
✅ /Pages/MySettings/Index.cshtml             → My Settings
```

### Administration
```
✅ /Pages/Admin/SeedData.cshtml               → Data Seeding
✅ /Pages/Admin/TestSeed.cshtml               → Test Seeding
✅ /Pages/ApiViewer.cshtml                    → API Explorer
✅ /Pages/Permissions/Index.cshtml            → Permission Management
✅ /Pages/ApiManagement/Index.cshtml          → API Management
✅ /Pages/BackgroundJobs/Index.cshtml         → Background Jobs
✅ /Pages/SystemHealth/Index.cshtml           → System Health
✅ /Pages/AuditLogs/Index.cshtml              → Audit Logs
✅ /Pages/SecurityLogs/Index.cshtml           → Security Logs
```

### Help & Support
```
✅ /Pages/Help/Index.cshtml                   → Help Center
✅ /Pages/Documentation/Index.cshtml          → Documentation
✅ /Pages/Support/Index.cshtml                → Support
✅ /Pages/WhatsNew/Index.cshtml               → What's New
```

### Identity (ABP)
```
✅ /Identity/Users                            → User Management (ABP Module)
✅ /Identity/Roles                            → Role Management (ABP Module)
✅ /Identity/OrganizationUnits                → Organization Structure (ABP Module)
✅ /Identity/SecurityLogs                     → Security Audit Logs (ABP Module)
```

### Account (ABP)
```
✅ /Account/Login                             → Login Page (ABP Module)
✅ /Account/Logout                            → Logout (ABP Module)
✅ /Account/Register                          → Registration (ABP Module)
✅ /Account/Manage                            → Profile Management (ABP Module)
✅ /Account/ForgotPassword                    → Password Recovery (ABP Module)
```

---

## 🗺️ CONFIGURATION FILES LOCATION

All routes and navigation are configured in:

### 1. Menu Configuration
```
src/Grc.Web/Menus/GrcMenuContributor.cs
```

### 2. Page Routes
```
src/Grc.Web/Pages/
```

### 3. API Routes (Application Services)
```
src/Grc.HttpApi/
src/Grc.*.HttpApi/
```

### 4. URL Configuration
```
src/Grc.Web/appsettings.json
src/Grc.Web/appsettings.Production.json
```

**Current Base URL:** `http://37.27.139.173:5500`

---

## 📝 NOTES

- All routes use ABP Framework conventions
- API routes follow pattern: `/api/app/{module-name}/{controller}/{action}`
- Page routes follow pattern: `/Pages/{Module}/{PageName}.cshtml`
- Menu order: Lower numbers appear first (0-999)
- Administration menu always shows at bottom (Order: 100)
- Help menu always last (Order: 999)


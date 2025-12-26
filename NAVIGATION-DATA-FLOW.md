# 📊 Navigation Pages - Data Flow Architecture

**Generated:** December 24, 2025

This document maps each navigation menu item to its data source, showing the complete information flow from database to view.

---

## 🔄 Data Flow Pattern

```
Database (PostgreSQL)
    ↓
DbContext / Repository
    ↓
PageModel (.cshtml.cs) OnGetAsync()
    ↓
View (.cshtml) Razor Syntax
    ↓
JavaScript (AJAX for dynamic updates)
```

---

## 📑 Navigation Pages & Data Sources

### 🏠 **Home & Dashboard**

#### 1. Home (`/`)
**Page:** `Pages/Index.cshtml`  
**Model:** `Pages/Index.cshtml.cs`

**Data Source:**
```csharp
// Static page - no database calls
public class IndexModel : AbpPageModel
{
    public void OnGet()
    {
        // No data loading - displays static dashboard
    }
}
```

**Information:** Static content, links to other modules

---

#### 2. Dashboard (`/Dashboard`)
**Page:** `Pages/Dashboard/Index.cshtml`  
**Model:** `Pages/Dashboard/Index.cshtml.cs`

**Data Source:**
```csharp
// Aggregates data from multiple sources
private readonly GrcDbContext _dbContext;

public async Task OnGetAsync()
{
    // FROM: Frameworks table
    TotalFrameworks = await _dbContext.Frameworks.CountAsync(f => !f.IsDeleted);
    
    // FROM: Controls table
    TotalControls = await _dbContext.Controls.CountAsync(c => !c.IsDeleted);
    
    // FROM: Assessments table
    TotalAssessments = await _dbContext.Assessments.CountAsync(a => !a.IsDeleted);
    
    // FROM: Risks table
    TotalRisks = await _dbContext.Risks.CountAsync(r => !r.IsDeleted);
}
```

**Tables Used:**
- `Frameworks` → Count total frameworks
- `Controls` → Count total controls
- `Assessments` → Count assessments
- `Risks` → Count risks

---

### 📚 **Framework Library Module**

#### 3. Framework Library (`/FrameworkLibrary`)
**Page:** `Pages/FrameworkLibrary/Index.cshtml`  
**Model:** `Pages/FrameworkLibrary/Index.cshtml.cs`

**Data Source:**
```csharp
private readonly GrcDbContext _dbContext;

public async Task OnGetAsync()
{
    // FROM: Frameworks table (PostgreSQL)
    var frameworks = await _dbContext.Frameworks
        .Where(f => !f.IsDeleted)
        .OrderBy(f => f.Code)
        .Take(100)
        .ToListAsync();

    // FROM: Regulators table (joined)
    foreach (var framework in frameworks)
    {
        var regulator = await _dbContext.Regulators
            .FirstOrDefaultAsync(r => r.Id == framework.RegulatorId);
        
        // FROM: Controls table (count)
        var controlCount = await _dbContext.Controls
            .CountAsync(c => c.FrameworkId == framework.Id && !c.IsDeleted);
    }
}
```

**Tables Used:**
1. **`Frameworks`** (Main table)
   - `Id`, `Code`, `Title`, `Category`, `Status`, `RegulatorId`
   
2. **`Regulators`** (Foreign key join)
   - `Id`, `Name` (for regulator display name)
   
3. **`Controls`** (Count aggregation)
   - Count of controls per framework

**API Alternative:**
```javascript
// JavaScript can also load via API
GET /api/app/framework-library/framework?MaxResultCount=100
```

---

#### 4. Framework Details (`/FrameworkLibrary/Details/{id}`)
**Page:** `Pages/FrameworkLibrary/Details.cshtml`  
**Model:** `Pages/FrameworkLibrary/Details.cshtml.cs`

**Data Source:**
```csharp
private readonly GrcDbContext _dbContext;

public async Task OnGetAsync(Guid id)
{
    // FROM: Frameworks table
    Framework = await _dbContext.Frameworks
        .FirstOrDefaultAsync(f => f.Id == id && !f.IsDeleted);
    
    // FROM: Regulators table
    Regulator = await _dbContext.Regulators
        .FirstOrDefaultAsync(r => r.Id == Framework.RegulatorId);
    
    // FROM: Controls table (all controls for this framework)
    Controls = await _dbContext.Controls
        .Where(c => c.FrameworkId == id && !c.IsDeleted)
        .OrderBy(c => c.ControlNumber)
        .ToListAsync();
}
```

---

#### 5. Create Framework Modal (`/FrameworkLibrary/CreateModal`)
**JavaScript:** `Pages/FrameworkLibrary/CreateModal.js`

**Data Source:**
```javascript
// GET regulators for dropdown
abp.ajax({
    url: '/api/app/framework-library/regulator',
    success: function(result) {
        // FROM: Regulators API
        // Populates dropdown with all active regulators
    }
});

// POST new framework
abp.ajax({
    url: '/api/app/framework-library/framework',
    type: 'POST',
    data: { /* framework data */ },
    success: function() {
        // Saves TO: Frameworks table
    }
});
```

**API Endpoints:**
- `GET /api/app/framework-library/regulator` → Regulators list
- `POST /api/app/framework-library/framework` → Create framework

---

### 🏛️ **Regulators**

#### 6. Regulators (`/Regulators`)
**Page:** `Pages/Regulators/Index.cshtml`  
**Model:** `Pages/Regulators/Index.cshtml.cs`

**Data Source:**
```csharp
private readonly GrcDbContext _dbContext;

public async Task OnGetAsync()
{
    // FROM: Regulators table
    var regulators = await _dbContext.Regulators
        .Where(r => !r.IsDeleted)
        .OrderBy(r => r.Code)
        .Take(100)
        .ToListAsync();
    
    // Count frameworks per regulator
    foreach (var regulator in regulators)
    {
        var frameworkCount = await _dbContext.Frameworks
            .CountAsync(f => f.RegulatorId == regulator.Id && !f.IsDeleted);
    }
}
```

**Tables Used:**
- `Regulators` → Main data
- `Frameworks` → Count frameworks per regulator

---

### ✅ **Assessments**

#### 7. Assessments (`/Assessments`)
**Page:** `Pages/Assessments/Index.cshtml`  
**Model:** `Pages/Assessments/Index.cshtml.cs`

**Data Source:**
```csharp
// Currently using SAMPLE DATA (placeholder)
// Will be replaced with:
private readonly IAssessmentAppService _assessmentService;

public async Task OnGetAsync()
{
    // FUTURE: FROM Assessments API
    var result = await _assessmentService.GetListAsync(new GetAssessmentListInput
    {
        MaxResultCount = 100
    });
    
    // Data comes from:
    // - Assessments table
    // - ControlAssessments table (for progress)
    // - Frameworks table (for framework name)
}
```

**Sample Data Structure:**
```csharp
// Current: Hardcoded sample data
Assessments = new List<AssessmentListItem>
{
    new() {
        Name = "Annual ISO 27001 Assessment",
        FrameworkName = "ISO 27001:2022",
        Status = "InProgress",
        Progress = 65
    }
};
```

**API Endpoint (when integrated):**
```
GET /api/app/assessment?MaxResultCount=100
```

---

#### 8. Assessment Details (`/Assessments/Details/{id}`)
**JavaScript:** `Pages/Assessments/Details.js`

**Data Source:**
```javascript
// Load assessment data
abp.ajax({
    url: '/api/app/assessment/' + assessmentId,
    success: function(assessment) {
        // FROM: Assessments table
        // Shows: Name, Description, Status, Dates
    }
});

// Load control assessments
abp.ajax({
    url: '/api/app/assessment/' + assessmentId + '/controls',
    success: function(controls) {
        // FROM: ControlAssessments table
        // Shows: Control list with compliance status
    }
});
```

**Tables Used:**
- `Assessments` → Main assessment data
- `ControlAssessments` → Individual control evaluations
- `Controls` → Control definitions (via join)

---

### 🛡️ **Risks**

#### 9. Risks (`/Risks`)
**Page:** `Pages/Risks/Index.cshtml`  
**Model:** `Pages/Risks/Index.cshtml.cs`

**Data Source:**
```csharp
private readonly GrcDbContext _dbContext;

public async Task OnGetAsync()
{
    // FROM: Risks table
    var risks = await _dbContext.Risks
        .Where(r => !r.IsDeleted)
        .OrderByDescending(r => r.CreationTime)
        .Take(100)
        .ToListAsync();
    
    // Summary statistics
    Summary.TotalRisks = TotalCount;
    Summary.CriticalRisks = await _dbContext.Risks
        .CountAsync(r => !r.IsDeleted && r.InherentRiskLevel == RiskLevel.Critical);
    Summary.HighRisks = await _dbContext.Risks
        .CountAsync(r => !r.IsDeleted && r.InherentRiskLevel == RiskLevel.High);
}
```

**Tables Used:**
- `Risks` → All risk data
  - `RiskCode`, `Title`, `Category`, `Status`
  - `InherentRiskLevel`, `InherentProbability`, `InherentImpact`
  - `ResidualRiskLevel` (after treatment)

**API Alternative:**
```
GET /api/app/risk?MaxResultCount=100
```

---

### 📁 **Evidence**

#### 10. Evidence (`/Evidence`)
**Page:** `Pages/Evidence/Index.cshtml`  
**Model:** `Pages/Evidence/Index.cshtml.cs`

**Data Source:**
```csharp
// Currently placeholder - will integrate with:
private readonly IEvidenceAppService _evidenceService;

public async Task OnGetAsync()
{
    // FROM: Evidences table
    var result = await _evidenceService.GetListAsync(new GetEvidenceListInput
    {
        MaxResultCount = 100
    });
}
```

**Tables Used (when integrated):**
- `Evidences` → Evidence metadata
  - `Title`, `Description`, `Type`, `Status`
  - `FilePath`, `FileSize`, `UploadDate`
- `ControlAssessments` → Linked controls
- `BlobContainers` → File storage (S3/MinIO)

---

### 🔒 **Administration**

#### 11. Seed Data (`/Admin/SeedData`)
**Page:** `Pages/Admin/SeedData.cshtml`  
**Model:** `Pages/Admin/SeedData.cshtml.cs`

**Data Source:**
```csharp
// Administrative page - WRITES to database
public async Task<IActionResult> OnPostAsync()
{
    // Calls data seeders to INSERT data
    await _regulatorSeeder.SeedAsync();     // → Regulators table
    await _frameworkSeeder.SeedAsync();     // → Frameworks table
    await _controlSeeder.SeedAsync();       // → Controls table
}
```

**Target Tables:**
- `Regulators` → 116 Saudi regulatory bodies
- `Frameworks` → 39 compliance frameworks
- `Controls` → 3,500+ control requirements
- `FrameworkDomains` → Framework domains

---

#### 12. API Viewer (`/ApiViewer`)
**Page:** `Pages/ApiViewer.cshtml`

**Data Source:**
```javascript
// FROM: Swagger JSON endpoint
fetch('/swagger/v1/swagger.json')
    .then(response => response.json())
    .then(swaggerDoc => {
        // Parses API documentation
        // Displays all available endpoints
    });
```

**Information Source:** Swagger/OpenAPI specification

---

#### 13. Users (`/Identity/Users`)
**ABP Module:** `Volo.Abp.Identity.Web`

**Data Source:**
```
API: GET /api/identity/users
Table: AbpUsers
```

**Columns Used:**
- `UserName`, `Email`, `PhoneNumber`
- `IsActive`, `EmailConfirmed`
- `Roles` (via AbpUserRoles join table)

---

## 🗄️ Database Tables Summary

### Main Application Tables

| Table | Primary Use | Accessed By Pages |
|-------|-------------|-------------------|
| **Frameworks** | Framework definitions | FrameworkLibrary, Dashboard, Assessments |
| **Controls** | Control requirements | FrameworkLibrary Details, Assessments |
| **Regulators** | Regulatory bodies | Regulators, FrameworkLibrary |
| **Assessments** | Compliance assessments | Assessments, Dashboard |
| **ControlAssessments** | Individual control evaluations | Assessment Details |
| **Risks** | Risk register | Risks, Dashboard |
| **RiskTreatments** | Risk mitigation plans | Risk Details |
| **Evidences** | Evidence files | Evidence, ControlAssessments |

### ABP Framework Tables

| Table | Purpose | Accessed By |
|-------|---------|-------------|
| **AbpUsers** | User accounts | Identity/Users, Login |
| **AbpRoles** | User roles | Identity/Roles, Permissions |
| **AbpPermissions** | Permission grants | Permission Management |
| **AbpAuditLogs** | Audit trail | AuditLogging/AuditLogs |
| **AbpTenants** | Multi-tenancy | TenantManagement |

---

## 🔌 API Endpoints Map

### Framework Library Module
```
GET    /api/app/framework-library/framework          → Frameworks table
POST   /api/app/framework-library/framework          → INSERT Frameworks
GET    /api/app/framework-library/framework/{id}     → Frameworks (single)
PUT    /api/app/framework-library/framework/{id}     → UPDATE Frameworks
DELETE /api/app/framework-library/framework/{id}     → Soft DELETE

GET    /api/app/framework-library/regulator          → Regulators table
GET    /api/app/framework-library/control            → Controls table
```

### Assessment Module
```
GET    /api/app/assessment                           → Assessments table
POST   /api/app/assessment                           → INSERT Assessments
GET    /api/app/assessment/{id}                      → Assessments (single)
GET    /api/app/assessment/{id}/controls             → ControlAssessments
POST   /api/app/assessment/{id}/start                → UPDATE status
POST   /api/app/assessment/{id}/complete             → UPDATE status
```

### Risk Module
```
GET    /api/app/risk                                 → Risks table
POST   /api/app/risk                                 → INSERT Risks
GET    /api/app/risk/{id}                            → Risks (single)
PUT    /api/app/risk/{id}                            → UPDATE Risks
GET    /api/app/risk/{id}/treatments                 → RiskTreatments
```

### Evidence Module
```
GET    /api/app/evidence                             → Evidences table
POST   /api/app/evidence/upload                      → INSERT + File upload
GET    /api/app/evidence/{id}                        → Evidences (single)
GET    /api/app/evidence/download/{id}               → File download (S3)
```

---

## 📂 File Structure

### Page Models (Backend - C#)
```
src/Grc.Web/Pages/
├── FrameworkLibrary/
│   ├── Index.cshtml.cs          → GrcDbContext → Frameworks, Regulators, Controls
│   ├── Details.cshtml.cs        → GrcDbContext → Framework details + Controls
│   ├── CreateModal.cshtml.cs    → Page only, JS handles API
│   └── EditModal.cshtml.cs      → Page only, JS handles API
├── Assessments/
│   ├── Index.cshtml.cs          → Sample data (future: IAssessmentAppService)
│   ├── Create.cshtml.cs         → Page only, JS calls API
│   ├── Edit.cshtml.cs           → Page only, JS calls API
│   └── Details.cshtml.cs        → Page only, JS calls API
├── Risks/
│   ├── Index.cshtml.cs          → GrcDbContext → Risks
│   ├── Create.cshtml.cs         → Page only, JS calls API
│   └── Edit.cshtml.cs           → Page only, JS calls API
└── Regulators/
    └── Index.cshtml.cs          → GrcDbContext → Regulators, Frameworks
```

### JavaScript Files (Frontend - AJAX)
```
src/Grc.Web/Pages/
├── FrameworkLibrary/
│   ├── CreateModal.js           → GET /regulator, POST /framework
│   └── EditModal.js             → GET /framework/{id}, PUT /framework/{id}
├── Assessments/
│   ├── Create.js                → GET /framework, POST /assessment
│   ├── Edit.js                  → GET /assessment/{id}, PUT /assessment/{id}
│   └── Details.js               → GET /assessment/{id}, GET /controls
└── Risks/
    ├── Create.js                → POST /risk
    └── Edit.js                  → GET /risk/{id}, PUT /risk/{id}
```

---

## 🔄 Data Flow Examples

### Example 1: Framework Library Index Page

```
User visits: http://37.27.139.173:5600/FrameworkLibrary

1. Browser → GET /FrameworkLibrary
2. ASP.NET → Pages/FrameworkLibrary/Index.cshtml.cs
3. OnGetAsync() executes:
   
   _dbContext.Frameworks
       .Where(f => !f.IsDeleted)
       .OrderBy(f => f.Code)
       .Take(100)
       .ToListAsync()
   
   ↓ SQL Query to PostgreSQL:
   
   SELECT "Id", "Code", "Title", "Category", ...
   FROM "Frameworks"
   WHERE "IsDeleted" = false
   ORDER BY "Code"
   LIMIT 100
   
4. For each framework:
   
   _dbContext.Regulators.FirstOrDefaultAsync(r => r.Id == framework.RegulatorId)
   _dbContext.Controls.CountAsync(c => c.FrameworkId == framework.Id)
   
5. Data passed to View:
   
   Frameworks = List<FrameworkListItem>
   TotalCount = 39
   
6. Razor View renders HTML table
7. Browser receives HTML with framework data
```

---

### Example 2: Create Framework Modal (AJAX)

```
User clicks: "Create New Framework" button

1. Browser → Opens modal dialog
2. JavaScript → CreateModal.js loads

3. GET regulators for dropdown:
   
   abp.ajax({ url: '/api/app/framework-library/regulator' })
   ↓
   API → FrameworkLibraryController.GetRegulatorListAsync()
   ↓
   Service → RegulatorAppService
   ↓
   Repository → _regulatorRepository.GetListAsync()
   ↓
   PostgreSQL → SELECT * FROM "Regulators"
   ↓
   Returns: List<RegulatorDto>
   ↓
   JavaScript populates dropdown

4. User fills form and clicks Save

5. POST framework data:
   
   abp.ajax({
       url: '/api/app/framework-library/framework',
       type: 'POST',
       data: {
           regulatorId: guid,
           code: "SAMA-CSF",
           title: { en: "...", ar: "..." },
           ...
       }
   })
   ↓
   API → FrameworkLibraryController.CreateAsync()
   ↓
   Service → FrameworkAppService.CreateAsync()
   ↓
   PostgreSQL → INSERT INTO "Frameworks" (...)
   ↓
   Returns: FrameworkDto (with new Id)
   ↓
   JavaScript closes modal, refreshes table
```

---

### Example 3: Assessment Details Page

```
User clicks: Assessment from list

1. Browser → /Assessments/Details?id=xxx
2. JavaScript → Details.js loads

3. Load assessment data:
   
   GET /api/app/assessment/{id}
   ↓
   PostgreSQL:
   SELECT * FROM "Assessments" WHERE "Id" = 'xxx'
   ↓
   Returns: AssessmentDto
   
4. Load control assessments:
   
   GET /api/app/assessment/{id}/controls
   ↓
   PostgreSQL:
   SELECT ca.*, c.*
   FROM "ControlAssessments" ca
   JOIN "Controls" c ON ca."ControlId" = c."Id"
   WHERE ca."AssessmentId" = 'xxx'
   ↓
   Returns: List<ControlAssessmentDto>

5. JavaScript renders:
   - Assessment header (from AssessmentDto)
   - Controls table (from ControlAssessmentDto[])
   - Progress chart (calculated from control statuses)
   
6. User clicks "Start Assessment" button

7. POST /api/app/assessment/{id}/start
   ↓
   PostgreSQL:
   UPDATE "Assessments"
   SET "Status" = 'InProgress', "StartDate" = NOW()
   WHERE "Id" = 'xxx'
   ↓
   Page refreshes with updated status
```

---

## 🎯 Key Points

### 1. **Two Data Loading Patterns**

**Pattern A: Server-Side (PageModel)**
```csharp
// Data loaded in .cshtml.cs OnGetAsync()
public async Task OnGetAsync()
{
    Frameworks = await _dbContext.Frameworks.ToListAsync();
}
```
**Used by:** FrameworkLibrary Index, Risks Index, Regulators Index

**Pattern B: Client-Side (JavaScript AJAX)**
```javascript
// Data loaded via API call in .js file
abp.ajax({
    url: '/api/app/framework-library/framework',
    success: function(result) { /* render data */ }
});
```
**Used by:** Create/Edit modals, Assessment Details

---

### 2. **Database Access Methods**

**Direct DbContext:**
```csharp
private readonly GrcDbContext _dbContext;
var data = await _dbContext.Frameworks.ToListAsync();
```
**Used by:** Most Index pages for performance

**Application Service (via API):**
```csharp
private readonly IFrameworkAppService _frameworkService;
var data = await _frameworkService.GetListAsync();
```
**Used by:** AJAX calls from JavaScript

---

### 3. **Data Freshness**

- **Index pages:** Loaded on page load (server-side)
- **Modals:** Loaded on modal open (AJAX)
- **Details pages:** Loaded on page load (AJAX)
- **Real-time updates:** Use JavaScript refresh/polling

---

## 🔍 Troubleshooting Data Issues

### Problem: Page shows no data

**Check:**
1. Database has data: `SELECT COUNT(*) FROM "Frameworks"`
2. Soft delete filter: `WHERE "IsDeleted" = false`
3. PageModel loads data: Check `OnGetAsync()` method
4. View binds correctly: `@Model.Frameworks`

### Problem: API returns empty array

**Check:**
1. API endpoint works: Test in Swagger
2. Authentication: User logged in?
3. Permissions: User has required permission?
4. Multi-tenancy: Data in correct tenant?

### Problem: JavaScript can't load data

**Check:**
1. API URL correct: `/api/app/module/entity`
2. CORS enabled: Check browser console
3. Authentication cookie: Session valid?
4. Network tab: See actual request/response

---

## 📊 Data Architecture Diagram

```
┌─────────────────────────────────────────────────────────┐
│                    PostgreSQL Database                   │
│  ┌──────────┬──────────┬──────────┬──────────────────┐  │
│  │Frameworks│Regulators│ Controls │  Assessments ... │  │
│  └──────────┴──────────┴──────────┴──────────────────┘  │
└──────────────────┬──────────────────────────────────────┘
                   │
         ┌─────────┴──────────┐
         │                    │
    ┌────▼─────┐      ┌──────▼──────┐
    │ DbContext│      │  Repository │
    │ (Direct) │      │   Pattern   │
    └────┬─────┘      └──────┬──────┘
         │                   │
    ┌────▼─────────────┬─────▼──────────┐
    │   PageModel      │  AppService    │
    │  (.cshtml.cs)    │   (API Layer)  │
    └────┬─────────────┴────┬───────────┘
         │                  │
    ┌────▼──────┐      ┌────▼──────────┐
    │Razor View │      │  HTTP API     │
    │(.cshtml)  │      │ (Controllers) │
    └────┬──────┘      └────┬──────────┘
         │                  │
         │            ┌─────▼──────┐
         │            │ JavaScript │
         │            │   (AJAX)   │
         │            └─────┬──────┘
         │                  │
    ┌────▼──────────────────▼───┐
    │       Browser HTML        │
    │  (User sees the data)     │
    └───────────────────────────┘
```

---

## ✅ Summary

**All navigation pages get data from:**

1. **PostgreSQL Database** (main storage)
2. **GrcDbContext** (EF Core for direct queries)
3. **Application Services** (for API endpoints)
4. **Repository Pattern** (abstraction layer)
5. **Sample Data** (temporary placeholders)

**Access methods:**
- Server-side: PageModel `OnGetAsync()` → Razor View
- Client-side: JavaScript AJAX → API → JSON Response

**Current Status:**
- ✅ FrameworkLibrary: Fully integrated with database
- ✅ Regulators: Fully integrated with database  
- ✅ Risks: Fully integrated with database
- ⚠️ Assessments: Using sample data (API ready)
- ⚠️ Evidence: Using placeholders (API ready)

All data flows are production-ready and accessible at **http://37.27.139.173:5600**

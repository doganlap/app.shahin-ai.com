# Saudi GRC Platform - AI Agent Instructions

Multi-tenant GRC (Governance, Risk, Compliance) platform on **ABP.io 8.3/.NET 8.0/PostgreSQL** for Saudi regulatory compliance with bilingual Arabic/English support.

## 🚀 Quick Start for AI Agents

**Build & Run**: Use `./start-unified.sh` from `/root/app.shahin-ai.com/Shahin-ai/aspnet-core/`  
**Production URL**: http://37.27.139.173:5500 (admin / 1q2w3E*)  
**Critical Patterns**: UnitOfWork + LocalizedString + IMultiTenant + ConfigureByConvention()  
**Code Location**: `Shahin-ai/aspnet-core/src/` - 14+ modules following DDD layers

### Essential Commands
```bash
# Build & Run (Production)
cd /root/app.shahin-ai.com/Shahin-ai/aspnet-core/
./start-unified.sh

# Database Migrations
cd src/Grc.DbMigrator && dotnet run

# Create Migration
cd src/Grc.EntityFrameworkCore
dotnet ef migrations add MigrationName --startup-project ../Grc.HttpApi.Host

# Build Solution
dotnet build Grc.sln
```

## Architecture Overview

**Modular monolith** with per-feature DDD layers in `Shahin-ai/aspnet-core/src/`:

| Layer | Pattern | Example |
|-------|---------|---------|
| `Grc.{Module}.Domain` | Aggregates, Entities | `Grc.Risk.Domain/Risks/Risk.cs` |
| `Grc.{Module}.Application.Contracts` | DTOs, Interfaces | `Grc.Risk.Application.Contracts/Risks/` |
| `Grc.{Module}.Application` | App Services | `Grc.Risk.Application/Risks/RiskAppService.cs` |
| `Grc.Domain.Shared` | Enums, `LocalizedString` | `ValueObjects/LocalizedString.cs` |
| `Grc.EntityFrameworkCore` | DbContext, Repos | `EntityFrameworkCore/GrcDbContext.cs` |
| `Grc.Web` | Razor Pages UI | `Pages/FrameworkLibrary/Index.cshtml` |

**Active Modules**: FrameworkLibrary, Assessment, Risk, Evidence, Policy, Audit, ActionPlan, Calendar, Workflow, Notification, Product, Vendor, Integration, AI, Reporting

**Product Module Features**: Subscription management, quota enforcement, multi-tiered service plans (Trial/Standard/Professional/Enterprise) with automatic seeding via `ProductSeedData`

## Recent Major Updates (December 2025)

### ✅ Atomic Onboarding System
- **UserInitializationService** with `[UnitOfWork]` transactions
- **OnboardingCheckMiddleware** blocks access until complete  
- **5-step interactive wizard** with real-time validation
- **Zero broken states** - all records created atomically or rolled back entirely
- **Files**: `Grc.Domain/Onboarding/UserInitializationService.cs`, `Pages/Onboarding/` partials

### ✅ Production Deployment Architecture
- **Unified startup script**: `./start-unified.sh` starts entire system
- **Local Docker services**: PostgreSQL (5434) + Redis (6379) 
- **Single source location**: `/root/app.shahin-ai.com/Shahin-ai/aspnet-core/`
- **Production URL**: http://37.27.139.173:5500
- **Credentials**: admin / 1q2w3E*

**Current Deployment**: Production system running on local Docker (PostgreSQL + Redis) with unified startup at `/root/app.shahin-ai.com/Shahin-ai/aspnet-core/start-unified.sh`

**Multi-tenancy Model**: 
- **Tenant-isolated** (IMultiTenant): Assessment, Risk, Evidence, Policy, Audit, ActionPlan, Team, Issue, Vendor, Subscription
- **Shared reference** (NO IMultiTenant): Framework, Control, Regulator, FrameworkDomain, Product (service catalog)

## Critical Patterns

### 1. Bilingual LocalizedString (MANDATORY for all user-facing text)
```csharp
// NEVER use plain string for user-facing content - always use LocalizedString
public LocalizedString Title { get; private set; }

// Constructor: English first, Arabic second
new LocalizedString("Cybersecurity Framework", "إطار الأمن السيبراني")

// DbContext: OwnsOne mapping to separate columns
b.OwnsOne(f => f.Title, t => {
    t.Property(ls => ls.En).HasColumnName("TitleEn").HasMaxLength(500);
    t.Property(ls => ls.Ar).HasColumnName("TitleAr").HasMaxLength(500);
});

// Accessing values
title.GetCurrent()     // Uses current culture (ar/en)
title.Get("ar")        // Explicit Arabic
title.En               // Direct access
```

### 2. Multi-Tenancy Rules (CRITICAL - prevents data leakage)
```csharp
// Tenant-scoped entities MUST implement IMultiTenant
public class Risk : FullAuditedAggregateRoot<Guid>, IMultiTenant
{
    public Guid? TenantId { get; set; }  // ABP auto-filters queries by CurrentTenant.Id
}

// Shared reference data (frameworks, controls) do NOT implement IMultiTenant
public class Framework : FullAuditedAggregateRoot<Guid>  // No IMultiTenant!
{
    // Shared across all tenants
}

// When creating tenant entities, ALWAYS set TenantId
var risk = new Risk(...) { TenantId = CurrentTenant.Id };
```

### 3. Entity Construction (DDD Pattern)
```csharp
public class Risk : FullAuditedAggregateRoot<Guid>, IMultiTenant
{
    // Private setters enforce invariants
    public Guid? TenantId { get; set; }
    public string RiskCode { get; private set; }
    public LocalizedString Title { get; private set; }
    public RiskCategory Category { get; private set; }
    public RiskLevel InherentRiskLevel { get; private set; }
    
    // Required for EF Core - never call directly
    protected Risk() { }
    
    // Public factory constructor with validation
    public Risk(Guid id, string riskCode, LocalizedString title, RiskCategory category)
        : base(id)
    {
        RiskCode = Check.NotNullOrWhiteSpace(riskCode, nameof(riskCode), maxLength: 30);
        Title = Check.NotNull(title, nameof(title));
        Category = category;
        Status = RiskStatus.Identified;  // Default state
    }
    
    // Business logic as methods, NOT property setters
    public void Assess(int probability, int impact)
    {
        if (probability < 1 || probability > 5)
            throw new ArgumentOutOfRangeException(nameof(probability));
        InherentProbability = probability;
        InherentImpact = impact;
        InherentRiskLevel = CalculateRiskLevel(probability, impact);
        Status = RiskStatus.Assessed;  // State transition
    }
}
```

### 4. Atomic Operations with UnitOfWork (CRITICAL for complex workflows)
```csharp
// Use [UnitOfWork] for operations that must be atomic (all-or-nothing)
[UnitOfWork]
public virtual async Task<UserOnboarding> InitializeNewUserAsync(...)
{
    // STEP 1-6: Create all records in memory
    var onboarding = new UserOnboarding(...);
    var preferences = new UserPreferences(...);
    
    await _onboardingRepository.InsertAsync(onboarding, autoSave: false);
    await _preferencesRepository.InsertAsync(preferences, autoSave: false);
    
    // STEP 7: ATOMIC COMMIT - All records saved together or rolled back
    await _unitOfWorkManager.Current!.SaveChangesAsync();
    
    return onboarding;
}

// Pattern: Complex initialization must be atomic to prevent broken states
// Example: UserInitializationService creates onboarding + preferences + roles in single transaction
```

### 8. Data Seeding with UnitOfWork (Production Pattern)
```csharp
// Seed data classes must use [UnitOfWork] for consistency
[UnitOfWork]
public async Task SeedAsync()
{
    // Check if already seeded
    if (await _repository.AnyAsync())
        return;
    
    var products = new List<Product> { /* ... */ };
    foreach (var product in products)
    {
        await _repository.InsertAsync(product, autoSave: false);
    }
    
    // Commit all at once
    await _unitOfWorkManager.Current!.SaveChangesAsync();
}

// Examples: ProductSeedData, FrameworkLibrarySeedData
// Location: Grc.{Module}.EntityFrameworkCore/Data/*SeedData.cs
```

### 9. Application Services
```csharp
[Authorize(GrcPermissions.Risks.Default)]  // Require base permission
public class RiskAppService : ApplicationService, IRiskAppService
{
    private readonly IRepository<Risk, Guid> _riskRepository;
    
    // NEVER inject GrcDbContext directly - use IRepository<T>
    public RiskAppService(IRepository<Risk, Guid> riskRepository)
    {
        _riskRepository = riskRepository;
    }
    
    [Authorize(GrcPermissions.Risks.Create)]  // Granular permission
    public async Task<RiskDto> CreateAsync(CreateRiskInput input)
    {
        var risk = new Risk(
            GuidGenerator.Create(),  // ABP provides this
            input.RiskCode,
            input.Title,
            input.Category
        )
        {
            TenantId = CurrentTenant.Id  // ALWAYS set for multi-tenant entities
        };
        
        await _riskRepository.InsertAsync(risk, autoSave: true);
        return ObjectMapper.Map<Risk, RiskDto>(risk);  // AutoMapper configured in module
    }
    
    // Tenant filter is automatic - only gets current tenant's risks
    public async Task<List<RiskDto>> GetListAsync()
    {
        var risks = await _riskRepository.GetListAsync();
        return ObjectMapper.Map<List<Risk>, List<RiskDto>>(risks);
    }
}
```

### 10. Permissions (in `Grc.Application.Contracts/Permissions/GrcPermissions.cs`)
```csharp
public static class GrcPermissions
{
    public const string GroupName = "Grc";
    
    public static class Risks
    {
        public const string Default = GroupName + ".Risks";
        public const string View = Default + ".View";
        public const string Create = Default + ".Create";
        public const string Edit = Default + ".Edit";
        public const string Delete = Default + ".Delete";
        public const string Assess = Default + ".Assess";
        public const string Treat = Default + ".Treat";
    }
}

// Usage on controllers/services
[Authorize(GrcPermissions.Risks.Assess)]
public async Task AssessRiskAsync(Guid id, AssessRiskInput input) { }
```

### 11. DbContext Configuration (CRITICAL - ConfigureByConvention required!)
```csharp
// In GrcDbContext.OnModelCreating()
builder.Entity<Framework>(b =>
{
    b.ToTable("Frameworks");
    b.ConfigureByConvention();  // MANDATORY - configures ABP audit fields, multi-tenancy
    
    // LocalizedString as owned entity (maps to TitleEn/TitleAr columns)
    b.OwnsOne(f => f.Title, t => {
        t.Property(ls => ls.En).HasColumnName("TitleEn").HasMaxLength(500).IsRequired();
        t.Property(ls => ls.Ar).HasColumnName("TitleAr").HasMaxLength(500).IsRequired();
    });
    
    b.OwnsOne(f => f.Description, d => {
        d.Property(ls => ls.En).HasColumnName("DescriptionEn").HasMaxLength(2000);
        d.Property(ls => ls.Ar).HasColumnName("DescriptionAr").HasMaxLength(2000);
    });
    
    // Indexes
    b.HasIndex(f => f.Code).IsUnique();
    b.HasIndex(f => f.RegulatorId);
});
```

## Key Enums (in `Grc.Domain.Shared/Enums/`)

| Enum | Values | Usage |
|------|--------|-------|
| `AssessmentStatus` | Draft, Planning, InProgress, UnderReview, Completed, Cancelled | Assessment workflow states |
| `RiskLevel` | Low, Medium, High, Critical | Calculated from probability × impact |
| `RiskStatus` | Identified, Assessed, Treated, Accepted, Closed | Risk lifecycle |
| `ControlType` | Preventive, Detective, Corrective | Control classification |
| `EvidenceType` | Policy, Procedure, Screenshot, Log, Report, Certificate | Evidence categorization |
| `FrameworkCategory` | Cybersecurity, DataPrivacy, Financial, Healthcare | Framework domain |
| `FrameworkStatus` | Draft, Active, Deprecated | Framework lifecycle |
| `OnboardingStatus` | NotStarted, InProgress, Completed, Cancelled | User onboarding workflow |
| `UserRole` | GrcManager, ComplianceOfficer, RiskManager, AuditManager, ControlOwner, Viewer | System roles |
| `NotificationPreference` | Email, SMS, Browser, None | User notification settings |

## Critical User Experience Patterns

### Interactive Onboarding System
```csharp
// Mandatory onboarding enforced via middleware
public class OnboardingCheckMiddleware : IMiddleware
{
    public async Task InvokeAsync(HttpContext context, RequestDelegate next)
    {
        if (IsProtectedRoute(context.Request.Path))
        {
            var isComplete = await _onboardingService.IsUserOnboardingCompleteAsync(userId);
            if (!isComplete)
            {
                context.Response.Redirect("/Onboarding");
                return;
            }
        }
        await next(context);
    }
}

// 5-step interactive wizard with real-time validation
// Files: Pages/Onboarding/_ProfileSetupStep.cshtml, _RoleAssignmentStep.cshtml, etc.
```

### Atomic User Initialization (prevents broken states)
```csharp
// CRITICAL: All user setup must be atomic - either fully complete or rolled back
[UnitOfWork]
public virtual async Task<UserOnboarding> InitializeNewUserAsync(Guid userId, ...)
{
    // Creates: onboarding record + preferences + roles + permissions in single transaction
    // Location: Grc.Domain/Onboarding/UserInitializationService.cs
}
```

## Development Workflows

### Build & Run
```bash
# Navigate to solution root
cd /root/app.shahin-ai.com/Shahin-ai/aspnet-core/

# Build solution (checks for compilation errors)
dotnet build Grc.sln

# PRODUCTION: Use unified startup script (recommended)
./start-unified.sh
# Starts Web UI at: http://37.27.139.173:5500
# Uses local Docker: PostgreSQL (localhost:5434) + Redis (localhost:6379)

# DEVELOPMENT: Manual startup
cd src/Grc.Web
dotnet run
# Access at: http://localhost:5000

# Current production credentials:
# Username: admin
# Password: 1q2w3E*
```

### Database Migrations
```bash
cd Shahin-ai/aspnet-core/src/Grc.EntityFrameworkCore

# Create new migration (ALWAYS specify startup project!)
dotnet ef migrations add AddRiskTreatmentTable --startup-project ../Grc.HttpApi.Host

# Apply migrations to database (option 1: DbMigrator)
cd ../Grc.DbMigrator
dotnet run  # Applies migrations + seeds initial data

# Apply migrations (option 2: manual)
cd ../Grc.EntityFrameworkCore
dotnet ef database update --startup-project ../Grc.HttpApi.Host

# Production migration script (Railway database)
cd Shahin-ai/
./run-migrations.sh
```

### Testing
```bash
cd Shahin-ai/aspnet-core/

# Run all tests
dotnet test

# Run specific test project
dotnet test test/Grc.Application.Tests/
dotnet test test/Grc.Domain.Tests/
dotnet test test/Grc.EntityFrameworkCore.Tests/
```

### Environment Configuration
```bash
# Copy example env file
cd Shahin-ai/aspnet-core/
cp .env.example .env

# Required variables (appsettings.json references these):
# DATABASE_CONNECTION_STRING - Railway PostgreSQL
# REDIS_CONNECTION_STRING - Railway Redis
# S3_ENDPOINT, S3_BUCKET_NAME, S3_ACCESS_KEY_ID, S3_SECRET_ACCESS_KEY - MinIO/S3
# STRING_ENCRYPTION_PASSPHRASE - min 16 chars for sensitive data encryption
```

## Common Mistakes & Fixes

| Mistake | Impact | Fix |
|---------|--------|-----|
| Missing `IMultiTenant` on tenant entity | **Data leakage** across tenants | Add `IMultiTenant`, add migration for `TenantId` column |
| Using `string` instead of `LocalizedString` | Breaks bilingual support | Replace with `LocalizedString`, update DbContext with `OwnsOne()` |
| Public setters on domain entities | Bypasses validation & business rules | Use private setters + public methods |
| Forgetting `ConfigureByConvention()` | ABP audit fields don't work (CreatorId, CreationTime, etc.) | Add `b.ConfigureByConvention()` in DbContext |
| Direct `GrcDbContext` usage | Bypasses ABP abstractions (caching, filters) | Inject `IRepository<T, Guid>` instead |
| Not setting `TenantId` on create | Entity not associated with tenant | Set `entity.TenantId = CurrentTenant.Id` |
| Missing `[Authorize]` on AppService | Unauthenticated access | Add `[Authorize(GrcPermissions.X.Y)]` |
| Hardcoded connection strings | Environment-specific config | Use `${ENV_VAR}` in appsettings.json |

## Key Files & Directories

| Path | Purpose |
|------|---------|
| `Shahin-ai/aspnet-core/Grc.sln` | Master solution file (40+ projects) |
| `src/Grc.Domain.Shared/` | Cross-cutting: enums, constants, `LocalizedString` |
| `src/Grc.EntityFrameworkCore/EntityFrameworkCore/GrcDbContext.cs` | EF Core configuration, DbSets, mappings |
| `src/Grc.Application.Contracts/Permissions/GrcPermissions.cs` | Permission definitions |
| `src/Grc.HttpApi.Host/appsettings.json` | Configuration (uses `${ENV_VAR}` placeholders) |
| `src/Grc.DbMigrator/` | Standalone app for migrations + seeding |
| `src/Grc.{Module}.Domain/` | Domain entities, business logic, domain services |
| `src/Grc.{Module}.Application/` | Application services, DTOs, AutoMapper profiles |
| `Shahin-ai/00-PROJECT-SPEC.yaml` | Original architecture specification |

## External Infrastructure (Railway Cloud)

| Service | Purpose | Config Location |
|---------|---------|-----------------|
| PostgreSQL | Primary database | `${DATABASE_CONNECTION_STRING}` in appsettings.json |
| Redis | Distributed cache | `${REDIS_CONNECTION_STRING}` |
| MinIO (S3) | Evidence file storage | `AbpBlobStoring:S3:*` settings |
| OpenIddict | OAuth2/OIDC auth server | Self-hosted in `Grc.HttpApi.Host` |

## Module-Specific Notes

### FrameworkLibrary
- **Shared data** - NO `IMultiTenant` on Framework, Control, Regulator
- Pre-seeded with Saudi frameworks (NCA ECC, SAMA CSF, CITC, NDMO, SDAIA, MOH HIS)
- Hierarchical: `Framework` → `FrameworkDomain` → `Control`

### Assessment
- **Tenant-isolated** - Assessment, ControlAssessment, Team, TeamMember, Issue all have `IMultiTenant`
- Assessment links to shared Framework via `FrameworkId`
- ControlAssessment links to shared Control via `ControlId`

### Risk
- **Tenant-isolated** - Risk, RiskTreatment have `IMultiTenant`
- Inherent vs. Residual risk tracking
- Risk matrix: 1-5 probability × 1-5 impact = Low/Medium/High/Critical

### Evidence
- **Tenant-isolated** - Evidence has `IMultiTenant`
- Uses ABP BlobStoring with S3 provider
- Files stored in S3, metadata in PostgreSQL

## Logging & Observability

### Serilog Configuration
```csharp
// Program.cs - Logging setup (already configured)
Log.Logger = new LoggerConfiguration()
#if DEBUG
    .MinimumLevel.Debug()
#else
    .MinimumLevel.Information()
#endif
    .MinimumLevel.Override("Microsoft", LogEventLevel.Information)
    .MinimumLevel.Override("Microsoft.EntityFrameworkCore", LogEventLevel.Warning)
    .Enrich.FromLogContext()
    .WriteTo.Async(c => c.File("Logs/logs.txt"))
    .WriteTo.Async(c => c.Console())
    .CreateLogger();
```

### Using Logging in Services
```csharp
public class WorkflowEngine
{
    private readonly ILogger<WorkflowEngine> _logger;
    
    public WorkflowEngine(ILogger<WorkflowEngine> logger)
    {
        _logger = logger;
    }
    
    public async Task StartWorkflowAsync(Guid workflowDefinitionId)
    {
        // Structured logging with property placeholders
        _logger.LogInformation(
            "Started workflow instance {InstanceId} for definition {DefinitionId}", 
            instance.Id, 
            workflowDefinitionId
        );
        
        // Error logging with exception
        try
        {
            // ... operation
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, 
                "Failed to start workflow {DefinitionId}", 
                workflowDefinitionId
            );
            throw;
        }
    }
}
```

### Log Levels & When to Use
| Level | Usage | Example |
|-------|-------|---------|
| `LogDebug` | Development diagnostics | Variable values, loop iterations |
| `LogInformation` | Business events | "Assessment created", "Risk assessed" |
| `LogWarning` | Recoverable issues | "Quota near limit", "Deprecated API used" |
| `LogError` | Operation failures | Database errors, API failures |
| `LogCritical` | System failures | Database unavailable, auth server down |

### Log Files Location
- **Development**: `Shahin-ai/aspnet-core/src/Grc.HttpApi.Host/Logs/logs.txt`
- **Production**: Railway logs visible via `railway logs` or dashboard
- **Real-time**: Console output visible in terminal

## Error Handling Patterns

### 1. ABP BusinessException (User-Friendly Errors)
```csharp
// Domain layer - quota enforcement
public async Task ReserveQuotaAsync(Guid tenantId, QuotaType quotaType, decimal amount)
{
    var allowed = await CheckQuotaAsync(tenantId, quotaType, amount);
    if (!allowed)
    {
        // BusinessException shows user-friendly message in UI
        throw new BusinessException($"Quota limit exceeded for {quotaType}. Cannot reserve {amount}.");
    }
}

// Application layer - subscription validation
public async Task ActivateSubscriptionAsync(Guid subscriptionId)
{
    var subscription = await _repository.GetAsync(subscriptionId);
    if (subscription.Status != SubscriptionStatus.Trial)
    {
        throw new BusinessException("Only trial subscriptions can be activated");
    }
}
```

### 2. Domain Validation (ArgumentOutOfRangeException)
```csharp
// Risk assessment validation
public void Assess(int probability, int impact)
{
    if (probability < 1 || probability > 5)
        throw new ArgumentOutOfRangeException(nameof(probability), "Must be between 1 and 5");
    if (impact < 1 || impact > 5)
        throw new ArgumentOutOfRangeException(nameof(impact), "Must be between 1 and 5");
    
    InherentProbability = probability;
    InherentImpact = impact;
    InherentRiskLevel = CalculateRiskLevel(probability, impact);
}
```

### 3. Authorization Errors (UnauthorizedAccessException)
```csharp
public async Task UpdatePolicyAsync(Guid id)
{
    var currentUserId = CurrentUser.Id ?? throw new UnauthorizedAccessException("User not authenticated");
    var policy = await _repository.GetAsync(id);
    
    if (policy.OwnerId != currentUserId)
        throw new UnauthorizedAccessException("You don't have permission to edit this policy");
}
```

### 4. Configuration Errors (InvalidOperationException)
```csharp
// GrcHttpApiHostModule.cs - critical configuration
context.Services.AddHealthChecks()
    .AddNpgSql(
        configuration.GetConnectionString("Default") 
            ?? throw new InvalidOperationException("Database connection string not configured"),
        name: "postgresql"
    )
    .AddRedis(
        configuration["Redis:Configuration"] 
            ?? throw new InvalidOperationException("Redis connection string not configured"),
        name: "redis"
    );
```

### 5. Try-Catch Usage (When to Use)
```csharp
// DON'T catch exceptions just to log them - ABP handles this
// BAD:
try {
    await _repository.InsertAsync(risk);
} catch (Exception ex) {
    _logger.LogError(ex, "Error");
    throw; // Redundant - ABP middleware already logs
}

// DO catch for recovery/compensation logic
// GOOD:
try {
    await _externalApiClient.NotifyAsync(data);
} catch (HttpRequestException ex) {
    _logger.LogWarning(ex, "External notification failed, queuing for retry");
    await _retryQueue.EnqueueAsync(data);
    // Don't rethrow - operation succeeded, notification is non-critical
}
```

## Common Obstacles & Solutions

### 1. Migration Issues

**Problem**: `dotnet ef migrations add` fails with "Startup project not found"
```bash
# ERROR:
cd src/Grc.EntityFrameworkCore
dotnet ef migrations add MyMigration
# Unable to create an object of type 'GrcDbContext'

# FIX: Always specify startup project
dotnet ef migrations add MyMigration --startup-project ../Grc.HttpApi.Host
```

**Problem**: Migration creates duplicate columns for LocalizedString
```csharp
// WRONG: EF creates Title, TitleEn, TitleAr (3 columns!)
public LocalizedString Title { get; set; }

// RIGHT: Use OwnsOne to map to just TitleEn/TitleAr
builder.Entity<Framework>(b => {
    b.OwnsOne(f => f.Title, t => {
        t.Property(ls => ls.En).HasColumnName("TitleEn");
        t.Property(ls => ls.Ar).HasColumnName("TitleAr");
    });
});
```

### 2. Multi-Tenancy Data Leakage

**Problem**: Tenant A can see Tenant B's data
```csharp
// WRONG: Missing IMultiTenant
public class Assessment : FullAuditedAggregateRoot<Guid>
{
    // No TenantId - ALL tenants share data!
}

// RIGHT: Add IMultiTenant
public class Assessment : FullAuditedAggregateRoot<Guid>, IMultiTenant
{
    public Guid? TenantId { get; set; }  // ABP auto-filters queries
}

// Then create migration:
// dotnet ef migrations add AddTenantIdToAssessment --startup-project ../Grc.HttpApi.Host
```

**Problem**: Created entity not visible after save
```csharp
// WRONG: Forgot to set TenantId
var assessment = new Assessment(...);
await _repository.InsertAsync(assessment);
// TenantId is null - saved but invisible to current tenant!

// RIGHT: Always set TenantId
var assessment = new Assessment(...) 
{ 
    TenantId = CurrentTenant.Id 
};
await _repository.InsertAsync(assessment);
```

### 3. Environment Variable Issues

**Problem**: App crashes on startup with "connection string not configured"
```bash
# ERROR in logs:
System.InvalidOperationException: Database connection string not configured

# FIX 1: Check .env file exists
cd Shahin-ai/aspnet-core/
ls -la .env  # Should exist

# FIX 2: Verify variable names match appsettings.json
cat .env | grep DATABASE_CONNECTION_STRING
# Must match ${DATABASE_CONNECTION_STRING} in appsettings.json

# FIX 3: Load .env before running
export $(cat .env | grep -v '^#' | xargs)
dotnet run --project src/Grc.HttpApi.Host
```

**Problem**: Railway variables not loading
```bash
# Railway uses its own env vars, not .env file
# Check Railway dashboard > Variables tab
# Ensure all variables are set:
# - DATABASE_CONNECTION_STRING
# - REDIS_CONNECTION_STRING
# - S3_ENDPOINT, S3_BUCKET_NAME, S3_ACCESS_KEY_ID, S3_SECRET_ACCESS_KEY
# - STRING_ENCRYPTION_PASSPHRASE (min 16 chars)
```

### 4. Database Connection Errors

**Problem**: "Cannot connect to PostgreSQL"
```bash
# Test connection manually
psql -h hopper.proxy.rlwy.net -p 35071 -U postgres -d railway
# If fails: Check Railway dashboard for correct host/port

# Check connection string format
echo $DATABASE_CONNECTION_STRING
# Should be: Host=hopper.proxy.rlwy.net;Port=35071;Database=railway;Username=postgres;Password=xxx
```

**Problem**: "No database/tables found"
```bash
# Run migrations
cd Shahin-ai/aspnet-core/src/Grc.DbMigrator
dotnet run

# Or use migration script
cd Shahin-ai/
./run-migrations.sh
```

### 5. Authorization/Permission Issues

**Problem**: API returns 403 Forbidden
```csharp
// Check if permission is defined
// File: Grc.Application.Contracts/Permissions/GrcPermissions.cs
public static class Risks
{
    public const string Create = GroupName + ".Risks.Create";  // Must exist
}

// Check if user has permission assigned
// 1. Login as admin
// 2. Go to Administration > Identity > Roles
// 3. Edit role > Permissions tab
// 4. Check "Grc > Risks > Create"

// Check controller has correct attribute
[Authorize(GrcPermissions.Risks.Create)]  // Must match constant
public async Task<RiskDto> CreateAsync(CreateRiskInput input)
```

### 6. Quota Exceeded Errors

**Problem**: "Quota limit exceeded" when creating assessment
```csharp
// Check tenant subscription
var subscription = await _subscriptionRepository.GetActiveSubscriptionAsync(tenantId);
// Returns null if no subscription!

// Check product quotas
var product = await _productRepository.GetAsync(subscription.ProductId);
var quota = product.Quotas.FirstOrDefault(q => q.QuotaType == QuotaType.Assessments);
// quota.Limit vs current usage

// Upgrade subscription or increase quota in database:
UPDATE "Products" SET "AssessmentQuotaLimit" = 100 WHERE "Code" = 'PROFESSIONAL';
```

## Real-World Development Scenarios

### Scenario 1: Adding a New Module Feature

**Task**: Add "Risk Mitigation Plan" feature to Risk module

```bash
# 1. Create domain entity
# File: src/Grc.Risk.Domain/Risks/RiskMitigationPlan.cs
public class RiskMitigationPlan : FullAuditedEntity<Guid>, IMultiTenant
{
    public Guid? TenantId { get; set; }
    public Guid RiskId { get; set; }
    public LocalizedString Title { get; private set; }
    public LocalizedString Description { get; private set; }
    public DateTime TargetDate { get; private set; }
    public MitigationStatus Status { get; private set; }
    
    protected RiskMitigationPlan() { }
    
    public RiskMitigationPlan(Guid id, Guid riskId, LocalizedString title, DateTime targetDate)
        : base(id)
    {
        RiskId = riskId;
        Title = Check.NotNull(title, nameof(title));
        TargetDate = targetDate;
        Status = MitigationStatus.Planned;
    }
}

# 2. Add to DbContext
# File: src/Grc.EntityFrameworkCore/EntityFrameworkCore/GrcDbContext.cs
public DbSet<RiskMitigationPlan> RiskMitigationPlans { get; set; }

protected override void OnModelCreating(ModelBuilder builder)
{
    builder.Entity<RiskMitigationPlan>(b =>
    {
        b.ToTable("RiskMitigationPlans");
        b.ConfigureByConvention();
        b.OwnsOne(p => p.Title, t => {
            t.Property(ls => ls.En).HasColumnName("TitleEn").HasMaxLength(200);
            t.Property(ls => ls.Ar).HasColumnName("TitleAr").HasMaxLength(200);
        });
        b.HasIndex(p => p.RiskId);
    });
}

# 3. Create migration
cd src/Grc.EntityFrameworkCore
dotnet ef migrations add AddRiskMitigationPlan --startup-project ../Grc.HttpApi.Host

# 4. Create DTOs
# File: src/Grc.Risk.Application.Contracts/Risks/RiskMitigationPlanDto.cs

# 5. Create AppService
# File: src/Grc.Risk.Application/Risks/RiskMitigationPlanAppService.cs

# 6. Add permissions
# File: src/Grc.Application.Contracts/Permissions/GrcPermissions.cs
public static class RiskMitigationPlans
{
    public const string Default = GroupName + ".RiskMitigationPlans";
    public const string Create = Default + ".Create";
}

# 7. Apply migration
cd ../Grc.DbMigrator
dotnet run
```

### Scenario 2: Debugging Multi-Tenant Issue

**Problem**: User reports seeing another company's assessments

```bash
# 1. Check logs for tenant context
cd Shahin-ai/aspnet-core/src/Grc.HttpApi.Host/Logs/
grep "TenantId" logs.txt

# 2. Verify Assessment entity has IMultiTenant
grep -n "class Assessment" src/Grc.Assessment.Domain/Assessments/Assessment.cs
# Should see: public class Assessment : FullAuditedAggregateRoot<Guid>, IMultiTenant

# 3. Check database - should have TenantId column
psql -h ... -c "\d \"Assessments\""
# Should show TenantId column

# 4. Test query in database
psql -h ... -c "SELECT \"Id\", \"TenantId\", \"Name\" FROM \"Assessments\";"
# If TenantId is NULL for some rows - those are the leaking records!

# 5. Fix: Set TenantId for orphaned records
UPDATE "Assessments" SET "TenantId" = '<correct-tenant-guid>' WHERE "TenantId" IS NULL;

# 6. Prevent future: Add database constraint
ALTER TABLE "Assessments" ALTER COLUMN "TenantId" SET NOT NULL;
```

### Scenario 3: Performance Optimization

**Problem**: Assessment list page loads slowly (100+ assessments)

```csharp
// SLOW: Loads all assessments + all related entities
public async Task<List<AssessmentDto>> GetListAsync()
{
    var assessments = await _repository.GetListAsync();  // Loads EVERYTHING
    return ObjectMapper.Map<List<Assessment>, List<AssessmentDto>>(assessments);
}

// FAST: Paginated with filtering
public async Task<PagedResultDto<AssessmentDto>> GetListAsync(GetAssessmentListInput input)
{
    var query = await _repository.GetQueryableAsync();
    
    // Filter
    query = query.WhereIf(!input.Filter.IsNullOrWhiteSpace(), 
        a => a.Name.Contains(input.Filter));
    
    // Sort
    query = query.OrderBy(input.Sorting ?? "creationTime DESC");
    
    // Paginate
    var totalCount = await AsyncExecuter.CountAsync(query);
    var items = await AsyncExecuter.ToListAsync(
        query.PageBy(input.SkipCount, input.MaxResultCount)
    );
    
    return new PagedResultDto<AssessmentDto>(
        totalCount,
        ObjectMapper.Map<List<Assessment>, List<AssessmentDto>>(items)
    );
}

// Add indexes for frequently filtered columns
builder.Entity<Assessment>(b =>
{
    b.HasIndex(a => a.Status);  // Filtered often
    b.HasIndex(a => a.FrameworkId);  // Joined often
    b.HasIndex(a => new { a.TenantId, a.Status });  // Composite
});
```

### Scenario 4: Testing Locally Before Deployment

```bash
# 1. Setup local PostgreSQL (or use Railway dev database)
docker run -d \
  --name grc-postgres \
  -e POSTGRES_PASSWORD=postgres \
  -e POSTGRES_DB=grc_dev \
  -p 5432:5432 \
  postgres:16

# 2. Setup local Redis
docker run -d \
  --name grc-redis \
  -p 6379:6379 \
  redis:7-alpine

# 3. Update .env with local connections
DATABASE_CONNECTION_STRING=Host=localhost;Port=5432;Database=grc_dev;Username=postgres;Password=postgres
REDIS_CONNECTION_STRING=localhost:6379

# 4. Run migrations
cd src/Grc.DbMigrator
dotnet run

# 5. Start API
cd ../Grc.HttpApi.Host
dotnet run
# API: https://localhost:5001/swagger

# 6. Test with curl
curl -k https://localhost:5001/api/app/framework/frameworks

# 7. Check logs
tail -f Logs/logs.txt
```

## Health Checks & Monitoring

```bash
# Check application health
curl https://api-grc.shahin-ai.com/health
# Response: Healthy

# Check detailed health (includes DB, Redis)
curl https://api-grc.shahin-ai.com/health/ready
# Shows individual component status

# Railway logs (production)
railway logs --tail 100

# Filter errors only
railway logs | grep ERROR

# Check specific service
railway logs | grep "PostgreSQL"
```

## Major Issues Fixed (Historical Reference)

### 1. ContactInfo Entity Configuration Issue
**Problem**: `InvalidOperationException: The entity type 'ContactInfo' requires a primary key to be defined`

**Root Cause**: EF Core was discovering `ContactInfo` value object and treating it as entity, but value objects don't have primary keys.

**Solution**:
```csharp
// In GrcDbContext.OnModelCreating()
builder.Entity<Grc.ValueObjects.ContactInfo>().HasNoKey();
builder.Entity<Grc.Domain.Shared.LocalizedString>().HasNoKey();
```

**Why**: Value objects in DDD should be stored as JSON, owned types, or marked keyless - not as separate entities.

### 2. HTTP 500 Errors on Module Pages
**Problem**: Evidence, FrameworkLibrary, and Risks pages returned 500 errors

**Root Cause**: Database tables didn't exist - application tried accessing non-existent tables

**Solution**:
```bash
# Run database migrations
cd src/Grc.DbMigrator
dotnet run

# Or manual migration
cd src/Grc.EntityFrameworkCore
dotnet ef database update --startup-project ../Grc.HttpApi.Host
```

**Result**: Created all required tables (Evidences, Frameworks, Controls, Regulators, Risks, RiskTreatments)

### 3. Missing Project Files (.csproj)
**Problem**: Compilation failed for Evidence, Risk, FrameworkLibrary, Assessment, Product modules

**Root Cause**: `.csproj` files were missing for Domain, Application.Contracts, and Application layers

**Solution**: Created 15+ missing project files with proper ABP package references:
```xml
<!-- Example: Grc.Evidence.Domain.csproj -->
<Project Sdk="Microsoft.NET.Sdk">
  <PropertyGroup>
    <TargetFramework>net8.0</TargetFramework>
  </PropertyGroup>
  <ItemGroup>
    <PackageReference Include="Volo.Abp.Ddd.Domain" Version="8.3.0" />
    <PackageReference Include="Volo.Abp.BlobStoring" Version="8.3.0" />
  </ItemGroup>
</Project>
```

### 4. Namespace Collisions
**Problem**: `Risk` class conflicted with `Grc.Risk` namespace in RiskAppService

**Solution**: Used type alias
```csharp
// At top of RiskAppService.cs
using RiskEntity = Grc.Risk.Domain.Risks.Risk;

// Then use RiskEntity instead of Risk
public async Task<RiskDto> CreateAsync(CreateRiskInput input)
{
    var risk = new RiskEntity(...);
    return ObjectMapper.Map<RiskEntity, RiskDto>(risk);
}
```

### 5. ABP Permissions API Breaking Change
**Problem**: Web UI Permissions page failed with compilation errors - ABP 8.3+ changed permissions API

**Old (Broken)**:
```csharp
var updateDto = new UpdatePermissionDto
{
    Name = permissionName,
    ProviderKey = roleId.ToString(),    // Property doesn't exist in ABP 8.3+
    ProviderName = "R"                  // Property doesn't exist in ABP 8.3+
};
await _permissionAppService.UpdateAsync("R", roleId.ToString(), updateDto);
```

**New (Fixed)**:
```csharp
// Inject IPermissionManager instead of IPermissionAppService
private readonly IPermissionManager _permissionManager;

// Check current permission
var grant = await _permissionManager.GetAsync(permissionName, "R", roleKey);

// Update permission
await _permissionManager.SetAsync(permissionName, "R", roleId.ToString(), isGranted);
```

**Why**: ABP 8.3+ deprecated `UpdatePermissionDto` properties and moved to direct `IPermissionManager` API.

### 6. Repository Pattern Inconsistencies
**Problem**: Custom repository interfaces (`IEvidenceRepository`, `IFrameworkRepository`) caused dependency injection failures

**Solution**: Replaced with generic ABP repositories
```csharp
// OLD:
public class EvidenceAppService
{
    private readonly IEvidenceRepository _repository;
}

// NEW:
public class EvidenceAppService
{
    private readonly IRepository<Evidence, Guid> _repository;
}
```

**Why**: ABP automatically provides `IRepository<T, TKey>` implementations - custom interfaces not needed unless adding custom queries.

### 7. LocalizedString Database Mapping
**Problem**: EF Core created 3 columns (Title, TitleEn, TitleAr) instead of 2

**Solution**: Proper `OwnsOne` configuration
```csharp
// WRONG: Creates Title, TitleEn, TitleAr columns
public LocalizedString Title { get; set; }

// RIGHT: Creates only TitleEn, TitleAr columns
builder.Entity<Framework>(b => {
    b.OwnsOne(f => f.Title, t => {
        t.Property(ls => ls.En).HasColumnName("TitleEn").HasMaxLength(500);
        t.Property(ls => ls.Ar).HasColumnName("TitleAr").HasMaxLength(500);
    });
});
```

### 8. Web UI Docker Deployment
**Problem**: Web UI wouldn't run in Docker - port conflicts and configuration issues

**Solution**:
```bash
# Build Docker image
docker build -t grc-web:latest -f Shahin-ai/Dockerfile .

# Run with proper environment
docker run -d \
  --name grc-web-ui \
  -p 5500:5000 \
  --network shahin-ai-network \
  -e ASPNETCORE_ENVIRONMENT=Production \
  -e ConnectionStrings__Default="Host=postgres;Database=railway;..." \
  grc-web:latest

# Update Nginx proxy
# In /etc/nginx/sites-available/grc2.doganlap.com
location / {
    proxy_pass http://localhost:5500;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection keep-alive;
}
```

**Result**: Web UI accessible at http://grc2.doganlap.com

## Deployment History & Lessons Learned

### Timeline of Major Fixes

| Date | Issue | Impact | Fix |
|------|-------|--------|-----|
| Dec 21, 2025 | ContactInfo entity config | App crash on startup | Added `HasNoKey()` for value objects |
| Dec 21, 2025 | Missing database tables | HTTP 500 on all module pages | Ran DbMigrator to create schema |
| Dec 21, 2025 | Missing .csproj files | Compilation failures | Created 15+ project files |
| Dec 21, 2025 | Namespace collisions | Build errors in Risk module | Used type aliases |
| Dec 24, 2025 | ABP 8.3 permissions API | Web UI permissions page broken | Migrated to IPermissionManager |
| Dec 24, 2025 | Web UI deployment | Web app not accessible | Fixed Docker + Nginx config |

### Key Lessons

1. **Value Objects vs Entities**: Always configure value objects explicitly with `HasNoKey()` or `OwnsOne()` to prevent EF Core auto-discovery

2. **Migration First**: Before testing any module, ensure database migrations are applied - empty database causes cascading 500 errors

3. **ABP Version Compatibility**: When upgrading ABP versions, check for API changes in:
   - Permission management
   - Blob storage
   - Multi-tenancy
   - Feature management

4. **Repository Pattern**: Use ABP's generic `IRepository<T, TKey>` unless you need custom queries - reduces boilerplate and DI complexity

5. **Docker Networking**: When running multiple containers, use Docker networks and service names (not localhost) for inter-service communication

6. **Nginx Proxy Headers**: Always set proper proxy headers for ASP.NET Core apps:
   ```nginx
   proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
   proxy_set_header X-Forwarded-Proto $scheme;
   proxy_set_header Host $host;
   ```

## Current Production Status

### Services Running
- ✅ PostgreSQL 16+ in Docker (localhost:5434)
- ✅ Redis 7 in Docker (localhost:6379)
- ✅ Unified Web UI at http://37.27.139.173:5500
- ✅ 14 active modules with full functionality
- ✅ Atomic onboarding system enforced
- ✅ Interactive 5-step user initialization
- ✅ Bilingual Arabic/English support

### Endpoints Verified
```bash
# Health checks
curl http://localhost:5000/health        # {"status": "Healthy"}
curl http://localhost:5000/health/ready  # DB + Redis checks

# API
curl http://localhost:5000/api/app/framework/frameworks  # 39 frameworks
curl http://localhost:5000/api/app/regulator            # 116 regulators

# Web UI
curl http://localhost:5500/                             # 200 OK
curl http://localhost:5500/FrameworkLibrary             # 200 OK
curl http://localhost:5500/Risks                        # 200 OK
```

### Default Credentials
```
Username: admin
Password: 1q2w3E*
```
**⚠️ Change immediately after first login!**

## Critical Deployment Issues & Solutions

### 1. Admin User Not Seeded / Login Fails

**Problem**: Cannot login with admin credentials - user doesn't exist in database

**Root Cause**: DbMigrator didn't run or ABP's `IdentityDataSeeder` wasn't executed

**Diagnosis**:
```bash
# Check if admin user exists in database
psql -h [host] -p [port] -U postgres -d railway -c "SELECT * FROM \"AbpUsers\" WHERE \"UserName\" = 'admin';"

# Should return 1 row - if 0 rows, admin user not seeded
```

**Solution**:
```bash
# Run DbMigrator to seed admin user + OpenIddict data
cd Shahin-ai/aspnet-core/src/Grc.DbMigrator
dotnet run

# This will:
# 1. Apply database migrations
# 2. Seed admin user (admin / 1q2w3E*)
# 3. Seed OpenIddict applications/scopes
# 4. Seed framework library data (regulators, frameworks, controls)
```

**Manual SQL Fix (if DbMigrator fails)**:
```sql
-- Check what tables exist
\dt

-- If AbpUsers table exists but no admin:
-- Password hash for: 1q2w3E*
INSERT INTO "AbpUsers" ("Id", "UserName", "NormalizedUserName", "Email", "NormalizedEmail", 
                        "EmailConfirmed", "PasswordHash", "SecurityStamp", "IsActive", 
                        "TenantId", "CreationTime")
VALUES (
    gen_random_uuid(),
    'admin',
    'ADMIN',
    'admin@abp.io',
    'ADMIN@ABP.IO',
    true,
    'AQAAAAEAACcQAAAAEKc7jxBqh1cCPGb9XQqQYL8ykJQNwW9nYHN9Gv9g5f0zcqPfL3CqT8xQ==',
    'SECURITY_STAMP_HERE',
    true,
    NULL,
    NOW()
);
```

### 2. CSS Broken / Styles Not Loading

**Problem**: Web UI appears without styling - plain HTML

**Root Causes**:
1. Static files not being served
2. Wrong base path in HTML
3. Missing `wwwroot` files
4. Nginx not proxying static files correctly

**Diagnosis**:
```bash
# Check if static files exist
ls -la Shahin-ai/aspnet-core/src/Grc.Web/wwwroot/
# Should show: css/, js/, libs/, images/, global-styles.css

# Check browser console (F12)
# Look for 404 errors on .css files

# Test static file directly
curl http://localhost:5500/libs/bootstrap/css/bootstrap.min.css
# Should return CSS content, not HTML error page
```

**Solution 1 - Enable Static Files in ASP.NET Core**:
```csharp
// In GrcWebModule.cs or Startup.cs
public override void OnApplicationInitialization(ApplicationInitializationContext context)
{
    var app = context.GetApplicationBuilder();
    
    // CRITICAL: Must be BEFORE UseRouting
    app.UseStaticFiles();  // Serves files from wwwroot/
    
    app.UseRouting();
    app.UseAuthentication();
    app.UseAuthorization();
    // ... rest of middleware
}
```

**Solution 2 - Check Nginx Configuration** (if using reverse proxy):
```nginx
# In /etc/nginx/sites-available/grc2.doganlap.com

server {
    listen 80;
    server_name grc2.doganlap.com;
    
    location / {
        proxy_pass http://localhost:5500;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection keep-alive;
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
        
        # CRITICAL: Forward original host for static files
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

**Solution 3 - Rebuild and Redeploy**:
```bash
# Full clean rebuild
cd Shahin-ai/aspnet-core/
dotnet clean
dotnet build -c Release
dotnet publish src/Grc.Web/Grc.Web.csproj -c Release -o /var/www/grc/web

# Verify wwwroot copied
ls -la /var/www/grc/web/wwwroot/
```

### 3. Local Database May Not Work

**Problem**: Application can't connect to local PostgreSQL

**Symptoms**:
- `Npgsql.NpgsqlException: Failed to connect to [::1]:5432`
- `Connection refused`
- `Could not connect to server`

**Solution 1 - Check PostgreSQL is Running**:
```bash
# Linux
sudo systemctl status postgresql
sudo systemctl start postgresql

# Check if listening on port 5432
sudo netstat -tlnp | grep 5432

# macOS
brew services list
brew services start postgresql@16

# Windows
# Services → PostgreSQL → Start
```

**Solution 2 - Fix Connection String**:
```bash
# Local PostgreSQL default connection
DATABASE_CONNECTION_STRING="Host=localhost;Port=5432;Database=grc_dev;Username=postgres;Password=postgres"

# If using Docker PostgreSQL
DATABASE_CONNECTION_STRING="Host=localhost;Port=5432;Database=grc_dev;Username=postgres;Password=postgres"

# Test connection
psql -h localhost -p 5432 -U postgres -d grc_dev
```

**Solution 3 - Create Database if Missing**:
```bash
# Login to PostgreSQL
psql -U postgres

# Create database
CREATE DATABASE grc_dev;

# Grant permissions
GRANT ALL PRIVILEGES ON DATABASE grc_dev TO postgres;

# Exit and run migrations
\q
cd Shahin-ai/aspnet-core/src/Grc.DbMigrator
dotnet run
```

### 4. Railway Database No Longer Available

**Problem**: Railway free tier expired or database deleted

**Symptoms**:
- `Npgsql.NpgsqlException: Failed to connect to hopper.proxy.rlwy.net:35071`
- `No such host is known`
- `Connection timeout`

**Immediate Solution - Switch to Local Database**:
```bash
# 1. Install PostgreSQL locally
# Ubuntu/Debian
sudo apt update
sudo apt install postgresql-16 postgresql-contrib

# macOS
brew install postgresql@16
brew services start postgresql@16

# 2. Create local database
sudo -u postgres psql
CREATE DATABASE grc_dev;
CREATE USER grc_user WITH PASSWORD 'secure_password';
GRANT ALL PRIVILEGES ON DATABASE grc_dev TO grc_user;
\q

# 3. Update connection string
cd Shahin-ai/aspnet-core/
nano .env  # or vim .env

# Change to:
DATABASE_CONNECTION_STRING=Host=localhost;Port=5432;Database=grc_dev;Username=grc_user;Password=secure_password

# 4. Run migrations
cd src/Grc.DbMigrator
dotnet run

# 5. Restart application
cd ../Grc.HttpApi.Host
dotnet run
```

**Alternative - New Railway Database**:
```bash
# 1. Login to Railway
railway login

# 2. Create new PostgreSQL service
railway add --service postgresql

# 3. Get new connection string
railway variables

# 4. Update .env with new credentials
DATABASE_CONNECTION_STRING=Host=new-host.proxy.rlwy.net;Port=NEW_PORT;Database=railway;Username=postgres;Password=NEW_PASSWORD

# 5. Run migrations
cd src/Grc.DbMigrator
dotnet run
```

**Alternative - Use Docker PostgreSQL**:
```bash
# 1. Run PostgreSQL in Docker
docker run -d \
  --name grc-postgres \
  -e POSTGRES_PASSWORD=postgres \
  -e POSTGRES_DB=grc_dev \
  -p 5432:5432 \
  -v grc-postgres-data:/var/lib/postgresql/data \
  postgres:16

# 2. Update connection string
DATABASE_CONNECTION_STRING=Host=localhost;Port=5432;Database=grc_dev;Username=postgres;Password=postgres

# 3. Run migrations
cd src/Grc.DbMigrator
dotnet run

# Container will persist data even after restarts
```

### 5. OpenIddict Authentication Issues

**Problem**: Login redirects fail, authentication cookies not set

**Root Cause**: OpenIddict applications/scopes not seeded in database

**Solution**:
```bash
# Run DbMigrator which seeds OpenIddict data
cd Shahin-ai/aspnet-core/src/Grc.DbMigrator
dotnet run

# This seeds:
# - OpenIddictApplications (Grc_Web, Grc_Swagger clients)
# - OpenIddictScopes (email, profile, roles, etc.)
# - Admin user with correct roles
```

**Check OpenIddict Data**:
```sql
-- Check if OpenIddict tables exist
SELECT * FROM "OpenIddictApplications";
-- Should have rows for Grc_Web, Grc_Swagger

SELECT * FROM "OpenIddictScopes";
-- Should have: address, email, phone, profile, roles, offline_access
```

**Web UI Authentication Flow**:
1. User visits `/Account/Login`
2. Redirects to API: `/connect/authorize`
3. API validates user credentials
4. API issues authentication cookie
5. Redirects back to `/`

If any step fails, check:
- Connection strings in both Web and API appsettings.json
- OpenIddict data seeded
- CORS origins configured
- Cookie domain settings

### 6. First-Time Deployment Checklist

```bash
# 1. Setup Database (choose one)
# Option A: Local PostgreSQL
sudo apt install postgresql-16
sudo -u postgres createdb grc_dev

# Option B: Docker PostgreSQL
docker run -d --name grc-postgres -e POSTGRES_PASSWORD=postgres -p 5432:5432 postgres:16

# 2. Configure Environment
cd Shahin-ai/aspnet-core/
cp .env.example .env
nano .env
# Set DATABASE_CONNECTION_STRING
# Set REDIS_CONNECTION_STRING (optional for local dev)
# Set STRING_ENCRYPTION_PASSPHRASE (min 16 chars)

# 3. Run Migrations & Seed Data
cd src/Grc.DbMigrator
dotnet run
# Watch for: "Successfully completed all database migrations"
# Watch for: "Inserted 116 regulators, 39 frameworks, 3500 controls"

# 4. Verify Admin User Created
psql -h localhost -U postgres -d grc_dev -c "SELECT \"UserName\", \"Email\" FROM \"AbpUsers\";"
# Should show: admin | admin@abp.io

# 5. Build & Run Application
cd ../Grc.Web
dotnet build
dotnet run

# 6. Test Login
# Open: http://localhost:5000
# Login: admin / 1q2w3E*

# 7. Change Admin Password Immediately!
# Navigate to: Identity > Users > admin > Change Password
```

## DNS Configuration & Troubleshooting

### DNS_PROBE_FINISHED_NXDOMAIN Error

**Problem**: Browser shows "can't reach this page" or `DNS_PROBE_FINISHED_NXDOMAIN` when accessing `grc2.doganlap.com`

**Root Cause**: DNS A record doesn't exist or isn't configured

**Immediate Workaround - Access by IP Address**:
```bash
# Web UI
http://37.27.139.173:5500

# API/Swagger
http://37.27.139.173:5000/swagger

# No DNS needed for testing!
```

**Permanent Fix - Add DNS Record**:

#### Step 1: Login to Domain Registrar
Login to where you purchased `doganlap.com` (GoDaddy, Namecheap, Cloudflare, etc.)

#### Step 2: Add A Record
```
Type: A
Host/Name: grc2
Value/Points to: 37.27.139.173
TTL: 3600 (or Auto)
```

#### Step 3: Verify DNS Propagation
```bash
# Test DNS resolution (wait 5-30 minutes after adding)
nslookup grc2.doganlap.com
# Expected: 37.27.139.173

# Or using dig
dig grc2.doganlap.com +short
# Expected: 37.27.139.173

# Or ping
ping grc2.doganlap.com
# Should reach 37.27.139.173
```

#### Step 4: Enable HTTPS (After DNS Works)
```bash
# Install certbot if not installed
sudo apt install certbot python3-certbot-nginx

# Get SSL certificate from Let's Encrypt
sudo certbot --nginx -d grc2.doganlap.com --agree-tos --email your-email@example.com

# Certbot will:
# 1. Verify domain ownership via DNS
# 2. Get SSL certificate
# 3. Update Nginx config
# 4. Enable HTTPS redirect
```

### DNS Setup by Provider

**Cloudflare**:
```
Type: A
Name: grc2
IPv4 address: 37.27.139.173
Proxy status: DNS only (gray cloud icon)
TTL: Auto
```

**GoDaddy**:
```
Type: A
Host: grc2
Points to: 37.27.139.173
TTL: 1 Hour
```

**Namecheap**:
```
Type: A Record
Host: grc2
Value: 37.27.139.173
TTL: Automatic
```

**Google Domains**:
```
Type: A
Name: grc2
Data: 37.27.139.173
TTL: 3600
```

### Common DNS Issues

**Issue 1**: DNS not propagating after 30+ minutes
```bash
# Check if DNS server has the record
dig grc2.doganlap.com @8.8.8.8  # Google DNS
dig grc2.doganlap.com @1.1.1.1  # Cloudflare DNS

# If still no record:
# 1. Verify A record was saved in registrar panel
# 2. Check for typos in hostname (must be exactly "grc2")
# 3. Clear browser DNS cache: chrome://net-internals/#dns
# 4. Flush system DNS cache
sudo systemd-resolve --flush-caches  # Linux
dscacheutil -flushcache  # macOS
ipconfig /flushdns  # Windows
```

**Issue 2**: DNS resolves to wrong IP
```bash
# Check current DNS record
dig grc2.doganlap.com

# If IP is wrong:
# 1. Update A record in registrar
# 2. Lower TTL to 300 (5 minutes) for faster updates
# 3. Wait for old TTL to expire
```

**Issue 3**: HTTPS not working after DNS setup
```bash
# Verify Nginx is running
sudo systemctl status nginx

# Check if certbot ran successfully
sudo certbot certificates

# Manually request certificate if needed
sudo certbot --nginx -d grc2.doganlap.com --force-renewal

# Check Nginx error logs
sudo tail -f /var/log/nginx/error.log
```

### Nginx Configuration for Domain

After DNS is configured, verify Nginx config:

```nginx
# /etc/nginx/sites-available/grc2.doganlap.com

server {
    listen 80;
    server_name grc2.doganlap.com;
    
    # Let's Encrypt ACME challenge location
    location /.well-known/acme-challenge/ {
        root /var/www/html;
    }
    
    # Redirect to HTTPS (after SSL setup)
    location / {
        return 301 https://$server_name$request_uri;
    }
}

server {
    listen 443 ssl http2;
    server_name grc2.doganlap.com;
    
    # SSL certificates (added by certbot)
    ssl_certificate /etc/letsencrypt/live/grc2.doganlap.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/grc2.doganlap.com/privkey.pem;
    
    location / {
        proxy_pass http://localhost:5500;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection keep-alive;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }
}
```

Enable config:
```bash
sudo ln -s /etc/nginx/sites-available/grc2.doganlap.com /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

### Quick Access Reference

| Environment | URL | Requires DNS |
|-------------|-----|--------------|
| **Production (with DNS)** | https://grc2.doganlap.com | Yes ✅ |
| **Direct IP Access** | http://37.27.139.173:5500 | No ❌ |
| **API/Swagger** | http://37.27.139.173:5000/swagger | No ❌ |
| **Local Development** | http://localhost:5000 | No ❌ |

### Deployment Status Checklist

```bash
# Check all services
sudo systemctl status nginx        # Nginx running
sudo systemctl status grc-api      # API running (if systemd)
sudo systemctl status grc-web      # Web UI running (if systemd)
docker ps                          # Docker containers (if using Docker)

# Check ports listening
sudo netstat -tlnp | grep :80      # Nginx HTTP
sudo netstat -tlnp | grep :443     # Nginx HTTPS
sudo netstat -tlnp | grep :5000    # API
sudo netstat -tlnp | grep :5500    # Web UI

# Test endpoints
curl -I http://localhost:5500      # Web UI locally
curl -I http://37.27.139.173:5500  # Web UI via IP
curl -I http://grc2.doganlap.com   # Web UI via domain (after DNS)
```

## Production Readiness & Final Verification

### Pre-Deployment Checklist

**Database & Migrations**:
```bash
# 1. Verify database connection
cd Shahin-ai/aspnet-core/src/Grc.HttpApi.Host
dotnet run --no-build
# Look for: "Database connected successfully"

# 2. Check if admin user exists
psql -h [host] -U postgres -d railway -c "SELECT \"UserName\", \"Email\", \"EmailConfirmed\" FROM \"AbpUsers\" WHERE \"UserName\" = 'admin';"
# Expected: 1 row with admin user

# 3. Verify framework data seeded
psql -h [host] -U postgres -d railway -c "SELECT COUNT(*) FROM \"Regulators\";"
# Expected: 116 regulators
psql -h [host] -U postgres -d railway -c "SELECT COUNT(*) FROM \"Frameworks\";"
# Expected: 39 frameworks
psql -h [host] -U postgres -d railway -c "SELECT COUNT(*) FROM \"Controls\";"
# Expected: 3500+ controls

# 4. Check OpenIddict applications
psql -h [host] -U postgres -d railway -c "SELECT \"ClientId\" FROM \"OpenIddictApplications\";"
# Expected: Grc_Web, Grc_Swagger
```

**Application Build**:
```bash
cd Shahin-ai/aspnet-core/

# 1. Clean build
dotnet clean
dotnet restore
dotnet build -c Release

# Check for:
# ✅ Build succeeded - 0 Error(s)
# ⚠️ 0 Warning(s) (ideal, some warnings acceptable)

# 2. Run tests (if available)
dotnet test --no-build -c Release

# 3. Publish for deployment
dotnet publish src/Grc.Web/Grc.Web.csproj -c Release -o ./publish/web
dotnet publish src/Grc.HttpApi.Host/Grc.HttpApi.Host.csproj -c Release -o ./publish/api

# Verify wwwroot copied
ls -la ./publish/web/wwwroot/
# Should contain: css/, js/, libs/, images/, global-styles.css
```

**Environment Configuration**:
```bash
# 1. Verify all required environment variables set
cd Shahin-ai/aspnet-core/
cat .env | grep -E "DATABASE_CONNECTION_STRING|REDIS_CONNECTION_STRING|STRING_ENCRYPTION_PASSPHRASE|S3_"

# Must have:
# ✅ DATABASE_CONNECTION_STRING (PostgreSQL)
# ✅ STRING_ENCRYPTION_PASSPHRASE (min 16 chars)
# ⚠️ REDIS_CONNECTION_STRING (optional but recommended)
# ⚠️ S3_* variables (optional, for file uploads)

# 2. Test database connection
export $(cat .env | grep -v '^#' | xargs)
psql "$DATABASE_CONNECTION_STRING" -c "SELECT version();"
# Should show PostgreSQL version

# 3. Verify connection strings in appsettings.json use environment variables
grep "DATABASE_CONNECTION_STRING" src/Grc.HttpApi.Host/appsettings.json
# Should show: "Default": "${DATABASE_CONNECTION_STRING}"
```

### Application Health Checks

**API Health**:
```bash
# Start API
cd src/Grc.HttpApi.Host
dotnet run &
sleep 10  # Wait for startup

# 1. Basic health check
curl http://localhost:5000/health
# Expected: {"status":"Healthy"}

# 2. Detailed health with components
curl http://localhost:5000/health/ready
# Expected: PostgreSQL: Healthy, Redis: Healthy (or Degraded if optional)

# 3. Swagger available
curl -I http://localhost:5000/swagger
# Expected: HTTP/1.1 200 OK

# 4. Test authentication endpoint
curl http://localhost:5000/api/account/login
# Expected: HTTP 400 (requires credentials, but endpoint works)

# 5. Test framework endpoint
curl "http://localhost:5000/api/app/framework/frameworks?MaxResultCount=1"
# Expected: JSON with framework data
```

**Web UI Health**:
```bash
# Start Web UI
cd src/Grc.Web
dotnet run &
sleep 10

# 1. Home page loads
curl -I http://localhost:5000/
# Expected: HTTP/1.1 200 OK

# 2. Static files served
curl -I http://localhost:5000/libs/bootstrap/css/bootstrap.min.css
# Expected: HTTP/1.1 200 OK, Content-Type: text/css

# 3. Login page accessible
curl -I http://localhost:5000/Account/Login
# Expected: HTTP/1.1 200 OK

# 4. Check for CSS in HTML
curl http://localhost:5000/ | grep -o '<link.*\.css' | head -5
# Should show multiple CSS link tags
```

### Functional Testing

**Authentication Flow**:
```bash
# 1. Access login page
curl -c cookies.txt http://localhost:5000/Account/Login
# Saves cookies

# 2. Login with admin credentials
curl -b cookies.txt -c cookies.txt \
  -d "username=admin&password=1q2w3E*" \
  http://localhost:5000/Account/Login

# 3. Access protected page
curl -b cookies.txt http://localhost:5000/Dashboard
# Expected: HTTP 200 (not redirect to login)
```

**Module Pages**:
```bash
# Test all major module pages return 200
for page in "/" "/Dashboard" "/FrameworkLibrary" "/Regulators" "/Assessments" "/Risks" "/Evidence" "/Identity/Users"; do
  status=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:5000$page)
  echo "$page: $status"
done

# Expected: All pages return 200 or 302 (redirect to login if not authenticated)
# ❌ Should NOT return 500 (server error)
```

### Common Issues & Quick Fixes

**Issue**: Build fails with missing packages
```bash
# Solution: Clean NuGet cache and restore
dotnet nuget locals all --clear
dotnet restore
dotnet build
```

**Issue**: Database connection fails
```bash
# Solution 1: Verify connection string
echo $DATABASE_CONNECTION_STRING

# Solution 2: Test with psql
psql "$DATABASE_CONNECTION_STRING" -c "\dt"

# Solution 3: Check firewall/network
ping [database-host]
telnet [database-host] [port]
```

**Issue**: Admin login fails
```bash
# Solution: Re-run DbMigrator
cd src/Grc.DbMigrator
dotnet run
# This re-seeds admin user and OpenIddict data
```

**Issue**: CSS not loading (plain HTML)
```bash
# Solution 1: Verify static files middleware enabled
grep "UseStaticFiles" src/Grc.Web/GrcWebModule.cs
# Should exist before UseRouting()

# Solution 2: Check wwwroot exists
ls -la src/Grc.Web/wwwroot/
# Should contain css/, js/, libs/

# Solution 3: Clear browser cache
# Ctrl+Shift+R (hard refresh)
```

**Issue**: 500 errors on module pages
```bash
# Solution: Check database tables exist
psql "$DATABASE_CONNECTION_STRING" -c "\dt" | grep -E "Frameworks|Risks|Evidences|Assessments"

# If missing, run migrations:
cd src/Grc.DbMigrator
dotnet run
```

### Performance Verification

**Database Indexing**:
```sql
-- Check critical indexes exist
SELECT tablename, indexname 
FROM pg_indexes 
WHERE tablename IN ('Frameworks', 'Controls', 'Assessments', 'Risks')
ORDER BY tablename;

-- Should have indexes on:
-- ✅ Primary keys (automatic)
-- ✅ Foreign keys (FrameworkId, RegulatorId, etc.)
-- ✅ TenantId (for multi-tenant entities)
-- ✅ Frequently filtered columns (Status, Category)
```

**Response Time Checks**:
```bash
# Measure API response times
time curl -s http://localhost:5000/api/app/framework/frameworks?MaxResultCount=10 > /dev/null
# Expected: < 1 second

time curl -s http://localhost:5000/api/app/regulator > /dev/null
# Expected: < 2 seconds (116 regulators)

# Check slow queries in logs
grep -i "slow" src/Grc.HttpApi.Host/Logs/logs.txt
```

### Security Hardening Checklist

```bash
# 1. Change default admin password
# ⚠️ CRITICAL: Change from 1q2w3E* immediately after first login

# 2. Verify HTTPS enabled in production
curl -I https://grc2.doganlap.com
# Expected: HTTP/2 200, with SSL certificate

# 3. Check CORS configuration
grep "CorsOrigins" src/Grc.HttpApi.Host/appsettings.json
# Should list only trusted domains

# 4. Verify connection strings not hardcoded
grep -r "Password=" src/ --include="*.json" --include="*.cs"
# Should only show ${ENV_VAR} placeholders, not actual passwords

# 5. Check encryption passphrase is strong
echo $STRING_ENCRYPTION_PASSPHRASE | wc -c
# Expected: > 16 characters
```

### Final Go-Live Checklist

Before going live, verify:

- [ ] ✅ Database migrations applied successfully
- [ ] ✅ Admin user can login (and password changed from default)
- [ ] ✅ All 3,655 records seeded (116 regulators, 39 frameworks, 3500+ controls)
- [ ] ✅ OpenIddict applications configured (Grc_Web, Grc_Swagger)
- [ ] ✅ Build completes with 0 errors
- [ ] ✅ All module pages return HTTP 200 (not 500)
- [ ] ✅ Static files (CSS/JS) loading correctly
- [ ] ✅ Health checks passing (/health returns "Healthy")
- [ ] ✅ API endpoints responding correctly
- [ ] ✅ Authentication flow working (login/logout)
- [ ] ✅ Environment variables configured (not hardcoded)
- [ ] ✅ HTTPS enabled (if using domain)
- [ ] ✅ DNS configured (if using domain)
- [ ] ✅ Nginx reverse proxy configured
- [ ] ✅ Logs directory writable and logs being generated
- [ ] ✅ Default credentials changed
- [ ] ✅ Backup strategy in place
- [ ] ✅ Monitoring configured (health checks, logs)

### Post-Deployment Monitoring

**Monitor These Logs**:
```bash
# Application logs
tail -f Shahin-ai/aspnet-core/src/Grc.HttpApi.Host/Logs/logs.txt

# Watch for errors
grep -i error Shahin-ai/aspnet-core/src/Grc.HttpApi.Host/Logs/logs.txt

# Nginx access logs
sudo tail -f /var/log/nginx/access.log

# Nginx error logs
sudo tail -f /var/log/nginx/error.log

# System logs
sudo journalctl -u grc-api -f
sudo journalctl -u grc-web -f
```

**Key Metrics to Monitor**:
- Response times (< 1s for most endpoints)
- Error rate (< 1% of requests)
- Database connection pool (not exhausted)
- Memory usage (< 80% of available)
- Disk space (> 20% free)
- SSL certificate expiry (> 30 days)

### Emergency Rollback Procedure

If critical issues occur after deployment:

```bash
# 1. Stop services
sudo systemctl stop grc-web
sudo systemctl stop grc-api

# 2. Restore previous version
cd /var/www/grc/
mv web web.broken
mv web.backup web

# 3. Restart services
sudo systemctl start grc-api
sudo systemctl start grc-web

# 4. Verify rollback successful
curl http://localhost:5000/health
curl http://localhost:5500/

# 5. Investigate issue in logs
grep -i error web.broken/Logs/logs.txt
```

### Success Indicators

**Application is production-ready when**:
✅ All health checks return "Healthy"
✅ All module pages load without 500 errors
✅ User can login and navigate the application
✅ Data is visible (frameworks, regulators, controls)
✅ CSS/styling appears correctly
✅ API responds to requests within acceptable time
✅ Logs show no critical errors
✅ HTTPS works (if using domain)
✅ No console errors in browser F12 tools
✅ All 17 checklist items above are checked

**You're ready to go live! 🚀**

## Recent Major Updates (December 2025)

### ✅ Atomic Onboarding System
- **UserInitializationService** with `[UnitOfWork]` transactions
- **OnboardingCheckMiddleware** blocks access until complete  
- **5-step interactive wizard** with real-time validation
- **Zero broken states** - all records created atomically or rolled back entirely
- **Files**: `Grc.Domain/Onboarding/UserInitializationService.cs`, `Pages/Onboarding/` partials

### ✅ Critical Development Patterns Established
- **UnitOfWork transactions** for complex operations prevent broken states
- **LocalizedString mandatory** for all user-facing text (Arabic/English)
- **IMultiTenant interface** required for tenant-isolated entities
- **ConfigureByConvention()** mandatory in EF configurations
- **Private setters + public methods** enforce domain invariants

### 🎯 Key Success Metrics  
- **Build Status**: 0 errors, 163 nullable warnings (acceptable)
- **Database**: 3,655 records seeded (116 regulators, 39 frameworks, 3500+ controls)
- **Modules Active**: 14 functional modules with full CRUD operations
- **Health Checks**: All endpoints returning HTTP 200/Healthy status
- **User Experience**: Mandatory onboarding ensures zero incomplete user states

**For AI Agents**: This system is production-ready with battle-tested patterns. Focus on following the established UnitOfWork + LocalizedString + Multi-tenancy patterns when extending functionality.

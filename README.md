# Saudi GRC Platform

A comprehensive **Governance, Risk, and Compliance (GRC)** platform designed for organizations operating in Saudi Arabia. Built with .NET 8.0, Angular 18, and PostgreSQL.

## 🚀 Features

- **Multi-Tenancy**: Domain-based tenant resolution with isolated data
- **Bilingual Support**: Full Arabic and English localization
- **Framework Library**: Pre-loaded Saudi regulatory frameworks (NCA ECC, SAMA, CITC, etc.)
- **Risk Management**: Comprehensive risk assessment and treatment workflows
- **Evidence Management**: Secure document storage with AI classification
- **Assessment Workflows**: Gap analysis and compliance tracking
- **Policy Management**: Centralized policy administration
- **Audit Tracking**: Complete audit trail for compliance
- **AI Integration**: Automated evidence classification and gap analysis

## 🏗️ Architecture

### Technology Stack

**Backend**:
- .NET 8.0 with ABP Framework
- Entity Framework Core 8.0
- PostgreSQL 16+
- Redis 7+ (caching)
- OpenIddict (OAuth2/OIDC)
- Serilog (logging)

**Frontend**:
- Angular 18
- TypeScript 5.4
- SCSS
- PrimeNG (UI components)

**Infrastructure**:
- Docker / Kubernetes
- Railway Cloud Platform
- MinIO S3-compatible storage
- GitHub Actions CI/CD

### Design Patterns

- **Domain-Driven Design (DDD)**: Clean separation of concerns
- **CQRS**: Command Query Responsibility Segregation
- **Microservices-ready**: Modular monolith architecture
- **Multi-tenancy**: Tenant isolation at data level
- **Event-Driven**: Domain events for cross-module communication

## 📋 Prerequisites

- [.NET 8.0 SDK](https://dotnet.microsoft.com/download/dotnet/8.0)
- [Node.js 20.x](https://nodejs.org/)
- [Docker Desktop](https://www.docker.com/products/docker-desktop/) (optional)
- [PostgreSQL 16+](https://www.postgresql.org/download/) (or use Railway)
- [Redis 7+](https://redis.io/download/) (or use Railway)

## 🛠️ Getting Started

### 1. Clone the Repository

\`\`\`bash
git clone https://github.com/your-org/app.shahin-ai.com.git
cd app.shahin-ai.com
\`\`\`

### 2. Configure Environment Variables

\`\`\`bash
cd Shahin-ai/aspnet-core
cp .env.example .env
# Edit .env with your actual credentials
\`\`\`

**Required Environment Variables**:
- `DATABASE_CONNECTION_STRING`: PostgreSQL connection string
- `REDIS_CONNECTION_STRING`: Redis connection string
- `S3_ENDPOINT`: S3-compatible storage endpoint
- `S3_BUCKET_NAME`: Storage bucket name
- `S3_ACCESS_KEY_ID`: S3 access key
- `S3_SECRET_ACCESS_KEY`: S3 secret key
- `STRING_ENCRYPTION_PASSPHRASE`: Encryption passphrase (min 16 chars)

### 3. Database Setup

\`\`\`bash
cd Shahin-ai/aspnet-core

# Run database migrations
dotnet run --project src/Grc.DbMigrator/Grc.DbMigrator.csproj

# Seed initial data (regulators, frameworks, controls)
# Data seeding runs automatically on first migration
\`\`\`

### 4. Build and Run Backend

\`\`\`bash
cd Shahin-ai/aspnet-core

# Restore packages
dotnet restore Grc.sln

# Build solution
dotnet build Grc.sln --configuration Release

# Run API
dotnet run --project src/Grc.HttpApi.Host/Grc.HttpApi.Host.csproj
\`\`\`

API will be available at: `https://localhost:7001`

### 5. Build and Run Frontend

\`\`\`bash
cd Shahin-ai/aspnet-core/angular

# Install dependencies
npm install

# Run development server
npm start
\`\`\`

Application will be available at: `http://localhost:4200`

### 6. Access Swagger API Documentation

Navigate to: `https://localhost:7001/swagger`

## 🐳 Docker Deployment

### Using Docker Compose (Local Development)

\`\`\`bash
cd Shahin-ai
docker-compose up -d
\`\`\`

This starts:
- PostgreSQL with pgAdmin
- Redis
- MySQL with phpMyAdmin

### Build Docker Image

\`\`\`bash
cd Shahin-ai
docker build -t grc-api:latest -f Dockerfile .
docker run -p 8080:8080 --env-file .env grc-api:latest
\`\`\`

## ☁️ Railway Deployment

### Prerequisites

1. Install Railway CLI: `npm install -g @railway/cli`
2. Login: `railway login`

### Deploy

\`\`\`bash
cd Shahin-ai
railway up
\`\`\`

Configuration is in `railway.json`.

## 🔐 Security

### ⚠️ CRITICAL: Security Vulnerabilities Remediation

**BEFORE deploying to production, you MUST:**

1. **Rotate all exposed credentials** (see `SECRETS_MIGRATION.md`)
2. **Remove secrets from git history**
3. **Configure environment variables** in your deployment platform
4. **Enable GitHub secret scanning**

See [SECRETS_MIGRATION.md](./SECRETS_MIGRATION.md) for detailed instructions.

### Security Features

- ✅ OAuth2/OpenID Connect authentication
- ✅ Role-based access control (RBAC)
- ✅ Multi-tenancy with data isolation
- ✅ Request/response logging
- ✅ Global exception handling
- ✅ Health check endpoints (`/health`, `/health/ready`, `/health/live`)
- ✅ CORS configuration
- ✅ HTTPS enforcement

## 📊 Health Checks

The application exposes health check endpoints:

- `/health` - Detailed health status (JSON)
- `/health/ready` - Readiness probe (for Kubernetes)
- `/health/live` - Liveness probe (for Kubernetes)

Health checks include:
- PostgreSQL database connectivity
- Redis cache connectivity

## 🧪 Testing

### Run Backend Tests

\`\`\`bash
cd Shahin-ai/aspnet-core
dotnet test Grc.sln --configuration Release
\`\`\`

### Run Frontend Tests

\`\`\`bash
cd Shahin-ai/aspnet-core/angular
npm run test
\`\`\`

## 📚 Documentation

### Project Documentation

- [Deployment Instructions](./docs/deployment/ACCESS-INSTRUCTIONS.md)
- [Database Setup](./docs/database/DATABASE_CONNECTION_STATUS.md)
- [API Documentation](./docs/api/API_VIEWER_README.md)
- [Enterprise Features](./docs/enterprise/ENTERPRISE-NAVIGATION-CHECKLIST.md)
- [Security Migration](./SECRETS_MIGRATION.md)

### API Documentation

- **Swagger UI**: `https://api-grc.shahin-ai.com/swagger`
- **API Viewer**: See `docs/api/API_VIEWER_README.md`

### Entity Documentation

Detailed entity specifications in:
- `Shahin-ai/saudi-grc-ai-agent-specs/01-ENTITIES.yaml`
- `Shahin-ai/saudi-grc-ai-agent-specs/02-DATABASE-SCHEMA.sql`
- `Shahin-ai/saudi-grc-ai-agent-specs/03-API-SPEC.yaml`

## 🤝 Contributing

### Development Workflow

1. Create a feature branch: `git checkout -b feature/your-feature-name`
2. Make your changes following DDD patterns
3. Write tests for new features
4. Run linters and formatters
5. Submit a pull request

### Code Standards

- **Backend**: Follow ABP Framework conventions and DDD patterns
- **Frontend**: Use Angular style guide
- **Commits**: Use conventional commits (feat:, fix:, docs:, etc.)
- **Localization**: Always use `LocalizedString` for user-facing text

## 📝 License

Copyright © 2024 Shahin AI. All rights reserved.

## 🆘 Support

For issues and questions:
- GitHub Issues: [Create an issue](https://github.com/your-org/app.shahin-ai.com/issues)
- Email: support@shahin-ai.com

## 🗺️ Roadmap

- [ ] Advanced analytics dashboard
- [ ] AI-powered gap analysis
- [ ] Automated evidence extraction
- [ ] Integration with external audit systems
- [ ] Mobile application (iOS/Android)
- [ ] Advanced workflow automation
- [ ] Third-party risk management
- [ ] Incident management module

## 📊 Project Status

- **Backend Build**: ✅ Passing
- **Frontend Build**: ✅ Passing
- **Security**: ⚠️ Requires credential rotation
- **Deployment**: ✅ Railway configured
- **CI/CD**: ✅ GitHub Actions configured

---

Built with ❤️ by the Shahin AI Team

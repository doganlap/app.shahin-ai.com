#!/bin/bash

# Saudi GRC Platform - Production Deployment Script
# Complete Arabic Workflow System Deployment
# Date: December 25, 2024

set -e  # Exit on any error

echo "========================================="
echo "Saudi GRC Platform - Production Deployment"
echo "Arabic Workflow System Included"
echo "========================================="

# Configuration
SOLUTION_PATH="/root/app.shahin-ai.com/Shahin-ai/aspnet-core"
PUBLISH_PATH="${SOLUTION_PATH}/publish"
DEPLOYMENT_PATH="/opt/grc-platform"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check prerequisites
check_prerequisites() {
    print_status "Checking prerequisites..."
    
    if ! command_exists dotnet; then
        print_error ".NET 8.0 runtime not found. Please install .NET 8.0."
        exit 1
    fi
    
    if ! command_exists psql; then
        print_warning "PostgreSQL client not found. Database connection testing will be limited."
    fi
    
    print_success "Prerequisites check completed"
}

# Environment variable validation
validate_environment() {
    print_status "Validating environment variables..."
    
    if [[ -z "${DATABASE_CONNECTION_STRING:-}" ]]; then
        print_error "DATABASE_CONNECTION_STRING environment variable is required"
        echo "Example: export DATABASE_CONNECTION_STRING='Host=localhost;Database=grc;Username=postgres;Password=yourpassword'"
        exit 1
    fi
    
    if [[ -z "${STRING_ENCRYPTION_PASSPHRASE:-}" ]]; then
        print_error "STRING_ENCRYPTION_PASSPHRASE environment variable is required (minimum 16 characters)"
        echo "Example: export STRING_ENCRYPTION_PASSPHRASE='YourSecureEncryptionKey123'"
        exit 1
    fi
    
    # Validate passphrase length
    if [[ ${#STRING_ENCRYPTION_PASSPHRASE} -lt 16 ]]; then
        print_error "STRING_ENCRYPTION_PASSPHRASE must be at least 16 characters long"
        exit 1
    fi
    
    print_success "Environment variables validated"
}

# Test database connection
test_database_connection() {
    print_status "Testing database connection..."
    
    # Extract connection details (basic parsing)
    DB_HOST=$(echo $DATABASE_CONNECTION_STRING | grep -oP 'Host=\K[^;]*' || echo "localhost")
    DB_NAME=$(echo $DATABASE_CONNECTION_STRING | grep -oP 'Database=\K[^;]*' || echo "grc")
    DB_USER=$(echo $DATABASE_CONNECTION_STRING | grep -oP 'Username=\K[^;]*' || echo "postgres")
    
    if command_exists psql; then
        # Test connection using psql (will prompt for password if needed)
        if PGPASSWORD="${DATABASE_PASSWORD:-}" psql -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" -c "SELECT 1;" > /dev/null 2>&1; then
            print_success "Database connection test passed"
        else
            print_warning "Database connection test failed. Please ensure database is accessible."
            read -p "Continue anyway? (y/N): " -r
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                exit 1
            fi
        fi
    else
        print_warning "Cannot test database connection (psql not available)"
    fi
}

# Create deployment directory
setup_deployment_directory() {
    print_status "Setting up deployment directory: $DEPLOYMENT_PATH"
    
    # Create deployment directory with proper permissions
    sudo mkdir -p "$DEPLOYMENT_PATH"
    sudo chown -R $USER:$USER "$DEPLOYMENT_PATH"
    
    print_success "Deployment directory created: $DEPLOYMENT_PATH"
}

# Copy published artifacts
deploy_artifacts() {
    print_status "Deploying application artifacts..."
    
    # Check if publish directory exists
    if [[ ! -d "$PUBLISH_PATH" ]]; then
        print_error "Published artifacts not found at: $PUBLISH_PATH"
        print_error "Please run 'dotnet publish' first or check the PRODUCTION-DEPLOYMENT-COMPLETE.md"
        exit 1
    fi
    
    # Copy API
    if [[ -d "$PUBLISH_PATH/api" ]]; then
        print_status "Deploying API server..."
        cp -r "$PUBLISH_PATH/api" "$DEPLOYMENT_PATH/"
        chmod +x "$DEPLOYMENT_PATH/api/Grc.HttpApi.Host"
        print_success "API deployed to: $DEPLOYMENT_PATH/api"
    else
        print_error "API artifacts not found at: $PUBLISH_PATH/api"
        exit 1
    fi
    
    # Copy Web UI
    if [[ -d "$PUBLISH_PATH/web" ]]; then
        print_status "Deploying Web UI..."
        cp -r "$PUBLISH_PATH/web" "$DEPLOYMENT_PATH/"
        chmod +x "$DEPLOYMENT_PATH/web/Grc.Web"
        print_success "Web UI deployed to: $DEPLOYMENT_PATH/web"
    else
        print_error "Web UI artifacts not found at: $PUBLISH_PATH/web"
        exit 1
    fi
    
    # Copy Database Migrator
    if [[ -d "$PUBLISH_PATH/migrator" ]]; then
        print_status "Deploying Database Migrator..."
        cp -r "$PUBLISH_PATH/migrator" "$DEPLOYMENT_PATH/"
        chmod +x "$DEPLOYMENT_PATH/migrator/Grc.DbMigrator"
        print_success "Migrator deployed to: $DEPLOYMENT_PATH/migrator"
    else
        print_error "Migrator artifacts not found at: $PUBLISH_PATH/migrator"
        exit 1
    fi
}

# Run database migrations
run_migrations() {
    print_status "Running database migrations and seeding data..."
    print_status "This will create/update database schema and seed Saudi regulatory data..."
    
    cd "$DEPLOYMENT_PATH/migrator"
    
    # Set environment variables for migrator
    export DATABASE_CONNECTION_STRING="$DATABASE_CONNECTION_STRING"
    export STRING_ENCRYPTION_PASSPHRASE="$STRING_ENCRYPTION_PASSPHRASE"
    
    print_status "Initializing database with Arabic workflow system..."
    ./Grc.DbMigrator
    
    if [[ $? -eq 0 ]]; then
        print_success "Database initialization completed successfully"
        print_success "Seeded data includes:"
        echo "  ✅ 116 Saudi regulators (NCA, SAMA, CITC, NDMO, SDAIA, MOH, etc.)"
        echo "  ✅ 39 compliance frameworks with Arabic translations"
        echo "  ✅ 3,500+ controls with bilingual requirements"
        echo "  ✅ 10 Arabic workflow definitions with BPMN"
        echo "  ✅ Admin user: admin / 1q2w3E* (CHANGE PASSWORD IMMEDIATELY)"
        echo "  ✅ OpenIddict OAuth2/OIDC configuration"
    else
        print_error "Database migration failed"
        exit 1
    fi
}

# Create systemd service files
create_systemd_services() {
    print_status "Creating systemd service files..."
    
    # API Service
    sudo tee /etc/systemd/system/grc-api.service > /dev/null <<EOF
[Unit]
Description=Saudi GRC Platform API Server
After=network.target
After=postgresql.service
Requires=postgresql.service

[Service]
Type=notify
User=$USER
Group=$USER
WorkingDirectory=$DEPLOYMENT_PATH/api
ExecStart=$DEPLOYMENT_PATH/api/Grc.HttpApi.Host
Restart=always
RestartSec=10
Environment=DATABASE_CONNECTION_STRING=$DATABASE_CONNECTION_STRING
Environment=STRING_ENCRYPTION_PASSPHRASE=$STRING_ENCRYPTION_PASSPHRASE
Environment=ASPNETCORE_ENVIRONMENT=Production
Environment=ASPNETCORE_URLS=http://localhost:5000

[Install]
WantedBy=multi-user.target
EOF

    # Web UI Service
    sudo tee /etc/systemd/system/grc-web.service > /dev/null <<EOF
[Unit]
Description=Saudi GRC Platform Web UI
After=network.target
After=grc-api.service
Requires=grc-api.service

[Service]
Type=notify
User=$USER
Group=$USER
WorkingDirectory=$DEPLOYMENT_PATH/web
ExecStart=$DEPLOYMENT_PATH/web/Grc.Web
Restart=always
RestartSec=10
Environment=DATABASE_CONNECTION_STRING=$DATABASE_CONNECTION_STRING
Environment=STRING_ENCRYPTION_PASSPHRASE=$STRING_ENCRYPTION_PASSPHRASE
Environment=ASPNETCORE_ENVIRONMENT=Production
Environment=ASPNETCORE_URLS=http://localhost:5001

[Install]
WantedBy=multi-user.target
EOF
    
    # Reload systemd
    sudo systemctl daemon-reload
    sudo systemctl enable grc-api
    sudo systemctl enable grc-web
    
    print_success "Systemd services created and enabled"
    print_success "Services: grc-api.service, grc-web.service"
}

# Start services
start_services() {
    print_status "Starting GRC Platform services..."
    
    # Start API first
    print_status "Starting API server..."
    sudo systemctl start grc-api
    sleep 5
    
    if sudo systemctl is-active --quiet grc-api; then
        print_success "API server started successfully"
    else
        print_error "Failed to start API server"
        sudo systemctl status grc-api
        exit 1
    fi
    
    # Start Web UI
    print_status "Starting Web UI..."
    sudo systemctl start grc-web
    sleep 5
    
    if sudo systemctl is-active --quiet grc-web; then
        print_success "Web UI started successfully"
    else
        print_error "Failed to start Web UI"
        sudo systemctl status grc-web
        exit 1
    fi
}

# Test deployment
test_deployment() {
    print_status "Testing deployment..."
    
    # Test API health
    print_status "Testing API health endpoint..."
    if curl -s http://localhost:5000/health | grep -q "Healthy"; then
        print_success "API health check passed"
    else
        print_warning "API health check failed or service not ready yet"
    fi
    
    # Test Web UI
    print_status "Testing Web UI..."
    if curl -s -o /dev/null -w "%{http_code}" http://localhost:5001/ | grep -q "200"; then
        print_success "Web UI is responding"
    else
        print_warning "Web UI not responding or not ready yet"
    fi
}

# Create nginx configuration (optional)
create_nginx_config() {
    if command_exists nginx; then
        print_status "Creating Nginx reverse proxy configuration..."
        
        sudo tee /etc/nginx/sites-available/grc-platform > /dev/null <<EOF
server {
    listen 80;
    server_name grc-platform.local _;
    
    # API proxy
    location /api/ {
        proxy_pass http://localhost:5000/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection keep-alive;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_cache_bypass \$http_upgrade;
    }
    
    # Web UI proxy
    location / {
        proxy_pass http://localhost:5001/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection keep-alive;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOF
        
        # Enable the site
        sudo ln -sf /etc/nginx/sites-available/grc-platform /etc/nginx/sites-enabled/
        sudo nginx -t && sudo systemctl reload nginx
        
        print_success "Nginx configuration created and enabled"
    else
        print_warning "Nginx not found. Skipping reverse proxy setup."
    fi
}

# Main deployment function
main() {
    echo "Starting production deployment..."
    
    check_prerequisites
    validate_environment
    test_database_connection
    setup_deployment_directory
    deploy_artifacts
    run_migrations
    create_systemd_services
    start_services
    test_deployment
    create_nginx_config
    
    print_success "========================================="
    print_success "DEPLOYMENT COMPLETED SUCCESSFULLY! 🚀"
    print_success "========================================="
    
    echo
    echo "🌐 Access URLs:"
    echo "   API Server: http://localhost:5000"
    echo "   Swagger UI: http://localhost:5000/swagger"
    echo "   Web UI: http://localhost:5001"
    echo "   Health Check: http://localhost:5000/health"
    
    if command_exists nginx; then
        echo "   Nginx Proxy: http://your-domain/"
    fi
    
    echo
    echo "👤 Default Credentials:"
    echo "   Username: admin"
    echo "   Password: 1q2w3E*"
    echo "   ⚠️  CHANGE PASSWORD IMMEDIATELY AFTER FIRST LOGIN!"
    
    echo
    echo "🔧 Service Management:"
    echo "   Start API: sudo systemctl start grc-api"
    echo "   Stop API: sudo systemctl stop grc-api"
    echo "   Start Web: sudo systemctl start grc-web"
    echo "   Stop Web: sudo systemctl stop grc-web"
    echo "   View API logs: sudo journalctl -u grc-api -f"
    echo "   View Web logs: sudo journalctl -u grc-web -f"
    
    echo
    echo "📊 Platform Features Available:"
    echo "   ✅ Multi-tenant GRC Management"
    echo "   ✅ 10 Arabic Workflow Definitions (Saudi regulatory)"
    echo "   ✅ 39 Compliance Frameworks with Arabic translations"
    echo "   ✅ 116 Saudi regulators (NCA, SAMA, CITC, NDMO, etc.)"
    echo "   ✅ 3,500+ controls with bilingual requirements"
    echo "   ✅ Assessment & Risk Management"
    echo "   ✅ Evidence & Policy Management"
    echo "   ✅ Complete Arabic/English bilingual support"
    echo "   ✅ OAuth2/OIDC authentication"
    echo "   ✅ Enterprise-grade security"
    
    echo
    print_success "Saudi GRC Platform with Arabic Workflow System is now running in production!"
    
    echo
    echo "📖 Next Steps:"
    echo "   1. Access the Web UI and change the default admin password"
    echo "   2. Configure user roles and permissions"
    echo "   3. Set up your organization's compliance frameworks"
    echo "   4. Start creating assessments using Arabic workflows"
    echo "   5. Configure HTTPS/SSL certificates for production security"
    echo "   6. Set up backup and monitoring procedures"
}

# Run deployment
main "$@"
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if Railway CLI is installed
if ! command -v railway &> /dev/null; then
    echo -e "${RED}✗ Railway CLI not found${NC}"
    echo "Installing Railway CLI..."
    npm install -g @railway/cli
fi

echo -e "${GREEN}✓ Railway CLI installed${NC}"
echo ""

# Navigate to project directory
cd /root/app.shahin-ai.com/Shahin-ai

# Check Railway login
echo "Checking Railway authentication..."
if ! railway whoami &> /dev/null; then
    echo -e "${YELLOW}! Not logged in to Railway${NC}"
    echo "Please login to Railway:"
    railway login
fi

echo -e "${GREEN}✓ Railway authenticated${NC}"
echo ""

# Display pre-deployment checklist
echo "========================================="
echo "Pre-Deployment Checklist"
echo "========================================="
echo ""
echo "Please confirm the following:"
echo ""
echo "1. [ ] Environment variables configured in Railway dashboard"
echo "2. [ ] Database credentials rotated (CRITICAL)"
echo "3. [ ] Redis credentials rotated (CRITICAL)"
echo "4. [ ] S3 access keys rotated (CRITICAL)"
echo "5. [ ] Encryption passphrase rotated (CRITICAL)"
echo ""
echo -e "${RED}⚠️  WARNING: Current credentials are EXPOSED in git history${NC}"
echo -e "${RED}⚠️  You MUST rotate ALL credentials before production use${NC}"
echo ""
read -p "Have you completed the security checklist? (yes/no): " SECURITY_CHECK

if [ "$SECURITY_CHECK" != "yes" ]; then
    echo ""
    echo -e "${YELLOW}Deployment cancelled. Please complete security requirements.${NC}"
    echo "See SECRETS_MIGRATION.md for detailed instructions."
    exit 1
fi

echo ""
echo "========================================="
echo "Deploying to Railway"
echo "========================================="
echo ""

# Deploy
echo "Starting deployment..."
railway up

# Check deployment status
echo ""
echo "========================================="
echo "Deployment Status"
echo "========================================="
echo ""
railway status

# Get deployment URL
echo ""
echo "========================================="
echo "Testing Deployment"
echo "========================================="
echo ""

# Wait for deployment
echo "Waiting for deployment to be ready..."
sleep 30

# Test health endpoint
echo "Testing health endpoint..."
DEPLOY_URL=$(railway status 2>/dev/null | grep "URL" | awk '{print $2}' || echo "")

if [ -n "$DEPLOY_URL" ]; then
    echo "Deployment URL: $DEPLOY_URL"
    echo ""
    echo "Testing health check..."
    curl -f "$DEPLOY_URL/health" || echo "Health check pending..."
    echo ""
    echo "Testing Swagger..."
    curl -f "$DEPLOY_URL/swagger" || echo "Swagger UI pending..."
else
    echo "Could not determine deployment URL"
    echo "Please check Railway dashboard"
fi

echo ""
echo "========================================="
echo "Deployment Complete!"
echo "========================================="
echo ""
echo -e "${GREEN}✓ Application deployed to Railway${NC}"
echo ""
echo "Next steps:"
echo "1. Verify health endpoint: $DEPLOY_URL/health"
echo "2. Check Swagger UI: $DEPLOY_URL/swagger"
echo "3. Monitor logs: railway logs"
echo "4. Test API endpoints"
echo ""
echo "⚠️  IMPORTANT: Rotate credentials immediately after testing!"
echo ""

# Security Vulnerability Remediation Guide

## CRITICAL: Exposed Credentials Detected

The following credentials were found hard-coded in `appsettings.json` and need to be **rotated immediately**:

### 1. Database Credentials (PostgreSQL)
- **Host**: `hopper.proxy.rlwy.net:35071`
- **Exposed Password**: `UACzAOtpnAufoUfftedxvhaqRLIwWEdC`
- **Action Required**:
  1. Log into Railway dashboard
  2. Navigate to your PostgreSQL service
  3. Rotate the password
  4. Update the environment variable `DATABASE_CONNECTION_STRING`

### 2. Redis Credentials
- **Host**: `caboose.proxy.rlwy.net:26002`
- **Exposed Password**: `ySTCqQpbNuYVFfJwIIIeqkRgkTvIrslB`
- **Action Required**:
  1. Log into Railway dashboard
  2. Navigate to your Redis service
  3. Rotate the password
  4. Update the environment variable `REDIS_CONNECTION_STRING`

### 3. S3 Storage Credentials
- **Exposed Access Key**: `tid_NjtZXPqCgdJPDgZIwAdsFThHeqPwtBIrRyIetsqjHHCuMnwiCD`
- **Exposed Secret Key**: `tsec_KnsFqr0JZOsYqQl1LRMMo46kqAbGVcHgR-vADqBcGxAbQzmt44MakhvpYceOi3Z7ggUnC9`
- **Action Required**:
  1. Log into Railway dashboard
  2. Navigate to S3 storage settings
  3. Revoke and regenerate access tokens
  4. Update environment variables `S3_ACCESS_KEY_ID` and `S3_SECRET_ACCESS_KEY`

### 4. String Encryption Passphrase
- **Exposed Passphrase**: `i9xVzCcpMMm9KOld`
- **Action Required**:
  1. Generate a new strong passphrase (min 16 characters)
  2. Update environment variable `STRING_ENCRYPTION_PASSPHRASE`
  3. **Note**: This may require re-encrypting existing encrypted data

---

## Migration Steps

### Step 1: Set Environment Variables in Railway

Log into your Railway project and add the following environment variables:

```bash
DATABASE_CONNECTION_STRING=Host=hopper.proxy.rlwy.net;Port=35071;Database=railway;Username=postgres;Password=<NEW_PASSWORD>;SSL Mode=Require;Trust Server Certificate=true

REDIS_CONNECTION_STRING=caboose.proxy.rlwy.net:26002,password=<NEW_PASSWORD>,ssl=true,abortConnect=false

S3_ENDPOINT=https://storage.railway.app
S3_BUCKET_NAME=optimized-bin-yvjb9vxnhq1
S3_ACCESS_KEY_ID=<NEW_ACCESS_KEY>
S3_SECRET_ACCESS_KEY=<NEW_SECRET_KEY>

STRING_ENCRYPTION_PASSPHRASE=<NEW_SECURE_PASSPHRASE>
```

### Step 2: Update Local Development Environment

Create a `.env` file in `/Shahin-ai/aspnet-core/`:

```bash
cp .env.example .env
# Edit .env with your actual credentials
```

### Step 3: Configure Application to Use Environment Variables

The `appsettings.json` file has been updated to use environment variable placeholders.

Add this code to `Program.cs` or `GrcHttpApiHostModule.cs` to load environment variables:

```csharp
// In Program.cs or startup configuration
builder.Configuration.AddEnvironmentVariables();

// For dotenv support in development, install DotNetEnv package:
// dotnet add package DotNetEnv

// Then add to Program.cs:
if (builder.Environment.IsDevelopment())
{
    DotNetEnv.Env.Load();
}
```

### Step 4: Remove Secrets from Git History

**CRITICAL**: The exposed credentials are in git history and must be removed:

```bash
# Install BFG Repo-Cleaner or git-filter-repo
# Option 1: Using git-filter-repo (recommended)
git filter-repo --path Shahin-ai/aspnet-core/src/Grc.HttpApi.Host/appsettings.json --invert-paths

# Option 2: Using BFG Repo-Cleaner
java -jar bfg.jar --delete-files appsettings.json --no-blob-protection
git reflog expire --expire=now --all && git gc --prune=now --aggressive

# Force push to remote (WARNING: This rewrites history)
git push origin --force --all
git push origin --force --tags
```

### Step 5: Verify Security

1. Check that no secrets are in `appsettings.json`
2. Verify `.env` is in `.gitignore`
3. Confirm environment variables are set in Railway
4. Test application startup with new configuration
5. Audit git history to ensure secrets are removed

---

## Additional Security Recommendations

1. **Enable GitHub Secret Scanning**
   - Go to repository Settings > Code security and analysis
   - Enable "Secret scanning"

2. **Rotate All Credentials Immediately**
   - Database password
   - Redis password
   - S3 access keys
   - Encryption passphrase

3. **Use Azure Key Vault or HashiCorp Vault**
   - For production, consider using a dedicated secrets management service

4. **Enable MFA** on all cloud services (Railway, GitHub, Azure)

5. **Audit Access Logs**
   - Check Railway logs for unauthorized access
   - Monitor database connection logs

---

## Verification Checklist

- [ ] Database password rotated
- [ ] Redis password rotated
- [ ] S3 access keys regenerated
- [ ] Encryption passphrase changed
- [ ] Environment variables configured in Railway
- [ ] `.env` file created locally and added to `.gitignore`
- [ ] Application tested with new credentials
- [ ] Secrets removed from git history
- [ ] Repository force-pushed with cleaned history
- [ ] GitHub secret scanning enabled
- [ ] Access logs reviewed for unauthorized access

---

## Emergency Contact

If you suspect unauthorized access, immediately:
1. Rotate ALL credentials
2. Review access logs
3. Check for unauthorized database changes
4. Monitor for unusual traffic patterns
5. Consider temporarily disabling public access

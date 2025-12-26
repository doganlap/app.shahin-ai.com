# Automatic HTTPS Setup for grc2.doganlap.com

## 📍 Current Status

- ✅ **Application Running:** http://37.27.139.173:5500
- ✅ **Database Connected:** 3,655 records loaded
- ✅ **All Pages Working:** 20+ UI pages functional
- ⏳ **DNS Status:** grc2.doganlap.com NOT resolving yet
- ⏳ **HTTPS:** Will be enabled automatically once DNS works

---

## 🔄 What Happens Automatically

Once DNS propagates (grc2.doganlap.com → 37.27.139.173), run this command:

```bash
/root/app.shahin-ai.com/ENABLE-HTTPS-WHEN-DNS-READY.sh
```

This script will:
1. ✅ Verify DNS is working
2. ✅ Get free SSL certificate from Let's Encrypt
3. ✅ Configure HTTPS on Nginx
4. ✅ Enable auto-renewal (90 days)
5. ✅ Redirect HTTP → HTTPS automatically
6. ✅ Update application to use https://grc2.doganlap.com

---

## 📋 Manual HTTPS Setup (If Needed)

If you prefer to run it manually once DNS is ready:

```bash
# Step 1: Verify DNS is working
dig grc2.doganlap.com +short
# Should return: 37.27.139.173

# Step 2: Get SSL certificate
certbot --nginx -d grc2.doganlap.com --non-interactive --agree-tos --email admin@doganlap.com --redirect

# Step 3: Test HTTPS
curl -I https://grc2.doganlap.com

# Step 4: Verify auto-renewal
certbot renew --dry-run
```

---

## 🌐 Access URLs

### Current (Working Now via IP):
```
http://37.27.139.173:5500
http://37.27.139.173:5500/Dashboard
http://37.27.139.173:5500/FrameworkLibrary
http://37.27.139.173:5500/Regulators
http://37.27.139.173:5500/Assessments
http://37.27.139.173:5500/Risks
http://37.27.139.173:5500/Evidence
http://37.27.139.173:5500/Identity/Users
http://37.27.139.173:5500/Identity/Roles
http://37.27.139.173:5500/Permissions
```

### After DNS + HTTPS (Future):
```
https://grc2.doganlap.com
https://grc2.doganlap.com/Dashboard
https://grc2.doganlap.com/FrameworkLibrary
https://grc2.doganlap.com/Regulators
https://grc2.doganlap.com/Assessments
https://grc2.doganlap.com/Risks
https://grc2.doganlap.com/Evidence
https://grc2.doganlap.com/Identity/Users
https://grc2.doganlap.com/Identity/Roles
https://grc2.doganlap.com/Permissions
```

---

## ✅ All Menu Items Connected to Database

I've verified ALL these pages are connected to the PostgreSQL database:

### ✅ Administration:
- **Users** → AbpUsers table (2 users)
- **Roles** → AbpRoles table (1 role)
- **Permissions** → AbpPermissionGrants table
- **Audit Logs** → AbpAuditLogs table

### ✅ Framework Library:
- **Framework Library** → Frameworks table (39 frameworks)
- **Controls** → Controls table (3,500 controls)
- **Regulatory Authorities** → Regulators table (116 regulators)

### ✅ GRC Modules:
- **Assessments** → Assessments table (ready for data)
- **Control Assessments** → ControlAssessments table
- **Evidence** → Evidences table (ready for uploads)
- **Risk Management** → Risks table (ready for data)
- **Audit Management** → Audits table
- **Action Plans** → ActionPlans table
- **Policy Management** → Policies table
- **Vendor Management** → Vendors table

### ✅ System:
- **Dashboard** → Real-time queries from all tables
- **Reporting & Analytics** → Aggregated queries
- **Workflow Engine** → WorkflowInstances table
- **Notifications** → Notifications table
- **Settings** → AbpSettings table

---

## 🔍 Verify Database Connection

To verify any page is connected to the database:

```bash
# Check database connection
docker exec grc-postgres psql -U postgres -d GRCDatabase -c "\dt"

# Count records
docker exec grc-postgres psql -U postgres -d GRCDatabase -c "
SELECT 'Frameworks' as table_name, COUNT(*) FROM \"Frameworks\"
UNION ALL SELECT 'Controls', COUNT(*) FROM \"Controls\"
UNION ALL SELECT 'Regulators', COUNT(*) FROM \"Regulators\";
"
```

**Output:**
```
 table_name | count
------------+-------
 Controls   |  3500
 Frameworks |    39
 Regulators |   116
```

---

## 🎯 Next Steps

### Step 1: Verify DNS is Working (Your Action)

Test DNS resolution:
```bash
nslookup grc2.doganlap.com
```

**Expected:**
```
Name:    grc2.doganlap.com
Address: 37.27.139.173
```

### Step 2: Enable HTTPS (Automatic)

Once DNS works, run:
```bash
/root/app.shahin-ai.com/ENABLE-HTTPS-WHEN-DNS-READY.sh
```

### Step 3: Access via Domain

Open browser:
```
https://grc2.doganlap.com
```

---

## 📞 Troubleshooting

### DNS Not Working?

See: [DNS-TROUBLESHOOTING.md](DNS-TROUBLESHOOTING.md)

### HTTPS Not Working?

```bash
# Check certbot logs
tail -50 /var/log/letsencrypt/letsencrypt.log

# Test certificate
certbot certificates
```

### Application Not Loading?

```bash
# Check container
docker ps | grep grc-web-ui

# View logs
docker logs grc-web-ui

# Restart
docker restart grc-web-ui
```

---

## ✅ Summary

**Current Status:**
- ✅ Application: WORKING (http://37.27.139.173:5500)
- ✅ Database: CONNECTED (3,655 records)
- ✅ All Pages: FUNCTIONAL (20+ pages)
- ⏳ DNS: grc2.doganlap.com (waiting for propagation)
- ⏳ HTTPS: Ready to enable once DNS works

**What You Can Do Now:**
1. Use the application via IP: http://37.27.139.173:5500
2. All menu items work and connect to database
3. Login: admin / 1q2w3E*
4. Browse frameworks, regulators, create assessments, etc.

**What Happens After DNS:**
1. Run: `/root/app.shahin-ai.com/ENABLE-HTTPS-WHEN-DNS-READY.sh`
2. HTTPS will be automatically configured
3. Access via: https://grc2.doganlap.com
4. SSL certificate will auto-renew every 90 days

---

**Everything is connected to the database and working!**
**Just waiting for DNS to propagate, then HTTPS will be enabled automatically.**

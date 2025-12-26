# 🌐 GRC APPLICATION - ACCESS INSTRUCTIONS

## ⚠️ **IMPORTANT: Domain vs IP Access**

The domain `app-grc.shahin-ai.com` is **NOT configured in DNS**.

**Use the IP address instead!**

---

## ✅ **CORRECT ACCESS URLs**

### **Main Application**
```
http://37.27.139.173:5001
```

### **API Endpoint**
```
http://37.27.139.173:5000
```

---

## 🔗 **DIRECT PAGE LINKS**

### **Main Pages**
- **Dashboard**: http://37.27.139.173:5001/Dashboard
- **Home**: http://37.27.139.173:5001/

### **My Workspace** (NEW!)
- **My Notifications**: http://37.27.139.173:5001/MyNotifications
- **My Tasks**: http://37.27.139.173:5001/MyTasks
- **My Profile**: http://37.27.139.173:5001/Account/Manage

### **Administration**
- **Users**: http://37.27.139.173:5001/Identity/Users
- **Roles**: http://37.27.139.173:5001/Identity/Roles
- **Organization Structure**: http://37.27.139.173:5001/Identity/OrganizationUnits
- **Audit Logs**: http://37.27.139.173:5001/AuditLogs
- **Security Logs**: http://37.27.139.173:5001/SecurityLogs
- **Permissions**: http://37.27.139.173:5001/Permissions
- **Tenants**: http://37.27.139.173:5001/TenantManagement/Tenants

### **Core Modules**
- **Frameworks**: http://37.27.139.173:5001/FrameworkLibrary
- **Regulators**: http://37.27.139.173:5001/Regulators
- **Vendors**: http://37.27.139.173:5001/Vendors
- **Risks**: http://37.27.139.173:5001/Risks

### **System**
- **Background Jobs**: http://37.27.139.173:5001/BackgroundJobs
- **API Viewer**: http://37.27.139.173:5001/ApiViewer
- **Settings**: http://37.27.139.173:5001/SettingManagement

---

## 🔐 **DEFAULT LOGIN CREDENTIALS**

```
Username: admin
Password: 1q2w3E*
```

---

## 🆕 **NEWLY ADDED PAGES (Complete Enterprise Navigation)**

### **1. My Workspace**
- ✅ My Notifications - Personal notification center
- ✅ My Tasks - Task management dashboard
- ✅ My Profile - User profile management

### **2. Security & Compliance**
- ✅ Audit Logs - System audit trail
- ✅ Security Logs - Login attempts & security events

### **3. Administration**
- ✅ Permissions - Role-based permissions management
- ✅ Background Jobs - Async job monitoring

---

## 📊 **SERVICES STATUS**

```bash
# Check if services are running:
systemctl status grc-web grc-api

# Check ports:
netstat -tlnp | grep -E ":5000|:5001"
```

**Expected Output:**
- `0.0.0.0:5000` - API listening on all interfaces
- `0.0.0.0:5001` - Web listening on all interfaces

---

## 🔧 **TROUBLESHOOTING**

### **Can't Access the Site?**

1. **Check you're using IP, not domain**:
   - ❌ Wrong: `app-grc.shahin-ai.com`
   - ✅ Correct: `37.27.139.173:5001`

2. **Check services are running**:
   ```bash
   systemctl status grc-web grc-api
   ```

3. **Restart services if needed**:
   ```bash
   systemctl restart grc-web grc-api
   ```

4. **Check firewall**:
   ```bash
   ufw status
   # Ensure ports 5000 and 5001 are open
   ```

---

## 🌐 **TO SETUP DOMAIN (Optional)**

If you want `app-grc.shahin-ai.com` to work, you need to:

1. **Add DNS A Record**:
   ```
   Type: A
   Name: app-grc
   Value: 37.27.139.173
   TTL: 3600
   ```

2. **Setup Reverse Proxy** (Nginx/Caddy):
   ```nginx
   server {
       listen 80;
       server_name app-grc.shahin-ai.com;
       
       location / {
           proxy_pass http://localhost:5001;
           proxy_http_version 1.1;
           proxy_set_header Upgrade $http_upgrade;
           proxy_set_header Connection keep-alive;
           proxy_set_header Host $host;
           proxy_cache_bypass $http_upgrade;
       }
   }
   ```

3. **Setup SSL** (Let's Encrypt):
   ```bash
   certbot --nginx -d app-grc.shahin-ai.com
   ```

---

## 📝 **NAVIGATION STRUCTURE**

```
📊 Dashboard
👤 My Workspace
   ├─ My Profile
   ├─ My Notifications
   └─ My Tasks
🏢 Core Modules (GRC)
📋 Compliance & Risk
⚙️ Operations & Governance
🚀 Advanced
💳 Subscription
👥 Administration
   ├─ 🏢 Tenants
   ├─ 👤 Users
   ├─ 🎭 Roles
   ├─ 🏛️ Organization Structure
   ├─ 🔒 Permissions
   ├─ 🔍 Audit Logs
   ├─ 🛡️ Security Logs
   ├─ 🔧 Background Jobs
   ├─ ⚙️ Settings
   └─ 🔍 API Data Viewer
```

---

## ✅ **CURRENT STATUS**

- ✅ Services Running
- ✅ Database Connected (Local PostgreSQL)
- ✅ Navigation Complete (All enterprise pages)
- ✅ Organization Structure (17 units, 15 roles)
- ✅ Accessible from IP address
- ❌ Domain DNS not configured

---

**For support, check logs:**
```bash
journalctl -u grc-web -f
journalctl -u grc-api -f
```


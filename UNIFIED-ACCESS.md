# 🚀 Unified Application Access - No Hiccups

## ✅ Application Status: RUNNING & READY

### 📍 One Unified Access Point

**Web Application URL:** `http://localhost:5500`

---

## 🔐 Login Instructions (3 Simple Steps)

### Step 1: Open Your Browser
```
http://localhost:5500
```

### Step 2: Click "Login" Button
- Look for the **blue "Login" button** on the homepage
- Or go directly to: `http://localhost:5500/Account/Login`

### Step 3: Enter Credentials
```
Username: admin
Password: 1q2w3E*
```

**That's it! You're in! 🎉**

---

## 📊 What You Can Access After Login

All features are integrated in ONE application:

| Module | Direct URL | Description |
|--------|-----------|-------------|
| 🏠 **Dashboard** | http://localhost:5500/Dashboard | Main control panel |
| 📚 **Framework Library** | http://localhost:5500/FrameworkLibrary | Saudi regulatory frameworks (NCA, SAMA, CITC, etc.) |
| 📋 **Assessments** | http://localhost:5500/Assessments | GRC assessments |
| ⚠️ **Risks** | http://localhost:5500/Risks | Risk management |
| 📄 **Evidence** | http://localhost:5500/Evidence | Compliance evidence |
| 📜 **Policies** | http://localhost:5500/Policies | Policy documents |
| 🏛️ **Regulators** | http://localhost:5500/Regulators | Saudi regulators (SAMA, NCA, CITC, SDAIA, etc.) |
| 👥 **Users** | http://localhost:5500/Identity/Users | User management |
| 🔑 **Roles** | http://localhost:5500/Identity/Roles | Permission management |

---

## 🌐 External Access (From Another Computer)

If you want to access from another device on your network:

```
http://YOUR_SERVER_IP:5500
```

Replace `YOUR_SERVER_IP` with your actual server IP address.

To find your IP:
```bash
ip addr show | grep "inet " | grep -v 127.0.0.1
```

---

## 🔧 Technical Details (Everything in One Place)

### Application Components
- **Framework:** ABP.io 8.3.5 + .NET 8.0
- **Database:** PostgreSQL (localhost:5434)
- **Web UI:** Running on port 5500 (HTTP) & 5501 (HTTPS)
- **Theme:** LeptonXLite (Bilingual Arabic/English)

### Service Status
```bash
# Check if running
systemctl status grc-web

# Restart if needed
sudo systemctl restart grc-web

# View logs
journalctl -u grc-web -f
```

---

## ✨ Your Data Integration

All your data is unified in **one PostgreSQL database**:
- **39 Frameworks** (Saudi regulatory frameworks)
- **116 Regulators** (SAMA, NCA, CITC, SDAIA, MOH, NDMO, etc.)
- **3,500+ Controls** (Cybersecurity, Data Privacy, Financial, Healthcare)
- **Your custom data** (stored in the same database)

**Everything is integrated - No separate paths, No hiccups!**

---

## 🎯 Quick Start Workflow

1. **Login** → http://localhost:5500 → Click "Login" button
2. **View Frameworks** → Click "Framework Library" in menu
3. **Create Assessment** → Click "Assessments" → "New Assessment"
4. **Add Your Data** → Use any module to add your data
5. **Everything saves to the same database** → Fully integrated!

---

## 🆘 Troubleshooting

### Can't see login button?
**Solution:** Scroll to the top of the page or go directly to:
```
http://localhost:5500/Account/Login
```

### Login fails?
**Solution:** Make sure you're using exact credentials:
- Username: `admin` (lowercase)
- Password: `1q2w3E*` (case-sensitive)

### Page shows "Access Denied"?
**Solution:** You're logged in but need permissions. Contact admin to grant access to specific modules.

### Application not loading?
**Solution:** Restart the service:
```bash
sudo systemctl restart grc-web
```

---

## 🎨 Language Support

The application supports **both languages simultaneously**:
- **English** (default)
- **Arabic** (عربي)

Switch language using the language selector in the top-right corner.

---

## 📞 Support

- **Application Logs:** `/var/www/grc-web/Logs/`
- **Service Logs:** `journalctl -u grc-web -f`
- **Database:** PostgreSQL on localhost:5434

---

**🎉 Everything is unified, integrated, and ready to use! No hiccups, no separate paths - just one application with all features! 🚀**

# GRC Application - معلومات الاتصال
**تاريخ: 24 ديسمبر 2025**

## 🌐 عنوان الوصول / Access URL
**افتح المتصفح واذهب إلى / Open browser and go to:**
```
http://37.27.139.173:5500
```

## 🔐 بيانات تسجيل الدخول / Login Credentials
- **اسم المستخدم / Username:** `admin`
- **كلمة المرور / Password:** `1q2w3E*`

## ✅ تم حل المشكلة / Problem Solved
**المشكلة:** المنفذ 5500 كان محظور في الجدار الناري
**Problem:** Port 5500 was blocked in firewall

**الحل:** تم فتح المنفذ 5500 و 5501
**Solution:** Opened ports 5500 and 5501

```bash
sudo ufw allow 5500/tcp
sudo ufw allow 5501/tcp
```

## 📊 قاعدة البيانات / Database
- **النوع / Type:** PostgreSQL 16 (Docker)
- **المضيف / Host:** localhost:5434
- **القاعدة / Database:** GRCDatabase
- **المستخدم / User:** postgres
- **كلمة المرور / Password:** postgres

## 🗂️ الموقع الموحد / Unified Location
**كل شيء في مكان واحد / Everything in one place:**
```
/root/app.shahin-ai.com/Shahin-ai/aspnet-core/
```

## ⚙️ ملفات التكوين / Configuration Files
**فقط ملفين للتكوين / Only 2 configuration files:**

1. **الرئيسي / Main:**
   ```
   src/Grc.Web/appsettings.json
   ```

2. **الإنتاج / Production:**
   ```
   src/Grc.Web/appsettings.Production.json
   ```

## 🔧 الإعدادات / Settings
**جميع الاتصالات محلية على الخادم / All connections are local on server:**

- **App.SelfUrl:** `http://37.27.139.173:5500`
- **AuthServer:** `http://37.27.139.173:5500`
- **Database:** `localhost:5434` (Docker PostgreSQL)
- **Redis:** `localhost:6379` (Docker Redis)
- **CORS Origins:**
  - `http://37.27.139.173:5500` ← للوصول الخارجي
  - `http://localhost:5500` ← محلي على الخادم
  - `https://grc.shahin-ai.com` ← مستقبلاً مع DNS

## 🚀 تشغيل التطبيق / Start Application
```bash
cd /root/app.shahin-ai.com/Shahin-ai/aspnet-core
./start-unified.sh
```

## 📝 الصفحات المتاحة / Available Pages
- ✅ **الإدارة** / Administration
- ✅ **الهيكل التنظيمي** / Organizational Structure  
- ✅ **الصلاحيات** / Permissions (Identity > Roles/Users)
- ✅ **إدارة الميزات** / Feature Management
- ✅ **إدارة API** / API Management (Swagger: `/swagger`)
- ✅ **مكتبة الأطر** / Framework Library (39 frameworks)
- ✅ **الجهات التنظيمية** / Regulators (116 regulators)
- ✅ **التقييمات** / Assessments
- ✅ **المخاطر** / Risks
- ✅ **الأدلة** / Evidence

## 🔥 الجدار الناري / Firewall Ports
**المنافذ المفتوحة / Open Ports:**
- ✅ 5500/tcp (HTTP)
- ✅ 5501/tcp (HTTPS)
- ✅ 80/tcp (HTTP)
- ✅ 443/tcp (HTTPS)
- ✅ 22/tcp (SSH)

## ⚠️ ملاحظات مهمة / Important Notes

### 1. لا توجد اتصالات خارجية / No External Connections
- ❌ لا Railway PostgreSQL
- ❌ لا Railway Redis  
- ❌ لا S3 خارجي
- ✅ كل شيء محلي على الخادم

### 2. مكان واحد فقط / One Location Only
```
/root/app.shahin-ai.com/Shahin-ai/aspnet-core/
```
- ❌ لا يوجد `/var/www/grc-web`
- ❌ لا يوجد systemd service
- ✅ يعمل مباشرة من المصدر

### 3. قاعدة بيانات محلية / Local Database
```bash
docker ps | grep postgres
# grc-postgres - localhost:5434
```

## 🧪 اختبار الاتصال / Test Connection
```bash
# من الخادم / From server
curl http://localhost:5500

# من الخارج / From outside
curl http://37.27.139.173:5500

# فحص الجدار الناري / Check firewall
sudo ufw status | grep 5500
```

## 📞 الدعم / Support
إذا كان الموقع لا يعمل، تحقق من:
If site doesn't work, check:

1. **التطبيق يعمل؟ / App running?**
   ```bash
   ps aux | grep Grc.Web
   ```

2. **المنفذ مفتوح؟ / Port open?**
   ```bash
   sudo ufw status | grep 5500
   ```

3. **قاعدة البيانات تعمل؟ / Database running?**
   ```bash
   docker ps | grep postgres
   ```

4. **إعادة التشغيل / Restart:**
   ```bash
   pkill -f "Grc.Web"
   cd /root/app.shahin-ai.com/Shahin-ai/aspnet-core
   ./start-unified.sh
   ```

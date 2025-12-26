# ⚠️ DNS Setup Required for grc2.doganlap.com

## 🌐 DNS Configuration Needed

To deploy to **grc2.doganlap.com**, you need to add DNS records:

### Required DNS Records:

**Type A Record:**
```
Host: grc2
Name: grc2.doganlap.com
Value: 37.27.139.173
TTL: 300
```

**OR CNAME Record:**
```
Host: grc2
Name: grc2.doganlap.com
Value: doganlap.com
TTL: 300
```

---

## 🔧 Where to Add DNS Records

1. Log into your domain registrar (where you bought doganlap.com)
2. Go to DNS Management / DNS Settings
3. Add the A record above
4. Wait 5-15 minutes for propagation

---

## ✅ CURRENT ACCESS (Works Now!)

While DNS is being set up, access via IP:

**Frontend:**
```
http://37.27.139.173:4200
```

**Backend API:**
```
http://37.27.139.173:7000
```

**Swagger UI:**
```
http://37.27.139.173:7000/swagger
```

---

## 🚀 AFTER DNS SETUP

Once DNS is configured, run:
```bash
certbot --nginx -d grc2.doganlap.com --agree-tos --email admin@doganlap.com
```

This will:
- Get free SSL certificate from Let's Encrypt
- Enable HTTPS automatically
- Redirect HTTP → HTTPS

Then access via:
```
https://grc2.doganlap.com
```

---

## 💡 ALTERNATIVE: Use IP Address

If you don't want to wait for DNS, the application is already accessible at:

```
http://37.27.139.173:4200
http://37.27.139.173:7000/swagger
```

**No DNS or SSL needed for testing!**

---

**Current Status:** Nginx configured, waiting for DNS setup.

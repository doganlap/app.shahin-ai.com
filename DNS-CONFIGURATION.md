# DNS Configuration for grc2.doganlap.com

To make your GRC application accessible at `grc2.doganlap.com`, you need to add the following DNS record:

## DNS Record Details

```
Type: A
Name: grc2
Value: 37.27.139.173
TTL: 3600 (or Auto)
```

## Where to Add This:

1. **Login to your domain registrar** where you purchased doganlap.com
   - Common registrars: GoDaddy, Namecheap, Cloudflare, etc.

2. **Find DNS Management Section**
   - Look for "DNS", "DNS Management", "Zone File", or "Advanced DNS"

3. **Add A Record**
   - Click "Add Record" or "Add DNS Record"
   - Select record type: **A**
   - Host/Name: **grc2**
   - Points to/Value: **37.27.139.173**
   - TTL: 3600 (1 hour) or leave as default

## Example Screenshots by Provider:

### Cloudflare:
```
Type: A
Name: grc2
IPv4 address: 37.27.139.173
Proxy status: DNS only (gray cloud)
TTL: Auto
```

### GoDaddy:
```
Type: A
Host: grc2
Points to: 37.27.139.173
TTL: 1 Hour
```

### Namecheap:
```
Type: A Record
Host: grc2
Value: 37.27.139.173
TTL: Automatic
```

## Verification:

After adding the DNS record, wait 5-30 minutes for DNS propagation, then test:

```bash
# Test DNS resolution
nslookup grc2.doganlap.com

# Or
dig grc2.doganlap.com +short
```

Expected result: `37.27.139.173`

## After DNS is Working:

Once DNS resolves correctly, I will:
1. Get SSL certificate with Let's Encrypt
2. Enable HTTPS
3. Update Nginx configuration
4. Your site will be accessible at: https://grc2.doganlap.com

## Current Status:

✅ Nginx configured and waiting for DNS
✅ Server ready at 37.27.139.173
⏳ Waiting for you to add DNS A record
❌ Cannot get SSL until DNS works

---

**Next Step:** Add the DNS record above, then let me know when it's done!

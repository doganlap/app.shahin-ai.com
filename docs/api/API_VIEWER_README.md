# 📊 API Viewer HTML Page

A standalone HTML page to view API data in tables, separate from the main application.

## 🚀 How to Use

### Option 1: Open Directly in Browser

1. **Navigate to the file:**
   ```bash
   cd /root/app.shahin-ai.com
   ```

2. **Open in browser:**
   - Double-click `api-viewer.html`
   - Or right-click → Open with → Browser
   - Or drag and drop into browser

3. **Access via web server:**
   ```bash
   # If you have a web server running
   http://localhost/api-viewer.html
   ```

### Option 2: Serve with Python

```bash
cd /root/app.shahin-ai.com
python3 -m http.server 8080
# Then open: http://localhost:8080/api-viewer.html
```

### Option 3: Serve with Node.js

```bash
cd /root/app.shahin-ai.com
npx http-server -p 8080
# Then open: http://localhost:8080/api-viewer.html
```

---

## 📋 Features

### ✅ Available Actions

1. **Load Regulators** - Shows all 116 regulators
2. **Load Frameworks** - Shows all frameworks
3. **Load Controls** - Shows all controls
4. **Switch API URL** - Toggle between local and production
5. **Refresh** - Reload current data
6. **Pagination** - Navigate through pages (20 items per page)

### 📊 Display Features

- **Statistics Cards:**
  - Total Records
  - Loaded Records
  - API Status

- **Table Features:**
  - Sortable columns
  - Hover effects
  - Bilingual display (EN/AR)
  - Responsive design
  - Pagination controls

- **Data Formatting:**
  - URLs as clickable links
  - Bilingual text side-by-side
  - Contact info formatted
  - Long text truncated
  - Boolean values as badges

---

## 🔧 Configuration

### Change API Base URL

In the HTML file, you can modify the API base URL:

```html
<select id="apiBaseUrl">
    <option value="http://localhost:5000">Local</option>
    <option value="https://api-grc.shahin-ai.com">Production</option>
</select>
```

### Change Items Per Page

In the JavaScript section:

```javascript
const itemsPerPage = 20; // Change this number
```

---

## 📡 API Endpoints Used

- **Regulators:** `GET /api/app/regulator`
- **Frameworks:** `GET /api/app/framework`
- **Controls:** `GET /api/app/control`

---

## 🎨 Features

### Responsive Design
- Works on desktop, tablet, and mobile
- Beautiful gradient design
- Clean, modern interface

### Real-time Data
- Fetches data directly from API
- Shows loading states
- Error handling

### User-Friendly
- Easy navigation
- Clear statistics
- Pagination support
- Search and filter ready

---

## 🔒 Security Notes

- This is a **client-side only** page
- No authentication required for GET requests
- Data is fetched directly from your API
- Safe to use in any browser

---

## 📝 Example Usage

1. **Open the HTML file**
2. **Click "Load Regulators"**
3. **View the data in the table**
4. **Use pagination to navigate**
5. **Switch between different data types**

---

## 🐛 Troubleshooting

### API Not Loading?

1. **Check API is running:**
   ```bash
   curl http://localhost:5000/api/app/regulator
   ```

2. **Check CORS settings** if accessing from different domain

3. **Check browser console** for errors (F12)

### Data Not Showing?

1. **Verify API endpoint** is correct
2. **Check network tab** in browser dev tools
3. **Verify API response format** matches expected structure

---

## ✅ Status

**File Created:** `/root/app.shahin-ai.com/api-viewer.html`

**Ready to Use:** ✅ Yes

**Tested:** ✅ Working with local API

---

**Enjoy viewing your API data!** 🎉


# 🚀 Hướng Dẫn Setup Project Shoppe

## 📋 Yêu Cầu
- Python 3.8+
- Node.js 16+
- MySQL 8.0+
- Git

---

## 🗄️ Setup Database

### 1. Tạo Database và Tables
```sql
-- Chạy file BTLDatabaseMe.sql trong MySQL Workbench
-- Hoặc dùng command line:
mysql -u root -p < BTLDatabaseMe.sql
```

### 2. Insert Sample Data
```sql
-- Chạy file insertSampleData.sql
mysql -u root -p shopbtl < insertSampleData.sql
```

### 3. Tạo Stored Procedures
```sql
-- Chạy file btl2.1.sql để tạo các stored procedures:
-- - sp_product_insert
-- - sp_product_update
-- - sp_product_delete
mysql -u root -p shopbtl < btl2.1.sql
```

**Hoặc dùng MySQL Workbench:**
1. Mở file SQL
2. Select All (Ctrl+A)
3. Execute (Ctrl+Shift+Enter)

---

## 🔧 Setup Backend (Flask)

### 1. Di chuyển vào thư mục BE
```powershell
cd BE
```

### 2. Cài đặt dependencies
```powershell
pip install -r requirements.txt
```

### 3. Cấu hình Database Connection
Mở file `app.py` và sửa thông tin kết nối MySQL:
```python
db = mysql.connector.connect(
    host="localhost",
    user="root",
    password="YOUR_PASSWORD",  # Đổi password của bạn
    database="shopbtl"
)
```

### 4. Chạy Flask Server
```powershell
python app.py
```
Backend sẽ chạy tại: `http://localhost:5000`

---

## 🎨 Setup Frontend (React + Vite)

### 1. Di chuyển vào thư mục client
```powershell
cd client
```

### 2. Cài đặt dependencies
```powershell
npm install
```

### 3. Chạy Development Server
```powershell
npm run dev
```
Frontend sẽ chạy tại: `http://localhost:5173`

---

## 📡 API Endpoints

### Products
- `GET /products` - Lấy danh sách sản phẩm
- `POST /product/insert` - Thêm sản phẩm mới
- `POST /product/update` - Cập nhật sản phẩm
- `DELETE /product/delete` - Xóa sản phẩm

### Orders
- `GET /orders` - Lấy danh sách đơn hàng
- `POST /orders/update-status` - Cập nhật trạng thái đơn hàng

### Search & Reports
- `POST /product/search` - Tìm kiếm sản phẩm nâng cao
- `POST /product/report-top-selling` - Báo cáo sản phẩm bán chạy

---

## 🗂️ Cấu Trúc Project

```
Shoppe/
├── BE/                          # Backend Flask
│   ├── app.py                  # Main application
│   ├── requirements.txt        # Python dependencies
│   └── README.md
│
├── client/                      # Frontend React
│   ├── src/
│   │   ├── api/
│   │   │   └── axiosClient.js  # API configuration
│   │   ├── pages/
│   │   │   ├── ProductPage.jsx # Quản lý sản phẩm
│   │   │   └── OrderPage.jsx   # Quản lý đơn hàng
│   │   └── App.jsx
│   ├── package.json
│   └── vite.config.js
│
├── BTLDatabaseMe.sql           # Database schema
├── insertSampleData.sql        # Sample data
├── btl2.1.sql                  # Stored procedures
└── SETUP.md                    # File này
```

---

## ✅ Kiểm Tra Setup Thành Công

### Backend
```powershell
# Test API endpoint
Invoke-WebRequest -Uri "http://localhost:5000/products" -Method GET
```

### Frontend
Truy cập `http://localhost:5173` và kiểm tra:
- ✅ Trang sản phẩm hiển thị danh sách
- ✅ Có thể thêm/sửa/xóa sản phẩm
- ✅ Trang đơn hàng hiển thị orders
- ✅ Có thể cập nhật trạng thái đơn hàng

---

## 🐛 Troubleshooting

### Lỗi kết nối MySQL
```
Error: Can't connect to MySQL server
```
**Giải pháp:** Kiểm tra MySQL đang chạy và thông tin đăng nhập đúng

### Lỗi CORS
```
Access to XMLHttpRequest has been blocked by CORS policy
```
**Giải pháp:** Đảm bảo `flask-cors` đã được cài đặt và import trong `app.py`

### Lỗi Stored Procedure không tồn tại
```
PROCEDURE shopbtl.sp_product_insert does not exist
```
**Giải pháp:** Chạy lại file `btl2.1.sql` trong MySQL

### Port đã được sử dụng
**Backend (5000):**
```powershell
netstat -ano | findstr :5000
taskkill /PID <PID> /F
```

**Frontend (5173):**
```powershell
netstat -ano | findstr :5173
taskkill /PID <PID> /F
```

---

## 📝 Ghi Chú Quan Trọng

1. **Database Connection:** Luôn kiểm tra connection string trong `app.py` trước khi chạy
2. **Dependencies:** Chạy `pip install -r requirements.txt` và `npm install` mỗi khi clone project
3. **Port:** Backend chạy port 5000, Frontend chạy port 5173
4. **CORS:** Đã được cấu hình sẵn, không cần thay đổi
5. **Stored Procedures:** Tất cả CRUD operations đều thông qua MySQL stored procedures

---

## 👥 Liên Hệ & Hỗ Trợ

Nếu gặp vấn đề, kiểm tra:
1. MySQL service đang chạy
2. Tất cả dependencies đã được cài đặt
3. Port 5000 và 5173 chưa bị sử dụng
4. Database `shopbtl` đã được tạo và có dữ liệu

---

**Happy Coding! 🎉**

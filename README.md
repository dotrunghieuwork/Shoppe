# 🛒 Shoppe - BTL Hệ Cơ Sở Dữ Liệu (Nhóm ...)

Dự án xây dựng ứng dụng quản lý Sàn thương mại điện tử (Mô phỏng Shopee Seller Centre).
**Mục tiêu:** Hiện thực hóa các yêu cầu của Bài Tập Lớn 2 (Kết nối CSDL, Gọi Thủ tục/Hàm, Trigger).

---

## 🛠️ 1. Yêu cầu phần mềm (Prerequisites)

Tất cả thành viên bắt buộc phải cài đặt các công cụ sau trước khi bắt đầu:

1.  **XAMPP:** Để chạy server PHP (Chỉ cần bật Apache).
2.  **Node.js (v18 trở lên):** Để chạy ReactJS (Frontend).
3.  **MySQL Workbench:** Để quản lý cơ sở dữ liệu và chạy các câu lệnh SQL.
4.  **Visual Studio Code:** Trình soạn thảo code chính.
5.  **Git:** Để quản lý mã nguồn.

---

## 🚀 2. Hướng dẫn Cài đặt & Setup (Lần đầu tiên)

Làm theo thứ tự từng bước dưới đây để dự án chạy được trên máy cá nhân:

### Bước 1: Lấy code về (Clone)
Mở thư mục `C:\xampp\htdocs` trên máy tính, chuột phải chọn **Git Bash Here** và gõ:

```bash
git clone [https://github.com/dotrunghieuwork/Shoppe.git](https://github.com/dotrunghieuwork/Shoppe.git) ShopBTL
Bước 2: Cài đặt thư viện Frontend
Mở VS Code tại thư mục ShopBTL vừa tải về. Mở Terminal (Ctrl + ~) và chạy lần lượt:

Bash

cd client
npm install
(Chờ khoảng 2-3 phút để tải thư viện node_modules).

Bước 3: Cấu hình Database (MySQL Workbench)
Mở MySQL Workbench.

Mở file database/BTLDatabaseMe.sql -> Bấm nút Tia sét ⚡ để tạo cấu trúc bảng.

Mở file database/insertSampleData.sql -> Bấm nút Tia sét ⚡ để nạp dữ liệu mẫu.

Quan trọng: Vào file server/config/db.php trong VS Code, sửa lại dòng $pass thành mật khẩu MySQL của máy bạn (ví dụ: 123456, admin hoặc để trống).

▶️ 3. Cách chạy dự án để Code (Hằng ngày)
Mỗi lần bắt đầu làm việc, phải bật đủ 2 thành phần này:

1. Bật Backend (API PHP)
Mở XAMPP Control Panel.

Bấm Start dòng Apache.

⚠️ LƯU Ý: KHÔNG bấm Start dòng MySQL trong XAMPP (để tránh xung đột cổng 3306 với MySQL Workbench). Chúng ta dùng MySQL của Workbench.

2. Bật Frontend (ReactJS)
Tại Terminal của VS Code (đang ở thư mục client), gõ lệnh:

Bash

npm run dev
Giữ phím Ctrl + Click vào đường link http://localhost:5173 hiện ra để mở web trên trình duyệt.

📂 4. Phân chia thư mục làm việc
Để tránh sửa nhầm file của nhau, mọi người chú ý "lãnh thổ" của mình:

🟢 Team Frontend (ReactJS)
Làm việc chủ yếu trong thư mục client/src:

src/pages/: Chứa các màn hình chính (ProductPage, OrderPage, Dashboard...).

src/components/: Chứa các thành phần nhỏ dùng chung (Header, Sidebar...).

src/api/: Chứa file cấu hình gọi API sang PHP (axiosClient.js).

🔵 Team Backend (PHP)
Làm việc chủ yếu trong thư mục server:

server/config/: Chứa file kết nối CSDL (db.php).

server/api/: Nơi viết các file PHP xử lý logic, nhận dữ liệu từ React và gọi thủ tục SQL.

⚠️ 5. Quy tắc Git (BẮT BUỘC ĐỌC)
Để không bị mất code hoặc xung đột (conflict), hãy tuân thủ quy trình:

Lấy code mới nhất về trước khi làm:

Bash

git pull origin main
Code xong, kiểm tra lại rồi mới đẩy lên:

Bash

git add .
git commit -m "Tên bạn - Mô tả ngắn gọn việc đã làm"
git push origin main
Nếu gặp lỗi Conflict: Tuyệt đối không xóa lung tung. Hãy chụp ảnh gửi lên nhóm hoặc gọi Leader để cùng xử lý.

🐛 6. Troubleshooting (Sửa lỗi thường gặp)
Lỗi "Network Error" trên Web:

Kiểm tra xem XAMPP (Apache) đã bật chưa?

Kiểm tra file server/config/db.php đã đúng mật khẩu MySQL chưa?

Lỗi XAMPP báo đỏ "Port 3306 in use":

Kệ nó! Vì mình đang dùng MySQL của Workbench nên không cần MySQL của XAMPP. Chỉ cần Apache xanh là được.

Lỗi trắng trang hoặc không chạy được lệnh npm:

Đảm bảo bạn đang đứng đúng thư mục client trong Terminal (cd client).

Thử chạy lại npm install.
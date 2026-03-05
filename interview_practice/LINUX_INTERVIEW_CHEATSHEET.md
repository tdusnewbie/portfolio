# Linux: Cẩm Nang Cho Người Mới (Bản Chi Tiết)

Nếu AWS là một chuỗi khách sạn, thì Linux chính là "Nội quy" và "Cách vận hành" bên trong từng căn phòng.

---

## 1. Hệ điều hành là gì?

- **Phần cứng:** Nồi, niêu, xoong, chảo.
- **Kernel (Nhân):** Ông Bếp Trưởng. Ông ấy là người duy nhất được chạm vào bếp gas. 
- **User (Bạn):** Người phụ bếp. Bạn muốn bật bếp? Bạn phải hét lên: "Sếp ơi bật bếp cho em!" (Đây gọi là **System Call**).

---

## 2. Quản lý công việc (Processes)

- **Process:** Một công việc đang chạy (ví dụ: đang thái hành).
- **Daemon:** Một nhân viên làm việc thầm lặng dưới hầm (chạy ngầm), ví dụ ông trực điện, ông trực nước. Bạn không thấy họ nhưng thiếu họ là tiệm cơm sập.
- **Root (Sếp tổng):** Người có quyền lực tối cao. Có thể đập phá bất cứ thứ gì, đuổi bất cứ ai. Đừng bao giờ đăng nhập bằng Root trừ khi thực sự cần thiết (vì lỡ tay là cháy tiệm).

---

## 3. Mạng Lưới Nội Bộ (Networking)

- **Localhost (127.0.0.1):** Là "Chính tôi". Khi bạn tự nói chuyện với mình.
- **IP Address:** Số điện thoại của bạn trong tiệm.
- **Port (Cửa sổ):** Tiệm cơm có nhiều cửa sổ. 
    - Cửa 80: Để đưa cơm cho khách (Web).
    - Cửa 22: Để chủ tiệm leo vào kiểm tra lúc đêm khuya (SSH).
- **DNS:** Cuốn danh bạ. Biến cái tên "Tiệm Cơm Anh Dung" thành số điện thoại "090...".

---

## 4. Các lệnh "Thần thánh" cho người mới

- **`ls` (List):** "Liếc" xem trong phòng có gì.
- **`cd` (Change Directory):** "Chạy" sang phòng khác.
- **`pwd` (Print Working Directory):** "Phòng nào đây?" (Để biết mình đang đứng ở đâu, khỏi lạc).
- **`cat`:** "Coi" nội dung một tờ giấy (file).
- **`sudo` (SuperUser Do):** "Nhân danh Sếp Tổng!". Dùng khi bạn cần làm việc gì đó quan trọng mà quyền nhân viên không làm được.

---

## 5. Xử lý sự cố (Troubleshooting)

- **"Tiệm cơm chạy chậm quá!":** 
    - Gõ lệnh `top`: Để xem thằng nhân viên nào đang "ngốn" nhiều sức lực (CPU/RAM) nhất rồi xử nó.
- **"Hết chỗ chứa đồ!":**
    - Gõ lệnh `df -h`: Để xem kho nào đang đầy.
- **"Quên mật khẩu!":**
    - Chia buồn, bạn phải nhờ Sếp Tổng (Root) hoặc cài lại tiệm cơm.

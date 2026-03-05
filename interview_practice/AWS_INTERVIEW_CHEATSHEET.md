# AWS Cloud: Từ Điển Cho Người Mới Bắt Đầu (Bản Cực Chi Tiết)

Sử dụng ví dụ "Chuỗi Khách Sạn" để giải thích mọi khái niệm kỹ thuật phức tạp nhất.

---

## 1. Mạng Lưới (Networking) - "Khuôn Viên Khách Sạn"

### VPC (Virtual Private Cloud)
- **Đời thực:** Là một khu đất riêng biệt bạn thuê của chính phủ (AWS). Bạn xây tường bao quanh. Không ai biết bên trong bạn làm gì trừ khi bạn mở cửa.

### Subnet (Phân lô đất)
- **Public Subnet (Lô mặt tiền):** Nơi bạn đặt Sảnh tiếp tân, quán cafe. Ai cũng nhìn thấy.
- **Private Subnet (Lô phía sau):** Nơi đặt nhà kho, két sắt, phòng ngủ. Bạn muốn giấu nó đi.

### IGW vs NAT Gateway (Cánh cửa)
- **Internet Gateway (IGW):** Cái **Cổng chính 2 chiều**. Dành cho những máy chủ muốn "nổi tiếng", muốn cả thế giới tìm thấy mình (như Web Server).
- **NAT Gateway:** Ông **Bảo vệ đi chợ hộ**. Dành cho những máy chủ muốn "ở ẩn" (như Database) nhưng thỉnh thoảng cần ra ngoài Internet để cập nhật phần mềm. Nó cho phép đi ra nhưng **chặn đứng** mọi nỗ lực lẻn vào từ bên ngoài.

---

## 2. Máy Chủ (Compute) - "Nhân Lực & Phòng Ốc"

### EC2 (Elastic Compute Cloud)
- **Đời thực:** Thuê một cái phòng trống. Bạn tự mang máy tính, tự cài hệ điều hành, tự dọn dẹp. Bạn có toàn quyền nhưng bạn phải tự làm mọi thứ (Vất vả nhưng linh hoạt).

### Lambda (Serverless)
- **Đời thực:** Thuê nhân viên theo phút. Bạn chỉ cần đưa cho họ tờ giấy ghi "Hãy photo tập tài liệu này". Nhân viên đến photo xong rồi biến mất. Bạn không cần lo họ ngủ ở đâu, ăn gì. Bạn chỉ trả tiền cho 2 phút họ đứng ở máy photo.

---

## 3. Lưu Trữ (Storage) - "Kho Bãi"

### EBS (Elastic Block Store)
- **Đời thực:** Cái **Ổ cứng di động** hoặc cái tủ cá nhân. Bạn cắm vào máy EC2 này để dùng. Nếu máy EC2 đó hỏng, bạn rút cái tủ ra cắm vào máy khác là xong. 
- *Lưu ý:* Cái tủ này chỉ nằm trong 1 tòa nhà (AZ). Bạn không thể bê nó sang thành phố khác (Region) một cách trực tiếp.

### S3 (Simple Storage Service)
- **Đời thực:** Cái **Kho tổng khổng lồ**. Nó không phải là ổ cứng, nó giống như một cái Google Drive nhưng cực mạnh. Bạn ném 1 tỷ cái ảnh vào cũng được. Nó không bao giờ đầy. Nó tự động sao chép ảnh của bạn ra 3 tòa nhà khác nhau để đảm bảo không bao giờ mất.

---

## 4. Bảo Mật (Security) - "Hàng Rào & Thẻ Từ"

### Security Group (SG)
- **Đời thực:** **Thẻ từ gác cửa phòng**. Mỗi căn phòng (EC2) có một danh sách người được vào. "Chỉ ông nào mặc áo Xanh (Port 80) mới được vào".
- **Tính chất (Stateful):** Nếu bạn đã cho khách vào cửa, thì khi họ đi ra bạn **không bao giờ chặn**. Bạn nhớ mặt họ rồi.

### NACL (Network ACL)
- **Đời thực:** **Lớp bảo vệ ở cổng khu đất (Subnet)**. Nó kiểm tra tất cả mọi người đi qua cổng lô đất. 
- **Tính chất (Stateless):** Nó "não cá vàng". Bạn cho khách vào, nhưng lúc họ ra bạn lại quên mặt, bạn lại phải kiểm tra lại từ đầu. Nếu quên mở cửa chiều ra, khách sẽ bị kẹt luôn trong sảnh.

### IAM (Identity & Access Management)
- **User:** Thẻ nhân viên (Có tên, có mật khẩu).
- **Role (Áo đồng phục):** Cái này cực hay. Thay vì cấp chìa khóa cho máy chủ (nguy hiểm), bạn treo cái áo "Đầu bếp" ở cửa bếp. Con Robot (EC2) nào mặc cái áo đó vào thì mới được mở tủ lạnh lấy thịt. Đây là cách bảo mật tốt nhất hiện nay.

---

## 5. Luồng Dữ Liệu (The Request Flow) - "Hành trình của khách"

Khi bạn gõ `facebook.com`:
1. **Route 53 (Lễ tân chỉ đường):** Chỉ cho bạn biết địa chỉ IP của khách sạn nằm ở đâu.
2. **WAF (Máy quét an ninh):** Kiểm tra xem bạn có mang theo "vũ khí" (code độc hại) không.
3. **Load Balancer (Người điều phối):** Thấy sảnh 1 đông quá, nó dẫn bạn sang sảnh 2 cho nhanh.
4. **Target Group (Nhóm phục vụ):** Là danh sách các phòng đang sẵn sàng đón khách. Load Balancer sẽ ném bạn vào một trong các phòng này.

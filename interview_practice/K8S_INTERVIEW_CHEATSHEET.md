# Kubernetes: Xưởng Robot Cho Người Mới (Bản Chi Tiết)

Đừng sợ K8s! Hãy nghĩ nó là một hệ thống **Quản lý Robot** cực kỳ thông minh.

---

## 1. Tại sao cần K8s?

Bạn có 1 con Robot nấu cơm, bạn tự quản lý được. Nhưng nếu bạn có 1000 con Robot? Con thì nấu cơm, con thì rửa bát, con thì đi chợ... 
- Con nào hỏng thì sao? 
- Con nào làm chậm thì sao? 
- Khách đông thì lấy đâu ra thêm Robot?
=> **Kubernetes (K8s)** sinh ra để làm "Sếp" của đám Robot này.

---

## 2. Các nhân vật chính

- **Pod:** Là cái **Xe đẩy**. Robot không đứng khơi khơi, nó phải ngồi trên xe đẩy. Thường thì 1 xe đẩy chở 1 con Robot.
- **Node:** Là cái **Phân xưởng**. Một phân xưởng có thể chứa nhiều xe đẩy (Pods).
- **Cluster:** Là **Cả khu công nghiệp**. Gồm nhiều phân xưởng gộp lại.

---

## 3. Ban Chỉ Huy (Control Plane)

Đây là những ông sếp ngồi trong văn phòng máy lạnh:
- **API Server:** Ông **Thư ký**. Bạn muốn gì (ví dụ: "Cho tôi 5 con Robot nấu cơm") thì phải viết giấy đưa cho ông này.
- **Etcd:** Cái **Két sắt**. Lưu toàn bộ danh sách Robot và Phân xưởng.
- **Scheduler:** Ông **Sắp xếp**. Ông ấy nhìn xem phân xưởng nào còn chỗ trống thì mới nhét Robot mới vào đó.
- **Controller:** Ông **Giám sát**. Ông ấy cầm bản danh sách đi kiểm tra. Nếu bạn bảo cần 5 con mà ông ấy thấy có 4 con, ông ấy sẽ ra lệnh đúc thêm 1 con ngay lập tức.

---

## 4. Cách Robot "Nói chuyện"

- **Service:** Là cái **Loa phường**. Vì Robot hay bị hỏng và thay con mới (địa chỉ thay đổi), nên K8s tạo ra một cái Loa phường có địa chỉ cố định. Ai muốn ăn cơm cứ gọi vào Loa phường, Loa sẽ tự kết nối tới con Robot nào đang rảnh.
- **Ingress:** Cái **Cổng bảo vệ khu công nghiệp**. Người ngoài muốn vào ăn cơm phải đi qua cổng này. Cổng sẽ hỏi: "Ăn cơm hay ăn phở?" để dẫn khách tới đúng khu vực.

---

## 5. Luồng làm việc (The Flow)

1. **Bạn (Người dùng):** Gõ lệnh `kubectl apply -f robot.yaml` (Đưa bản thiết kế cho Thư ký).
2. **Thư ký (API Server):** Cất bản thiết kế vào Két sắt.
3. **Giám sát (Controller):** Thấy bản thiết kế mới, báo cho Thư ký là "Thiếu Robot rồi!".
4. **Sắp xếp (Scheduler):** Tìm phân xưởng (Node) nào còn chỗ.
5. **Quản đốc xưởng (Kubelet):** Nhận lệnh, đi đúc Robot và cho nó chạy.

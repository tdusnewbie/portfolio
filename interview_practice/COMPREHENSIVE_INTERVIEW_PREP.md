# TỔNG HỢP BỘ ĐỀ PHỎNG VẤN DEVOPS (FULL SRE/PLATFORM)

Tài liệu này tổng hợp các câu hỏi phỏng vấn phổ biến kèm câu trả lời chi tiết, được tổ chức theo từng mảng kỹ thuật.

---

## I. TERRAFORM (IaC)

### 1. Cách tổ chức Terraform module?
- **Cấu trúc chuẩn:** Thường chia thành 2 loại:
    - **Resource Modules:** Gom các tài nguyên liên quan lại (ví dụ: module VPC gồm vpc, subnet, igw).
    - **Infrastructure Modules (Composition):** Gọi các Resource Modules để tạo thành một môi trường hoàn chỉnh (Dev/Staging/Prod).
- **Quy tắc:** Mỗi module nên có `main.tf`, `variables.tf`, `outputs.tf`, `versions.tf` và `README.md`. Tránh "Mega-module" làm mọi thứ.

### 2. Cách apply GitOps cho Terraform?
- Sử dụng các công cụ như **Atlantis**, **Terraform Cloud/Enterprise**, hoặc **GitHub Actions/GitLab CI**.
- **Luồng (Flow):** Developer tạo Pull Request (PR) -> CI chạy `terraform plan` và comment kết quả vào PR -> Reviewer approve -> Merge vào branch chính -> CI chạy `terraform apply`.

### 3. Khi chạy `terraform plan`, TF làm gì? So sánh cái gì với cái gì?
- TF thực hiện 3 bước so sánh:
    1.  **State vs Real World:** Kiểm tra xem tài nguyên thực tế trên Cloud có thay đổi gì so với file `terraform.tfstate` không (Refresh).
    2.  **State vs Configuration:** So sánh file code (`.tf`) với file State.
    3.  **Output:** Đưa ra các thay đổi cần thực hiện để Real World = Configuration.

### 4. `count` vs `for_each` khác nhau như thế nào?
- **`count`:** Dùng khi muốn tạo nhiều tài nguyên giống hệt nhau dựa trên số lượng (integer). Nhược điểm: Nếu xóa một phần tử ở giữa danh sách, TF sẽ destroy và recreate các phần tử phía sau do index bị thay đổi.
- **`for_each`:** Dùng với `map` hoặc `set`. Linh hoạt hơn vì định danh tài nguyên bằng `key` thay vì `index`, giúp tránh việc recreate không mong muốn.

### 5. `dynamic` block làm gì?
- Dùng để tạo các block lặp đi lặp lại bên trong một resource (như nhiều `ingress` rules trong Security Group) dựa trên một danh sách đầu vào, giúp code gọn gàng và linh hoạt hơn.

### 6. Khác nhau giữa Terraform và Terragrunt?
- **Terraform:** Công cụ IaC gốc. Nhược điểm là dễ bị lặp lại code (DRY - Don't Repeat Yourself) khi quản lý nhiều môi trường.
- **Terragrunt:** Là một wrapper cho Terraform. Giúp giữ code DRY, quản lý remote state tự động và hỗ trợ dependency giữa các module tốt hơn.

### 7. File `tfstate` lưu ở đâu?
- **Local:** Mặc định lưu tại máy người dùng (nguy hiểm khi làm team).
- **Remote (Khuyên dùng):** Lưu trên S3, GCS, Azure Blob Storage... Kết hợp với **State Locking** (dùng DynamoDB) để tránh 2 người apply cùng lúc gây hỏng state.

### 8. Có quá nhiều resource thủ công, làm sao đưa vào Terraform quản lý nhanh nhất?
- Nếu chỉ dùng `terraform import` từng cái thì rất lâu. Có 2 cách tiếp cận hiện đại:
    1. **Sử dụng `import` block (Terraform 1.5+):** Bạn viết block `import { to = ... id = ... }`. Sau đó chạy `terraform plan -generate-config-out=generated.tf`. TF sẽ tự sinh code HCL cho bạn dựa trên tài nguyên thực tế. Đây là cách "chính chủ" và an toàn nhất hiện nay.
    2. **Sử dụng công cụ `Terraformer` (của Google):** Đây là công cụ CLI giúp quét toàn bộ Infrastructure hiện có và tự động sinh ra file `.tf` và `.tfstate`. Rất nhanh nhưng code sinh ra đôi khi hơi rác, cần dọn dẹp lại.
- **Chiến lược:** Không nên import tất cả cùng lúc. Nên chia theo cụm (VPC, sau đó đến DB, rồi đến App) để dễ kiểm soát.

### 9. Cách tránh hard-code thông tin nhạy cảm (password DB) trong code TF?
- Sử dụng **Variables** kết hợp với file `.tfvars` (đã đưa vào `.gitignore`).
- Sử dụng **Environment Variables** (`TF_VAR_password`).
- Sử dụng **Secret Manager** (AWS Secrets Manager, HashiCorp Vault): Dùng `data source` để kéo giá trị về khi apply thay vì lưu trong code.

### 10. Chuyện gì xảy ra nếu một tài nguyên đang quản lý bị xóa khỏi file State?
- Terraform sẽ không còn "biết" về sự tồn tại của tài nguyên đó nữa.
- Ở lần `plan/apply` tiếp theo, Terraform sẽ thấy trong code có khai báo nhưng trong state không có -> Nó sẽ cố gắng **tạo mới** tài nguyên đó, dẫn đến lỗi xung đột (nếu tên/id đã tồn tại) hoặc tạo ra 2 cái song song.

### 11. Cách quản lý version cho Terraform Module?
- **Nguyên tắc:** Luôn sử dụng **Semantic Versioning (v1.0.0)**.
- **Cách quản lý:**
    1. **Git Tags:** Cách phổ biến nhất. Gắn tag cho repo module và gọi module qua URL: `source = "git::https://github.com/org/repo.git?ref=v1.2.3"`.
    2. **Terraform Registry:** Dùng Terraform Cloud hoặc GitHub Packages. Registry cho phép quản lý version chuyên nghiệp hơn, có tài liệu tự động và UI để xem các bản release.
- **Tại sao cần versioning?** Để tránh việc một thay đổi nhỏ ở module làm hỏng (break) toàn bộ hạ tầng của các team đang sử dụng module đó. Mọi nâng cấp phải được thực hiện chủ động bằng cách thay đổi giá trị `ref`.

---

## II. AWS (Cloud Computing)

### 1. NACL vs Security Group?
- **Security Group (SG):** Hàng rào ở mức **Instance/ENI**. **Stateful** (cho vào thì tự động cho ra).
- **NACL:** Hàng rào ở mức **Subnet**. **Stateless** (phải mở cả chiều vào và chiều ra). NACL được kiểm tra trước SG (chiều vào).

### 2. Peering 2 VPC: Có mấy cách? Khi nào dùng cách nào?
- **VPC Peering:** Kết nối 1-1. Dùng khi chỉ có ít VPC (2-3 cái). Không hỗ trợ transitive routing (A -> B -> C).
- **Transit Gateway (TGW):** Hub-and-spoke. Dùng khi có nhiều VPC (hàng chục, hàng trăm). Quản lý tập trung, hỗ trợ transitive routing.
- **PrivateLink:** Dùng khi chỉ muốn share một Service cụ thể (không phải cả mạng) sang VPC khác một cách an toàn.

### 3. S3 Gateway Endpoint vs Interface Endpoint?
- **Gateway Endpoint:** Miễn phí, chỉ dành cho S3 và DynamoDB. Hoạt động bằng cách cập nhật Route Table.
- **Interface Endpoint (PrivateLink):** Tính phí theo giờ và dung lượng. Dùng IP nội bộ của VPC. Dùng cho hầu hết các dịch vụ AWS khác hoặc khi muốn truy cập S3 từ On-premise qua VPN/Direct Connect.

### 4. How IRSA (IAM Roles for Service Accounts) work?
- Là cách cấp quyền IAM cho Pod trong K8s thông qua OIDC provider. 
- **Cơ chế:** K8s cấp một Projected Volume Token cho Pod -> Pod dùng token này đổi lấy temp credentials từ AWS STS (Security Token Service) dựa trên IAM Role đã được map.

### 5. ALB vs NLB?
- **ALB (Layer 7):** Hiểu được HTTP/HTTPS, URL path, Headers. Thích hợp cho Web app.
- **NLB (Layer 4):** Hiểu được TCP/UDP/TLS. Tốc độ cực nhanh (triệu request/s), độ trễ cực thấp. Thích hợp cho game, socket, hoặc app yêu cầu IP tĩnh.

### 6. Troubleshoot: Server A (VPC A) không kết nối được Web Server B (VPC B)?
1.  **Network:** Kiểm tra VPC Peering/TGW đã active chưa? Route Table đã có route tới dải IP của VPC kia chưa?
2.  **Firewall:** NACL của cả 2 Subnet có cho phép traffic không? Security Group của Server B có mở port 80/443 cho IP của Server A không?
3.  **Application:** Web Server B có đang chạy không (`netstat -tulpn`)? Kiểm tra log của ứng dụng.
4.  **DNS:** Nếu dùng domain, kiểm tra phân giải IP có đúng không.

---

## III. KUBERNETES (Orchestration)

### 1. Kubernetes là gì? Khác gì Docker Compose?
- **Kubernetes:** Là nền tảng Orchestration để quản lý container trên quy mô lớn (cluster nhiều node). Hỗ trợ tự động mở rộng (scaling), tự phục hồi (self-healing), rolling update và quản lý cấu hình phức tạp.
- **Docker Compose:** Là công cụ để chạy các ứng dụng đa container trên **một host duy nhất** (thường dùng cho Local Development). Không hỗ trợ clustering thực thụ, không có cơ chế tự phục hồi cao cấp như K8s.

### 2. Control Plane và Worker Node gồm những gì?
- **Control Plane (Bộ não):** 
    - `kube-apiserver`: Cổng giao tiếp duy nhất.
    - `etcd`: Database lưu trạng thái cluster.
    - `kube-scheduler`: Quyết định Pod chạy trên node nào.
    - `kube-controller-manager`: Duy trì trạng thái mong muốn (replica, node...).
- **Worker Node (Nơi thực thi):**
    - `kubelet`: Quản lý vòng đời Pod trên node.
    - `kube-proxy`: Quản lý luật mạng (iptables/ipvs).
    - `Container Runtime`: (Docker/Containerd) Chạy container.

### 3. App bị bug crash sau đúng 5h, xử lý thế nào khi chờ Dev fix? (Hot fix)
- Sử dụng **Liveness Probe:** Cấu hình để K8s tự động restart Pod khi app không phản hồi hoặc check endpoint `/health`.
- Sử dụng **CronJob:** Tạo một job chạy lệnh `kubectl rollout restart deployment` sau mỗi 4.5 giờ để chủ động thay mới các Pod trước khi bị crash.
- Đây là giải pháp tình thế (Workaround) để duy trì uptime.

### 4. Liveness vs Readiness vs Startup Probe khác nhau thế nào?
- **Startup:** Kiểm tra ứng dụng đã khởi chạy xong chưa. Khi Startup đang chạy, Liveness và Readiness sẽ bị vô hiệu hóa. Dùng cho các app khởi động chậm.
- **Liveness:** Kiểm tra Pod còn sống không? Nếu fail -> K8s **restart** Pod.
- **Readiness:** Kiểm tra Pod sẵn sàng nhận traffic chưa? Nếu fail -> K8s **gỡ IP Pod khỏi Service** (không cho traffic vào nữa), nhưng không restart Pod.

### 5. Cách update Secrets trong HashiCorp Vault?
- Dùng CLI: `vault kv put secret/my-app password=new-pass`.
- Dùng UI của Vault hoặc qua API.
- Nếu dùng **Vault Agent Injector** hoặc **External Secrets Operator** trong K8s, các Secret này sẽ tự động được sync về K8s Secret hoặc được mount trực tiếp vào Pod.

### 6. Deployment vs StatefulSet?
- **Deployment:** Dùng cho **Stateless** apps (Web, API). Các Pod là vô danh, có thể thay thế lẫn nhau, thứ tự start/stop không quan trọng.
- **StatefulSet:** Dùng cho **Stateful** apps (Database, Kafka). Các Pod có định danh cố định (`app-0`, `app-1`), thứ tự start/stop theo thứ tự, và mỗi Pod có Persistent Volume riêng được gắn chặt với định danh đó.

### 7. Graceful Shutdown trong K8s?
- Khi Pod bị xóa:
    1.  Trạng thái Pod chuyển sang `Terminating`.
    2.  K8s gửi tín hiệu `SIGTERM` tới ứng dụng.
    3.  Ứng dụng có khoảng thời gian (`terminationGracePeriodSeconds`, mặc định 30s) để đóng kết nối, hoàn tất xử lý.
    4.  Nếu quá thời gian, K8s gửi `SIGKILL` để ép buộc tắt.

### 8. ExternalTrafficPolicy: "Local" vs "Cluster"?
- **Cluster:** Traffic có thể nhảy qua các node khác trước khi tới Pod (gây mất IP gốc của client - SNAT).
- **Local:** Traffic chỉ được gửi tới Pod nằm trên chính node nhận traffic đó (giữ được IP gốc, giảm hop mạng, nhưng có thể gây lệch tải).

### 9. Đường đi của traffic từ User tới Pod?
- `User` -> `Internet` -> `Load Balancer` (Cloud) -> `Ingress Controller` (Nginx/Envoy) -> `Service` (ClusterIP) -> `Endpoint` (Pod IP).

### 10. Các thành phần chính và ETCD?
- **Control Plane:** API Server (Cổng giao tiếp), Scheduler (Chọn node), Controller Manager (Giữ trạng thái mong muốn), **ETCD**.
- **ETCD:** Là database dạng Key-Value lưu trữ toàn bộ trạng thái của cluster. Nó hoạt động theo cơ chế **Raft Consensus** để đảm bảo tính nhất quán dữ liệu giữa các node.
- **Worker Node:** Kubelet (Quản lý Pod), Kube-proxy (Quản lý mạng), Container Runtime (Docker/CRI-O).

### 11. DaemonSet là gì?
- Là loại tài nguyên đảm bảo **mỗi Node** trong cluster đều chạy đúng 1 bản sao của Pod đó. Thường dùng cho các ứng dụng hệ thống như Log Collector (Fluentd), Monitoring Agent (Prometheus Exporter), hoặc Network Plugin.

### 12. Ngăn pull image từ community?
- Sử dụng **Admission Controller** (như OPA Gatekeeper hoặc Kyverno) để kiểm tra trường `image` trong file YAML. Nếu không bắt đầu bằng registry cho phép (ví dụ `my-repo.com/`) thì sẽ bị Reject.

### 13. Ngoài etcd ra, còn database nào khác có thể dùng cho K8s?
- **etcd** là mặc định và phổ biến nhất.
- Tuy nhiên, trong các bản phân phối nhỏ gọn như **K3s**, ta có thể dùng **SQLite** (cho single node) hoặc các database ngoại vi như **PostgreSQL, MySQL, MariaDB** thông qua dự án **Kine** (Kine is not etcd) của Rancher.

### 14. Khi chạy `kubectl apply`, điều gì xảy ra under the hood?
- K8s thực hiện **Three-way Merge** để bảo toàn các thay đổi động:
    1. **Live configuration:** Trạng thái thực tế đang chạy (có thể chứa các field do K8s tự thêm như IP, hoặc HPA tự scale replica).
    2. **Manifest file:** File YAML bạn vừa chỉnh sửa.
    3. **Last-applied-configuration:** Annotation `kubectl.kubernetes.io/last-applied-configuration` lưu trạng thái của lần apply trước đó.
- **Tại sao cần 3 nguồn?** Nếu bạn chỉ so sánh file YAML với Live config, bạn có thể vô tình ghi đè (overwrite) các thay đổi mà các controller khác (như HPA) đã thực hiện. Three-way merge giúp K8s biết được field nào là do bạn chủ động sửa, field nào là do hệ thống tự sinh để giữ lại.

### 15. Các bước migrate K8s cluster sang cluster mới mà giữ nguyên data?
- Đây là bài toán **Stateful Migration**:
    1. **Resource Migration:** Dùng **Velero** để backup/restore các object (Deployment, Service, Ingress...).
    2. **Data Migration (PV):** 
        - Nếu cùng Cloud Provider: Velero có thể snapshot và tạo disk mới ở cluster mới.
        - Nếu khác Provider/On-premise: Dùng công cụ như **Restic** (tích hợp trong Velero) để copy dữ liệu ở mức file-system sang cluster mới.
    3. **Traffic Cutover:** Hạ TTL của DNS, setup Ingress ở cluster mới, sau đó trỏ DNS sang IP của Load Balancer mới.
    4. **Database:** Thường sẽ migrate DB riêng (dùng Replica/DMS) trước khi chuyển ứng dụng.

### 16. Helm vs Kustomize: Ưu/Nhược điểm và khi nào dùng?
- **Helm (The Package Manager):** 
    - *Triết lý:* "Đóng gói một lần, chạy mọi nơi". 
    - *Ưu:* Có logic (if/else, loop), quản lý version (history), rollback cực nhanh. Phù hợp cho app phức tạp, cần cài nhiều resource đi kèm.
    - *Nhược:* Cấu trúc template khó debug, rủi ro cấu hình sai (misconfiguration) do lồng ghép logic quá nhiều.
- **Kustomize (The Configuration Overlay):** 
    - *Triết lý:* "Không template, chỉ đè (overlay)".
    - *Ưu:* Giữ YAML gốc thuần khiết, dễ đọc vì không có cú pháp lạ. Native hoàn toàn với `kubectl`.
    - *Nhược:* Không quản lý được các trạng thái phức tạp (conditional logic), không có rollback history.
- **Áp dụng:** Dùng Helm để cài các tool hạ tầng (Prometheus, Ingress). Dùng Kustomize để quản lý các microservices của chính mình qua các môi trường Dev/Staging/Prod.

### 17. Nếu không dùng DaemonSet, làm sao rải Pod của Deployment ra các node?
- Sử dụng **Pod Anti-Affinity:** Cấu hình `topologyKey: kubernetes.io/hostname` với mode `requiredDuringSchedulingIgnoredDuringExecution` để ngăn các Pod có cùng label chạy trên cùng một node.
- Sử dụng **Topology Spread Constraints:** Giúp phân bổ Pod đều hơn trên các Failure Domains (nodes, zones) một cách linh hoạt hơn Anti-Affinity.

### 18. Ingress và Ingress Controller khác nhau thế nào?
- **Ingress (Lớp định nghĩa):** Là một bản thiết kế (blueprint). Bạn chỉ nói: "Tôi muốn traffic `/shop` vào service A". Nó không tự chạy được.
- **Ingress Controller (Lớp thực thi):** Là một con Reverse Proxy (Nginx, Envoy, Kong) chạy 24/7. Nó liên tục "nghe" API Server, khi thấy có Ingress mới, nó sẽ tự động cập nhật file config (ví dụ `nginx.conf`) và reload để thực hiện việc chuyển hướng traffic.

### 19. InitContainer vs Sidecar Container khác nhau thế nào?
- **InitContainer (Tuần tự):** Giống như "đội tiền trạm". Nó chạy xong và thoát thì container chính mới được khởi động. VD: Đợi DB sẵn sàng, tải cấu hình từ Vault về thư mục dùng chung.
- **Sidecar (Song hành):** Giống như "trợ lý". Nó chạy cùng lúc với container chính. 
    - *Legacy:* Sidecar chỉ là một container bình thường chạy cùng Pod.
    - *K8s 1.29+:* Đã có **Native Sidecar** (Container có `restartPolicy: Always` trong phần init), giúp đảm bảo Sidecar khởi động trước và tắt sau cùng, giải quyết triệt để vấn đề log bị mất hoặc job kết thúc sớm.

### 20. Meta Monitoring là gì?
- Là việc "giám sát hệ thống giám sát". Ví dụ: Monitoring hệ thống Prometheus/Grafana để đảm bảo khi hệ thống chính chết thì chúng ta vẫn nhận được cảnh báo là công cụ monitoring cũng đang gặp vấn đề. Thường dùng một Prometheus tách biệt (hoặc Dead Man's Snitch) để theo dõi trạng thái của chính Prometheus chính.

### 21. Tại sao Pod là đơn vị nhỏ nhất trong K8S mà không phải Container?
- **Nguyên lý "Cùng chung số phận" (Co-scheduling):** Một ứng dụng thường gồm app chính và các helper (log, proxy). Nếu K8s quản lý container riêng lẻ, nó có thể schedule app chính ở Node A, helper ở Node B -> Không thể kết nối qua localhost.
- Pod đóng vai trò là một **Virtual Host**. Các container trong Pod chia sẻ chung Network Namespace (IP chung), IPC, và UTS, giúp chúng giao tiếp hiệu quả như trên cùng một máy vật lý.

### 22. Static Provisioning và Dynamic Provisioning trong Persistent Volume?
- **Static:** Admin phải tạo trước các Persistent Volume (PV) thủ công từ trước. Khi User tạo PVC, K8s sẽ tìm PV có sẵn để bind. Nhược điểm: Khó scale, admin phải làm việc thủ công nhiều.
- **Dynamic:** Admin chỉ cần tạo StorageClass (định nghĩa loại disk, ví dụ SSD gp3). Khi User tạo PVC, K8s sẽ tự động yêu cầu Cloud Provider tạo Disk thực tế và tạo PV tương ứng một cách tự động.

### 23. Làm sao Extend Size cho ứng dụng chạy StatefulSet?
- **Vấn đề:** Mặc định `volumeClaimTemplates` trong StatefulSet là bất biến (immutable).
- **Quy trình chuẩn:**
    1. Kiểm tra StorageClass có `allowVolumeExpansion: true`.
    2. Sửa trực tiếp dung lượng trong tất cả các **PVC** mà các Pod của StatefulSet đang dùng. Cloud provider sẽ tự scale disk ngầm.
    3. Nếu cần cập nhật file YAML gốc (để các Pod tạo sau này cũng to ra): Xóa StatefulSet bằng lệnh `kubectl delete sts <name> --cascade=orphan` (giúp giữ lại các Pod đang chạy để tránh downtime).
    4. Cập nhật size mới trong file YAML và `kubectl apply` lại. STS mới sẽ "nhận con nuôi" (adopt) các Pod đang chạy và bind vào các PVC đã được scale.


### 24. Các thành phần trong K8s giao tiếp với nhau như thế nào?
- **Mô hình Hub-and-Spoke:** `kube-apiserver` là trung tâm duy nhất. **KHÔNG** thành phần nào (Scheduler, Controller, Kubelet) nói chuyện trực tiếp với nhau.
- **Luồng:** Tất cả đều gọi qua REST API của API Server. API Server là thực thể duy nhất được phép đọc/ghi vào `etcd`.
- **Cơ chế Watch:** Để nhận biết thay đổi (ví dụ: có Pod mới), thay vì hỏi liên tục (polling), các thành phần sẽ duy trì một kết nối HTTP dài (Long Polling) với API Server để nhận thông báo ngay khi có sự kiện xảy ra.

### 25. Giải thích về FQDN trong K8s?
- **FQDN (Fully Qualified Domain Name):** Là định danh duy nhất của một Service trong mạng nội bộ cluster.
- **Cấu trúc:** `<service-name>.<namespace>.svc.cluster.local`
- **Các thành phần:**
    - `service-name`: Tên bạn đặt cho service.
    - `namespace`: Namespace chứa service đó.
    - `svc`: Chỉ định đây là một service.
    - `cluster.local`: Domain mặc định của cluster.
- **Ứng dụng:** Giúp các microservice gọi nhau mà không cần biết IP. Ví dụ: `curl http://payment-service.finance.svc.cluster.local:8080`.

---

## IV. DOCKER (Containerization)

... (rest of the file until section VI)

---

## VI. LINUX & FOUNDATION

### 1. Lệnh `kill` làm gì?
- Dùng để gửi tín hiệu (signals) tới một hoặc nhiều process.
- **Mặc định:** `kill <pid>` gửi `SIGTERM` (15) để yêu cầu process tắt an toàn (graceful shutdown).
- **Cưỡng chế:** `kill -9 <pid>` gửi `SIGKILL` để ép buộc process dừng ngay lập tức mà không giải phóng tài nguyên.

### 2. Zombie vs Orphan Process?
- **Zombie:** Process đã kết thúc nhưng vẫn còn entry trong bảng process vì cha (parent) chưa đọc exit code. Không tốn tài nguyên trừ PID.
- **Orphan:** Process đang chạy nhưng cha đã chết. Nó sẽ được nhận nuôi bởi `init` (PID 1).

### 3. Xử lý lỗi "target is busy" khi umount?
- Tìm process đang sử dụng folder đó: `lsof +D /path/to/mount` hoặc `fuser -m /path/to/mount`.
- Kill process đó hoặc yêu cầu người dùng thoát khỏi thư mục.
- Nếu không thể đợi, dùng **Lazy Unmount**: `umount -l /path/to/mount` (Hệ thống sẽ gỡ mount ngay lập tức khỏi cấu trúc file và dọn dẹp các handle khi chúng không còn bận).

### 4. Troubleshoot mạng chậm giữa 2 máy trong mạng local?
1. **Kiểm tra vật lý/băng thông:** Dùng `iperf3` để đo tốc độ truyền tải thực tế giữa 2 máy.
2. **Kiểm tra độ trễ và mất gói:** Dùng `ping` (với gói tin lớn) và `mtr` (hoặc `traceroute`) để xem có hop nào bị nghẽn không.
3. **Kiểm tra Interface:** Dùng `ethtool` hoặc `ifconfig/ip -s link` để xem có lỗi CRC, dropped packets, hay duplex mismatch không.
4. **Kiểm tra Resource:** Xem CPU/RAM của 2 máy có bị quá tải làm chậm quá trình xử lý gói tin không.

---

## VII. CI/CD & SECURITY

### 1. GitOps là gì? 4 nguyên tắc cốt lõi?
- **GitOps** là mô hình vận hành hạ tầng và ứng dụng lấy Git làm trung tâm (Single Source of Truth).
- **4 nguyên tắc theo GitOps Working Group:**
    1. **Declarative (Khai báo):** Toàn bộ trạng thái mong muốn phải được khai báo bằng code (YAML, HCL...).
    2. **Versioned (Lưu vết):** Toàn bộ code phải được lưu trong Git để có lịch sử thay đổi và rollback dễ dàng.
    3. **Pulled Automatically (Tự động kéo):** Một Agent (ArgoCD/Flux) tự động kéo các thay đổi từ Git về Cluster mà không cần con người can thiệp.
    4. **Continuously Reconciled (Liên tục đồng bộ):** Hệ thống luôn tự động so sánh trạng thái thực tế với trạng thái trong Git để tự sửa (self-heal) nếu có sự sai lệch (Drift).

### 2. Khác nhau giữa GitOps và Classical CI/CD?
- **Classical CI/CD (Push-based):** 
    - *Cơ chế:* CI tool (Jenkins/GitHub Actions) sau khi build xong sẽ dùng quyền Admin (`kubeconfig`) để "đẩy" (push) lệnh update vào Cluster. 
    - *Nhược điểm:* 1. Lỗ hổng bảo mật nếu CI tool bị hack (vì nó giữ quyền cao nhất). 2. Không phát hiện được **Configuration Drift** (Nếu ai đó sửa tay trên Cluster, Git không hề biết).
- **GitOps (Pull-based):** 
    - *Cơ chế:* Một Agent (ArgoCD/Flux) chạy **bên trong** Cluster. Nó liên tục so sánh trạng thái trong Git và trạng thái thực tế. 
    - *Ưu điểm:* 
        1. **Security:** Không cần mở port Cluster cho CI tool bên ngoài, Cluster tự "kéo" cấu hình về. 
        2. **Self-healing:** Nếu ai đó sửa tay trên Cluster, Agent sẽ tự động ghi đè lại (Sync) về đúng trạng thái trong Git. 
        3. **Audit:** Mọi thay đổi hạ tầng đều phải qua Pull Request, có lịch sử rõ ràng.

### 2. Thiết kế CI/CD cho Python App như thế nào?
- **CI (Continuous Integration):** 
    - 1. **Linting & Formatting:** Dùng `ruff` hoặc `flake8` để check code style.
    - 2. **Security Scan:** Dùng `bandit` để quét lỗi bảo mật trong code Python.
    - 3. **Unit Test:** Chạy `pytest` với coverage report.
    - 4. **Containerize:** Build Docker image (nên dùng multi-stage build để giảm dung lượng).
    - 5. **Image Scan:** Dùng `Trivy` hoặc `Grype` quét lỗ hổng trong image.
    - 6. **Push:** Đẩy image lên ECR/Docker Hub với tag là Git Commit SHA.
- **CD (Continuous Deployment - theo GitOps):** 
    - 1. CI tool tự động cập nhật tag image mới vào file Manifest (YAML) hoặc Helm Chart trong **Git Repository dành riêng cho cấu hình** (Config Repo).
    - 2. **ArgoCD/Flux** nhận thấy Git có thay đổi, thực hiện "Pull" và update Cluster.
    - 3. **Smoke Test:** Chạy một script nhỏ kiểm tra endpoint `/health` sau khi deploy.

### 3. Git Flow vs Trunk-based?
...

---

## IX. AI (LLM Ops)

### 1. MCP là gì?
- **Model Context Protocol (MCP):** Là một giao thức tiêu chuẩn (do Anthropic đề xướng) để các AI Model (như Claude) có thể kết nối với các nguồn dữ liệu bên ngoài (Database, File System, API) một cách bảo mật và chuẩn hóa.
- **Tại sao cần MCP?** Trước đây, để AI đọc được file hay DB, lập trình viên phải viết code riêng cho từng tool. Với MCP, AI có thể tự động hiểu "khả năng" (Capabilities) của một server và gọi chúng mà không cần cấu hình thủ công nhiều.
- **Cơ chế hoạt động:** 
    - **MCP Server:** Cung cấp tài nguyên (Resources) và công cụ (Tools). 
    - **MCP Client:** (VD: Claude Desktop, Gemini CLI) Kết nối với Server qua giao thức JSON-RPC (qua `stdio` hoặc `HTTP/SSE`) để trao đổi dữ liệu.

### 2. LiteLLM: Quản lý API Key như thế nào?
- **LiteLLM Proxy:** Là lớp đứng giữa ứng dụng và các nhà cung cấp AI (OpenAI, Anthropic). 
- **Cách quản lý:** 
    1. **Master Keys:** Dùng để quản trị hệ thống. 
    2. **Virtual Keys:** Tạo ra các key ảo cho từng team/dự án. Mỗi key có thể giới hạn ngân sách (Budget), Model được phép dùng (Models), và theo dõi chi tiết (Observability).
    3. **Secret Management:** Proxy tự động đọc key thực từ Environment Variables hoặc AWS Secrets Manager, giúp giấu kín key thật khỏi ứng dụng.

### 3. Tool theo dõi AI usage và monitoring?
- **LangSmith:** Debugging, testing, monitoring LLM apps.
- **Helicone / Arize Phoenix:** Quản lý chi phí, latency và observability cho AI.
- **Weights & Biases (W&B):** Tracking thí nghiệm và phiên bản model.

---

## X. OPEN QUESTIONS

### 1. API bị chậm: Xử lý thế nào?
- **Quy trình 4 bước:**
    1. **Isolate:** Lỗi xảy ra ở đâu? (Dùng Monitoring/Grafana xem latency tăng ở layer nào: LB, Nginx, App, hay DB).
    2. **Trace:** Dùng **Distributed Tracing** (Jaeger, Datadog) để xem request đó bị chậm ở câu lệnh SQL nào hay API call nào ra bên ngoài.
    3. **Resource Check:** Xem CPU/RAM của server có bị nghẽn (throttling) hoặc bị rác (GC - Garbage Collection) không.
    4. **Fix:** Tối ưu hóa câu query (Indexing), thêm Cache (Redis), hoặc tăng Resource (Vertical/Horizontal Scaling).

### 2. Xây dựng App Multi-region?
- **Networking:** Route 53 (Latency-based routing) để trỏ user về region gần nhất.
- **Data:** Dùng DynamoDB Global Tables hoặc Aurora Global Database để đồng bộ dữ liệu đa vùng với độ trễ thấp.
- **Compute:** Deploy ứng dụng lên cả 2 region (EKS/ECS) đồng bộ qua CI/CD.

### 3. So sánh ECS vs EKS?
- **ECS (AWS Native):** Đơn giản, dễ học, tích hợp sâu với AWS (IAM, VPC). Phù hợp cho team nhỏ, ít kinh nghiệm K8s.
- **EKS (Standard Kubernetes):** Mạnh mẽ, linh hoạt, chuẩn hóa toàn cầu (không bị vendor lock-in). Phù hợp cho hệ thống lớn, cần nhiều tính năng phức tạp như Service Mesh, Custom Operators.

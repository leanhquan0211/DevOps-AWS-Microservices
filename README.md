# DevOps-AWS-Microservices

Repository này được dùng cho bài thực hành NT548 Lab 02. Hiện tại repo chỉ triển khai phần Câu 1:

- Provision hạ tầng AWS bằng Terraform
- Tự động hóa quá trình kiểm tra và triển khai bằng GitHub Actions
- Tích hợp Checkov để quét bảo mật và tuân thủ mã Terraform

Phạm vi hiện tại chỉ gồm:

- Thư mục `terraform/` cho VPC, subnets, route tables, NAT Gateway, security groups và 2 EC2
- Workflow `.github/workflows/terraform-cicd.yml`
- Tài liệu demo và checklist bằng chứng trong `docs/lab02-part1/`

Không tạo trước CloudFormation, microservices, RDS, EKS hoặc ALB ở giai đoạn này.

Hướng dẫn nhanh:

1. Đọc [terraform/README.md](/n:/UIT/HK2/NT548/Lab/Lab2/DevOps-AWS-Microservices/terraform/README.md) để chuẩn bị biến và chạy Terraform bằng PowerShell.
2. Đọc [docs/lab02-part1/evidence-checklist.md](/n:/UIT/HK2/NT548/Lab/Lab2/DevOps-AWS-Microservices/docs/lab02-part1/evidence-checklist.md) để chụp ảnh đúng yêu cầu báo cáo.
3. Đọc [docs/lab02-part1/demo-script.md](/n:/UIT/HK2/NT548/Lab/Lab2/DevOps-AWS-Microservices/docs/lab02-part1/demo-script.md) để demo theo đúng thứ tự.

Biến `allowed_ssh_cidrs` là danh sách các IP public được phép SSH vào EC2. Dùng kiểu `list(string)` vì mạng ISP có thể thay đổi giữa nhiều IP public khác nhau, nên việc khai báo nhiều CIDR trong cùng một biến sẽ thuận tiện hơn khi demo và kiểm thử.

## Workflow Terraform CI/CD

Workflow `.github/workflows/terraform-cicd.yml` có 2 job tách biệt:

- `terraform-ci`: chạy kiểm tra mã nguồn Terraform trước khi triển khai, gồm `fmt`, `init`, `validate`, `plan` và quét Checkov.
- `terraform-cd`: tự động triển khai hạ tầng bằng `terraform apply` sau khi job CI thành công.

Quy tắc chạy workflow:

- `pull_request` vào `main`: chỉ chạy `terraform-ci`, không được apply.
- `push` vào `main`: chạy `terraform-ci` trước, nếu pass mới chạy `terraform-cd`.

GitHub Actions cần cấu hình:

- Secrets: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_REGION`, `ALLOWED_SSH_CIDR_1`, `ALLOWED_SSH_CIDR_2`
- Repository variables: `KEY_NAME`

Lưu ý quan trọng:

- Không commit file `terraform.tfvars` lên repo.
- Workflow tạo file `terraform.auto.tfvars` tạm thời từ GitHub Secrets/Variables để phục vụ `plan` và `apply`.
- NAT Gateway có thể phát sinh chi phí ngay cả khi lưu lượng thấp.
- Sau khi demo xong, hãy chạy `terraform destroy` để tránh tốn chi phí không cần thiết.

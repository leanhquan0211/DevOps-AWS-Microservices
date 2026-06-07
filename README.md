# DevOps-AWS-Microservices

Repository này được dùng cho bài thực hành NT548 Lab 02. Hiện tại repo chỉ triển khai phần Câu 1:

- Provision hạ tầng AWS bằng Terraform
- Tự động hóa kiểm tra bằng GitHub Actions
- Tích hợp Checkov để quét bảo mật và tuân thủ mã Terraform

Phạm vi hiện tại chỉ gồm:

- Thư mục `terraform/` cho VPC, subnets, route tables, NAT Gateway, security groups và 2 EC2
- Workflow `.github/workflows/terraform-ci.yml`
- Tài liệu demo và checklist bằng chứng trong `docs/lab02-part1/`

Không tạo trước CloudFormation, microservices, RDS, EKS hoặc ALB ở giai đoạn này.

Hướng dẫn nhanh:

1. Đọc [terraform/README.md](/n:/UIT/HK2/NT548/Lab/Lab2/DevOps-AWS-Microservices/terraform/README.md) để chuẩn bị biến và chạy Terraform bằng PowerShell.
2. Đọc [docs/lab02-part1/evidence-checklist.md](/n:/UIT/HK2/NT548/Lab/Lab2/DevOps-AWS-Microservices/docs/lab02-part1/evidence-checklist.md) để chụp ảnh đúng yêu cầu báo cáo.
3. Đọc [docs/lab02-part1/demo-script.md](/n:/UIT/HK2/NT548/Lab/Lab2/DevOps-AWS-Microservices/docs/lab02-part1/demo-script.md) để demo theo đúng thứ tự.

Biến `allowed_ssh_cidrs` là danh sách các IP public được phép SSH vào EC2. Dùng kiểu `list(string)` vì mạng ISP có thể thay đổi giữa nhiều IP public khác nhau, nên việc khai báo nhiều CIDR trong cùng một biến sẽ thuận tiện hơn khi demo và kiểm thử.

GitHub Actions cần cấu hình:

- Secrets: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_REGION`, `ALLOWED_SSH_CIDR_1`, `ALLOWED_SSH_CIDR_2`
- Repository variables: `KEY_NAME`

Lưu ý quan trọng:

- Không commit file `terraform.tfvars` lên repo.
- Workflow GitHub Actions chỉ chạy `fmt`, `init`, `validate`, `plan` và Checkov, không tự động `terraform apply`.
- NAT Gateway có thể phát sinh chi phí ngay cả khi lưu lượng thấp.
- Sau khi demo xong, hãy chạy `terraform destroy` để tránh tốn chi phí không cần thiết.

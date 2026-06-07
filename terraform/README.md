# Terraform Lab 02 Part 1

Tài liệu này hướng dẫn triển khai hạ tầng AWS cho Câu 1 bằng Windows PowerShell.

Tài nguyên được tạo:

- 1 VPC CIDR `10.20.0.0/16`
- 1 public subnet và 1 private subnet
- 1 Internet Gateway
- 1 Elastic IP và 1 NAT Gateway
- 1 public route table và 1 private route table
- 1 security group dùng chung cho 2 EC2
- 1 public EC2 Amazon Linux 2023 có cài nginx
- 1 private EC2 Amazon Linux 2023 không có public IP

Cảnh báo chi phí:

- NAT Gateway có tính phí theo giờ và theo lưu lượng.
- Sau khi demo xong, phải chạy `terraform destroy` để tránh phát sinh chi phí.

## 1. Kiểm tra AWS CLI

Kiểm tra AWS CLI đã cài đặt:

```powershell
aws --version
```

Kiểm tra danh tính AWS đang sử dụng:

```powershell
aws sts get-caller-identity
```

Nếu chưa cấu hình credentials, dùng:

```powershell
aws configure
```

## 2. Tạo file biến đầu vào

Sao chép file mẫu:

```powershell
Copy-Item .\terraform.tfvars.example .\terraform.tfvars
```

Cập nhật ít nhất các giá trị sau trong `terraform.tfvars`:

- `key_name`: tên key pair đã có sẵn trên AWS
- `allowed_ssh_cidrs`: danh sách các IP public hoặc CIDR được phép SSH, nên ưu tiên `/32`

Biến `allowed_ssh_cidrs` dùng kiểu `list(string)` để bạn có thể khai báo nhiều IP public hợp lệ cùng lúc. Điều này hữu ích khi mạng ISP thay đổi địa chỉ public giữa nhiều kết nối hoặc khi bạn cần demo từ nhiều vị trí khác nhau.

Lưu ý:

- Không commit file `terraform.tfvars` lên repo.

## 3. Chạy Terraform

Di chuyển vào thư mục `terraform`:

```powershell
Set-Location .\terraform
```

Khởi tạo provider:

```powershell
terraform init
```

Format mã nguồn:

```powershell
terraform fmt -recursive
```

Kiểm tra cấu hình:

```powershell
terraform validate
```

Xem kế hoạch:

```powershell
terraform plan
```

Áp dụng hạ tầng:

```powershell
terraform apply
```

Xem outputs:

```powershell
terraform output
```

Xóa hạ tầng sau khi demo:

```powershell
terraform destroy
```

## 4. Checklist ảnh cho báo cáo

Cần chụp ít nhất các bằng chứng sau:

- Cấu trúc repo và các file Terraform
- AWS identity đang sử dụng
- `terraform fmt`, `terraform validate`, `terraform plan`
- Kết quả quét Checkov
- GitHub Actions chạy thành công
- VPC, subnets, route tables, NAT Gateway, EC2 trong AWS Console
- Trang web trên public EC2
- Outputs và kết quả `terraform destroy`

Danh sách đầy đủ nằm trong [docs/lab02-part1/evidence-checklist.md](/n:/UIT/HK2/NT548/Lab/Lab2/DevOps-AWS-Microservices/docs/lab02-part1/evidence-checklist.md).

## 5. Cấu hình GitHub Actions

Workflow CI dùng các biến sau trên GitHub:

- Secrets: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_REGION`, `ALLOWED_SSH_CIDR_1`, `ALLOWED_SSH_CIDR_2`
- Repository variables: `KEY_NAME`

Workflow sẽ tạo file `terraform.auto.tfvars` tạm thời trong lúc chạy `terraform plan`, không cần commit file này vào repo. Workflow chỉ kiểm tra và quét bảo mật, không tự động `terraform apply`.

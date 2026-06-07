# CloudFormation Infrastructure

## Mục tiêu

Thư mục này chứa phần triển khai hạ tầng AWS bằng CloudFormation cho bài thực hành DevOps. Toàn bộ quá trình kiểm tra, build và triển khai được thiết kế để chạy trên dịch vụ AWS, không cần script local.

## Cấu trúc thư mục

```text
cloudformation/
├── templates/
│   └── infrastructure.yaml
├── taskcat/
│   └── .taskcat.yml
├── buildspec.yml
└── README.md
```

## Luồng CI/CD

Do CodeCommit bị giới hạn trên AWS Free Plan, source provider được thay bằng GitHub repository.

Luồng mới là:

`GitHub -> CodePipeline -> CodeBuild -> CloudFormation`

Tóm tắt vai trò từng thành phần:

- `GitHub`: lưu source cho phần CloudFormation.
- `CodePipeline`: theo dõi thay đổi từ GitHub và điều phối pipeline.
- `CodeBuild`: cài `cfn-lint` và `taskcat`, sau đó kiểm tra template.
- `CloudFormation`: dùng template đã kiểm tra để tạo hoặc cập nhật stack.

## Các tài nguyên được tạo

Template `templates/infrastructure.yaml` tạo các tài nguyên sau:

- 1 VPC
- 1 public subnet
- 1 private subnet
- 1 Internet Gateway
- 1 Elastic IP cho NAT Gateway
- 1 NAT Gateway
- 1 public route table
- 1 private route table
- 1 security group cho public EC2
- 1 security group cho private EC2
- 1 public EC2 instance
- 1 private EC2 instance

Ngoài ra template cũng xuất các outputs quan trọng để phục vụ kiểm tra sau khi deploy.

## Kiểm tra trong CodeBuild

File `buildspec.yml` được viết cho trường hợp CodeBuild lấy source từ root của GitHub repository. Vì thư mục `cloudformation/` nằm bên trong repo, các đường dẫn trong buildspec đều bắt đầu bằng `cloudformation/`.

Các bước chính:

- cài `cfn-lint` và `taskcat`
- in version của `aws`, `cfn-lint`, `taskcat`
- chạy `cfn-lint cloudformation/templates/infrastructure.yaml`
- chạy `cd cloudformation/taskcat && taskcat test run`

File `taskcat/.taskcat.yml` vẫn dùng đường dẫn `../templates/infrastructure.yaml` vì lệnh `taskcat test run` được thực thi từ bên trong thư mục `cloudformation/taskcat`.

## Lưu ý về Key Pair

Trước khi chạy pipeline, cần kiểm tra giá trị `KeyName` trong `taskcat/.taskcat.yml`.

Hiện tại file đã đặt:

- `KeyName: nt548-laq1254-key-v2`

Khi triển khai stack bằng CloudFormation, cần truyền cùng `KeyName` để EC2 instances được tạo đúng với key pair đang có trên AWS account.

Nếu đổi sang key pair khác trong tương lai, hãy cập nhật đồng thời:

- `cloudformation/taskcat/.taskcat.yml`
- tham số `KeyName` khi tạo hoặc cập nhật stack CloudFormation

## Ghi chú chi phí

- NAT Gateway có thể phát sinh phí theo giờ và theo lưu lượng.
- EC2 và Elastic IP cũng có thể phát sinh chi phí nếu để lâu.
- Sau khi demo xong, cần xóa stack CloudFormation để tránh phát sinh chi phí không cần thiết.

## Danh sách ảnh cần chụp báo cáo

- Cấu trúc thư mục `cloudformation/`
- Nội dung template `infrastructure.yaml`
- Cấu hình `buildspec.yml`
- Cấu hình `taskcat/.taskcat.yml`
- Kết quả `cfn-lint` trong CodeBuild
- Kết quả `taskcat test run`
- Các stage của CodePipeline
- Stack CloudFormation tạo thành công
- VPC, subnets, NAT Gateway và EC2 trên AWS Console
- Outputs của stack
- Ảnh cleanup sau khi xóa stack

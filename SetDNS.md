# Set DNS bằng Script trên Windows

## Giới thiệu
Repo này chứa script giúp thay đổi DNS thủ công trên Windows.
Mục tiêu: tối ưu tốc độ truy cập internet và bảo mật tốt hơn.

## Cách sử dụng
1. Tải script về máy.
2. Chạy script với quyền **Administrator**.
3. Script sẽ tự động cấu hình DNS bạn đã chọn.

## Ví dụ lệnh
```powershell
netsh interface ip set dns "Wi-Fi" static 8.8.8.8
netsh interface ip add dns "Wi-Fi" 8.8.4.4 index=2

VBoxManage controlvm "ubuntu-vm" natpf1 "SSH,tcp,127.0.0.1,2222,,22"
VBoxManage controlvm "ubuntu-vm" natpf1 "HTTP,tcp,,80,,80"
VBoxManage controlvm "ubuntu-vm" natpf1 "HTTPS,tcp,,443,,443"
VBoxManage controlvm "ubuntu-vm" natpf1 "phpMyAdmin,tcp,127.0.0.1,8888,,8888"
VBoxManage controlvm "ubuntu-vm" natpf1 "Webhook,tcp,,9001,,9001"

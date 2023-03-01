resource "aws_instance" "windows-server" {
  ami                   = "ami-0c2b0d3fb02824d92" # Windows Server 2022
  instance_type         = "t2.medium"   # 2vCPU 4GiB Memory
  key_name              = "windows-server-pem-keys-${var.env}"
  subnet_id             =  var.Private-1A
  security_groups       = [data.aws_security_group.windows_server_ec2_security_group.id]
  iam_instance_profile  = "windows-server-role"
  tags                = {
    Name = "windows-server"
  }
  user_data = <<-EOF
              <powershell>
              net user Administrator ${random_password.windows_server_pwd.result}
              </powershell>
              EOF
  depends_on = [random_password.windows_server_pwd]
}
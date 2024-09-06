resource "aws_instance" "ec2" {
  ami = var.ami
  instance_type = var.type
  key_name = var.key
  tags = {
    Name = "test"
  }
}

output "publicip" {
    value = aws_instance.ec2.public_ip
    description = "printing the publicip"
}

output "privateip" {
   value = aws_instance.ec2.private_ip
   description = "printing the privateip"
   sensitive = true
}
# output server public ip
output "ec2-server-public-ip" {
    value = module.myapp-server.instance.public_ip
}
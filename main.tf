# connect aws
provider "aws" {
  region = "eu-north-1"
}

# create custom vpc name myapp-vpc
resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
      Name = "${var.env_prefix}-vpc"
  }
}

// create subnet, use subnet module
module "myapp-subnet" {
    source = "./modules/subnet"
    vpc_id = aws_vpc.myapp-vpc.id
    subnet_cidr_block = var.subnet_cidr_block
    avail_zone = var.avail_zone
    env_prefix = var.env_prefix
}

// create ec2 server, use webserver module
module "myapp-server" {
    source = "./modules/webserver"
    vpc_id = aws_vpc.myapp-vpc.id
    subnet_id = module.myapp-subnet.subnet.id
    my_ip  = var.my_ip
    env_prefix = var.env_prefix
    avail_zone = var.avail_zone
    image_name = var.image_name
    ssh-key-pair-name = var.ssh-key-pair-name
    public_key_location = var.public_key_location
    instance_type = var.instance_type
}




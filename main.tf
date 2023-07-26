//connect aws
provider "aws" {
  region = "eu-north-1"
}

variable "cidr_blocks" {
  description = "cidr blocks and name tags for vpc and subnets"
  type = list(object({
        cidr_block = string
        name = string
  }))
}

variable avail_zone {
    default = "eu-north-1a"
}

//start, add custom vpc and subnet inside it 
// create custom vpc name dev-vpc
resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_blocks[0].cidr_block
  tags = {
    Name = var.cidr_blocks[0].name
  }
}
// create custom subnet in dev-vpc
resource "aws_subnet" "subnet" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.cidr_blocks[1].cidr_block
    tags = {
    Name = var.cidr_blocks[1].name
  }
}
//end, add custom vpc and subnet inside it 


//start, add subnet in existing vpc 
// fetch existing vpc data
data "aws_vpc" "existing_vpc" {
    default = true
}
// create subnet in existing vpc, which we fetch above
resource "aws_subnet" "dev-subnet-2" {
    vpc_id = data.aws_vpc.existing_vpc.id
    cidr_block = var.cidr_blocks[2].cidr_block
    availability_zone = var.avail_zone
    tags = {
        Name = var.cidr_blocks[2].name
    }
}
//end, add subnet in existing vpc 

// outut vpc id value when apply file, each output must have only one value define
// output is like function retun
output "existing_vpc_id" {
  value = data.aws_vpc.existing_vpc.id
}
//connect aws
provider "aws" {
  region = "eu-north-1"
}

//variables
variable vpc_cidr_block {}
variable subnet_1_cidr_block {}
variable avail_zone {}
variable env_prefix {}


//start, add custom vpc and subnet inside it 
// create custom vpc name myapp-vpc
resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
      Name = "${var.env_prefix}-vpc"
  }
}

// create custom myapp-subnet-1 in myapp-vpc
resource "aws_subnet" "myapp-subnet-1" {
  vpc_id = aws_vpc.myapp-vpc.id
  cidr_block = var.subnet_1_cidr_block
  availability_zone = var.avail_zone
  tags = {
      Name = "${var.env_prefix}-subnet-1"
  }
}
//end, add custom vpc and subnet inside it 


//start, add custom route-table  and internet gateway
// create internet gateway
resource "aws_internet_gateway" "myapp-igw" {
	vpc_id = aws_vpc.myapp-vpc.id
    
    tags = {
     Name = "${var.env_prefix}-internet-gateway"
   }
}

// create route-table 
resource "aws_route_table" "myapp-route-table" {
   vpc_id = aws_vpc.myapp-vpc.id

   route {
     cidr_block = "0.0.0.0/0"
     gateway_id = aws_internet_gateway.myapp-igw.id
   }
   # default route, mapping VPC CIDR block to "local", created implicitly and cannot be specified.
   tags = {
     Name = "${var.env_prefix}-route-table"
   }
 }
//end, add custom route-table  and internet gateway



# create custom myapp-subnet-1 in myapp-vpc
resource "aws_subnet" "myapp-subnet-1" {
  vpc_id = var.vpc_id
  cidr_block = var.subnet_cidr_block
  availability_zone = var.avail_zone
  tags = {
      Name = "${var.env_prefix}-subnet-1"
  }
}


# create internet gateway
resource "aws_internet_gateway" "myapp-igw" {
	vpc_id = var.vpc_id
    
    tags = {
     Name = "${var.env_prefix}-internet-gateway"
   }
}

# create route-table 
resource "aws_route_table" "myapp-route-table" {
   vpc_id = var.vpc_id

   route {
     cidr_block = "0.0.0.0/0"
     gateway_id = aws_internet_gateway.myapp-igw.id
   }
   # default route, mapping VPC CIDR block to "local", created implicitly and cannot be specified.
   tags = {
     Name = "${var.env_prefix}-route-table"
   }
 }

# Associate subnet with Route Table
resource "aws_route_table_association" "a-rtb-subnet" {
  subnet_id      = aws_subnet.myapp-subnet-1.id
  route_table_id = aws_route_table.myapp-route-table.id
}

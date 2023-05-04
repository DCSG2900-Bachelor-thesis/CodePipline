resource "aws_vpc" "my_vpc" {
  cidr_block = "172.16.0.0/16"
}

resource "aws_subnet" "my_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "172.16.10.0/24"
  availability_zone       = "eu-north-1a"
  map_public_ip_on_launch = true
}

resource "aws_network_interface" "interface_network1" {
  subnet_id       = aws_subnet.my_subnet.id
  private_ips     = ["172.16.10.100"]
  security_groups = ["${aws_security_group.network-security.id}"]
}

resource "aws_network_interface" "interface_network2" {
  subnet_id       = aws_subnet.my_subnet.id
  private_ips     = ["172.16.10.101"]
  security_groups = ["${aws_security_group.network-security.id}"]
}

resource "aws_security_group" "network-security" {
  name_prefix = "network-security"

  vpc_id = aws_vpc.my_vpc.id

  ingress {
    from_port   = 0
    to_port     = 6000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 6000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    name = "vpc_gateway"
  }
}

resource "aws_route_table" "routing" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    name = "gatewayrouter"
  }
}

resource "aws_route" "routing" {
  route_table_id         = aws_route_table.routing.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gateway.id
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.my_subnet.id
  route_table_id = aws_route_table.routing.id
}
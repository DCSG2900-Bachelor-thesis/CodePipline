resource "aws_internet_gateway" "gateway1" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "gateway1"
  }
}
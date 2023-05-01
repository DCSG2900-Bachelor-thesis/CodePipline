resource "aws_instance" "test_instance" {

  ami                  = var.ami
  instance_type        = var.instance_type
  key_name             = var.instance_key

  iam_instance_profile = aws_iam_instance_profile.instance_profile.name

  network_interface {
    network_interface_id = aws_network_interface.interface_network1.id
    device_index         = 0
  }

  tags = {
    "Name" = "test_instance"
  }
  #dns hostnames
  user_data = <<-EOF
        #!/bin/bash
        echo "start codedeploy agenet install"
        sudo yum update -y
        sudo yum install -y ruby
        sudo yum install -y aws-cli
        wget https://aws-codedeploy-eu-north-1.s3.eu-north-1.amazonaws.com/latest/install
        chmod +x ./install
        sudo ./install auto
        sudo service codedeploy-agent status
        echo "agent instald"
    EOF
}

#172.16.10.101
resource "aws_instance" "test_instance1" {
  ami                  = var.ami
  instance_type        = var.instance_type
  key_name             = var.instance_key
  iam_instance_profile = aws_iam_instance_profile.instance_profile.name

  network_interface {
    network_interface_id = aws_network_interface.interface_network2.id
    device_index         = 0
  }

  tags = {
    "Name" = "test_instance1"
  }
  #dns hostnames
  user_data = <<-EOF
        #!/bin/bash
        echo "start codedeploy agenet install"
        sudo yum update -y
        sudo yum install -y ruby
        sudo yum install -y aws-cli
        wget https://aws-codedeploy-eu-north-1.s3.eu-north-1.amazonaws.com/latest/install
        chmod +x ./install
        sudo ./install auto
        sudo service codedeploy-agent status
        echo "agent instald"
        sudo su
        yum install docker -y
        systemctl start docker
        docker pull owasp/zap2docker-stable
        echo "docker installd"
    EOF
}


resource "aws_iam_instance_profile" "instance_profile" {
  name = var.instance_profile
  role = aws_iam_role.ec2-role.name
}
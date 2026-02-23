provider "aws" {
  region = "ap-south-1"   # Mumbai region
}

resource "aws_key_pair" "deployer" {
  key_name   = "terraform-key"
  public_key = file("/var/lib/jenkins/.ssh/id_rsa.pub")
}

resource "aws_security_group" "allow_ports" {
  name = "allow_ssh_http"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Jenkins"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ubuntu" {
  ami           = "ami-0f5ee92e2d63afc18"  # Ubuntu 22.04 (Mumbai)
  instance_type = "t3.micro"

  key_name        = aws_key_pair.deployer.key_name
  security_groups = [aws_security_group.allow_ports.name]

  tags = {
    Name = "Ananth-EC2"
  }
}
output "instance_public_ip" {
  value = aws_instance.ubuntu.public_ip
}

output "instance_id" {
  value = aws_instance.ubuntu.id
}
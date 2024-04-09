resource "aws_instance" "budgetwise_instance" {
  ami                    = "ami-09a6704a52d96773b"
  instance_type          = "t4g.nano"
  key_name               = "aws_key_0123"
  vpc_security_group_ids = [aws_security_group.security_group_react.id]

  user_data = <<-EOF
    #!/bin/bash
    # Update package index and install Docker
    sudo yum update -y
    sudo yum install -y docker
    
    # Start the Docker service
    sudo service docker start
    
    # Start your Docker container
    sudo docker run -d -p 80:80 -e API_URL="${aws_api_gateway_deployment.deployment.invoke_url}" rv8542/budgetwise-frontend
    EOF

  depends_on = [aws_api_gateway_deployment.deployment]
  
  tags = {
    Name = "budgetwise-app"
  }
}

resource "aws_security_group" "security_group_react" {
  name        = "react1-sg"
  description = "allow http port"

  ingress {
    description = "https"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "allow http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "allow ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "react1-sg"
  }
}
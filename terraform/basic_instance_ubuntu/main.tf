provider "aws" {
  version = "~> 2.33"
  region  = "us-east-1"
}

resource "aws_instance" "example" {
  ami           = "ami-04b9e92b5572fa0d1"
  instance_type = "t3.micro"
	# vpc_security_group_ids = [ "aws_security_group.instance.id"]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF

  tags = {
    Name        = "terraform-example-ubuntu"
    Environment = "Demo"
  }

  credit_specification {
    cpu_credits = "unlimited"
  }

}

resource "aws_security_group" "instance" {
	name = "terraform-example-instance"

	ingress {
		from_port   = 8080
		to_port     = 8080
		protocol    = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}
}

provider "aws" {
  access_key =  var.access_key
  secret_key =  var.secret_key
  region = "eu-west-2"
}

variable "access_key" {
  type = string
}
variable "secret_key" {
  type = string
}
variable "public_key" {
  type = string
}
variable "private_key_path" {
  type = string
}
resource "aws_key_pair" "deployer" {
  key_name   = "aws_key"
  public_key = var.public_key
}

resource "aws_instance" "ec2" {
    ami = "ami-0015a39e4b7c0966f"
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.test_sg.id]
    key_name= "aws_key"
    tags = {
      "Name" = var.instance_name
    }

    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ubuntu"
      private_key = file(var.private_key_path)
    }

    provisioner "file" {
        source      = "script2.sh"
        destination = "/tmp/script2.sh"
    }

    provisioner "remote-exec" {
      inline = [
        "chmod +x /tmp/script2.sh",
        "/tmp/script2.sh args",
      ]
    }

    provisioner "remote-exec" {
      inline = [
        "sudo docker run -d -p 5701:5701 hazelcast/hazelcast:5.1"
      ]
    }
}

variable "instance_name" {
    type = string
    default = "Default"
}

output "private_ip" {
    value = aws_instance.ec2.private_ip
}

output "public_ip" {
    value = aws_instance.ec2.public_ip
}

resource "aws_security_group" "test_sg" {
    name = "test_sg"
    tags = {
        Name = "Test_sg_for_ali"

    }
    ingress {
        description = "SSH"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "Hazelcast"
        from_port   = 5701
        to_port     = 5801
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

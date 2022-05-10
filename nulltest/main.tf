provider "aws" {
  access_key = ""
  secret_key = ""
  region = "eu-west-2"
}

resource "null_resource" "test" {
    connection {
    type        = "ssh"
    host        = "18.169.18.171"
    user        = "ubuntu"
    private_key = file("Path of ssh private key file")
    }

    provisioner "remote-exec" {
      inline = [
        "sudo touch test.txt"
      ]
    }
}
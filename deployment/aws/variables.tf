# key pair name to be assigned to EC2 instance, it will be created by terraform.
variable "aws_key_name" {
  type    = string
  default = "hazelcast"
}

# local path of private key file for SSH connection - local_key_path/aws_key_name
variable "local_key_path" {
  type    = string
  default = "~/.ssh"
}

variable "shared_credentials_file" {
  type    = string
  default = "~/.aws/credentials"
}

variable "member_count" {
  type    = number
  //default = "3"
}

variable "prefix" {
  type    = string
  default = "projectx"
}

# If you are using free tier, changing this to other than "t3.micro" will cost money.
variable "aws_instance_type" {
  type    = string
  default = "t2.micro"
}

variable "aws_region" {
  type    = string
  default = "eu-central-1"
}

variable "aws_tag_key" {
  type    = string
  default = "Category"
}

variable "aws_tag_value" {
  type    = string
  default = "hazelcast-aws-discovery"
}

variable "aws_connection_retries" {
  type    = number
  default = "3"
}

variable "hazelcast_version" {
  type    = string
  default = "5.1"
}

variable "hazelcast_aws_version" {
  type    = string
  default = "3.4"
}

variable "aws_ssh_user" {
  type    = string
  default = "ubuntu"
}

# license enterprise key
variable "license_enterprise_key" {
  type = string
}
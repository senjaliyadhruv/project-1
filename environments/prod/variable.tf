variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "subnet_cidr" {
  default = "10.0.1.0/24"
}

variable "az" {
  default = "us-east-1a"
}

variable "ami" {
  default = "ami-053b0d53c279acc90"
}

variable "instance_type" {
  default = "t3.medium"
}

variable "name" {
  default = "prod"
}

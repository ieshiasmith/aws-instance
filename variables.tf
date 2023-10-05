variable "region" {
  type        = string
  description = "AWS Region"
  default     = "us-east-2"
}

variable "management_privkey" {
  type        = string
  description = "SSH Private Key"
  sensitive   = true
}

variable "cidr_block" {
  default = "10.42.0.0/16"
}

variable "my_ip" {
  default = "64.79.57.24/32"
}

variable "instance_type" {
  description = "Description of the instance type"
  default     = "t3.medium"
}

variable "volume_size" {
  description = "Volume Size in GB"
  type        = number
  default     = 100
}
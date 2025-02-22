variable "region" {
  type        = string
  description = "AWS Region"
  default     = "us-east-2"
}

variable "cidr_block" {
  default = "10.42.0.0/16"
}

variable "my_ip" {
  default = "x.x.x.x/32"
}

variable "instance_type" {
  description = "Description of the instance type"
  default     = "t3.medium"
}

variable "volume_size" {
  description = "Volume Size in GB"
  type        = number
  default     = 50
}

variable "hashi_tool" {
  description = "HashiCorp tools to install"
  type        = string
  default     = "none"
}

variable "vault_license" {
  description = "Vault License"
  type        = string
  default     = "none"
  sensitive   = true
}
terraform {
  required_version = "~> 1.6.6"
  backend "remote" {
    organization = "HashIeshia"
    workspaces {
      name = "aws-instance"
    }
  }
}

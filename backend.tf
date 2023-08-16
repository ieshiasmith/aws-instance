terraform {
  required_version = "~> 1.5.2"
  backend "remote" {
    organization = "demo-land"
    workspaces {
      name = "aws-instance"
    }
  }
}

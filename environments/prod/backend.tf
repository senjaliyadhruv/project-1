terraform {
  backend "s3" {
    bucket         = "dhruv-project-1204"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
  }
}

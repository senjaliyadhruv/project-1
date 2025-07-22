terraform {
  backend "s3" {
    bucket         = "dhruv-project-1204"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
  }
}

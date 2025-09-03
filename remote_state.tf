# store the terraform state file in s3 and lock with dynamodb
terraform {
  backend "s3" {
    # bucket name
    bucket         = "zhen-terraform-remote-state"
    # key is the name we want to call our state file in our S3 Bucket
    # 这里我们还顺便 Create 了一个 folder
    key            = "nebulaops/terraform.tfstate"
    region         = "us-east-1"
    profile        = "terraform-user"
    # the name of the table
    dynamodb_table = "zhen-terraform-state-lock"
  }
}
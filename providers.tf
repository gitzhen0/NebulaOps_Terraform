# configure aws provider to establish a secure connection between terraform and aws
provider "aws" {
  region  = var.region
  profile = "terraform-user"

# the tags we want to add to every resource in this project
  default_tags {
    tags = {
      "Automation"  = "terraform"
      "Project"     = var.project_name
      "Environment" = var.environment
    }
  }
}

provider "aws" {
  alias  = "us_east_1" # 这个取了别名, 给 acm 用的, 必须在这个 region
  region = "us-east-1"
  profile = "terraform-user"
}
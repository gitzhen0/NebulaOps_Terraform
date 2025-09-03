# first we are going to store the variable, region, project name and environment as a local variables 
# because we will reference those variables throughout our project, so want to store these variables as local variables
# 因为这几个 variable 到处都要用, 所以我们把它搞成 local variable 方便 access
locals {
  region       = var.region
  project_name = var.project_name
  environment  = var.environment
}

# create vpc module
module "vpc" {

  source = "git::https://github.com/gitzhen0/NebulaOps_Terraform_Modules.git//vpc?ref=main"


  # environment variables
  # local 是 local 的一些 variable
  region       = local.region
  project_name = local.project_name
  environment  = local.environment

  # vpc variables
  # var 开头的是 terraform.tfvars 里的, 外头传进来的
  vpc_cidr                     = var.vpc_cidr
  public_subnet_az1_cidr       = var.public_subnet_az1_cidr
  public_subnet_az2_cidr       = var.public_subnet_az2_cidr
  private_app_subnet_az1_cidr  = var.private_app_subnet_az1_cidr
  private_app_subnet_az2_cidr  = var.private_app_subnet_az2_cidr
  private_data_subnet_az1_cidr = var.private_data_subnet_az1_cidr
  private_data_subnet_az2_cidr = var.private_data_subnet_az2_cidr

}

# Create nat_gateways
module "nat_gateway" {
  source = "git::https://github.com/gitzhen0/NebulaOps_Terraform_Modules.git//nat_gateway?ref=main"

  # 这些就是 module 里的 variable.tf 里的那些, 一一对应的
  project_name = local.project_name
  environment  = local.environment
  # module 开头的是, 别的 module 的 output.tf 传进来的
  public_subnet_az1_id       = module.vpc.public_subnet_az1_id
  public_subnet_az2_id       = module.vpc.public_subnet_az2_id
  internet_gateway           = module.vpc.internet_gateway
  vpc_id                     = module.vpc.vpc_id
  private_app_subnet_az1_id  = module.vpc.private_app_subnet_az1_id
  private_data_subnet_az1_id = module.vpc.private_data_subnet_az1_id
  private_app_subnet_az2_id  = module.vpc.private_app_subnet_az2_id
  private_data_subnet_az2_id = module.vpc.private_data_subnet_az2_id
}

# Create Security Groups
module "security_group" {
  source = "git::https://github.com/gitzhen0/NebulaOps_Terraform_Modules.git//security_group?ref=main"


  # module variable.tf 的那几个, 一一对应
  project_name = local.project_name
  environment  = local.environment
  vpc_id       = module.vpc.vpc_id
  ssh_ip       = var.ssh_ip
}


# static site

module "frontend_static_site" {
  source = "git::https://github.com/gitzhen0/NebulaOps_Terraform_Modules.git//static_site?ref=main"

  domain_name    = var.domain_name
  hosted_zone_id = var.hosted_zone_id

  frontend_github_owner   = var.frontend_github_owner
  frontend_github_repo    = var.frontend_github_repo
  frontend_github_branch  = var.frontend_github_branch

  frontend_create_github_oidc_provider = true
  frontend_force_destroy_bucket = true

  providers = {
    aws           = aws
    aws.us_east_1 = aws.us_east_1
  }

}

# backend
module "backend_gha_ecr" {
# 请替换为你的 modules 仓库地址与版本
source = "git::https://github.com/gitzhen0/NebulaOps_Terraform_Modules.git//backend_gha_ecr_2?ref=main"

backend_aws_region            = var.backend_aws_region
backend_project_name          = var.backend_project_name

backend_github_owner          = var.backend_github_owner
backend_github_repo           = var.backend_github_repo
backend_github_branch         = var.backend_github_branch

# backend_create_oidc_provider  = var.backend_create_oidc_provider
# backend_existing_oidc_provider_arn = var.backend_existing_oidc_provider_arn

# 关键：不再创建 OIDC，直接复用前端模块创建的那个
backend_create_oidc_provider        = false
backend_existing_oidc_provider_arn  = module.frontend_static_site.github_oidc_provider_arn

backend_service_names         = var.backend_service_names
backend_ecr_repo_prefix       = var.backend_ecr_repo_prefix
}
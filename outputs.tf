# 这里的 outputs 是给 github action 用的
output "bucket_name"                 { value = module.frontend_static_site.bucket_name }
output "cloudfront_domain_name"      { value = module.frontend_static_site.cloudfront_domain_name }
output "cloudfront_distribution_id"  { value = module.frontend_static_site.cloudfront_distribution_id }
output "github_actions_role_arn"     { value = module.frontend_static_site.github_actions_role_arn }
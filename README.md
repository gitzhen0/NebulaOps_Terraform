# NebulaOps_Terraform
Terraform part for NebulaOps

## update one

## Terraform Commands

* 初始化
```sh
terraform init
```

* 格式化 - 把配置文件 .tf 自动排版，统一风格  
```sh
terraform fmt
```

* 校验 - 检查语法是否正确，但不会连接云端
```sh
terraform validate
```

* 预览执行计划 - 显示 Terraform 会创建/修改/删除哪些资源，不会真正执行
```sh
terraform plan
```

* 执行变更
```sh
terraform apply
```

* 常用加参数自动确认
```sh
terraform apply -auto-approve 
```

* 销毁资源

```sh
terraform destroy
```
```sh
terraform destroy -auto-approve
```

* terraform init 之前记得删这个目录
```sh
rm -rf .terraform/modules
```
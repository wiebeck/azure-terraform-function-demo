# Prerequisites

- Azure Subscription
- Azure CLI tool (`az`)
- Terraform installed -> [download](https://www.terraform.io/downloads.html)

# Build the function deployment using Gradle

1. copy `local.settings.json.sample` to `local.settings.json`
1. run `./gradlew azureFunctionsPackageZip`
   
# Provision infrastructure and deploy function

1. modify `infrastructure/variables.tf` to your needs (e.g. choose a different `prefix`)
1. login to Azure: `az login`
1. change to `infrastructure` and run:
    
```
terraform init
terraform apply
```

Done.

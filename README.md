# CodePipeline
This project is a practical component of a bachelor's project.

# Preconceptions
Assuming that you have Terraform and AWS CLI installed and set up.  
Also assume you have a variables.tfvars file for definitions of your variables (found in variables.tf)

# Including the Juice-Shop repository
The Juice-Shop repository can be forked from https://github.com/juice-shop/juice-shop  
For this project, some additional files, like the appspec file, is added. These can be found under the juice-shop repository in this organization: https://github.com/DCSG2900-Bachelor-thesis/juice-shope

# Build
Here are the steps you need to follow to build the project:

Initialize the repository:
`terraform init`

Plan the deployment:
`terraform plan`

Deploy the project:
`terraform apply -var-file="variables.tfvars"`

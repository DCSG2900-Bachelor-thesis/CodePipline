variable "build_name" {
  type    = string
}

variable "codedeploy_app_name" {
  type = string
}

variable "pipeline_name" {
  type    = string
}

variable "git_repo" {
  type    = string
}

variable "git_branch" {
  type    = string
}

variable "bucket_name" {
  type    = string
}

variable "deployment_config_name" {
  type    = string
}

variable "deploy_group_name" {
  type    = string
}

variable "instance_key" {
  type    = string
}

variable "instance_profile" {
  type    = string  
}

variable "kms_key" {
  type = string
}

variable "kms_alias" {
  type = string
}
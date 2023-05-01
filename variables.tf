variable "build_name" {
  type    = string
  default = "build"
}

variable "codedeploy_app_name" {
  type = string
}

variable "pipeline_name" {
  type    = string
}

variable "git_repo" {
  type    = string
  default = "SebastianHestsveen/juice-shop"
}

variable "git_branch" {
  type    = string
}

variable "bucket_name" {
  type    = string
  default = "artifact-bucket-sebastian"
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

variable "instance_type" {
  type    = string
  default = "t3.medium"
}

variable "instance_key" {
  type    = string
  default = "mykey"
}

variable "kms_alias" {
  type = string
}
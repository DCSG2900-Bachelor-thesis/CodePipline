variable "build_name" {
  type    = string
  default = "build"
}

variable "build_desc" {
  type    = string
  default = "test build"
}

variable "pipeline_name" {
  type    = string
  default = "code-pipeline2"
}

variable "git_repo" {
  type    = string
  default = "SebastianHestsveen/juice-shop"
}

variable "git_branch" {
  type    = string
  default = "master"
}

variable "bucket_name" {
  type    = string
  default = "artifact-bucket-sebastian"
}

variable "deployment_config_name" {
  type    = string
  default = "deploy-tf-cicd"
}

variable "deployment_platform" {
  type    = string
  default = "EC2"
}

variable "deploy_group_name" {
  type    = string
  default = "deploy_group1"
}

variable "ami" {
  type    = string
  default = "ami-0f960c8194f5d8df5"
}

variable "instance_type" {
  type    = string
  default = "t3.xlarge"
}

variable "instance_key" {
  type    = string
  default = "mykey"
}

variable "vpc" {
  type    = string
  default = "vpc-0e86f4e2a1a764e0d"
}

variable "codedeploy_app_name" {
  type = string
  default = "deployment1"
}

variable "instance_profile" {
  type = string
  default = "instance_profile"
}

variable "kms_key" {
  type = string
  default = "pipeline_key"
}

variable "kms_alias" {
  type = string
  default = "sebastian-key"
}
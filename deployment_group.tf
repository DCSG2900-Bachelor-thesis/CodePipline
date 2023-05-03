resource "aws_codedeploy_deployment_group" "deploy_group" {
  deployment_group_name  = var.deploy_group_name
  deployment_config_name = aws_codedeploy_deployment_config.deployment_config.id
  app_name               = "deployment"
  service_role_arn       = aws_iam_role.codedeploy-role.arn

  ec2_tag_filter {
    key   = "Name"
    type  = "KEY_AND_VALUE"
    value = "test_instance"
  }
}

resource "aws_codedeploy_deployment_group" "deploy_group1" {
  deployment_group_name  = "deploy_group1"
  deployment_config_name = aws_codedeploy_deployment_config.deployment_config.id
  app_name               = "codedeploy1"
  service_role_arn       = aws_iam_role.codedeploy-role.arn

  ec2_tag_filter {
    key   = "Name"
    type  = "KEY_AND_VALUE"
    value = "test_instance1"
  }
}
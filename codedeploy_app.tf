#Create the application for CodeDeploy
resource "aws_codedeploy_app" "codedeploy" {
  name = var.codedeploy_app_name
}

resource "aws_codedeploy_app" "codedeploy1" {
  name = "codedeploy1"
}
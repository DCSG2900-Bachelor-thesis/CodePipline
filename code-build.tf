resource "aws_codebuild_project" "build" {
  name         = var.build_name
  description  = var.build_desc
  service_role = aws_iam_role.tf-codebuild-role.arn

  artifacts {
    type      = "CODEPIPELINE"
    packaging = "ZIP"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:6.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = file("buildspec/buildspec.yml")
  }
}

resource "aws_codebuild_project" "zap_scan" {
  name         = "zap-scan"
  description  = "CodeBuild project for ZAP Scan action"
  service_role = aws_iam_role.tf-codebuild-role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:6.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    environment_variables = [
      {
        name  = "ZAP_SCAN_URL"
        value = "https://example.com"
      },
      {
        name  = "ZAP_SCAN_CONFIG"
        value = "config.xml"
      }
    ]
  }
  source { 
    type      = "CODEPIPELINE"
    buildspec = file("buildspec/buildspec-zap.yml")
  }
}
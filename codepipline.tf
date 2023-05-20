#Create the CodePipeline
resource "aws_codepipeline" "cicd_pipeline" {

  name     = var.pipeline_name
  role_arn = aws_iam_role.codepipline-role.arn

  artifact_store {
    type     = "S3"
    location = aws_s3_bucket.codepipeline_artifact.id
  }

  stage {
    name = "Source"
    action {
      name             = "code-source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]
      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.code-connection.arn
        FullRepositoryId = var.git_repo
        BranchName       = var.git_branch
      }
    }

    action {
      name             = "zap-source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["owasp"]
      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.code-connection.arn
        FullRepositoryId = "DCSG2900-Bachelor-thesis/OWASP-Zap-appspec"
        BranchName       = var.git_branch
      }
    }
  }

  stage {
    name = "Test"
    
    action {
      name            = "Build"
      category        = "Build"
      provider        = "CodeBuild"
      version         = "1"
      owner           = "AWS"
      input_artifacts = ["source_output"]
      configuration = {
        ProjectName = "build"
      }
      run_order = 1
    }

    #Deploys the web page to EC2 instance for scanning 
    action {
      name            = "staging"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeploy"
      input_artifacts = ["source_output"]
      version         = "1"
      configuration = {
        ApplicationName     = aws_codedeploy_app.codedeploy.name
        DeploymentGroupName = var.deploy_group_name
      }
      run_order = 2
    }
    #Deploys OWASP ZAP for scanning the web page 
    action {
      name            = "owasp-zap-test"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeploy"
      input_artifacts = ["owasp"]
      version         = "1"
      configuration = {
        ApplicationName     = aws_codedeploy_app.codedeploy1.name
        DeploymentGroupName = "deploy_group1"
      }
      run_order = 3
    }    
  }

  stage { 
    name = "Deploy"
    
    #Set up the manual approval
    action {
      name     = "Approval"
      category = "Approval"
      owner    = "AWS"
      provider = "Manual"
      version  = "1"

      configuration = {
        NotificationArn = aws_sns_topic.approval_notifications.arn
        CustomData = "Review this and accept or reject"
      }
      run_order = 1
    }
    
    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeploy"
      input_artifacts = ["source_output"]
      version         = "1"
      configuration = {
        ApplicationName     = aws_codedeploy_app.codedeploy.name
        DeploymentGroupName = var.deploy_group_name
      }
      run_order = 2
    }
  }  
}
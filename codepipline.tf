resource "aws_codepipeline" "cicd_pipeline" {

  name     = var.pipeline_name
  role_arn = aws_iam_role.codepipline-role.arn

  artifact_store {
    type     = "S3"
    location = aws_s3_bucket.codepipline_artifact.bucket
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
        FullRepositoryId = "SebastianHestsveen/buildspec"
        BranchName       = var.git_branch
      }
    }
  }

  stage {
    name = "Plan"
    
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

    #depolys the web page to ec2 isntans for scaning
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

    #Deploys owasp zap so it can scan the web page 
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
    }
  }  
}
#iam policy for the codepipline
resource "aws_iam_role" "codepipline-role" {
  name = "codepipline-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = [
            "codepipeline.amazonaws.com",
          ]
        }
      },
    ]
  })
}

#Allows the pipeline to access the S3 bucket, codebuild,codestar-connection and sns polesis
data "aws_iam_policy_document" "codepipeline-policy-document" {
  statement {
    sid       = ""
    actions   = ["codestar-connections:UseConnection"]
    resources = [aws_codestarconnections_connection.code-connection.arn]
    effect    = "Allow"
  }
  statement {
    sid       = ""
    actions   = ["s3:*", "codebuild:*", ]
    resources = ["${aws_s3_bucket.codepipeline_artifact.arn}/*", aws_codebuild_project.build.arn]
    effect    = "Allow"
  }
  statement {
    sid       = ""
    actions   = ["sns:Publish"]
    resources = [aws_sns_topic.approval_notifications.arn]
    effect    = "Allow"
  }
  statement {
    sid       = "VisualEditor0"
    effect    = "Allow"
    actions   = ["codedeploy:*"]
    resources = [aws_codedeploy_deployment_group.deploy_group.arn, aws_codedeploy_deployment_group.deploy_group1.arn]
  }
}

resource "aws_iam_policy" "codepipline-policy" {
  name        = "codepipline-policy"
  path        = "/"
  description = "Allows the pipeline to access the S3 bucket and CodeBuild agent."
  policy      = data.aws_iam_policy_document.codepipeline-policy-document.json
}

resource "aws_iam_role_policy_attachment" "tf-cicd-pipeline-attachment" {
  policy_arn = aws_iam_policy.codepipline-policy.arn
  role       = aws_iam_role.codepipline-role.id
}

#Let the CodePipeline publish to the SNS topic.
resource "aws_iam_role_policy_attachment" "codepipeline-policies-attachment-sns-topic" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSIoTDeviceDefenderPublishFindingsToSNSMitigationAction"
  role       = aws_iam_role.codepipline-role.id
}


#iam policy for codebuild ------------------------------------------------------------------------------------------------------------------
resource "aws_iam_role" "codebuild-role" {
  name = "codebuild-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

data "aws_iam_policy_document" "codebuild-policies-document" {
  statement {
    sid       = ""
    actions   = ["s3:*", "codebuild:*", "logs:*"]
    resources = [aws_codebuild_project.build.arn]
    effect    = "Allow"
  }
}

resource "aws_iam_policy" "codebuild-policy" {
  name        = "codebuild-policy"
  path        = "/"
  description = "Codebuild policy that alows the codebuild agent to acses the s3 bucket and codebuild resosses"
  policy      = data.aws_iam_policy_document.codebuild-policies-document.json
}

resource "aws_iam_role_policy_attachment" "codebuild-attachment" {
  policy_arn = aws_iam_policy.codebuild-policy.arn
  role       = aws_iam_role.codebuild-role.id
}

#codedeploy roles -------------------------------------------------------------------------------------------------------------------------
resource "aws_iam_role" "codedeploy-role" {
  name = "codedeploy-role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : [
            "codedeploy.amazonaws.com",
            "ec2.amazonaws.com"
          ]
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

data "aws_iam_policy_document" "codedeploy-document" {
  statement {
    sid       = "VisualEditor0"
    effect    = "Allow"
    actions   = ["codedeploy:CreateDeployment"]
    resources = [aws_codedeploy_deployment_group.deploy_group.arn, aws_codedeploy_deployment_group.deploy_group1.arn]
  }
}

resource "aws_iam_policy" "codedeploy-create-deployment" {
  name        = "codedeploy-create-deployment"
  path        = "/"
  description = "Codedeploy policy"
  policy      = data.aws_iam_policy_document.codedeploy-document.json
}

#atach the policy dockument we made
resource "aws_iam_role_policy_attachment" "codedeploy-role-attachment" {
  policy_arn = aws_iam_policy.codedeploy-create-deployment.arn
  role       = aws_iam_role.codedeploy-role.id
}

#Lets codepipline interact with codedeploy
resource "aws_iam_role_policy_attachment" "codedeploy-role-codepipeline" {
  policy_arn = aws_iam_policy.codedeploy-create-deployment.arn
  role       = aws_iam_role.codepipline-role.id
}

#Lets us use codedeploy
resource "aws_iam_role_policy_attachment" "codedeploy-role-codedeploy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
  role       = aws_iam_role.codedeploy-role.id
}

#lets us interact with ECS
resource "aws_iam_role_policy_attachment" "codedeploy-role-ECS" {
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
  role       = aws_iam_role.codedeploy-role.id
}

#Lets us read form ouer s3 bucket
resource "aws_iam_role_policy_attachment" "codedeploy-role-AmazonS3ReadOnlyAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  role       = aws_iam_role.codedeploy-role.id
}


#Role for ec2 insteanses-------------------------------------------------------------------------------------------------------------------------
resource "aws_iam_role" "ec2-role" {
  name = "ec2-role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "sts:AssumeRole"
        ],
        "Principal" : {
          "Service" : [
            "ec2.amazonaws.com"
          ]
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2-attachment-s3-readonly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  role       = aws_iam_role.ec2-role.id
}

resource "aws_iam_role_policy_attachment" "ec2-attachment-deployRole" {
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
  role       = aws_iam_role.ec2-role.id
}

resource "aws_iam_role_policy_attachment" "ec2-attachment-instentmanger" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.ec2-role.id
}


#Create an S3 bucket
resource "aws_s3_bucket" "codepipeline_artifact" {
  bucket = var.bucket_name
}
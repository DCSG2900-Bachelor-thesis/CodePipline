#Create an SNS topic 
resource "aws_sns_topic" "approval_notifications" {
  name = "project-sns"
}
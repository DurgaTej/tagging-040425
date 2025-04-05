output "stackset_arn" {
  value = aws_cloudformation_stack_set.this.arn
  description = "value of the stackset arn"
}

output "stackset_id" {
  value = aws_cloudformation_stack_set.this.stack_set_id
  description = "value of the stackset id" 
}

output "ConfigLambdaRoleARN" {
  value = aws_cloudformation_stack_set_instance.this["us-east-1"].stack_id
  description = "ARN of the IAM Role for the AWS Config Custom Rule Lambda"
}
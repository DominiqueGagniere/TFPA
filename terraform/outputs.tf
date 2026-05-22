output "iam_role_arn" {
  description = "ARN of the IAM role"
  value       = aws_iam_role.ec2_manage_elasticip_role.arn
}

output "iam_role_name" {
  description = "Name of the IAM role"
  value       = aws_iam_role.ec2_manage_elasticip_role.name
}

output "iam_policy_arn" {
  description = "ARN of the IAM policy"
  value       = aws_iam_policy.elastic_ip_management_policy.arn
}

output "instance_profile_arn" {
  description = "ARN of the instance profile"
  value       = aws_iam_instance_profile.ec2_instance_profile.arn
}
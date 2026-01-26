output "security_group_id" {
  value       = aws_security_group.this.id
  description = "Security Group ID for EC2"
}

variable "region" {
  type        = string
  description = "AWS region"
  default     = "eu-north-1"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t3.micro"
}
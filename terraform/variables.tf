
# ------------------------------------
#    Virtual machine configurations 
# ------------------------------------

variable "www_configuration" {
  type        = map(any)
  description = "List of web virtual machines to be deployed"
}

variable "rproxymain_configuration" {
  type        = map(any)
  description = "List of main reverse proxy virtual machines to be deployed"
}

variable "rproxysec_configuration" {
    type        = map(any)
  description = "List of secondary reverse proxy virtual machines to be deployed"
}
# ------------------------------------
#    Automation configurations 
# ------------------------------------

variable "automation_useracc_name" {
    type        = string
    description = "Name of the automation user account"
    default     = "awsuser"
}

variable "automation_useracc_ssh_public_key" {
  type        = string
  description = "SSH public key for automation user account"
}

# ------------------------------------
#    Roles variables 
# ------------------------------------

variable "ec2_manage_elasticip_role_name" {
  description = "Name of the IAM role"
  type        = string
  default     = "ec2-manage-elasticip-role"
}

# ------------------------------------
#    Virtual machine configurations 
# ------------------------------------

variable "www_configuration" {
  type        = map(any)
  description = "List of web virtual machines to be deployed"
}

variable "rproxy_configuration" {
  type        = map(any)
  description = "List of reverse proxy virtual machines to be deployed"
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
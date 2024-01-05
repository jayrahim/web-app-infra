variable "vpc_cidr" {
  type        = string
  description = "The CIDR block of the VPC. If you overwrite the default value, you must also provide values for the subnet CIDRs, i.e., public_cidrs etc."
  default     = "10.0.0.0/16"
}

variable "enable_dns_support" {
  type        = bool
  description = "Whether to enable DNS support"
  default     = true
}

variable "enable_dns_hostnames" {
  type        = bool
  description = "Whether to enable DNS hostnames"
  default     = false
}

variable "enable_network_address_usage_metrics" {
  type        = bool
  description = "Whether to enable NAU metrics"
  default     = false
}

variable "public_cidrs" {
  type        = set(string)
  description = "The set of CIDRs for the public subnets"
  default     = []
}
variable "web_cidrs" {
  type        = set(string)
  description = "The set of CIDRs for the public subnets"
  default     = []
}
variable "app_cidrs" {
  type        = set(string)
  description = "The set of CIDRs for the public subnets"
  default     = []
}
variable "db_cidrs" {
  type        = set(string)
  description = "The set of CIDRs for the public subnets"
  default     = []
}
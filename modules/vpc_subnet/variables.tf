variable "owner" {
    type = string
    default = "arul"
    description = "Name of the owner"
}

variable "env" {
    type = string
    default = "training"
    description = "Environment type"
}

variable "ownermail" {
    type = string
    default = "arulprasathv@presidio.com"
    description = "Mail ID of the owner"
}
variable "vpc_cidr" {
  default = "16.0.0.0/16"
  description = "CIDR for the VPC"
}

variable "public_subnets_cidr" {
  type    = list(any)
  default = ["16.0.1.0/24", "16.0.11.0/24"]
  description = "Public subnet cidr"
}

variable "private_subnets_cidr" {
  type    = list(any)
  default = ["16.0.2.0/24", "16.0.22.0/24"]
  description = "private subnet cidr"
}

variable "availability_zones" {
  type    = list(any)
  default = ["us-east-1a", "us-east-1b"]
  description = "availability zones for the subnets"
}
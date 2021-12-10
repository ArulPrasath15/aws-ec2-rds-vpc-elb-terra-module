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
    description = "Mail ID of the owner"
}
variable "private_subnet_ids" {
    type = list
    default = []
    description = "private subnet ids"
}

variable "vpc_id" {
    type = string
    description = "VPC id"
}

variable "public_subnets_cidr" {
    type = list
    default = []
    description = "private subnets CIDR"
}
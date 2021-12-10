module "vpc_subnet" {
  source               = "./modules\\vpc_subnet"
  owner                = "arul"
  ownermail            = "arulprasathv@presidio.com"
  vpc_cidr             = "16.0.0.0/16"
  public_subnets_cidr  = ["16.0.1.0/24", "16.0.11.0/24"]
  private_subnets_cidr = ["16.0.2.0/24", "16.0.22.0/24"]
  availability_zones   = ["us-east-1a", "us-east-1b"]
}

data "aws_vpc" "vpc" {
  depends_on = [
    module.vpc_subnet
  ]
  filter {
    name   = "tag:Environmnet"
    values = ["training"]
  }
  filter {
    name   = "tag:Createdby"
    values = ["arulprasathv@presidio.com"]
  }
}

data "aws_subnet_ids" "public" {
  depends_on = [
    module.vpc_subnet,
    data.aws_vpc.vpc
  ]
  vpc_id = data.aws_vpc.vpc.id
  filter {
    name   = "tag:Environmnet"
    values = ["training"]
  }
  filter {
    name   = "tag:Createdby"
    values = ["arulprasathv@presidio.com"]
  }
  filter {
    name   = "tag:Tier"
    values = ["public"]
  }
}

data "aws_subnet_ids" "private" {
  depends_on = [
    module.vpc_subnet,
    data.aws_vpc.vpc
  ]
  vpc_id = data.aws_vpc.vpc.id
  filter {
    name   = "tag:Environmnet"
    values = ["training"]
  }
  filter {
    name   = "tag:Createdby"
    values = ["arulprasathv@presidio.com"]
  }
  filter {
    name   = "tag:Tier"
    values = ["private"]
  }
}


module "rds" {
  depends_on = [
    module.vpc_subnet
  ]
  source              = "./modules\\rds"
  owner               = "arul"
  ownermail           = "arulprasathv@presidio.com"
  vpc_id              = data.aws_vpc.vpc.id
  private_subnet_ids  = data.aws_subnet_ids.private.ids
  public_subnets_cidr = module.vpc_subnet.public_subnets_cidr
}

module "ec2" {
  depends_on = [
    module.vpc_subnet
  ]
  source            = "./modules\\ec2"
  owner             = "arul"
  ownermail         = "arulprasathv@presidio.com"
  instance_count    = 2
  instance_keypair  = "TrainingKey-Arul"
  instance_type     = "t2.micro"
  vpc_id            = data.aws_vpc.vpc.id
  public_subnet_ids = data.aws_subnet_ids.public.ids
  mysql_address     = module.rds.mysql_endpoint_dns
}

module "alb" {
  source            = "./modules\\alb"
  owner             = "arul"
  ownermail         = "arulprasathv@presidio.com"
  vpc_id            = module.vpc_subnet.vpc_id
  ec2_instances     = module.ec2.ec2_instances
  public_subnet_ids = module.vpc_subnet.public_subnet_ids

}

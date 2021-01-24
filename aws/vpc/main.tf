#--------------------------------------------------------------------------
# Create VPC, IGW, S3 Endpoint
#--------------------------------------------------------------------------

resource "aws_vpc" "vpc" {
  cidr_block = "${var.cidr_ab}.0.0/16"
  instance_tenancy = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  enable_classiclink = "false"
  tags = {
    Name = "${var.client}-${var.app}-${var.env}"
    App = var.app
    Env = var.env
    Client = var.client
    "Tech Lead" = var.techlead
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.client}-${var.app}-${var.env}-igw"
    App = var.app
    Env = var.env
    Client = var.client
    "Tech Lead" = var.techlead
  }
}

# Create VPC endpoint into S3
resource "aws_vpc_endpoint" "s3" {
  vpc_id = aws_vpc.vpc.id
  service_name = "com.amazonaws.${var.region}.s3"
  tags = {
    Name = "${var.client}-${var.app}-${var.env}-S3-endpoint"
    App = var.app
    Env = var.env
    Client = var.client
    "Tech Lead" = var.techlead
  }
}

#--------------------------------------------------------------------------
# Create subnets
#--------------------------------------------------------------------------

resource "aws_subnet" "elb_subnet" {
  count =  var.make_elb_subnets ? length(data.aws_availability_zones.available.names) : 0
  vpc_id = aws_vpc.vpc.id
  cidr_block = "${var.cidr_ab}.${local.cidr_c_elb_subnets + count.index}.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "${var.client}-${var.app}-${var.env}-elb-${data.aws_availability_zones.available.names[count.index]}"
    App = var.app
    Env = var.env
    Client = var.client
    "Tech Lead" = var.techlead
  }

}


resource "aws_subnet" "ec2_subnet" {
  count = var.make_ec2_subnets ? length(data.aws_availability_zones.available.names) : 0
  vpc_id = aws_vpc.vpc.id
  cidr_block = "${var.cidr_ab}.${local.cidr_c_ec2_subnets + count.index}.0/24"
  map_public_ip_on_launch = "false"
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "${var.client}-${var.app}-${var.env}-ec2-${data.aws_availability_zones.available.names[count.index]}"
    App = var.app
    Env = var.env
    Client = var.client
    "Tech Lead" = var.techlead
  }
}

resource "aws_subnet" "rds_subnet" {
  count = var.make_rds_subnets ? length(data.aws_availability_zones.available.names) : 0
  vpc_id = aws_vpc.vpc.id
  cidr_block = "${var.cidr_ab}.${local.cidr_c_rds_subnets + count.index}.0/24"
  map_public_ip_on_launch = "false"
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "${var.client}-${var.app}-${var.env}-rds-${data.aws_availability_zones.available.names[count.index]}"
    App = var.app
    Env = var.env
    Client = var.client
    "Tech Lead" = var.techlead
  }
}

resource "aws_subnet" "cache_subnet" {
  count = var.make_cache_subnets ? length(data.aws_availability_zones.available.names) : 0
  vpc_id = aws_vpc.vpc.id
  cidr_block = "${var.cidr_ab}.${local.cidr_c_cache_subnets + count.index}.0/24"
  map_public_ip_on_launch = "false"
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "${var.client}-${var.app}-${var.env}-cache-${data.aws_availability_zones.available.names[count.index]}"
    App = var.app
    Env = var.env
    Client = var.client
    "Tech Lead" = var.techlead
  }
}


#--------------------------------------------------------------------------
# Create DB subnet group
#--------------------------------------------------------------------------

resource "aws_db_subnet_group" "rds_subnet_group" {
  count       = var.make_rds_subnets ? 1 : 0
  name        = "${var.client}-${var.app}-${var.env} db subnet group"
  description = "DB subnet group for ${var.client}-${var.app}-${var.env}"
  subnet_ids  = aws_subnet.rds_subnet.*.id
  tags = {
    Name = "${var.client}-${var.app}-${var.env}-db-subnet-group"
    App = var.app
    Env = var.env
    Client = var.client
    "Tech Lead" = var.techlead
  }
}

#--------------------------------------------------------------------------
# Create Cache subnet group
#--------------------------------------------------------------------------

resource "aws_elasticache_subnet_group" "cache_subnet_group" {
  count      = var.make_cache_subnets ? 1 : 0
  name       = "${var.client}-${var.app}-${var.env}-cache-subnet-group"
  description = "Cache subnet group for ${var.client}-${var.app}-${var.env}"
  subnet_ids = aws_subnet.cache_subnet.*.id
}

#--------------------------------------------------------------------------
# Create NAT gateway
# (Can't create the gateway before the ELB subnets have been created)
#--------------------------------------------------------------------------

resource "aws_eip" "nat-eip" {
  count    = var.make_elb_subnets ? 1 : 0
  vpc      = true
  tags = { 
    Name = "${var.client}-${var.app}-${var.env}-nat-eip"
    App = var.app
    Env = var.env
    Client = var.client
    "Tech Lead" = var.techlead
  }
}

resource "aws_nat_gateway" "nat-gw" {
  count       = var.make_elb_subnets ? 1 : 0
  allocation_id = aws_eip.nat-eip[0].id
  subnet_id     = aws_subnet.elb_subnet[0].id
  depends_on = [aws_internet_gateway.igw]
  tags = {
    Name = "${var.client}-${var.app}-${var.env}-nat-gw"
    App = var.app
    Env = var.env
    Client = var.client
    "Tech Lead" = var.techlead
  }
}

#--------------------------------------------------------------------------
# Route tables
#--------------------------------------------------------------------------

# Create public route table
resource "aws_route_table" "route_public" {
  vpc_id = aws_vpc.vpc.id

  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.client}-${var.app}-${var.env}-public"
    App = var.app
    Env = var.env
    Client = var.client
    "Tech Lead" = var.techlead
  }
}

# Tie the subnets to the route
resource "aws_route_table_association" "rta_elb" {
  count = var.make_elb_subnets ? length(aws_subnet.elb_subnet) : 0
  subnet_id      = aws_subnet.elb_subnet[count.index].id
  route_table_id = aws_route_table.route_public.id
}

# Create private route table with the NAT
resource "aws_route_table" "route_private" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw[0].id
  }
  tags = {
    Name = "${var.client}-${var.app}-${var.env}-private"
    App = var.app
    Env = var.env
    Client = var.client
    "Tech Lead" = var.techlead
  }
}

# Tie the subnets to the route

resource "aws_route_table_association" "rta_db" {
  count = var.make_rds_subnets ? length(aws_subnet.rds_subnet) : 0
    subnet_id = aws_subnet.rds_subnet[count.index].id
    route_table_id = aws_route_table.route_private.id
}

resource "aws_route_table_association" "rta_web" {
  count = var.make_ec2_subnets ? length(aws_subnet.ec2_subnet) : 0
    subnet_id = aws_subnet.ec2_subnet[count.index].id
    route_table_id = aws_route_table.route_private.id
}

resource "aws_route_table_association" "rta_cache" {
  count = var.make_cache_subnets ? length(aws_subnet.cache_subnet) : 0
    subnet_id = aws_subnet.cache_subnet[count.index].id
    route_table_id = aws_route_table.route_private.id
}


# Tie the S3 VPC endpoint to the routes
resource "aws_vpc_endpoint_route_table_association" "rta_s3_private" {
    route_table_id = aws_route_table.route_private.id
    vpc_endpoint_id = aws_vpc_endpoint.s3.id
}
# Probably doesn't need an S3 VPC endpoint here, but just in case...
resource "aws_vpc_endpoint_route_table_association" "rta_s3_public" {
    route_table_id = aws_route_table.route_public.id
    vpc_endpoint_id = aws_vpc_endpoint.s3.id
}

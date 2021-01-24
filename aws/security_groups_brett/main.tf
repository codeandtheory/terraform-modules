#-------------------------------------------------------------------------------
# Security groups
#-------------------------------------------------------------------------------

resource "aws_security_group" "elb_public" {
  name        = "${var.app}-${var.env} ELB public SG"
  description = "Allow all incoming traffic on port 80 and 443"
  vpc_id      = var.vpc_id
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.anybody.cidr]
    description = var.anybody.description
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.anybody.cidr]
    description = var.anybody.description
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.anybody.cidr]
    description = var.anybody.description
  }
}

resource "aws_security_group" "elb_private" {
  name        = "${var.app}-${var.env} ELB private SG"
  description = "Allow traffic on port 80 and 443 from the office"
  vpc_id      = var.vpc_id
  dynamic "ingress" {
    for_each = var.allowed_ips
    content {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
      description = ingress.key
    }
  }
  dynamic "ingress" {
    for_each = var.allowed_ips
    content {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
      description = ingress.key
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.anybody.cidr]
    description = var.anybody.description
  }
}

resource "aws_security_group" "ssh_access" {
  name        = "${var.app}-${var.env} ssh SG"
  description = "Allow ssh access"
  vpc_id      = var.vpc_id
  dynamic "ingress" {
    for_each = var.allowed_ips
    content {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
      description = ingress.key
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.anybody.cidr]
    description = var.anybody.description
  }
}

resource "aws_security_group" "web_access" {
  name        = "${var.app}-${var.env} Web SG"
  description = "Allow traffic from the ELBs"
  vpc_id      = var.vpc_id
  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    security_groups = [
      aws_security_group.elb_public.id,
      aws_security_group.elb_private.id
    ]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.anybody.cidr]
    description = var.anybody.description
  }
}

resource "aws_security_group" "db_access" {
  name        = "${var.app}-${var.env} Database SG"
  description = "Database security group"
  vpc_id      = var.vpc_id
  ingress {
    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"
    security_groups = [
      aws_security_group.web_access.id,
      aws_security_group.ssh_access.id
    ]
  }
  ingress {
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"
    security_groups = [
      aws_security_group.web_access.id,
      aws_security_group.ssh_access.id
    ]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.anybody.cidr]
    description = var.anybody.description
  }
}

# Making one SG for caching, regardless if it's Redis or Memcached
resource "aws_security_group" "cache_access" {
  name        = "${var.app}-${var.env} Cache SG"
  description = "Cache security group"
  vpc_id      = var.vpc_id
  ingress {
    from_port = 11211
    to_port   = 11211
    protocol  = "tcp"
    security_groups = [
      aws_security_group.web_access.id,
      aws_security_group.ssh_access.id
    ]
  }
  ingress {
    from_port = 6379
    to_port   = 6379
    protocol  = "tcp"
    security_groups = [
      aws_security_group.web_access.id,
      aws_security_group.ssh_access.id
    ]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.anybody.cidr]
    description = var.anybody.description
  }
}

resource "aws_security_group" "github_access" {
  name        = "${var.app}-${var.env} Github hooks"
  description = "Github hooks"
  vpc_id      = var.vpc_id
  ingress {
    from_port = 9418
    to_port   = 9418
    protocol  = "tcp"
    cidr_blocks = [
      "140.82.112.0/20",
      "185.199.108.0/22",
      "192.30.252.0/22"
    ]
    description = "Github webhooks"
  }
  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = [
      "140.82.112.0/20",
      "185.199.108.0/22",
      "192.30.252.0/22"
    ]
    description = "Github webhooks"
  }
  ingress {
    from_port = 9418
    to_port   = 9418
    protocol  = "tcp"
    cidr_blocks = [
      "140.82.112.0/20",
      "185.199.108.0/22",
      "192.30.252.0/22"
    ]
    description = "Github webhooks"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.anybody.cidr]
    description = var.anybody.description
  }
}

resource "aws_security_group" "blazemeter_debug_access" {
  name        = "${var.app}-${var.env} Blazemeter debug access"
  description = "Blazemeter debug access"
  vpc_id      = var.vpc_id
  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = [
      "35.245.251.194/32",
      "35.245.160.5/32",
      "35.194.77.139/32",
      "35.194.88.224/32",
      "35.245.24.75/32",
      "35.221.19.213/32",
      "35.245.0.140/32",
      "35.245.200.243/32"
    ]
    description = "Blazemeter debug test engines"
  }
  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = [
      "35.245.251.194/32",
      "35.245.160.5/32",
      "35.194.77.139/32",
      "35.194.88.224/32",
      "35.245.24.75/32",
      "35.221.19.213/32",
      "35.245.0.140/32",
      "35.245.200.243/32"
    ]
    description = "Blazemeter debug test engines"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.anybody.cidr]
    description = var.anybody.description
  }
}

resource "aws_security_group" "blazemeter_api_access" {
  name        = "${var.app}-${var.env} Blazemeter API access"
  description = "Blazemeter API access"
  vpc_id      = var.vpc_id
  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = [
      "35.245.252.18/32",
      "35.236.217.19/32",
      "35.186.173.73/32",
      "35.199.53.148/32",
      "35.245.136.64/32",
      "35.245.204.146/32",
      "35.245.41.95/32",
      "35.245.208.98/32",
      "52.78.8.113/32",
      "13.228.103.209/32",
      "54.206.36.108/32",
      "35.182.204.102/32",
      "35.158.178.115/32",
      "52.31.195.35/32",
      "52.56.150.110/32",
      "13.58.142.246/32",
      "13.56.70.111/32",
      "34.209.230.88/32",
      "35.245.232.79/32",
      "34.64.185.248/32",
      "35.198.210.225/32",
      "35.244.89.90/32",
      "35.203.78.93/32",
      "35.234.97.23/32",
      "34.76.64.195/32",
      "35.246.9.61/32",
      "35.231.2.168/32",
      "35.236.93.4/32",
      "34.82.42.213/32"
    ]
    description = "Blazemeter API test engines"
  }
  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = [
      "35.245.252.18/32",
      "35.236.217.19/32",
      "35.186.173.73/32",
      "35.199.53.148/32",
      "35.245.136.64/32",
      "35.245.204.146/32",
      "35.245.41.95/32",
      "35.245.208.98/32",
      "52.78.8.113/32",
      "13.228.103.209/32",
      "54.206.36.108/32",
      "35.182.204.102/32",
      "35.158.178.115/32",
      "52.31.195.35/32",
      "52.56.150.110/32",
      "13.58.142.246/32",
      "13.56.70.111/32",
      "34.209.230.88/32",
      "35.245.232.79/32",
      "34.64.185.248/32",
      "35.198.210.225/32",
      "35.244.89.90/32",
      "35.203.78.93/32",
      "35.234.97.23/32",
      "34.76.64.195/32",
      "35.246.9.61/32",
      "35.231.2.168/32",
      "35.236.93.4/32",
      "34.82.42.213/32"
    ]
    description = "Blazemeter API test engines"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.anybody.cidr]
    description = var.anybody.description
  }
}

resource "aws_security_group" "cloudflare_access" {
  name        = "${var.app}-${var.env} Cloudflare access"
  description = "Allow Cloudflare incoming traffic on port 80 and 443"
  vpc_id      = var.vpc_id
  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = [
      "173.245.48.0/20",
      "103.21.244.0/22",
      "103.22.200.0/22",
      "103.31.4.0/22",
      "141.101.64.0/18",
      "108.162.192.0/18",
      "190.93.240.0/20",
      "188.114.96.0/20",
      "197.234.240.0/22",
      "198.41.128.0/17",
      "162.158.0.0/15",
      "104.16.0.0/12",
      "172.64.0.0/13",
      "131.0.72.0/22"
    ]
    description = "Cloudflare access"
  }
  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = [
      "173.245.48.0/20",
      "103.21.244.0/22",
      "103.22.200.0/22",
      "103.31.4.0/22",
      "141.101.64.0/18",
      "108.162.192.0/18",
      "190.93.240.0/20",
      "188.114.96.0/20",
      "197.234.240.0/22",
      "198.41.128.0/17",
      "162.158.0.0/15",
      "104.16.0.0/12",
      "172.64.0.0/13",
      "131.0.72.0/22"
    ]
    description = "Cloudflare access"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.anybody.cidr]
    description = var.anybody.description
  }
}

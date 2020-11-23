# Get the latest Centos7 AMI
data "aws_ami" "centos" {
  owners      = ["679593333241"]
  most_recent = true

  filter {
    name   = "name"
    values = ["CentOS Linux 7 x86_64 HVM EBS *"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

data "aws_ami" "ubuntu" {
    owners = ["099720109477"] # Canonical
    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }

}

#resource "aws_key_pair" "united" {
#  key_name   = "united"
#  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCR3wNkyO5PTnLk++/bzu9fAhRezZaM9jgk++Op29P35+C4uk20ir2HV6WqN3/GPjr7Q9swfbmnNRrAbrwH2Sn9lNu4Dvg4hvsoFUL7mwDEWeYjgvXNRb3x4WB6YdCMrhXM7oHfghJJ3y0LmRfR4eNXnKCE4jA757DrffYSVONlkP24eEy8N8x2tqpp1a1LsBvY0WKX43XwM3iPzhD/iSnR5tHwMgIMtyTnDqRxZnCLc2WmQpIVZR1M/x6uf3HLpoUWglnv1x/+AEnwEo2cKTamj59jrX5AknFsl0IHI7vP5chmYau4EH7hLUrm3pvZDxBT7RDrH+FZaKzuINf26bfx united"
#}

resource "aws_instance" "ec2_instance" {
  count = var.instance_count
  ami = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name = var.key_pair
  subnet_id = var.subnet_ids[(count.index % length(var.subnet_ids))]
  associate_public_ip_address = false
  vpc_security_group_ids = var.vpc_security_group_ids
  
  tags = {
    Name    = "${var.app}-${var.env}-${var.server_type}-${count.index + 1}"
    Env     = var.env
    App     = var.app
    Client  = var.client
    Tech Lead = var.techlead
  }
}


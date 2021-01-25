resource "tls_private_key" "this" {
  algorithm = "RSA"
}

module "key_pair" {
  source = "../../"

  key_name   = "${var.client}-${var.app}"
  public_key = tls_private_key.this.public_key_openssh

  tags = {
    App         = var.app
    Client      = var.client
    "Tech Lead" = var.techlead
  }
}


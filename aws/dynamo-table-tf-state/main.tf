# Create a dynamodb table for locking a Terraform state file

resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
  name           = "${var.client}-${var.app}-${var.env}-tf-state-lock"
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name   = "${var.client}-${var.app}-${var.env} DynamoDB TF State Lock Table"
    Client = var.client
    Env    = var.env
  }
}


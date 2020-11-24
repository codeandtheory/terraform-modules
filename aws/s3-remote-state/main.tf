# Create an S3 bucket to store the state file in
resource "aws_s3_bucket" "terraform-state-storage-s3" {
  bucket = "${var.app}-tf-remote-state"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name = "${var.app} TF remote state"
    Client = var.client
    Env = var.env
    Tech Lead = var.techlead
  }
}

# Create a dynamodb table for locking the state file
resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
  name = "${var.app}-tf-state-lock"
  hash_key = "LockID"
  read_capacity = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "${var.app} DynamoDB TF State Lock Table"
    Client = var.client
    Env = var.env
    Tech Lead = var.techlead
  }
}



resource "aws_s3_bucket" "bucket" {
  bucket        = var.s3_name
  versioning {
    enabled = true
  }
  lifecycle {
    prevent_destroy = true
  }
  tags          = merge(var.tags, map("Name", format("%s", var.s3_name)))
}

resource "aws_s3_bucket_policy" "private" {
  count  = var.allow_public != true ? 1 : 0
  bucket = aws_s3_bucket.bucket.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Action": ["s3:*"],
      "Effect": "Allow",
      "Resource": ["arn:aws:s3:::${var.s3_name}",
                   "arn:aws:s3:::${var.s3_name}/*"],
      "Principal": {
        "AWS": ["arn:aws:iam::${var.aws_account_id}:user/${var.aws_username}"]
      }
    }
  ]
}
EOF
}

resource "aws_s3_bucket_policy" "public" {
  count  = var.allow_public ? 1 : 0
  bucket = aws_s3_bucket.bucket.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Action": ["s3:*"],
      "Effect": "Allow",
      "Resource": ["arn:aws:s3:::${var.s3_name}",
                   "arn:aws:s3:::${var.s3_name}/*"],
      "Principal": {
        "AWS": ["arn:aws:iam::${var.aws_account_id}:user/${var.aws_username}"]
      }
    },
    {
      "Sid": "",
      "Action": [
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": ["arn:aws:s3:::${var.s3_name}",
                   "arn:aws:s3:::${var.s3_name}/*"],
      "Principal": {
        "AWS": "*"
      }
    }
  ]
}
EOF
}

resource "aws_iam_policy" "full_access_policy" {
  name        = "_S3_${var.s3_name}"
  description = "This policy gives full access to the ${var.s3_name} bucket"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetBucketLocation",
                "s3:ListAllMyBuckets"
            ],
            "Resource": [
                "arn:aws:s3:::*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:*"
            ],
            "Resource": [
                "arn:aws:s3:::${var.s3_name}",
                "arn:aws:s3:::${var.s3_name}/*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_policy" "read_only_policy" {
  name        = "_S3_${var.s3_name}_Read-Only"
  description = "This policy gives read-only access to the ${var.s3_name} bucket"
  
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket",
                "s3:ListAllMyBuckets"
            ],
            "Resource": "arn:aws:s3:::*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket",
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::${var.s3_name}",
                "arn:aws:s3:::${var.s3_name}/*"
            ]
        }
    ]
}
EOF
}


resource "aws_iam_policy" "hashistack" {
  name        = "hashistack"
  path        = "/"
  description = "Policy to allow AWS auto join HashiStack servers in cluster"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["ec2:DescribeInstances"]
        Effect   = "Allow"
        Sid      = "hashistack"
        Resource = "*"
      }
    ],
  })
}

resource "aws_iam_policy" "s3_hashistack" {
  name        = "s3_hashistack"
  path        = "/"
  description = "Policy for writing configurations to s3"
  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Action   = ["s3:PutObject", "s3:GetObject"]
        Effect   = "Allow"
        Sid      = "S3Hashistack"
        Resource = module.s3_bucket.s3_bucket_arn
      }
    ]
  })

}

# Create Role
resource "aws_iam_role" "hashistack" {
  name = "hashistack"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Attach Policy to Role
resource "aws_iam_policy_attachment" "hashistack" {
  name       = "hashistack"
  roles      = [aws_iam_role.hashistack.name]
  policy_arn = aws_iam_policy.hashistack.arn
}

resource "aws_iam_policy_attachment" "s3_hashistack" {
  name       = "s3_hashistack"
  roles      = [aws_iam_role.hashistack.name]
  policy_arn = aws_iam_policy.s3_hashistack.arn
}

resource "aws_iam_instance_profile" "hashistack" {
  name = "hashistack"
  role = aws_iam_role.hashistack.name
}

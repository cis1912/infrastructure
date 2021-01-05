// User
resource "aws_iam_user" "user" {
  name = var.pennkey

  tags = {
    created-by = "terraform"
  }
}

// Policy to allow user to assume any role
data "aws_iam_policy_document" "assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]
    resources = ["*"]
  }
}

// Allow user to assume roles
resource "aws_iam_user_policy" "policy" {
  name   = "assume-role"
  user   = aws_iam_user.user.name
  policy = data.aws_iam_policy_document.assume-role-policy.json
}

// Policy to allow iam user of same pennkey to assume role
data "aws_iam_policy_document" "allow-user-assume-role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [aws_iam_user.user.arn]
    }
  }
}

// Role
resource "aws_iam_role" "role" {
  name = var.pennkey

  assume_role_policy = data.aws_iam_policy_document.allow-user-assume-role.json

  tags = {
    created-by = "terraform"
  }
}


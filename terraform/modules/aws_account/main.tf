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
    actions   = ["sts:AssumeRole"]
    resources = ["*"]
  }
}

// Allow user to assume roles
resource "aws_iam_user_policy" "policy" {
  name   = "assume-role"
  user   = aws_iam_user.user.name
  policy = data.aws_iam_policy_document.assume-role-policy.json
}

resource "aws_iam_user_policy" "describe-cluster" {
  name   = "eks"
  user   = aws_iam_user.user.name
  policy = var.view_cluster
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

// Allow role to create an access key for the user
data "aws_iam_policy_document" "manage-user" {
  statement {
    actions = [
      "iam:CreateAccessKey",
      "iam:DeleteAccessKey",
      "iam:GetAccessKeyLastUsed",
      "iam:GetUser",
      "iam:ListAccessKeys",
      "iam:UpdateAccessKey"
    ]
    resources = [aws_iam_user.user.arn]
  }
}

resource "aws_iam_role_policy" "manage-user" {
  name   = "manage-user"
  role   = aws_iam_role.role.name
  policy = data.aws_iam_policy_document.manage-user.json
}

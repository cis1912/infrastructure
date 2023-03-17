data "aws_caller_identity" "current" {}

// User
# resource "aws_iam_user" "user" {
#   name = var.emails[var.pennkey]

#   tags = {
#     created-by = "terraform"
#   }
# }

// Policy to allow user to assume any role
data "aws_iam_policy_document" "assume-role-policy" {
  statement {
    actions   = ["sts:AssumeRole"]
    resources = [aws_iam_role.role.arn]
  }
}

// Allow user to assume roles
resource "aws_iam_user_policy" "policy" {
  name   = "assume-role"
  user   = var.emails[var.pennkey]
  policy = data.aws_iam_policy_document.assume-role-policy.json
}

resource "aws_iam_user_policy" "describe-cluster" {
  name   = "eks"
  user   = var.emails[var.pennkey]
  policy = var.view_cluster
}

// Policy to allow iam user of same pennkey to assume role
data "aws_iam_policy_document" "allow-user-assume-role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [format("arn:aws:iam::751852120204:user/%s", var.emails[var.pennkey])]
    }
  }
  statement {
    actions = ["sts:AssumeRoleWithSAML"]

    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.id}:saml-provider/PennWebLogin"]
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
    resources = [format("arn:aws:iam::751852120204:user/%s", var.emails[var.pennkey])]
  }
}

resource "aws_iam_role_policy" "manage-user" {
  name   = "manage-user"
  role   = aws_iam_role.role.name
  policy = data.aws_iam_policy_document.manage-user.json
}

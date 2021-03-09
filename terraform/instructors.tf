// Create IAM users for instructors
resource "aws_iam_user" "instructors" {
  for_each = local.instructors
  name     = each.key

  tags = {
    created-by = "terraform"
  }
}

// Allow instructors to describe eks cluster
resource "aws_iam_user_policy" "instructors-view" {
  for_each = local.instructors
  name     = "eks"
  user     = aws_iam_user.instructors[each.key].name
  policy   = data.aws_iam_policy_document.view-k8s.json
}

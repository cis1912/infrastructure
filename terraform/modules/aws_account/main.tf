resource "aws_iam_user" "user" {
  name = var.pennkey
  tags = {
    created-by = "terraform"
  }
}

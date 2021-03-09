// Configure all student aws accounts
module "aws_accounts" {
  for_each     = var.students
  source       = "./modules/aws_account"
  pennkey      = each.key
  view_cluster = data.aws_iam_policy_document.view-k8s.json
}

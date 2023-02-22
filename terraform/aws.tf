// Configure all aws accounts
module "aws_accounts" {
  for_each     = local.users
  source       = "./modules/aws_account"
  pennkey      = each.key
  emails       = local.emails
  view_cluster = data.aws_iam_policy_document.view-k8s.json
}

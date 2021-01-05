// Configure all student aws accounts
module "aws_accounts" {
  for_each = local.students
  source   = "./modules/aws_account"
  pennkey  = each.key
}

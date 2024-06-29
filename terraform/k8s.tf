// Configure all student k8s resources
# module "k8s_config" {
#   for_each = local.users
#   source   = "./modules/k8s_config"
#   pennkey  = each.key
# }

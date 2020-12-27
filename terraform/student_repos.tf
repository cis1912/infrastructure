// Student teams
resource "github_team" "student" {
  for_each = var.students
  name     = each.key
  privacy  = "secret"
}


// HWs
module "hws" {
  // Terraform doesn't allow for_each over objects, so we must translate our hws object into a map
  // Taken from https://www.terraform.io/docs/configuration/functions/flatten.html#flattening-nested-structures-for-for_each
  for_each    = { for hw in local.hws : "${hw.hw}-${hw.student}" => hw }
  source      = "./modules/hw_repo"
  hw          = each.value.hw
  pennkey     = each.value.student
  team-id     = github_team.student[each.value.student].id
  bot-team-id = github_team.bot.id
  published   = each.value.published
}

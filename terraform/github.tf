// Teams
resource "github_team" "teams" {
  for_each = local.users
  name     = each.key
  privacy  = "secret"
}

resource "github_team_membership" "team_membership" {
  for_each = local.users
  team_id  = github_team.teams[each.key].id
  username = each.value
  role     = "member"
}

// Student access
resource "github_membership" "org_membership" {
  for_each = var.students
  username = each.value
  role     = "member"
}

// HWs
module "hws" {
  // Terraform doesn't allow for_each over objects, so we must translate our hws object into a map
  // Taken from https://www.terraform.io/docs/configuration/functions/flatten.html#flattening-nested-structures-for-for_each
  for_each = {
    for hw in local.hws : "${hw.hw}-${hw.student}" => hw
    if hw != "hw0" && hw != "hw1" && hw != "hw2"
  }
  source      = "./modules/hw_repo"
  hw          = each.value.hw
  pennkey     = each.value.student
  team-id     = github_team.teams[each.value.student].id
  bot-team-id = github_team.bot.id
  published   = each.value.published
}

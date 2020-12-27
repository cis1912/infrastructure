// Add bot user to organization
resource "github_membership" "bot" {
  username = local.bot_user
  role     = "member"
}

// Create master GitHub homework repositories
resource "github_repository" "hw" {
  for_each    = local.published
  name        = each.key
  description = "${each.key} stubbed template"
  visibility  = "private"
  is_template = true
}

// Grant bot user push access to hw repos
resource "github_team" "bot" {
  name        = "bot"
  description = "Bot team"
  privacy     = "closed"
}

resource "github_team_membership" "bot" {
  team_id  = github_team.bot.id
  username = local.bot_user
  role     = "member"
}

resource "github_team_repository" "bot" {
  for_each   = local.published
  team_id    = github_team.bot.id
  repository = each.key
  permission = "push"
}

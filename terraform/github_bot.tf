// Add bot user to organization
resource "github_membership" "bot" {
  username = local.bot_user
  role     = "admin"

  # TODO: may not be possible
  lifecycle {
    prevent_destroy = true
  }
}

// Create master GitHub homework repositories
resource "github_repository" "hw" {
  for_each    = local.published
  name        = each.key
  description = "${each.key} stubbed template"
  visibility  = "private"
  is_template = true

  lifecycle {
    prevent_destroy = true
  }

  template {
    repository = each.key
    owner      = "cis1912"
  }
}

// Grant bot user push access to hw repos
resource "github_team" "bot" {
  name        = "cis1912-bot"
  description = "Bot team"
  privacy     = "closed"

  lifecycle {
    prevent_destroy = true
  }
}

resource "github_team_membership" "bot" {
  team_id  = github_team.bot.id
  username = local.bot_user
  role     = "member"

  lifecycle {
    prevent_destroy = true
  }
}

resource "github_repository_collaborators" "bot" {
  for_each = local.published

  repository = each.key

  user {
    permission = "admin"
    username   = local.bot_user
  }

  team {
    permission = "push"
    team_id    = github_team.bot.id
  }


  lifecycle {
    prevent_destroy = true
  }
}

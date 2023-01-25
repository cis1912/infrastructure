resource "github_repository" "hw" {
  count      = var.published ? 1 : 0
  name       = "${var.hw}-${var.pennkey}"
  visibility = "private"

  template {
    owner      = "cis1880"
    repository = var.hw
  }
}

resource "github_team_repository" "hw" {
  count      = var.published ? 1 : 0
  team_id    = var.team-id
  repository = github_repository.hw[0].name
  permission = var.hw != "hw4" ? "push" : "admin"
}

resource "github_team_repository" "bot" {
  count      = var.published ? 1 : 0
  team_id    = var.bot-team-id
  repository = github_repository.hw[0].name
  permission = "admin"
}

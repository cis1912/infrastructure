resource "github_repository" "hw" {
  count      = var.published ? 1 : 0
  name       = "${var.hw}-${var.pennkey}"
  visibility = "private"

  template {
    owner      = "cis1912"
    repository = var.hw
  }
}

resource "github_repository_collaborators" "hw" {
  count      = var.published ? 1 : 0
  repository = github_repository.hw[0].name

  user {
    permission = "admin"
    username   = "cis1912bot"
  }

  team {
    permission = var.hw != "hw4" ? "push" : "admin"
    team_id    = var.team-id
  }

  user {
    permission = "push"
    username   = var.github-username
  }
}

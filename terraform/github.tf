// Create master GitHub homework repositories
resource "github_repository" "hw" {
  for_each = local.hws
  name        = each.key
  description = "${each.key} stubbed template"
  visibility = "private"
}

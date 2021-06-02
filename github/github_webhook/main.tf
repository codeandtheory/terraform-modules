provider "github" {
  token        = var.github_token
  organization = var.github_organization
}

data "github_repository" "repo" {
  full_name = var.repo
}

resource "github_repository_webhook" "hook" {
  repository = data.github_repository.repo.name

  configuration {
    url          = var.url
    content_type = "json"
    insecure_ssl = false
    secret       = var.secret
  }
  active = true
  events = var.events
}

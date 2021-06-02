variable "repo" {
  type        = string
  description = "The path to the repo (`eg codeandtheory/my-repo`)"
}

variable "url" {
  type        = string
  description = "The webhook URL (eg `https://jenkins-ci.codeandtheory.net/github-webhook/`)"
}

variable "events" {
  type        = list(any)
  description = "Which events should be sent? (`https://developer.github.com/webhooks/`)"
  default     = ["push"]
}

variable "secret" {
  type        = string
  description = "Webhook secret"
}

variable "github_token" {
  type        = string
  description = "Github personal access token"
}

variable "github_organization" {
  type        = string
  description = "Github Organization/Username"
  default     = "codeandtheory"
}

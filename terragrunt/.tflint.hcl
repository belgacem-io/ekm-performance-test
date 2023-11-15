# explicit "terraform" plugin with version + source
plugin "terraform" {
  enabled = true
  version = "0.2.2"
  source  = "github.com/terraform-linters/tflint-ruleset-terraform"
}

# ...and the "google" plugin

plugin "google" {
  enabled    = true
  deep_check = false
  version    = "0.24.0"
  source     = "github.com/terraform-linters/tflint-ruleset-google"
}

config {
  format = "compact"
  plugin_dir = "~/.tflint.d/plugins"

  module = false
  force = false
  disabled_by_default = false
}

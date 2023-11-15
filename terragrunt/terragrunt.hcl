locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config("./env-vars.hcl")

  # Automatically load common variables
  common_vars = read_terragrunt_config(find_in_parent_folders("common-vars.hcl"))

  # Extract the variables we need for easy access
  module_name     = local.environment_vars.locals.module_name

}

# ---------------------------------------------------------------------------------------------------------------------
# TERRAGRUNT CONFIGURATION
# This is the configuration for Terragrunt, a thin wrapper for Terraform that helps keep your code DRY and
# maintainable: https://github.com/gruntwork-io/terragrunt
# ---------------------------------------------------------------------------------------------------------------------

# We override the terraform block source attribute here just for the QA environment to show how you would deploy a
# different version of the module in a specific environment.
terraform {
  source = "${dirname(find_in_parent_folders())}/../terraform//${local.module_name}"

  before_hook "tflint" {
    commands = ["apply", "plan"]
    execute  = ["tflint"]
  }
}


# ---------------------------------------------------------------------------------------------------------------------
# GLOBAL PARAMETERS
# These variables apply to all configurations in this subfolder. These are automatically merged into the child
# `terragrunt.hcl` config via the include block.
# ---------------------------------------------------------------------------------------------------------------------

# Configure root level variables that all resources can inherit. This is especially helpful with multi-envs configs
# where terraform_remote_state data sources are placed directly into the modules.
inputs = merge(
  local.common_vars.locals,
  local.environment_vars.locals
)
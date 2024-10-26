# resource "gitlab_group" "infrastructure_maintainers" {
#   name                   = "Infrastructure maintainers"
#   path                   = "infrastructure_maintainers"
#   description            = "Group for Infrastructure Engineers that are responsible for maintaining the Cloud infrastructure of the organization."
#   project_creation_level = "maintainer" # Only maintainers can create projects here

#   default_branch_protection_defaults {
#     allowed_to_push            = ["developer"]
#     allow_force_push           = true
#     allowed_to_merge           = ["developer", "maintainer"]
#     developer_can_initial_push = true
#   }
# }

# resource "gitlab_group" "developers" {
#   name                   = "Developers"
#   path                   = "developers"
#   description            = "Group for all developers."
#   project_creation_level = "developer" # Only maintainers can create projects here

#   default_branch_protection_defaults {
#     allowed_to_push            = ["developer"]
#     allow_force_push           = true
#     allowed_to_merge           = ["developer", "maintainer"]
#     developer_can_initial_push = true
#   }
# }

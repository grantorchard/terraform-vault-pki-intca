output "token_roles" {
  value = [
    module.yellow.role_name,
    module.orange.role_name
  ]
}
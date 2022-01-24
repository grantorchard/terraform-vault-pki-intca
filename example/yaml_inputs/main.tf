locals {
  // return the list of yaml files in the clusters directory.
  group_files = fileset(path.module, "./meshs/*.yaml")

  // write out the contents of all of the files in the group_files local variable.
  raw_inputs = [for v in local.group_files : yamldecode(file(v))]

  // check our yaml files for empty keys and fall back to default variables as needed
  processed_inputs = { for mesh in local.raw_inputs : mesh.mesh_name => {
    mesh_name                 = mesh.mesh_name
    root_ca_mount_path        = mesh.root_ca_mount_path
    common_name_suffix        = try(mesh.common_name_suffix, var.common_name_suffix)
    default_certificate_ttl   = try(mesh.default_certificate_ttl, var.default_certificate_ttl)
    maximum_certificate_ttl   = try(mesh.maximum_certificate_ttl, var.maximum_certificate_ttl)
    token_role_ttl            = try(mesh.token_role_ttl, var.token_role_ttl)
    additional_token_policies = try(mesh.additional_token_policies, var.additional_token_policies)
    }
  }
}

module "intermediate_ca" {
  source   = "github.com/grantorchard/terraform-vault-pki-intca"
  for_each = local.processed_inputs

  mesh_name                 = each.value.mesh_name
  root_ca_mount_path        = each.value.root_ca_mount_path
  common_name_suffix        = each.value.common_name_suffix
  default_certificate_ttl   = each.value.default_certificate_ttl
  maximum_certificate_ttl   = each.value.maximum_certificate_ttl
  token_role_ttl            = each.value.token_role_ttl
  additional_token_policies = each.value.additional_token_policies
}
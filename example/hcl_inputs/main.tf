module "yellow" {
  source = "github.com/grantorchard/terraform-vault-pki-intca"

  mesh_name          = "yellow"
  root_ca_mount_path = "pki_root_ca"
}

module "orange" {
  source = "github.com/grantorchard/terraform-vault-pki-intca"

  mesh_name                 = "orange"
  root_ca_mount_path        = "pki_root_ca"
  common_name_suffix        = "service mesh"
  default_certificate_ttl   = 24
  maximum_certificate_ttl   = 72
  token_role_ttl            = 24
  additional_token_policies = ["manage_self"]
}
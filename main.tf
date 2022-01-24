locals {
	# Removing spaces from the common name suffix
	common_name_suffix = trimspace(var.common_name_suffix)
	# The mount path should not have a leading or trailing slash
	root_ca_mount_path = trim("/", var.root_ca_mount_path)
}

# Create a mount for the new intermediate
resource "vault_mount" "this" {
	type = "pki"
	path = "pki_mesh_${var.mesh_name}"
	max_lease_ttl_seconds = var.maximum_certificate_ttl * 3600
	default_lease_ttl_seconds = var.default_certificate_ttl * 3600
}

# Generate the CSR against the intermediate mount
resource "vault_pki_secret_backend_intermediate_cert_request" "this" {
  backend = vault_mount.this.path
	type = "internal"
  common_name = "${var.mesh_name} ${local.common_name_suffix}"
	uri_sans = [
		"spiffe://${var.mesh_name}"
	]
}

# Get Root CA to generate certificate from CSR
resource "vault_pki_secret_backend_root_sign_intermediate" "this" {
	backend = var.root_ca_mount_path

	common_name = "${var.mesh_name} ${local.common_name_suffix}"
  csr = vault_pki_secret_backend_intermediate_cert_request.this.csr
	format = "pem"
}

# Add certificate to mount
resource "vault_pki_secret_backend_intermediate_set_signed" "this" {
	backend = vault_mount.this.path
	certificate = vault_pki_secret_backend_root_sign_intermediate.this.certificate
}

# Create a role that can be used to request certificate signing
resource "vault_pki_secret_backend_role" "this" {
	backend = vault_mount.this.path
	name = "${var.mesh_name}-dataplane-proxies"
	allowed_uri_sans = [
		"spiffe://default/*",
		"kuma://*"
	]
	key_usage = [
		"KeyUsageKeyEncipherment",
		"KeyUsageKeyAgreement",
		"KeyUsageDigitalSignature"
	]
  ext_key_usage = [
		"ExtKeyUsageServerAuth",
		"ExtKeyUsageClientAuth"
	]
  client_flag = true
  require_cn = false
  allowed_domains = ["mesh"]
  allow_subdomains = true
  basic_constraints_valid_for_non_ca = true
  max_ttl = var.maximum_certificate_ttl
  ttl = var.default_certificate_ttl
}

# Create a policy that grants access to the role
resource "vault_policy" "this" {
	name = "issue_cert_${var.mesh_name}"
	policy = templatefile("${path.module}/templates/issue.hcl.tmpl",
		{
			mount_path = vault_mount.this.path
			role_name = vault_pki_secret_backend_role.this.name
		}
	)
}

# Create a token role to generate a token with policy attached
resource "vault_token_auth_backend_role" "this" {
	role_name = vault_policy.this.name
	token_period = var.token_role_ttl * 3600
	allowed_policies = concat([vault_policy.this.name], var.additional_token_policies)
}
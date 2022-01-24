<!-- BEGIN_TF_DOCS -->
## Summary
This module generates the required objects in Vault to support the deployment of multiple intermediate CAs.
The included `policy.hcl` provides the permissions to run this module. Since the initial development work is to support a mesh deployment on Kubernetes, the included example leverages YAML files as an input mechanism.

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_vault"></a> [vault](#provider\_vault) | 3.2.x |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [vault_mount.this](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/mount) | resource |
| [vault_pki_secret_backend_intermediate_cert_request.this](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/pki_secret_backend_intermediate_cert_request) | resource |
| [vault_pki_secret_backend_intermediate_set_signed.this](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/pki_secret_backend_intermediate_set_signed) | resource |
| [vault_pki_secret_backend_role.this](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/pki_secret_backend_role) | resource |
| [vault_pki_secret_backend_root_sign_intermediate.this](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/pki_secret_backend_root_sign_intermediate) | resource |
| [vault_policy.this](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/policy) | resource |
| [vault_token_auth_backend_role.this](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/token_auth_backend_role) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_token_policies"></a> [additional\_token\_policies](#input\_additional\_token\_policies) | Extra policies that should be granted to the generated token, besides the ability to request certificates. An example 'manage self' policy is included in the templates directory of this module which is required in most cases. | `list(string)` | `[]` | no |
| <a name="input_common_name_suffix"></a> [common\_name\_suffix](#input\_common\_name\_suffix) | Combines with 'mesh\_name' to generate a common name for the intermediate certificate. | `string` | `"Service Mesh"` | no |
| <a name="input_default_certificate_ttl"></a> [default\_certificate\_ttl](#input\_default\_certificate\_ttl) | Default time to expiry (in hours) that the certificate will be issued with. | `number` | `24` | no |
| <a name="input_maximum_certificate_ttl"></a> [maximum\_certificate\_ttl](#input\_maximum\_certificate\_ttl) | Maximum time to expiry (in hours) that the certificate will be issued with. | `number` | `72` | no |
| <a name="input_mesh_name"></a> [mesh\_name](#input\_mesh\_name) | Used as a prefix for spiffe and also to generate the intermediate certificate common name (see 'common\_name\_suffix'). | `string` | n/a | yes |
| <a name="input_root_ca_mount_path"></a> [root\_ca\_mount\_path](#input\_root\_ca\_mount\_path) | This path to the mount for your root CA. This is required in order to sign your intermediate certificate. | `string` | `"pki"` | no |
| <a name="input_token_role_ttl"></a> [token\_role\_ttl](#input\_token\_role\_ttl) | The time to expiry (in hours) for tokens created from the token role. | `number` | `24` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_role_name"></a> [role\_name](#output\_role\_name) | n/a |
<!-- END_TF_DOCS -->
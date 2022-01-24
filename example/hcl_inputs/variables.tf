variable "common_name_suffix" {
  description = "Combines with 'mesh_name' to generate a common name for the intermediate certificate."
  type        = string
  default     = "Service Mesh"
}

variable "default_certificate_ttl" {
  description = "Default time to expiry (in hours) that the certificate will be issued with."
  type        = number
  default     = 24
}

variable "maximum_certificate_ttl" {
  description = "Maximum time to expiry (in hours) that the certificate will be issued with."
  type        = number
  default     = 72
}

variable "token_role_ttl" {
  description = "The time to expiry (in hours) for tokens created from the token role."
  type        = number
  default     = 24
}

variable "additional_token_policies" {
  description = "Extra policies that should be granted to the generated token, besides the ability to request certificates. An example 'manage self' policy is included in the templates directory of this module which is required in most cases."
  type        = list(string)
  default     = []
}

variable "root_ca_mount_path" {
  description = "This path to the mount for your root CA. This is required in order to sign your intermediate certificate."
  type        = string
  default     = "pki"
}
variable "name" {
  type        = string
  description = "Name for grouping resources in module"
}

variable "project" {
  type        = string
  description = "String identifying project (e.g., a GitHub repository) in which this module is used"
}

variable "filename" {
  type        = string
  description = "Path to Lambda deployment package"
  default     = "webflow-oidc-auth.zip"
}

variable "auth_api_route" {
  type        = string
  description = "Route relative to API host at which the auth API may be accessed"
  default     = "auth"
}

variable "additional_api_allow_origins" {
  type        = list(string)
  description = "Additional HTTP origins from which the auth API will permit CORS requests"
  default     = []
}

variable "oidc_issuer" {
  type        = string
  description = "Identity provider issuer URL according to the OpenID Connect Discovery specification"
}

variable "oidc_audience" {
  type        = string
  description = "Target audience for whom the identity provider issues tokens. Should be the client ID of the relying party"
}

variable "oidc_hosted_domain" {
  type        = string
  description = "Optional domain to which end-users must belong"
  default     = null
}

variable "webflow_site_domain" {
  type        = string
  description = "Webflow site domain for which authentication is being federated. E.g., foobar.webflow.io"
}

variable "webflow_site_password" {
  type        = string
  description = "Site password of Webflow site for which authentication is being federated"
}

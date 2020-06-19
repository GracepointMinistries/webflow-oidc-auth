# webflow-oidc-auth

[![main](https://github.com/GracepointMinistries/webflow-oidc-auth/workflows/main/badge.svg)](https://github.com/GracepointMinistries/webflow-oidc-auth/actions?query=workflow/main)

Reusable [AWS Lambda](https://aws.amazon.com/lambda) module for OIDC federated authentication for [Webflow](https://webflow.com) sites.

[Password protect](https://university.webflow.com/article/password-protect-your-site-or-web-pages) a Webflow site with a secret, and use the API provided by this module to exchange an [ID token](https://auth0.com/docs/tokens/concepts/id-tokens) for a cookie authenticating the client to the Webflow site without knowledge / use of the password.

## Example

Download the Lambda package:

```shell script
curl -L \
  -o webflow-oidc-auth.zip \
  "https://github.com/GracepointMinistries/webflow-oidc-auth/releases/download/${VERSION}/webflow-oidc-auth.zip"
```

Terraform:

```hcl-terraform
module "webflow_auth_api" {
  source                = "github.com/GracepointMinistries/webflow-oidc-auth//terraform-module"
  name                  = "auth-for-my-webflow-site"
  project               = "https://github.com/ghost/my-project"
  oidc_issuer           = "https://securetoken.google.com/my-gcp-project-id"
  oidc_audience         = "my-gcp-project-id"
  webflow_site_domain   = "foobar.webflow.io"
  webflow_site_password = "password"
}
```

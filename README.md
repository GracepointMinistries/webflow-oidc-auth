# webflow-oidc-auth

[![main](https://github.com/GracepointMinistries/webflow-oidc-auth/workflows/main/badge.svg)](https://github.com/GracepointMinistries/webflow-oidc-auth/actions?query=workflow/main)

Reusable [AWS Lambda](https://aws.amazon.com/lambda) module for [OpenID Connect](https://auth0.com/docs/protocols/oidc) federated authentication for [Webflow](https://webflow.com) sites.

## Use Case

[Password protect](https://university.webflow.com/article/password-protect-your-site-or-web-pages) a Webflow site with a secret, and use the API provided by this module to exchange an [ID token](https://auth0.com/docs/tokens/concepts/id-tokens) for a cookie with which an end-user may authenticate to the Webflow site.

This effectively gives your Webflow site poor-man's federated authentication, until such a time Webflow decides to support it natively. 🙃

## Usage

### Things You'll Need

1. A Webflow site with a [site password](https://university.webflow.com/article/password-protect-your-site-or-web-pages), and the password in question
2. An OpenID Connect identity provider and relying party<sup>1</sup>, and the IdP issuer URL<sup>2</sup> according to the [OpenID Connect Discovery specification](https://developers.google.com/identity/protocols/oauth2/openid-connect#discovery)
3. An [AWS account](https://aws.amazon.com) onto which to deploy the service ([AWS Lambda](https://aws.amazon.com/lambda) and [API GateWay](https://aws.amazon.com/api-gateway))


<sup>1</sup> In this example, we've set up a [Google Cloud](https://cloud.google.com) project through [Firebase](https://firebase.google.com), which will act as the relying party to Google as the identity provider, but you may use any OpenID connect compliant IdP.

<sup>2</sup> For Google Cloud / Firebase projects, the IdP issuer URL may be found at `https://securetoken.google.com/{YOUR_GCP_PROJECT_ID}`.

### Deployment

Download the latest release:

```shell script
curl -sL https://api.github.com/repos/GracepointMinistries/webflow-oidc-auth/releases/latest \
  | jq '.assets[] | select(.name == "webflow-oidc-auth.zip") | .browser_download_url' \
  | xargs curl -L -o webflow-oidc-auth.zip
```

Deploy using the provided [Terraform](https://www.terraform.io) module [`./terraform-module`](terraform-module)

E.g.:

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

When applied, the module output the API endpoint at which the API may be accessed.

End-user applications may then authenticate with your IdP (e.g., with the [Firebase client SDK](https://firebase.google.com/docs/libraries)) to obtain an ID token, and request:

```http request
POST /auth HTTP/1.1
Host: {YOUR_API_GW_ENDPOINT}
Authorization: Bearer {YOUR_ID_TOKEN}
Content-Type: application/json

{
  "path": "/"
}
```

to get back a cookie which will let them into the Webflow site.

# webflow-oidc-auth

[![main](https://github.com/GracepointMinistries/webflow-oidc-auth/workflows/main/badge.svg)](https://github.com/GracepointMinistries/webflow-oidc-auth/actions?query=workflow/main)

Reusable [AWS Lambda](https://aws.amazon.com/lambda) module for OIDC federated authentication for [Webflow](https://webflow.com) sites.

[Password protect](https://university.webflow.com/article/password-protect-your-site-or-web-pages) a Webflow site with a secret, and use the API provided by this module to exchange an [ID token](https://auth0.com/docs/tokens/concepts/id-tokens) for a cookie authenticating the client to the Webflow site without knowledge / use of the password.

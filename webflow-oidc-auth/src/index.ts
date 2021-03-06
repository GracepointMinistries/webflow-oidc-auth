import {APIGatewayProxyHandlerV2} from 'aws-lambda'
import fetch, {Response} from 'node-fetch'
import * as queryString from 'querystring'

function requireEnvVar(key: string): string {
  const value: string | undefined = process.env[key]

  if (value === undefined || value === '') {
    throw new Error(`Environment variable ${key} missing`)
  }

  return value
}

const OIDC_HD: string | undefined = process.env['OIDC_HD']
const WEBFLOW_SITE_AUTH_ENDPOINT: string = requireEnvVar('WEBFLOW_SITE_AUTH_ENDPOINT')
const WEBFLOW_SITE_PASSWORD: string = requireEnvVar('WEBFLOW_SITE_PASSWORD')

export const handler: APIGatewayProxyHandlerV2 = async ({requestContext, body}) => {
  const email: string | undefined = requestContext.authorizer?.jwt.claims.email as string

  if (OIDC_HD && !email?.endsWith(`@${OIDC_HD}`)) {
    return {
      statusCode: 403,
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        error: 'Forbidden',
        details: `Invalid claims: email=${email} does not belong to hosted domain ${OIDC_HD}`
      })
    }
  }

  const path: string | undefined = (body ? JSON.parse(body) : undefined)?.path

  if (!path) {
    return {
      statusCode: 400,
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        error: 'Bad Request',
        details: 'Invalid payload: missing required attribute .path'
      })
    }
  }

  const response: Response = await fetch(
    WEBFLOW_SITE_AUTH_ENDPOINT,
    {
      method: 'POST',
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: queryString.stringify({
        pass: WEBFLOW_SITE_PASSWORD,
        path: '/',
        page: path
      }),
      redirect: 'manual'
    }
  )

  const cookie = response.headers.get('set-cookie')

  if (response.status! >= 400 || !cookie) {
    return {
      statusCode: 500,
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        error: 'Internal server error',
        details: 'Error obtaining session cookie'
      })
    }
  }

  return {
    statusCode: 200,
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      cookie: cookie
    })
  }
}

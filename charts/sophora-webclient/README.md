# Sophora Webclient

This chart deploys a Sophora Webclient.

## What you need (requirements)

This chart requires the following already present in the target namespace:

* An ImagePullSecret for the subshell Docker Registry
* A secret containing the Sophora username and password (fields "username" and "password" by default - can be configured)

## Customize it (values.yaml)

You can use the following values to customize the deployment

| Parameter                                   | Description                                                                | Default                                         | Required |
|---------------------------------------------|----------------------------------------------------------------------------|-------------------------------------------------|----------|
| `sophora.authentication.secret.name`        | The name of the secret that contains the credentials to the Sophora server |                                                 | **yes**  |
| `sophora.authentication.secret.passwordKey` | The key in the secret that contains the password                           | `password`                                      | no       |
| `sophora.authentication.secret.usernameKey` | The key in the secret that contains the username                           | `username`                                      | no       |
| `webclient.image.name`                      | The name of the docker image                                               | `docker.subshell.com/sophora/sophora-webclient` | no       |
| `webclient.image.tag`                       | The tag of the docker image                                                | chart appVersion                                | no       |
| `webclient.binaryFilesBase64`               | A map of filename to base64 encoded file contents                          | The logo (logo.png)                             | no       |
| `webclient.configuration`                   | The Sophora webclient `application.yml` file                               |                                                 | **yes**  |
| `ingress.hosts`                             | An array of ingress hosts                                                  |                                                 | **yes**  |
| `ingress.annotations`                       | A map of additional ingress annotations                                    | `{}`                                            | no       |

## Changelog

### Version 1.3.0

* BREAKING: `image.version` was renamed to `image.tag`.

### Version 1.2.0

* `webclient.binaryFilesBase64` now accepts a map instead of an array.  

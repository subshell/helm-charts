# Sophora MobileClient

This chart deploys a Sophora MobileClient.

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
| `mobileclient.image.name`                      | The name of the docker image                                               | `docker.subshell.com/sophora/sophora-mobileclient` | no       |
| `mobileclient.image.version`                   | The version of the docker image                                            | `master`                                        | no       |
| `mobileclient.binaryFilesBase64`               | A map of filename to base64 encoded file contents                          | The logo (logo.png)                             | no       |
| `mobileclient.ingress.host`                    | The ingress host                                                           |                                                 | **yes**  |
| `mobileclient.ingress.annotations`             | Additional ingress annotations                                             | `{}`                                            | no       |
| `mobileclient.configuration`                   | The Sophora mobileclient `application.yml` file                            |                                                 | **yes**  |
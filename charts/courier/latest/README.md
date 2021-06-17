# Helm Chart: Courier

This chart deploys courier.

## What you need (requirements)

This chart requires the following already present in the target namespace:

* An ImagePullSecret for the subshell Docker Registry
* A secret containing username and password for Sophora, basicauth and the mail server.

## Example values.yaml

```yaml
image:
  repository: docker.subshell.com/sophora-courier/base
  pullPolicy: Always
  tag: # Overrides the image tag whose default is the chart appVersion.
  
imagePullSecrets: []

javaOptions: "-XX:MinRAMPercentage=50.0 -XX:MaxRAMPercentage=90.0 -XX:+AlwaysPreTouch"

service:
  type: LoadBalancer
  port: 80
  targetPort: 8080
  jolokiaPort: 1496
  jolokiaTargetPort: 1496

sophora:
  courier:
    config:
      server:
        port: 8080

        sophora:
          serverUrl: "http://my-server:1196"
          urlServletPath: "http://my-delivery.default.svc.cluster.local/system/servlet/urlService.servlet"
          channel: presse
          retryIntervalInMs: 5000
          maxRetries: 5
          noRetryErrorMessage: "Fehler: E-Mail/Newsletter hat keinen Inhalt."

        preview:
          urlServletPath: "http://my-delivery.default.svc.cluster.local/system/servlet/urlService.servlet"
          userExternalId: preview-user-courier

        propertyNames:
          distributorName: customer:name
          publicDistributor: customer:public

        logging:
          config: "config/logback/logback.xml"
          path: "/logs/"

        mail:
          useDeliveryToGenerateTemplate: true
          sendIntervalMs: 1000
          maxQueueSize: 200
          host: 10.5.0.2
          port: 25
          safeMode:
            enabled: true
            whitelist:
              - someone@subshell.com


resources:
  requests:
    memory: "3G"
    cpu: "0.5"
  limits:
    memory: "3.5G"
    cpu: "2"

secret:
  name: courier-credentials
  key:
    courier:
      username: username
      password: password
    basicauth:
      username: username
      password: password
    mail:
      username: username
      password: password
```
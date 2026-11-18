# Sophora Microfrontend Demo

This chart deploys the Sophora Microfrontend Demo as a single nginx application. Set `targetOrigin` to the URL of the microfrontend before installing:

Ingress is disabled by default; configure `ingress.hosts` and `ingress.tls` when enabling it. Gateway API `HTTPRoute` resources can be configured through `httpRoutes`.
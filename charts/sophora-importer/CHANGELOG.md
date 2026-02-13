# Changelog

## 2.5.0

- Updated HTTPRoute configuration for consistency with `httpRoute.matches` and `httpRoute.filters`. Deprecated `httpRoute.rules` in favor of new properties. Breaking: only first rule of `httpRoute.rules` is used!

## 2.4.0

- added optional HTTPRoute for Gateway API

## 2.3.0

- enable custom pod labels

## 2.2.1

- reimplement clusterIP

## 2.2.0

- fix type in service, remove clusterIP

## 2.1.0

- add optional extraIngress

## 2.0.5

- bump alpine-toolkit image version to 0.2.0 to update curl

## 2.0.4

- chart formatting

## 2.0.3

- link to sources at GitHub

## 2.0.2

- added service type configuration
- fixed the configuration of the fullNameOverride

## 2.0.1

- Removed creation of working directories, as this is now done by the importer itself
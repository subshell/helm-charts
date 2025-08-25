# Changelog

## 2.0.12
- link to sources at GitHub

## 2.0.11
- fix changelog YAML

## 2.0.10
- corrected the environment-variables for the ugc-multimedia statefulset: database-credentials and s3-credentials

## 2.0.9
- Add S3 connection for UGC

## 2.0.8
- Add service account name to pod. 

## 2.0.7
- All deployment secrets are optional now. You can use `env` in your `values.yaml` instead, or leave it empty.

## 2.0.6
- Add support for service accounts

## 2.0.3

- Add S3 submission connection for UGC

## 2.0.2 -- 2025-01-30

- Configured Server Port of UGC and UGC Multimedia is now used by ingress
- obsolete nginx/server-snippet has been removed from ingress

## 2.0.0 -- 2024-02-13

- UGC Multimedia can now be deployed along with UGC
- Configuration options in the values.yaml were restructured. An example configuration with the new structure can be found in the README.md.
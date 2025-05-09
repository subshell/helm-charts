# Sophora Export Job

A one-time Sophora Repo Exporter that runs as a k8s job and uploads the data to s3.

## 2.0.0 (Breaking changes)

* If the job is configured as a cronjob, it will no longer upload multiple files to S3. Previously, it included additional files for each day of the week. Use s3 retention policies instead.

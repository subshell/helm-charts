# Alerting Runbook

This document is a reference to the alerts that the Sophora Import Job can fire.

## Sophora Import Job

### `ImportJobMissedDocuments`
**Severity:** error

**Summary:** The job downloaded more files than it imported successfully.

**Remediation steps:**
* Check the container logs for obvious errors
* Check if there are connection issues between the importer and the Sophora Server

### `ImportJobDidNotDownloadAnyDocuments`
**Severity:** warning

**Summary:** The import job did not find any documents in the downloaded archives and hence cannot import anything.

**Remediation steps:**
* Check the container logs for obvious errors (e.g. errors while unzipping the .zip files - the downloaded files are counted after extracting the archives)
* Check if the downloaded .zip archives contain documents
* Check the job's configuration

### `ImportJobFailed`
**Severity:** critical

**Summary:** The import job did not complete successfully.

**Remediation steps:**
* Check the container logs for obvious errors
* Check if there are connection issues between the importer and the Sophora Server

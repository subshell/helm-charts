# Alerting Runbook

This document is a reference to the alerts that the Sophora Export Job can fire.

## Sophora Export Job

### SophoraExportJobDidNotExportDocuments
**Severity:** warning

**Summary:** The job did not export any documents

**Remediation steps:**

* Check the container logs for obvious errors
* Check the job's configuration, e.g. if the exporter is configured correctly
* Check whether the Sophora installation contains documents matching the exporter's configuration

### SophoraExportJobFailed
**Severity:** critical

**Summary:** The export job did not complete successfully.

**Remediation steps:**

* Check the container logs for obvious errors
* Check if there are connection issues between the exporter and the Sophora Server

### SophoraExportJobDidNotUpdate
**Severity:** warning

**Summary:** The job did not update metrics in the last 24 hours.

**Remediation steps:**

* If the job is not configured as a cronjob and is triggered manually consider removing this alerting rule
* Check whether the cronjob is suspended
* Check whether the job really did not run
* If the job did run: Check if the pushgateway url is configured correctly

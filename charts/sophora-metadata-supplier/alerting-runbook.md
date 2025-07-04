# Alerting Runbook

This document is a reference to the alerts that the Sophora Metadata Supplier can fire.

## Sophora Metadata Supplier

### MetadataSupplierJobQueueFull

**Severity:** high

**Summary:** The internal job queue of the Sophora Metadata Supplier exceeds a size of 1,000 for more than 10m.

**Remediation steps:**

* Check if the SMS is experiencing a higher volume of jobs than usual (e.g. triggered by imports)
* Check the logs of the SMS

# Alerting Runbook

This document is a reference to the alerts that the Sophora Metadata Supplier can fire.

## Sophora Metadata Supplier

### MetadataSupplierJobQueueFull

**Severity:** high

**Summary:** The internal job queue of the Sophora Metadata Supplier exceeds a size of 1,000 entries for more than 10 minutes.

**Remediation steps:**

* Check if the SMS is experiencing a higher volume of jobs than usual (triggered by imports, scheduled state changes etc.)
* Check the logs of the SMS, for example if a document has triggered a large amount of used sources
* Workaround: For sending content immediately, the client script "Trigger SMS" may be used which bypasses the queue.
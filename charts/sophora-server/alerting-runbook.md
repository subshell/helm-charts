# Alerting Runbook

This document is a reference to the alerts this Helm chart can fire.

## Sophora Server: General

### SophoraServerOffline

**Severity:** medium

**Summary:** The Sophora server is offline for more than 10 minutes.

**Remediation steps:**

* Check if the server is down for maintenance or incident remediation
* Check whether the server is in a crash loop
* Check the server logs for error messages
* Try to restart the server

### SophoraServerAPISlow

**Severity:** medium

**Summary:** The API of the server exhibits a response time exceeding 150ms for more than 5 minutes at the 95th percentile.

**Remediation steps:**

* Check if the server is experiencing a higher API call volume than usual (e.g. imports)
* Check the server's logs for errors that could be related to a slower API response time
* Check if the server has enough RAM and CPU at hand
* If the server is a staging server, consider scaling the statefulset up to cover higher loads
* Check if a newly added or modified server script is inefficient and adds an overhead to many API calls

## Sophora Server: State related alerts

### SophoraServerStateUnknown

**Severity:** medium

**Summary:** Sophora server's state is unknown

**Remediation steps:**

* Check the logs of the server

### SophoraServerStateSynchronizationDelayed

**Severity:** medium

**Summary:** Sophora server's synchronization is delayed

**Remediation steps:**

* Check the logs of the server
* See if the issue persists after waiting a little longer
* Try to fix the issue by restarting the server
* Check the logs of the primary server for any related errors

### SophoraServerStateQueueTooLong

**Severity:** medium

**Summary:** Sophora server's queue is too long and the server is not up to date

**Remediation steps:**

* Check the logs of the server
* See if the issue persists after waiting a little longer
* Try to fix the issue by restarting the server
* Check the logs of the primary server for any related errors

### SophoraServerStateUnavailable

**Severity:** medium

**Summary:** The Sophora server is unavailable and the cause should be investigated.

**Remediation steps:**

* Check the logs of the server
* Check the logs of the primary server for any related errors
* Restart the server

### SophoraServerStateConnectionLost

**Severity:** medium

**Summary:** The Sophora server is disconnected from its primary server and cannot receive replication events.

**Remediation steps:**

* Check if the primary server is running
* Check the logs of the server
* Check the logs of the primary server
* Check whether there are any network issues
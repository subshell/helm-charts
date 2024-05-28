# Alerting Runbook

This document is a reference to the alerts this Helm chart can fire.

## Sophora Server: General

### SophoraServerOffline

**Severity:** high

**Summary:** The Sophora server is offline for more than 10 minutes.

**Remediation steps:**

* Check if the server is down for maintenance or incident remediation
* Check whether the server is in a crash loop
* Check the server logs for error messages
* Try to restart the server

### SophoraServerAPISlow

**Severity:** high

**Summary:** The API of the server exhibits a response time exceeding 300ms for more than 15 minutes at the 95th percentile.

**Remediation steps:**

* Check if the server is experiencing a higher API call volume than usual (e.g. imports)
* Check the server's logs for errors that could be related to a slower API response time
* Check if the server has enough RAM and CPU at hand
* If the server is a staging server, consider scaling the statefulset up to cover higher loads
* Check if a newly added or modified server script is inefficient and adds an overhead to many API calls

### SophoraServerAsyncEventQueueBlocked

**Severity:** high

**Summary:** The internal event queue of the server "{{`{{ $labels.pod }}`}}" exceeds a size of 10,000 for more than 10m.

**Remediation steps:**

* Check the Sophora server logs for exceptions in the event processing. Look for logs with a message containing "An exception occurred while broadcasting an event"
* Check if all Sophora servers are effected
* Restart the server and monitor the metric sophora_server_events_number_of_asyc_events_waiting_to_be_processed
* If the error persists it is likely caused by a server side issue in the event processing or a malformed event. Please contact us.

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
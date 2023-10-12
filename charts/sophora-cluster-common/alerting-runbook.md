# Alerting Runbook

This document is a reference to the alerts this Helm chart can fire.

## Sophora Cluster Common

### NoPrimarySophoraServer

**Severity:** critical

**Summary:** The Sophora Cluster has no primary server. No operations with client tools will succeed and no further
replication will happen to other running servers, if there are any.

**Remediation steps:**

* Check if the Sophora cluster is down for another maintenance or incident remediation
* Check if the deployment has been uninstalled by mistake
* Check whether the server might have crashed
* Check the server logs for error messages
* Check if it would be possible to elect another cluster server to the primary. This should be done carefully to ensure no data is lost.
* Try to restart the server, if it is running but unresponsive
* Restore the server from a working backup

### SophoraServerNotInSync

**Severity:** high

**Summary:** The Sophora server is not in sync. This is concluded from comparing the server's *SourceTime* with the 
SourceTime of the primary server. The SourceTime is the timestamp of the latest event that occured on the primary server.
Usually the SourceTimes of the servers should not diverge too much and stay equal when compared over a short time frame.

**Remediation steps:**

* Check if the primary server logged a message containing "ReplicationMaster stopped". If yes: The primary server needs to be
restarted **without electing another server to the primary**. The last part is absolutely critical to prevent data loss. As
the servers automatically switch using a shutdown hook, a workaround is to exec into the container and replace the
shutdown hook located in the `/tools/` directory with an empty executable file before restarting the server. Note that during the restart 
working with Sophora will not be possible for a few minutes. If the error persists check the logs of the primary
to find error logs hinting at the root cause of the problem.
* Check if there is a large replication queue (e.g. due to a large amount of imports), which would result in a short replication
delay
* Check whether the not-in-sync server is in an erroneous state and stopped receiving replication messages
* Check whether network connection issues between the server and the primary server exist
* Check the server's and the primary server's logs for errors or warnings
* Restart the server
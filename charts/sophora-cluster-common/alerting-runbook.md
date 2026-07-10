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
* Check if it would be possible to elect another cluster server to the primary. This should be done carefully to ensure
  no data is lost.
* Try to restart the server, if it is running but unresponsive
* Restore the server from a working backup

### SophoraReplicaServerNotInSync

**Severity:** high

**Summary:** A Sophora replica server is not in sync. This alert applies only to replica servers, not to staging servers. It is triggered by comparing the 
replica server's *SourceTime* with the SourceTime of the primary server. The SourceTime is the timestamp of the latest event that occurred on the primary server.
Usually, the SourceTimes of replica servers should not diverge too much from the primary server and should stay equal when compared over a short time frame.

**Remediation steps:**

* Check if the primary server logged a message containing "ReplicationMaster stopped". If
  yes: The primary server needs to be
  restarted. If "ReplicationMaster stopped" is logged, this needs to happen **without electing another server to the
  primary**. The last part is absolutely critical to preventing data loss. Depending on the version of the Server Helm
  Chart
  you are using, there are two options to ensure this:
    * Server Helm Chart 2.1.0 and later: Give the server's Pod the
      annotation `prestop.server.sophora.cloud/switch-enabled: "false"`.
    * Before 2.1.0: As the servers automatically switch using a shutdown hook, a workaround is to exec into the
      container and replace the
      shutdown hook located in the `/tools/` directory with an empty executable file before restarting the server. Note
      that
      during the restart
      working with Sophora will not be possible for a few minutes. If the error persists check the logs of the primary
      to find error logs hinting at the root cause of the problem.
* Check if there is a large replication queue (e.g. due to a large amount of imports), which would result in a short
  replication
  delay
* Check whether the not-in-sync server is in an erroneous state and stopped receiving replication messages
* Check whether network connection issues between the server and the primary server exist
* Check the server's and the primary server's logs for errors or warnings
* Restart the server

### SophoraStagingServerNotInSync

**Severity:** high

**Summary:** A Sophora staging server is not in sync. This alert applies only to staging servers, not to replica servers.
It is triggered when the servers' state is `SYNCHRONIZATION_DELAYED` or `QUEUE_TOO_LONG`.

**Remediation steps:**

* Check if the primary server logged a message containing "StagingMaster stopped". If yes: The primary server needs to be restarted.
* Check if there is a large replication queue or a large amount of activity on the server, which could result in a short delay
* Check whether the not-in-sync staging server is in an erroneous state and stopped receiving staging messages
* Check whether network connection issues between the staging servers exist
* Check the staging servers' logs for errors or warnings
* Restart the affected staging server

### MultiplePrimarySophoraServers

**Severity:** critical

**Summary:** The Sophora Cluster has more than one server claiming to be the primary server.
Write operations with client tools can likely lead to inconsistencies in the entire Sophora cluster
that will need to be resolved manually.

**Remediation steps:**

* Check if a cluster switch is in progress and taking longer than expected to complete
* Restart all servers which should not be primary. To prevent these servers from switching automatically,
  give their pods the annotation `prestop.server.sophora.cloud/switch-enabled: "false"`(*)
* Check the server logs for error messages
* Make sure the servers are started in the correct order. Currently, servers can only have one remote-server configured.
  This means in a scenario with three or more cluster servers, it is possible that a server mistakenly assumes it should
  start
  as primary.
* Make sure the PDB is configured to only let one cluster server be down at the same time, which should prevent this
  from happening if the remote servers of each server are configured correctly in a loop. (e.g. 3 <- 1 <- 2 <- 3)
* If there are inconsistencies in the cluster (e.g. documents created in both primaries) see if these can be resolved
  manually.
  Else, restore the servers from a backup.

(*) This works starting with the Server Helm Chart 2.1.0 and the there included pre-stop hook 2.0.0.
Before, this can only be done by replacing the shutdown hook located in the `/tools/` directory of the server's
container with an empty executable file.
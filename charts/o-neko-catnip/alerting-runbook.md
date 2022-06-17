# Alerting Runbook

This document is a reference to the alerts that O-Neko catnip can fire.

## O-Neko Catnip

### OnekoCatnipDisconnected

**Severity:** error

**Summary:** O-Neko Catnip is not connected to the O-Neko main application and cannot work properly until this issue is resolved.

**Remediation steps:**

* Check whether the O-Neko main application is up and running
* Check whether Catnip has the correct credentials for the O-Neko main application
* Check the Catnip logs for error messages
* Check for network issues between Catnip and the O-Neko main application

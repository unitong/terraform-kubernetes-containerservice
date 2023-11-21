locals {
  hosts = [
    format("%s.%s.svc.%s", local.resource_name, local.namespace, local.domain_suffix)
  ]

  endpoints = length(local.external_ports) > 0 ? flatten([
    for c in local.hosts : formatlist("%s:%d", c, local.external_ports[*].external)
  ]) : []
}

#
# Orchestration
#

output "context" {
  description = "The input context, a map, which is used for orchestration."
  value       = var.context
}

output "refer" {
  description = "The refer, a map, including hosts, ports and account, which is used for dependencies or collaborations."
  sensitive   = true
  value = {
    schema = "k8s:deployment"
    params = {
      selector = local.labels
      hosts    = local.hosts
      ports    = length(local.external_ports) > 0 ? local.external_ports[*].external : []
    }
  }
}

#
# Reference
#

output "connection" {
  description = "The connection, a string combined host and port, might be a comma separated string or a single string."
  value       = join(",", local.endpoints)
}

output "connection_without_port" {
  description = "The connection without port, a string combined host, might be a comma separated string or a single string."
  value       = join(",", local.hosts)
}

## UI display

output "endpoints" {
  description = "The endpoints, a list of string combined host and port."
  value       = local.endpoints
}

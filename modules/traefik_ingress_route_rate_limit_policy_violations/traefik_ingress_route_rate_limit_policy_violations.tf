resource "shoreline_notebook" "traefik_ingress_route_rate_limit_policy_violations" {
  name       = "traefik_ingress_route_rate_limit_policy_violations"
  data       = file("${path.module}/data/traefik_ingress_route_rate_limit_policy_violations.json")
  depends_on = [shoreline_action.invoke_update_rate_limit]
}

resource "shoreline_file" "update_rate_limit" {
  name             = "update_rate_limit"
  input_file       = "${path.module}/data/update_rate_limit.sh"
  md5              = filemd5("${path.module}/data/update_rate_limit.sh")
  description      = "Increase the rate limit for the affected routes to accommodate the incoming traffic."
  destination_path = "/tmp/update_rate_limit.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_update_rate_limit" {
  name        = "invoke_update_rate_limit"
  description = "Increase the rate limit for the affected routes to accommodate the incoming traffic."
  command     = "`chmod +x /tmp/update_rate_limit.sh && /tmp/update_rate_limit.sh`"
  params      = ["NAMESPACE","DEPLOYMENT_NAME","NEW_RATE_LIMIT","ROUTE_NAME"]
  file_deps   = ["update_rate_limit"]
  enabled     = true
  depends_on  = [shoreline_file.update_rate_limit]
}


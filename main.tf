terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "traefik_ingress_route_rate_limit_policy_violations" {
  source    = "./modules/traefik_ingress_route_rate_limit_policy_violations"

  providers = {
    shoreline = shoreline
  }
}
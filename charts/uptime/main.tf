locals {

  uptime_kuma_vars = {
    ALB_SSL_REDIRECT     = "{\"Type\": \"redirect\", \"RedirectConfig\": {\"Protocol\": \"HTTPS\", \"Port\": \"443\", \"StatusCode\": \"HTTP_301\"}}"
    ALB_GROUP_NAME       = "bb-services"
    ALB_HEALTHCHECK_PATH = "/"
    ALB_LISTENING_PORTS  = "[{\"HTTP\": 80}, {\"HTTPS\": 443}]"
    ALB_SCHEME           = "internet-facing"
    ALB_TARGET_TYPE      = "ip"
    ING_HOSTNAME         = "uptime.dev.bb.vacuumlabs.com"
    ING_PATH             = "/"
    ING_PATH_TYPE        = "Prefix"

    IMAGE_REGISTRY   = "${data.aws_caller_identity.current.account_id}.dkr.ecr.eu-central-1.amazonaws.com"
    IMAGE_REPOSITORY = "quay/k3rnel-pan1c/uptime-kuma"
    IMAGE_TAG        = "latest"
  }

  uptime_ingress_values = templatefile("${path.module}/templates/ingress_alb.yaml", local.uptime_kuma_vars)

  default_uptime_kuma_helm_config = {
    name             = "uptime-kuma"
    chart            = "${path.module}/charts/uptime-kuma"
    version          = "1.0.1"
    namespace        = "bb-admin"
    create_namespace = true
    description      = "Uptime kuma Helm Chart deployment configuration."
  }

  uptime_kuma_helm_config = merge(
    local.default_uptime_kuma_helm_config,
    {
      values = [
        "${templatefile("${path.module}/templates/uptime_kuma.yaml", local.uptime_kuma_vars)}\n${local.uptime_ingress_values}"
      ]
    }
  )
}

data "aws_caller_identity" "current" {}

module "uptime_kuma" {
  source        = "git::https://github.com/aws-ia/terraform-aws-eks-blueprints.git//modules/kubernetes-addons/helm-addon?ref=v4.15.0"
  helm_config   = local.uptime_kuma_helm_config
  addon_context = {}
}

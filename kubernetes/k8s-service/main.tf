# @TODO Deprecate in favor of external-dns
resource "aws_route53_record" "record" {
  for_each = toset(var.records)
  zone_id  = var.route53_zone_id
  name     = each.key
  type     = "CNAME"
  ttl      = "60"
  records  = [var.load_balancer]
}

resource "null_resource" "helm_dependency_build" {
  count = var.build_chart ? 1 : 0
  triggers = {
    always = timestamp()
  }
  provisioner "local-exec" {
    command = <<-EOF
    helm repo add ${var.chart_repository_name} ${var.chart_repository_url}
    helm dependency build ${var.chart}
    echo "${var.depend_on}" > /dev/null
    EOF
  }
}

resource "helm_release" "release" {
  depends_on       = [null_resource.helm_dependency_build]
  name             = var.name
  chart            = var.chart
  version          = var.chart_version
  repository       = var.chart_repository_url
  namespace        = var.namespace
  timeout          = var.timeout
  wait             = var.wait
  values           = var.values_files
  create_namespace = var.create_namespace
  dynamic "set" {
    for_each = var.values_overrides
    content {
      name  = set.key
      value = set.value
    }
  }
}
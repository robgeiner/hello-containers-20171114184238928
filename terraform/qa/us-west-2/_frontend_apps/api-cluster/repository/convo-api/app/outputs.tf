output "name" {
  value = "${var.name}"
}

output "repository_url" {
  value = "twc-cognitive-${var.ENVIRONMENT}-docker.jfrog.io/${var.namespace}/${var.name}"
}

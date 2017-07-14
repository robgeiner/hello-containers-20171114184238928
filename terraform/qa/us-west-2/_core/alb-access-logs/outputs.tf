output "name" {
  value = "${var.PROJECT_BUCKET_PREFIX}-${var.ENVIRONMENT}-${var.REGION}-${var.bucket_suffix}"
}

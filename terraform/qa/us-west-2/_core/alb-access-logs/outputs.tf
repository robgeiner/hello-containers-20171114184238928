output "name" {
  value = "${var.PROJECT_BUCKET_PREFIX}-${var.ENVIRONMENT}-${var.bucket_suffix}"
}

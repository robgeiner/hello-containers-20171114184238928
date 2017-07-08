output "zone_id" {
  value = "Z3NZ1VOYE9MFRP"
}

output "domain" {
  value = "dev.cogads.weather.com"
}

output "certificate_arn" {
  value = "arn:aws:iam::${var.AWS_ACCOUNT_ID}:server-certificate/wildcard-dev.cogads.weather.com-2019-09-20"
}

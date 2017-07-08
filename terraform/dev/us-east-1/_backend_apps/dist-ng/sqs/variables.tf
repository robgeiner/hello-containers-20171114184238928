variable "sqs_queues" {
  type = "list"
  default = [
    "dist-ng-dev-apns",
    "dist-ng-dev-gcm",
    "dist-ng-dev-reporting",
    "dist-ng-dev-smtp",
    "dist-ng-tests-apns",
    "dist-ng-tests-gcm",
    "dist-ng-tests-reporting",
    "dist-ng-tests-smtp"
  ]
}

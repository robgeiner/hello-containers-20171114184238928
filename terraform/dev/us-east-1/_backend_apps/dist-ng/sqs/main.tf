resource "aws_sqs_queue" "queue" {
  name = "${element(var.sqs_queues, count.index)}"
  count = "${length(var.sqs_queues)}"
  delay_seconds = 0
  max_message_size = 262144
  visibility_timeout_seconds = 30
  message_retention_seconds = 345600
  receive_wait_time_seconds = 0
}

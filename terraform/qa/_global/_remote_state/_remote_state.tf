# Remote_state config, don't change

module "remote_state" {
  source        = "git@github.com:TheWeatherCompany/module-remote_state-terraform.git?ref=0.0.5"
  name          = "cognitive-devops-_qa__global__remote_state"
  bucket        = "cognitive-devops-qa-remote-state-bucket"
  bucket_region = "us-east-1"
  group         = "cognitive-devops"
  environment   = "qa"
}

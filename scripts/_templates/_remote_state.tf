# Remote_state config, don't change

module "remote_state" {
  source        = "git@github.com:TheWeatherCompany/module-remote_state-terraform.git?ref=0.0.5"
  name          = "OWNER_NAME-DIR_FLAT"
  bucket        = "REMOTE_STATE_BUCKET_NAME"
  bucket_region = "REGION"
  group         = "OWNER_NAME"
  environment   = "ENV"
}

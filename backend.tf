terraform {
  backend "s3" {
    bucket = "ecs_state"
    key    = "consul/terraform.tfstate"
    encrypt = "true"
    region = "us-east-1"
#    dynamodb_table = "prod_lock"
    profile = "contino-els-hgallo"
  }

  versioning {
      enabled = true
    }

  lifecycle {
    prevent_destroy = true
  }
}

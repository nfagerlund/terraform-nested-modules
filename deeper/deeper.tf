terraform {
  required_version = ">= 0.13"
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0.0"
    }
  }
}

variable "deeper_param" {
  default = "default from deeper config"
}

resource "null_resource" "deeper" {
  triggers = {
    deeper_param = var.deeper_param
  }
}

resource "null_resource" "many" {
    for_each = toset(["eh", "bee", "sea"])
    triggers = {
        deeper_param = var.deeper_param
        index = each.key
    }
}

resource "null_resource" "more" {
    count = 4
    triggers = {
        deeper_param = var.deeper_param
        index = count.index
    }
}

output "deeper_id" {
  value = "Changed to ${null_resource.deeper.id}"
}

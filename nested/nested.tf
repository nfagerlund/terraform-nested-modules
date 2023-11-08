terraform {
  required_version = ">= 0.13"
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0.0"
    }
  }
}

variable "my_param" {
  default = "default from inner config"
}

resource "null_resource" "inner" {
  triggers = {
    my_param = var.my_param
  }
}

module "deeper1" {
    source = "../deeper"
    deeper_param = "inner_${var.my_param}"
}

module "deeper2" {
    for_each = toset(["hey", "ho"])
    source = "../deeper"
    deeper_param = "inner_${each.key}_${var.my_param}"
}

output "inner_id" {
  value = "Changed to ${null_resource.inner.id}"
}

terraform {
  required_version = ">= 0.13"
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0.0"
    }
  }

  cloud {
    hostname = "tfe-zone-b0c8608c.ngrok.io"
    organization = "shadycorp"
    workspaces {
        name = "nov23-nested-modules"
    }
  }
}

variable "username" {
  default = "default from outer config"
}

resource "null_resource" "outer" {
  triggers = {
    username = var.username
  }
}

module "nested1" {
    source = "./nested"
    my_param = var.username
}

module "nested2" {
    source = "./deeper"
    deeper_param = "outer_${var.username}"
}

output "outer_id" {
  value = "Changed to ${null_resource.outer.id}"
}

output "inner_id" {
    value = "Here it is: ${module.nested1.inner_id}"
}

output "username" {
  value = "Username is ${var.username}. Extra text!!"
}

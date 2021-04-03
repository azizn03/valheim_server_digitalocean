

# Configure the DigitalOcean Provider
terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
    }
  }
}

provider "digitalocean" {
   token = var.do_token
}

data "digitalocean_ssh_key" "terraform" {
  name = "arch"
}

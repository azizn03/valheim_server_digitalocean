
resource "digitalocean_droplet" "centosbox" {
  image  = "centos-8-x64"
  name   = "Valheim-Server"
  region = "LON1"
  size   = "s-2vcpu-4gb"
  private_networking = "true"
  ssh_keys = [data.digitalocean_ssh_key.terraform.id]

    provisioner "remote-exec" {

    connection {
      user = "root"
      type = "ssh"
      private_key = file(var.git_private_key)
      timeout = "2m"
      host = digitalocean_droplet.centosbox.ipv4_address
    }
   }

   provisioner "local-exec" {
    command = "ansible-playbook -u root -i '${digitalocean_droplet.centosbox.ipv4_address},' --private-key ${var.git_private_key} ansible/playbooks/centosbox.yml" 
    }
   }

   resource "digitalocean_firewall" "firewall" {
   name = "Valheim-game-server"

  droplet_ids = [digitalocean_droplet.centosbox.id]
 
  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["11.11.11.11/32"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "2456-2458"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "udp"
    port_range       = "2456-2458"
    source_addresses = ["0.0.0.0/0", "::/0"]
 }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
 }
  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
  
  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}
output "ip" {
  value = digitalocean_droplet.centosbox.ipv4_address
}

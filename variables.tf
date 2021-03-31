
variable "do_token" {}

variable "ssh_fingerprint" {}

variable "git_private_key" {
    default = "ansible/inventory/ssh_keys/id_rsa"
}

variable "git_public_key" {
    default = "ansible/inventory/ssh_keys/id_rsa.pub"
}

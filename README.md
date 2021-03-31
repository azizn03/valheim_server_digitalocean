# valheim_server_digitalocean
Automated server setup for Valheim

SSH fingerprint and provider token are stored as variables on the local
machine.

Running the terraform script does the following.

1. Creates a droplet on digital ocean.
2. Runs ansible playbook against server to setup Valheim game server. This
   includes
  - [x] Installs the relevant packages needed to run steamcmd and Valheim.
  - [x] Installs steamcmd and the Valheim game.
  - [x] Open the relevant ports in the server using firewalld
  - [x] Runs the game server for 15 seconds to generate the map files
  - [x] Restores the map files from the previous backup.
  - [x] Runs the game server as a background process ensuring the game server runs
    without the need to log into the server.
  - [x] Attaches firewall rules to the droplet to ensure the right ports are
    forwarded.
3. Outputs the IP of the server.

A seperate ansible playbook named "backup_world" can be run to stop the server
and backup the map files locally then terraform destroy can be used.

# valheim_server_digitalocean
Automated server setup for Valheim

Using the power of DevOps tools I have created a script which providing you have access to a unix shell with docker installed it runs a set of commands using terraform and ansible to not only bring up a server, but it will configure the server and output an IP and you can simply connect to your Valhiem server from there.

The first thing that might come into mind is the cost. Well as most cloud service providers, they run off a pay for what you use model. The idea behind
this script is when you are done playing, you can run the stop server script
which will destroy the server so you will not be paying for the server when you are not using it. You can then simply run the
start and the restore script from there and carry on where you left off. For
reference with the current server size which handles three players just fine,
I am hosting the server for roughly 6-8 hours a day and it is costing me $3-$6
dollars a week. I will later add how to change the server size and region the
server is hosted in. 

## Prerequisites:

Very basic knowlege of Linux. i.e. knowing how to navigate through directories
and manipulate text files through the terminal.

Access to a Unix based terminal with Docker installed. (Look into creating a virtual machine via VirtualBox) or use wsl2 if you are using windows 10.

### Digital Ocean provider key.

Create an account on digital ocean, feel free to use my refferal code for $100 credit to use over 60 days: https://m.do.co/c/ab9254216e3f
After you created your account and have logged in, on the left tab at the
bottom you will see a link called "API" click on that then Generate a new token.
Call it whatever you want. Ensure you tick the Write(optional) box or this
won't work. We will use this key later. It is very very important you keep this
key safe. If anyone else has access to this key they can create resources using
your account and you will be paying for it. 

### SSH fingerprint

So first step, you need to register an SSH key on your digital ocean account.
you can either use your own SSH keys and place them in the
ansible/inventory/ssh_keys/ directory or you can run my generate_sshkeys.sh
script which generate and place the keys in there for you. From there go to your
digital ocean account and on the left tab again near the bottom and click on
settings which is near the API link we clicked on last time and then on the new page click on
"ADD SSH KEY" from there paste the contents of the id_rsa.pub file located in
the directory mentioned previously and call this "arch" or the script will not
work. You will then see a fingerprint field with a value that has alot of
colons. Copy that we will use this later. Again please keep this safe. 

### Variables. 

Now there should be a file named env-file and in there you need to paste your
digital ocean provider key after the TF_VAR_do_token and the SSH fingerprint
after the TF_VAR_ssh_fingerprint with no spaces or quotes so it looks something
like this.

```
TF_VAR_do_token=value
TF_VAR_ssh_fingerprint=value
```

### Add your IP address to the SSH firewall rule.

For the script to connect and configure the server we need to make sure we give
our IP address from the machine we are running the script from added the
firewall rule. Once you have your IP address simply navigate to
terraform/variables.tf. Just paste your IP in the home_ip field and keep the
/32 at the end so it looks something like 

```json
variable "home_ip" {
  default = "111.111.111.111/32"
}
```
### Using an existing map 

If you want to use an existing world then simply ensure your world folder is in
a zip folder named worlds.zip including the worlds folder itself not just the files so it looks
something like this

worlds.zip
  * worlds
     * .fwl files
     * .db files 

Simply place that in the ansible/worldbackup directory before running the container and after the start_server.sh script has finished simply run the restore_world.sh script and this will import the files for you. 

### Edit your game server script file

go to ansible/roles/server_setup/files and you should see
the start_server.sh file. Here you can give your server and the world a name
and choose the password. It is pretty self explanatory what needs changing.
I have added some place holders.

Now we can build our docker container and run the scripts we need.
Simply run the following command whilst in the root folder of the project.

```docker build . -t game_server```

So with all the pre requirement steps completed, everytime you want to play you
simply do the following. 

#### Starting and stopping the server

1. Navigate to root folder of the project.
2. If you want to play using your previously backed up map files, first put the worlds.zip folder in the ansible/worldsbackup folder then rebuild the container and follow the restore map files instructions
3. Run this command ```docker run --env-file ./env-file --name valhiem_server -v $pwd:/terraform -it --rm game_server bash```
4. Now you are inside the container. Run the start_server.sh script. (Ensure you stay inside the container as long as the server is running so you can stop it when finished playing.)
5. You will be given an IP address. Simply connect to your server with that IP and the port 2456 and your good to go. 
6. To stop the server when you are finished just run stop_server.sh
7. Make sure you backup your map files as shown below before exiting the container or you will lose your map files. 
8. Simply type ```exit``` to exit the container. 

#### Backing up your map files

1. First stop the server with stop_server.sh inside the container.
2. Open a new terminal as you will be running the following command outside the container whilst it is still running
3. Navigate to ansible/worldbackup 
4. run the commmand ```docker cp valhiem_server:/terraform/ansible/worldbackup/worlds.zip .```
5. You can now exit the container by typing ```exit```

#### Restore map files.

1. Place your worlds.zip folder structured as mentioned previously in the ansible/worldsbackup folder.
2. Use the docker build and run commands as previously mentioned
3. Ensure the server is running using the start_server.sh script. 
4. Run restore_world script. This will automatically pause the game server, restore the files then start the game server again with the new map. 

This project is a PoC of simple provisioner for cloud providers.
It uses python-terraform library to call terraform scripts.
FirstTest folder main.tf is creating a security-group and then an instance which uses this security-group.
nulltest folder is executing commands on an already created instance.

In order to run project locally, you need to set aws acces key, secret, ssh public key and private key file path as an env variable like that

export TF_VAR_access_key=""

export TF_VAR_secret_key=""

export TF_VAR_public_key=""

export TF_VAR_private_key_path=""


-----------------------------


1. Run command `export FLASK_APP=.terraform_test/main.py` 
2. Generate SSH keys by running command ssh-keygen -f ~/.ssh/hazelcast -t rsa
2. Open you laptop CLI and run the next command `mkdir ~/.aws && touch credentials`
3. Edit this file `~/.aws/credentials`  and put there the next text where placeholders are from previous setup. 
		
		
		[testing]
		aws_access_key_id = {Access key ID}
		aws_secret_access_key = {Secret access key}


This project is a PoC of simple provisioner for cloud providers.
It uses python-terraform library to call terraform scripts.
FirstTest folder main.tf is creating a security-group and then an instance which uses this security-group.
nulltest folder is executing commands on an already created instance.

In order to run project locally, you need to set aws acces key, secret, ssh public key and private key file path as an env variable like that

export TF_VAR_access_key=""

export TF_VAR_secret_key=""

export TF_VAR_public_key=""

export TF_VAR_private_key_path=""


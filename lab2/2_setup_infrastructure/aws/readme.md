# Deploy a Virtual Machine to Amazon AWS

This is an example of how to deploy a VM to AWS. You need to install `aws-cli` and `terraform` on your control host. (There are Docker images for [aws-cli](https://hub.docker.com/r/amazon/aws-cli) and [terraform](https://hub.docker.com/r/hashicorp/terraform/) available).

1. Create a new IAM user for programmatic access, attach AdministratorAccess to the policies put the provided AWS Access Key ID and Secret Access Key to a save place
2. Run `aws configure` and enter Access Key and Secret Access Key to the CLI. Now we can run control AWS remotely ;-)
3. Have a look at `main.tf` and figure out, what is going on there. We create a VM and connect it to the internet with an SSH key for access. Create/change the public ssh key to yours (public key=no worries).
4. Run `terraform init` in this directory to initialize terraform.
5. Run `terraform plan` to see what terraform would do if you run it.
6. Run `terraform apply` to perform the actions/changes. As output, the IP and hostname of the deployed VM is provided.
7. Run `ssh ubuntu@hostname` to check if you can connect to your VM.
8. Run `terraform destroy` to delete the deployment when you do not need it any longer.

---

Just for reference: the terraform docker command looks like this:
`docker run --rm -it -v $PWD:/data -v ~/.aws:/root/.aws -w /data hashicorp/terraform init|plan|apply|destroy`
(We mount the current and the .aws directory with the cloud credentials to the container, set the working directory, and run the terraform command).
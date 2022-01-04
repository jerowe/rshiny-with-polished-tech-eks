# README

This is a github repo to deploy a Kubernetes cluster on AWS (EKS) with terraform, and to add an RShiny app with [Polished Authentication](https://polished.tech/docs/01-get-started).

## Polished Authentication

Go through the [quickstart guide](https://polished.tech/docs/01-get-started) to sign up and grab your secret and app name.

## Deploy the Kubernetes Cluster

Grab the code!

```
git clone https://github.com/jerowe/rshiny-with-polished-tech-eks
```

### EKS Cluster Code

The recipe for the EKS cluster mainly comes from the [Terraform AWS EKS Module examples](https://github.com/terraform-aws-modules/terraform-aws-eks) and is in `auto-deployment/eks`. 

If you've never used terraform before its a very handy tool for deploying infrastructure! It's also not to bad to learn, and since they have so many prepackaged recipes you don't need to configure much on your own.

### Docker Image

I've built a minimal docker image that just logs you in with polished. It doesn't do anything else! The code is all in `rshiny-app-polished-auth`.

### Update the AWS Region

The region is set as `us-east-1`. If you need to change it take a look at `auto-deployment/eks/variables.tf` and `auto-deployment/terraform-state/main.tf`.

### Update the credentials

Make sure to update your polished API credentials in `auto-deployment/eks/variables.tf`.

```
# auto-deployment/eks/variables.tf
# CHANGE THESE!

...

# Then make sure to add your user to the app!
variable "POLISHED_APP_NAME" {
  default = "my_first_shiny_app"
}

# Grab this from the polished.tech Dashboard -> Account -> Secret
variable "POLISHED_API_KEY" {
  default = "XXXXXXXXXXXXXXXXXX"
}
``` 


## Clean up

If you'd like to get rid of your kubernetes cluster just

```
cd auto-deployment/terraform-state
terraform init; terraform refresh; terraform destroy -auto-approve
cd ../eks
terraform init; terraform refresh; terraform destroy -auto-approve
```

If anything times out and gets clobbered head on over to the AWS Console. First go to EC2 -> AutoScaling -> Autoscaling Groups and delete it. 

It's this url, except with your region - https://console.aws.amazon.com/ec2/autoscaling/home?region=AWS_REGION#AutoScalingGroups:view=details

Then you can either try the destroy command again, or just destroy from the AWS EKS console.

If you're really having issues [grab the script from AWS support](https://aws.amazon.com/premiumsupport/knowledge-center/troubleshoot-dependency-error-delete-vpc/), make some tea and delete the resources one by one.

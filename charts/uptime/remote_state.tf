data "terraform_remote_state" "eks" {
  backend = "s3"
  config  = {
    bucket       = "terraform-state-778785141721-eu-central-1-env-dev"
    key          = "infra/eks-cluster-bb-dev/terraform.tfstate"
    region       = "eu-central-1"
    role_arn     = "arn:aws:iam::778785141721:role/terraform_backend"
    session_name = "terraform"
  }
}

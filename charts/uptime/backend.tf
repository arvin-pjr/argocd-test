terraform {
  backend "s3" {
    bucket   = "terraform-state-778785141721-eu-central-1-env-dev"
    encrypt  = true
    key      = "workloads/eks-cluster-bb-dev/uptime-kuma/terraform.tfstate"
    region   = "eu-central-1"
    role_arn = "arn:aws:iam::778785141721:role/terraform_backend"
  }
}

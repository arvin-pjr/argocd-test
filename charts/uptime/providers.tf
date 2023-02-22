provider "aws" {
  assume_role {
    role_arn = "arn:aws:iam::778785141721:role/terraform_provider"
  }
  default_tags {
    tags = {
      Component = "Infrastructure"
      Account   = "env-dev"
    }
  }
}

provider "kubernetes" {
  host                   = data.terraform_remote_state.eks.outputs.eks_cluster_endpoint
  cluster_ca_certificate = base64decode(data.terraform_remote_state.eks.outputs.eks_cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args = [
      "eks", "get-token",
      "--cluster-name", data.terraform_remote_state.eks.outputs.eks_cluster_id,
      "--role-arn", "arn:aws:iam::778785141721:role/terraform_provider"
    ]
  }
}

provider "helm" {
  kubernetes {
    host                   = data.terraform_remote_state.eks.outputs.eks_cluster_endpoint
    cluster_ca_certificate = base64decode(data.terraform_remote_state.eks.outputs.eks_cluster_certificate_authority_data)

    exec {
      api_version = "client.authentication.k8s.io/v1"
      command     = "aws"
      # This requires the awscli to be installed locally where Terraform is executed
      args = [
        "eks", "get-token",
        "--cluster-name", data.terraform_remote_state.eks.outputs.eks_cluster_id,
        "--role-arn", "arn:aws:iam::778785141721:role/terraform_provider"
      ]
    }
  }
}

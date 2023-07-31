
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.15.4"

  cluster_name = "myapp-eks-cluster"  
  cluster_version = "1.27"

  subnet_ids = module.myapp-vpc.private_subnets
  vpc_id = module.myapp-vpc.vpc_id
  cluster_endpoint_public_access = true


  tags = {
    environment = "development"
    application = "myapp"
  }

  eks_managed_node_groups = {
    dev = {
      min_size     = 1
      max_size     = 2
      desired_size = 2

      instance_types = ["t3.micro"]
    }
  }
}



provider "kubernetes" {
    host = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      # This requires the awscli to be installed locally where Terraform is executed
      args = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
    }
}



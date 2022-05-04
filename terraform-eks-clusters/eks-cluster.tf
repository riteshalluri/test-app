module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "17.24.0"
  cluster_name    = local.cluster_name
  cluster_version = "1.20"
  subnets         = module.vpc.private_subnets

  vpc_id = module.vpc.vpc_id

  workers_group_defaults = {
    root_volume_type = "gp3"
  }

  worker_groups = [
    {
      name                          = "worker-group-1"
      instance_type                 = "t2.medium"
      additional_userdata           = "echo Hello"
      additional_security_group_ids = [aws_security_group.worker_group_mgmt_one.id]
      asg_desired_capacity          = 1
    },
  ]
}

# NODE GROUP
resource "aws_eks_node_group" "node-ec2" {
  cluster_name    = flatten( module.eks-eks.cluster_name)
  node_group_name = "t3_micro-node_group"
  subnet_ids      = flatten( module.vpc.private_subnets)

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  ami_type       = "AL2_x86_64"
  instance_types = ["t3.micro"]
  capacity_type  = "ON_DEMAND"
  disk_size      = 20

}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

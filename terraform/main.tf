module "ecs" {
  source = "./modules/ecs"
  cluster_name = "demo-cluster"
  service = {
    cat-gif-generator = {
      name = "cat-gif-generator"
    },
    clumsy-bird = {
      name = "clumsy-bird"
    }
  }
}
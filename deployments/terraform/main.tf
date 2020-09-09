module "academy-deploy" {
  source  = "fuchicorp/chart/helm"
  deployment_name        = "hello-world"
  deployment_environment = "${var.deployment_environment}"
  deployment_endpoint    = "${lookup(var.deployment_endpoint, "${var.deployment_environment}")}.${var.google_domain_name}"
  deployment_path        = "hello-world"
  template_custom_vars  = {
    deployment_image= "${var.deployment_image}"
   }
}
output "application_endpoint" {
    value = "${lookup(var.deployment_endpoint, "${var.deployment_environment}")}.${var.google_domain_name}"
}
variable  "deployment_image" {
    default = "docker.emilbek.com/hello-world-job-dev-feature:d0d2dfe"
}
variable "deployment_environment" {
    default = "qa"
}

variable "deployment_endpoint" {
    type = "map"
     default = {
        test  = "test.hello"
        dev  = "dev.hello"
        qa   = "qa.hello"
        prod = "hello"
        stage = "stage.hello"
  }
}
variable "google_domain_name" {
    default = "emilbek.com"
}
variable "google_bucket_name" {
    default = "fuchicorp-emil-343"
}
module "academy-deploy" {
  source  = "fuchicorp/chart/helm"

  deployment_name        = "hello-world"
  deployment_environment = "${var.deployment_environment}"
  deployment_endpoint    = "${lookup(var.deployment_endpoint, "${var.deployment_environment}")}.${var.google_domain_name}"
  deployment_path        = "hello-world"
<<<<<<< HEAD
  template_custom_vars  = {
    deployment_image = "${var.deployment_image}"
   }
=======

  template_custom_vars  = {     
    deployment_image     = "${var.deployment_image}"
  }
>>>>>>> c6f52c5c23a7c5ff57c546355fc91edf3209cee6
}


output "application_endpoint" {
    value = "${lookup(var.deployment_endpoint, "${var.deployment_environment}")}.${var.google_domain_name}"
}



variable  "deployment_image" {
    default = "docker.emilbek.com/hello-world-job-dev-feature:565b43e"
}

variable "deployment_environment" {
    default = "dev"
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
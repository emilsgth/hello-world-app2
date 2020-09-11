terraform {
  backend "gcs" {
    bucket  = "devoploadbalancer"
    prefix  = "stage/hello_world"
    project = "long-centaur-286100"
  }
}
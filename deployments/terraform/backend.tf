terraform {
  backend "gcs" {
    bucket  = "fuchicorp-emil-343"
    prefix  = "stage/hello_world"
    project = "long-centaur-286100"
  }
}

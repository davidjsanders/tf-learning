terraform {
 backend "gcs" {
   bucket  = "dsande2-terraform-admin"
   path    = "/terraform.tfstate"
   project = "dsande2-terraform-admin"
 }
}

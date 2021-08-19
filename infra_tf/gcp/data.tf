# Data for GCP module

# GCP data
# ----------------------------------------------------------

# NETWORK
data "google_compute_network" "default" {
  name = "default"
}

# OS IMAGE
data "google_compute_image" "os_image" {
  family  = "centos-8"
  project = "centos-cloud"
}

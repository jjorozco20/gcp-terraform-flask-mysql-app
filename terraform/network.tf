resource "google_compute_network" "vpc" {
  name                    = "devops-vpc"
  auto_create_subnetworks = false

  lifecycle {
    prevent_destroy = false
  }
}

resource "google_compute_subnetwork" "public_subnet" {
  name          = "public-subnet"
  region        = var.region
  network       = google_compute_network.vpc.id
  ip_cidr_range = "10.0.1.0/24"
}

resource "google_compute_address" "flask_vm_ip" {
  name   = "flask-vm-ip"
  region = var.region
}

resource "google_compute_global_address" "private_ip_range" {
  name          = "private-ip-range"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 24
  network       = google_compute_network.vpc.id
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.vpc.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_range.name]

  depends_on = [
    google_compute_global_address.private_ip_range
  ]

  lifecycle {
    prevent_destroy = false
  }
}

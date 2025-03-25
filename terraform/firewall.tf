resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "allow_flask" {
  name    = "allow-flask"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["5001"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "deny_mysql_external" {
  name    = "deny-mysql-external"
  network = google_compute_network.vpc.name

  deny {
    protocol = "tcp"
    ports    = ["3306"]
  }

  source_ranges = ["0.0.0.0/0"]
}
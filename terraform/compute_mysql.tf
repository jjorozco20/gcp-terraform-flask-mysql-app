resource "google_sql_database_instance" "mysql_server" {
  name             = "flask-mysql-db"
  region           = var.region
  database_version = "MYSQL_8_0"
  deletion_protection = false

  settings {
    tier = "db-f1-micro"  # Free tier machine type for MySQL

    backup_configuration {
      enabled = false
    }

    ip_configuration {
      ipv4_enabled = true
      private_network = google_compute_network.vpc.id
    }
  }
  depends_on = [google_service_networking_connection.private_vpc_connection]
}

resource "google_sql_user" "mysql_admin" {
  name     = var.mysql_admin_user
  instance = google_sql_database_instance.mysql_server.name
  password = var.mysql_admin_password

  depends_on = [google_sql_database_instance.mysql_server]
}

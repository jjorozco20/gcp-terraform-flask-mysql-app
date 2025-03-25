output "vm_public_ip" {
  description = "Public IP of the Flask VM"
  value       = google_compute_address.flask_vm_ip.address
}

output "mysql_private_ip" {
  description = "Private IP of MySQL server"
  value       = google_sql_database_instance.mysql_server.private_ip_address
}

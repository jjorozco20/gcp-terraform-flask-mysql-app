variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  default     = "us-central1"
}

variable "zone" {
  description = "GCP Zone"
  default     = "us-central1-a"
}

variable "vm_size" {
  description = "VM size for Flask app"
  default     = "e2-micro"
}

variable "admin_username" {
  default     = "gcpuser"
  description = "Admin username for VM"
}

variable "mysql_admin_user" {
  default     = "mysqladmin"
  description = "MySQL admin username"
}

variable "mysql_admin_password" {
  description = "MySQL admin password"
  type        = string
  sensitive   = true
}

variable "mysql_dbname" {
  description = "MySQL database name"
  type        = string
  default     = "flask-mysql-db"
}

variable "admin_user" {
  description = "Admin username"
  type        = string
}

variable "ssh_path" {
  description = "Path to SSH public key"
  type        = string
}

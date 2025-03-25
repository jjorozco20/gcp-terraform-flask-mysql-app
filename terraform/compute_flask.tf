resource "tls_private_key" "flask_vm_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key" {
  content  = tls_private_key.flask_vm_key.private_key_pem
  filename = "${path.module}/flask_vm_key.pem"
}

resource "local_file" "public_key" {
  content  = tls_private_key.flask_vm_key.public_key_openssh
  filename = "${path.module}/flask_vm_key.pub"
}

data "google_client_openid_userinfo" "me" {}

resource "google_os_login_ssh_public_key" "cache" {
  user = data.google_client_openid_userinfo.me.email
  key  = local_file.public_key.content
  project = var.project_id

  depends_on = [local_file.public_key]
}

# This is commented due to pipeline purposes, Terraform Cloud cannot run ansible-playbooks.
# resource "local_file" "ansible_inventory" {
#   content = <<-EOT
#     [flask_vm]
#     ${google_compute_address.flask_vm_ip.address}

#     [flask_vm:vars]
#     ansible_user=ubuntu
#     ansible_ssh_common_args='-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no'
#   EOT

#   filename = "${path.module}/provisioning/inventory.ini"
# }

resource "google_compute_instance" "flask_vm" {
  name         = "flask-vm"
  machine_type = var.vm_size
  zone         = var.zone
  tags         = ["flask-vm"]

  boot_disk {
    initialize_params {
      image = "ubuntu-2004-focal-v20250213"
    }
  }

  network_interface {
    network    = google_compute_network.vpc.name
    subnetwork = google_compute_subnetwork.public_subnet.name

    access_config {
      nat_ip = google_compute_address.flask_vm_ip.address
    }
  }

# This is commented due to pipeline purposes, Terraform Cloud cannot run ansible-playbooks.
  # metadata = {
  #   enable-oslogin = "TRUE"
  # }

  # provisioner "local-exec" {
  # command = <<-EOT
  #   sleep 20
  #   export ANSIBLE_HOST_KEY_CHECKING=False
  #   export DB_ENDPOINT="${google_sql_database_instance.mysql_server.private_ip_address}"
  #   export DB_NAME="${var.mysql_dbname}"
  #   export DB_USER="${var.mysql_admin_user}"
  #   export DB_PASS="${var.mysql_admin_password}"

  #   # Retrieve the temporary SSH key from Google Cloud
  #   gcloud compute os-login ssh-keys list --format="value(key)" > /tmp/flask_vm_key.pub

  #   # Run Ansible using gcloud SSH authentication
  #   ansible-playbook -i "${google_compute_address.flask_vm_ip.address}," \
  #     --private-key ${var.ssh_path} \
  #     -u ${var.admin_user} \
  #     ${path.cwd}/provisioning/deploy_docker.yml
  # EOT
  # }

  lifecycle {
    prevent_destroy = false
  }

  depends_on = [
    google_sql_database_instance.mysql_server
  ]
}

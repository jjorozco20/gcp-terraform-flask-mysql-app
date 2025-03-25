To retrieve the project and the billing account (and the org if you have one):
`gcloud beta billing accounts list`
`gcloud organizations list`
`gcloud projects list`

To authenticate Terraform: 
`gcloud auth application-default login`


poc.auto.tfvars

```
project_id      = "your-id"
region          = "us-central1" # Default
zone            = "us-central1-a" # Default
mysql_admin_user      = "mysqladmin" # Default
mysql_admin_password = "Testpassword!12" # Default
```

wsl --install











## Troubleshooting
To check logs for your userdata (provisioning side):
sudo journalctl -u google-startup-scripts.service -n 100

For now, you need to delete manually one resource. In `VPC Networks>Your VPC>VPC Network Peering>Your Peering`
this in order to destroy the things stopping you to delete whole infra

There's another method to do so, which is doing this
`terraform destroy -target="google_compute_instance.flask_vm`
then run terraform destroy normally.
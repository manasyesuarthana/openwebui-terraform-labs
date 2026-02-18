output "public_ip" {
  value = google_compute_instance.openwebui.network_interface[0].access_config[0].nat_ip
}

output "openwebui_password" {
  value     = random_password.password.result
  sensitive = true
}

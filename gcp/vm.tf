resource "google_service_account" "openwebui" {
  account_id   = "openwebui"
  display_name = "Custom SA for VM Instance"
}

data "google_compute_image" "debian" {
  family  = "debian-11"
  project = "debian-cloud"
}

resource "google_compute_firewall" "ssh" {
  name    = "ssh-access"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ssh"]
}

resource "google_compute_firewall" "http" {
  name    = "http-access"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http"]
}

resource "google_compute_instance" "openwebui" {
  name         = "openwebui"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  tags = ["ssh", "http"]

  boot_disk {
    initialize_params {
      image = data.google_compute_image.debian.self_link
      size  = 20
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }

  metadata_startup_script = file("${path.module}/scripts/provision_basic.sh")

  metadata = {
    ssh-keys = "openwebui:${file("")} openwebui" # add a public key path
  }


  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.openwebui.email
    scopes = ["cloud-platform"]
  }
}

resource "terracurl_request" "openwebui" {
  name   = "openwebui"
  url    = "http://${google_compute_instance.openwebui.network_interface[0].access_config[0].nat_ip}"
  method = "GET"

  response_codes = [200]
  max_retry      = 120
  retry_interval = 10
}

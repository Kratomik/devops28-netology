
resource "yandex_compute_instance" "test" {
  name        = var.vms_resources.vm2["name"]
  platform_id = var.vms_resources.vm2["platform_id"]
  resources {
    cores         = var.vms_resources.vm2["cores"]
    memory        = var.vms_resources.vm2["memory"]
    core_fraction = var.vms_resources.vm2["core_fraction"]
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  metadata = var.metadata

}


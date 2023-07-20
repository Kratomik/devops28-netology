/*
resource "yandex_compute_instance" "vm" {
  for_each = local.resource_map_key
  name     = each.value.vm_name
  resources {
  cores    = each.value.cores
  memory   = each.value.memory
  core_fraction = 5
  }
    boot_disk {
    initialize_params {
      size     = each.value.size
      image_id = data.yandex_compute_image.ubuntu-2004-lts.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${local.file}"
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }
  allow_stopping_for_update = true
}
*/

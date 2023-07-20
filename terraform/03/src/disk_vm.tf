resource "yandex_compute_disk" "volume" {
  count = 3
  size  = 1
}

resource "yandex_compute_instance" "vm-1" {
  name            = "storage"
  platform_id     = "standard-v1"
  resources {
    cores         = 2
    memory        = 2
    core_fraction = 5
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }
  dynamic "secondary_disk" {
    for_each = ["fhm2o026uehanrn9mhj6", "fhm63q29ih4vpt4t9nni", "fhmr2a31c102n50pm0ko"]
    content {
      disk_id = secondary_disk.value
    }
  }
}

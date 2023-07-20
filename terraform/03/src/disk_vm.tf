resource "yandex_compute_disk" "volume" {
  count = 3
  size  = 1
}

resource "yandex_compute_instance" "vm1" {
  for_each = local.disk_vm
  name     = each.value.vm_name
  resources {
    cores         = each.value.cores
    memory        = each.value.memory
    core_fraction = 5
  }

  boot_disk {
    initialize_params {
      size     = each.value.size
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }
  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }
  depends_on = [yandex_compute_instance.vm]
/*
  dynamic "secondary_disk" {
    for_each = ["fhmbvnojc61r0939m2m1", "fhmeqkd3hugils03vjq5", "fhmip3pu7p0gbkqbqjl2"]
    content {
      disk_id = secondary_disk.value
    }
*/
  }




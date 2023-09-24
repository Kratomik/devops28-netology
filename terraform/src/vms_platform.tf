
resource "yandex_compute_instance" "vm2" {
  name        = var.vm_db_name
  platform_id = var.vm_db_platform_id
  resources {
    cores         = var.vm_db_resources["cores"]
    memory        = var.vm_db_resources["memory"]
    core_fraction = var.vm_db_resources["core_fraction"]
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.centos7.image_id
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


variable "vm_db_name" {
  type        = string
  default     = "vm-2"
  description = "Name web-platforms"
}

variable "vm_db_platform_id" {
  type        = string
  default     = "standard-v1"
  description = "Platform_id"
}

variable "vm_db_cores" {
  type        = number
  default     = "2"
  description = "Количество vCPU"
}

variable "vm_db_memory" {
  type        = number
  default     = "4"
  description = "Количество памяти"
}

variable "vm_db_core_fraction" {
  type        = number
  default     = "20"
  description = "Доля загрузки каждого ядра в %"
}

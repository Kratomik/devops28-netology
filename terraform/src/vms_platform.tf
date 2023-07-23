/*
variable "vm_web_name" {
  type        = string
  default     = "netology-develop-platform-web"
  description = "Name web-platforms"
}

variable "vm_web_platform_id" {
  type        = string
  default     = "standard-v1"
  description = "Platform_id"
}

variable "vm_veb_cores" {
  type        = number
  default     = "2"
  description = "Количество vCPU"
}

variable "vm_veb_memory" {
  type        = number
  default     = "1"
  description = "Количество памяти"
}

variable "vm_veb_core_fraction" {
  type        = number
  default     = "5"
  description = "Доля загрузки каждого ядра в %"
}

*/
/*
resource "yandex_vpc_network" "develop-1" {
  name = var.vpc_name
}

resource "yandex_vpc_subnet" "develop-1" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}
*/
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

/*
variable "vm_db_name" {
  type        = string
  default     = "netology-develop-platform-db"
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
  default     = "2"
  description = "Количество памяти"
}

variable "vm_db_core_fraction" {
  type        = number
  default     = "20"
  description = "Доля загрузки каждого ядра в %"
}
*/

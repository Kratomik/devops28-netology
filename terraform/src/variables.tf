###cloud vars
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network & subnet name"
}

variable "vm_web_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "install OC"
}

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


variable "vm_web_resources" {
  type        = map(string)
  default     = {
    cores      = "2"
    memory     = "1"
    core_fraction = "5"
  }
}


variable "vm_db_resources" {
  type        = map
  default     = {
    cores      = 2
    memory     = 2
    core_fraction = 20    
  }
}

*/

variable "env" {
  type        = string
  default     = "develop"
}

variable "project" {
  type        = string
  default     = "analitics"
}

variable "role" {
  type        = string
  default     = "airflow"
}


variable "metadata" {
  type = map(any)
  default = {
    "ssh-keys"           = "ubuntu:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK7LDD/Df/YYEDcZPQfzkvrUsbbG3Vbm1SrSKKSTTjDl nicolay@nicolay-VirtualBox"
    "serial-port-enable" = 1
  }
}

variable "vms_resources" {
  description = "Configi VM"
  type        = map(object({
    name               = string
    cores              = number
    memory             = number
    size               = number
    core_fraction      = number
    platform_id        = string
    ssh-keys           = string
    serial-port-enable = number
  }))    
}



###ssh vars

variable "vms_ssh_root_key" {
  type        = string
  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK7LDD/Df/YYEDcZPQfzkvrUsbbG3Vbm1SrSKKSTTjDl nicolay@nicolay-VirtualBox"
  description = "ssh-keygen -t ed25519"
}



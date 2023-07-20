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
  description = "VPC network&subnet name"
}

variable "cpu-ram-disk" {
  description = "Ресурсы виртуальных машин"
  type = list(object({
    vm_name = string,
    cores  = number,
    memory  = number,
    size = number
  }))
}

/*
variable "volume" {
  description = "Disk_id vm"
  type = list(object({
    disk_id = string
  }))
}
*/

variable "public_key" {
  description = "Публичный ключ"
  type        = string
  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK7LDD/Df/YYEDcZPQfzkvrUsbbG3Vbm1SrSKKSTTjDl nicolay@nicolay-VirtualBox"
}
###ssh vars
/*
variable "vms_ssh_root_key" {
  type        = string
  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK7LDD/Df/YYEDcZPQfzkvrUsbbG3Vbm1SrSKKSTTjDl nicolay@nicolay-VirtualBox"
  description = "ssh-keygen -t ed25519"
}
*/

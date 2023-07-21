/*
resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}


#создаем облачную сеть
resource "yandex_vpc_network" "develop" {
  name = "develop"
}

#создаем подсеть
resource "yandex_vpc_subnet" "develop" {
  name           = "develop-ru-central1-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = ["10.0.1.0/24"]
}
*/

module "vpc" {
  source = "./modules/yc_network"
  token     = var.token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
}

module "test-vm" {
  source          = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"
  env_name        = "develop"
  network_id      = "yandex_vpc_network.test_id"
  subnet_zones    = ["ru-central1-a"]
  subnet_ids      = [ "yandex_vpc_subnet.test_id" ]
  instance_name   = "web"
  instance_count  = 1
  image_family    = "ubuntu-2004-lts"
  public_ip       = true

  metadata = {
      user-data          = data.template_file.cloudinit.rendered #Для демонстрации №3
      serial-port-enable = 1
  }

}


#Пример передачи cloud-config в ВМ для демонстрации №3
data template_file "cloudinit" {
  template = file("${path.module}/cloud-init.yml")

  vars = {
    public_key     = file(var.ssh_public_key)
  }
}


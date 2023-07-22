#создаем облачную сеть
resource "yandex_vpc_network" "test" {
  name = var.vpc_name
}

#создаем подсеть
resource "yandex_vpc_subnet" "test" {
  name           = var.vpc_name
  network_id     = yandex_vpc_network.test.id
  zone           = var.default_zone
  v4_cidr_blocks = var.default_cidr
}


output "name" {
  value = yandex_vpc_subnet.test
}

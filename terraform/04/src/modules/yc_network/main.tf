#создаем облачную сеть
resource "yandex_vpc_network" "test" {
  name = var.vpc_name
}

#создаем подсеть
resource "yandex_vpc_subnet" "test" {
  name           = "develop-ru-central1-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.test.id
  v4_cidr_blocks = ["10.0.5.0/24"]
}


output "name" {
  value = yandex_vpc_subnet.test
}


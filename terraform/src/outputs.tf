output "vm_platform_ip_address" {
  value = yandex_compute_instance.vm1.*.network_interface.0.nat_ip_address
  description = "vm_platform external ip"
}


output "vm_test_ip_address" {
  value = yandex_compute_instance.vm2.*.network_interface.0.nat_ip_address
  description = "vm_test external ip"
}


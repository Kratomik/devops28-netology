locals {
  resource_map_key = { for item in var.cpu-ram-disk : item.vm_name => item }
}

locals {
  file = ("${path.module}/home/nicolay/.ssh/id_ed25519.pub") 
}

locals {
  disk_vm = {for item in var.disk_vm : item.vm_name => item}
}

/*
locals {
  disk_id = { for item in var.volume : item.disk_id => item }
}


output "disk_id" {
  value = local.disk_id
}
*/


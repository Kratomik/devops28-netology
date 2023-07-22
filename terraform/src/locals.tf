
locals {
 platform = "netology-${var.env}-${var.project}-${var.role}"
 test     = "tetsing-${var.project}-${var.role}"
}

/*
locals {
  metadata = {for key, item in var.metadata: "${item.name}" => item}
}


locals {
  metadata = {  for key, value in var.metadata : key => value }
}

locals {
  metdat = { for k, v in var.vms_ssh-key : k => v }
}

output "metdat" {
  value = local.metdat
}


output "metadata" {
  value = local.metadata
}


resource_map_key = { for item in var.cpu-ram-disk : item.vm_name => item }
*/

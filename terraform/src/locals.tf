
locals {
 platform = "netology-${var.env}-${var.project}-${var.role}"
 test     = "tetsing-${var.project}-${var.role}"
}

/*
locals {
  metadata = {for key, item in var.metadata: "${item.name}" => item}
}
*/

locals {
  metadata = {  for key, value in var.metadata : key => value }
}



/*
output "metadata" {
  value = local.metadata
}


resource_map_key = { for item in var.cpu-ram-disk : item.vm_name => item }
*/

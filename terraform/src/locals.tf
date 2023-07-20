locals {
 platform = "${var.vm_web_name}"
 test = "${var.vm_db_name}"
}

locals {
  metadata = {  for item in var.metadata : item.serial-port-enable => item }
}

output {
  
}

/*
resource_map_key = { for item in var.cpu-ram-disk : item.vm_name => item }
*/

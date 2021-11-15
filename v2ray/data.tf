# Data for alicloud module

# OS IMAGE
data "alicloud_images" "default" {
  name_regex  = "^centos_8"
  most_recent = true
  owners      = "system"
}

# INSTANCE TYPE
data "alicloud_instance_types" "c1g1" {
  instance_type_family = "ecs.t5"
  cpu_core_count       = 1
  memory_size          = 1
}

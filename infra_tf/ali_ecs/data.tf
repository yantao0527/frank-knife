# Data for alicloud module

# OS IMAGE
data "alicloud_images" "default" {
  name_regex  = "^centos_8.2"
  most_recent = true
  owners      = "system"
}

# INSTANCE TYPE
data "alicloud_instance_types" "c1g1" {
  instance_type_family = "ecs.t5"
  cpu_core_count       = 1
  memory_size          = 1
}

data "alicloud_instance_types" "c2g8" {
  instance_type_family = "ecs.t5"
  cpu_core_count       = 2
  memory_size          = 8
}

data "alicloud_instance_types" "c4g16" {
  instance_type_family = "ecs.t5"
  cpu_core_count       = 4
  memory_size          = 16
}

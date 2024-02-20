#######################
# Launch template
#######################
resource "aws_launch_template" "LT" {
  count = var.create_lt ? 1 : 0

  name          = var.lt_name
  image_id      = var.image_id
  instance_type = var.instance_type
  key_name      = var.PUB_KEY
  ebs_optimized = var.ebs_optimized
  dynamic "block_device_mappings" {
    for_each = var.block_device_mappings
    content {
      device_name = "/dev/sda1"

      ebs {
        volume_size = 30
        volume_type = "gp2"
      }
    }
  }

  iam_instance_profile {
    arn = var.iam_instance_profile
  }

  network_interfaces {
    description                 = var.lt_name
    device_index                = 0
    associate_public_ip_address = var.associate_public_ip_address
    delete_on_termination       = true
    security_groups             = var.security_groups
  }

  monitoring {
    enabled = var.enable_monitoring
  }

  placement {
    tenancy = var.placement_tenancy
  }

  lifecycle {
    create_before_destroy = true
  }
}
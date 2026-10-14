# One hailstone step in HCL, evaluated by OpenTofu: infrastructure as code,
# minus the infrastructure.
variable "n" {
  type = number
}

locals {
  next = var.n % 2 == 0 ? var.n / 2 : 3 * var.n + 1
}

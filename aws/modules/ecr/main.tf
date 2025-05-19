resource "aws_ecr_repository" "main" {
  name                 = "${var.project_name}-${var.env}-${var.repository_type}-repo"
  image_tag_mutability = "MUTABLE"

  tags = merge(
    {
      Name = "${var.project_name}-${var.env}-${var.repository_type}-repo"
    },
    var.tags
  )
}
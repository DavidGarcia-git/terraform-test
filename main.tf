resource "random_id" "suffix" {
  byte_length = 2
}

resource "aws_s3_bucket" "demo" {
  bucket        = "terraform-demo-${random_id.suffix.hex}"
  force_destroy = true        # permite deletar o bucket sem erro
}

output "bucket_name" {
  value = aws_s3_bucket.demo.id
}

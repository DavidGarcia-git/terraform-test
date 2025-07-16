# main.tf
resource "aws_s3_bucket" "demo" {
  bucket        = "bucket-test12213"
  force_destroy = true # permite deletar o bucket mesmo com objetos
}

output "bucket_name" {
  value = aws_s3_bucket.demo.id
}

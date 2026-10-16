output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_ids" {
  value = aws_subnet.public[*].id
}

output "bucket_name" {
  value = aws_s3_bucket.artifacts.bucket
}
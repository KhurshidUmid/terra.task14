output "ssh_sg_id" {
  description = "ID of SSH security group"
  value       = aws_security_group.ssh.id
}

output "public_http_sg_id" {
  description = "ID of public HTTP security group"
  value       = aws_security_group.public_http.id
}

output "private_http_sg_id" {
  description = "ID of private HTTP security group"
  value       = aws_security_group.private_http.id
}

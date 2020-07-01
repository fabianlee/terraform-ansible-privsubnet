
output "wgserver_public" {
  value = aws_instance.wgserver.public_ip
}
output "wgserver_private" {
  value = aws_instance.wgserver.private_ip
}
output "webpub_public" {
  value = aws_instance.webpub.public_ip
}
output "webpub_private" {
  value = aws_instance.webpub.private_ip
}

output "webpriv_private" {
  value = aws_instance.webpriv.private_ip
}
output "dbpriv_private" {
  value = aws_instance.dbpriv.private_ip
}



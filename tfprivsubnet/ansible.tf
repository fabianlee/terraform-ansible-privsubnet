# https://github.com/mantl/terraform.py
# check above for dynamic inventory from terraform->ansible
#

# https://stackoverflow.com/questions/45489534/best-way-currently-to-create-an-ansible-inventory-from-terraform
data "template_file" "ansible_vars" {
  template = "${file("${path.module}/ansible_inventory.template")}"
  depends_on = [
    aws_instance.wgserver,
    aws_instance.webpub,
    aws_instance.webpriv,
    aws_instance.dbpriv
  ]
  vars = {
    wgserver_public = aws_instance.wgserver.public_ip
    webpub_public = aws_instance.webpub.public_ip
    webpriv_private = aws_instance.webpriv.private_ip
    dbpriv_private = aws_instance.dbpriv.private_ip
    aws_region = var.aws_region
  }
}

# https://blog.aurynn.com/2017/2/23-fun-with-terraform-template-rendering/
resource "null_resource" "ansible_inventory" {
  triggers = {
    template_rendered = data.template_file.ansible_vars.rendered
  }
  provisioner "local-exec" {
    command = "cat > ansible_inventory <<EOL\n${data.template_file.ansible_vars.rendered}\nEOL"
  }
}

data "template_file" "ansible_allvals" {
  template = "${file("${path.module}/allvals.properties.template")}"
  depends_on = [
    aws_instance.wgserver,
    aws_instance.webpub,
    aws_instance.webpriv,
    aws_instance.dbpriv
  ]
  vars = {
    wgserver_public = aws_instance.wgserver.public_ip
    webpub_public = aws_instance.webpub.public_ip
    webpriv_private = aws_instance.webpriv.private_ip
    dbpriv_private = aws_instance.dbpriv.private_ip
    aws_region = var.aws_region
    vpc_cidr = var.vpc_cidr
    # grab first 2 octets
    vpc_cidr_prefix = "${ regex("(\\d*.\\d*.)\\d*.\\d",var.vpc_cidr)[0] }"
    other_vpc_cidr = var.other_vpc_cidr
    subnet_cidr_public = var.subnet_cidr_public
    subnet_cidr_private = var.subnet_cidr_private
  }
}


resource "null_resource" "all_inventory" {
  triggers = {
    template_rendered = data.template_file.ansible_allvals.rendered
  }
  provisioner "local-exec" {
    command = "cat > ../allvals.properties <<EOL\n${data.template_file.ansible_allvals.rendered}\nEOL"
  }
}

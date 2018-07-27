data aws_route53_zone eugenesia {
  name = "aws.eugenesia.net"
}

resource aws_route53_record desktop {
  zone_id = "${data.aws_route53_zone.eugenesia.zone_id}"
  name    = "desktop.${data.aws_route53_zone.eugenesia.name}"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_instance.desktop.public_dns}"]
}

class gre (
  String $local_public_ip,
) inherits gre::params {

  validate_ip_address($local_public_ip)

}


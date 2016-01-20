define gre::tunnel (
  String         $remote_public_ip,
  String         $local_ip,
  String         $remote_ip,
  String         $local_ip6        = undef,
  Integer        $mtu              = 1476,
  Integer[0,255] $ttl              = 255,
  Array[String]  $pre_up           = [],
  Array[String]  $post_up          = [],
  Array[String]  $pre_down         = [],
  Array[String]  $post_down        = [],
) {

  validate_ip_address($remote_public_ip)
  validate_ip_address($local_ip)

  $interface = 'gre-${title}'

  include gre
  include gre::params

  if ($local_public_ip == $remote_public_ip) {
    notice('Skipping. Local and remote are the same.')
  } else {
    file { '/etc/network/interfaces.d/${interface}':
      content => epp('gre/tunnel.epp'),
      owner   => 'root',
      group   => 'root',
      mode    => '600',
      require => Package['iproute2'],
      notify  => Service['networking'],
    }
  }

}

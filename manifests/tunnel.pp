define gre::tunnel (
  String[7,15]   $remote_public_ip,
  String[7,15]   $local_ip,
  Integer[0,32]  $local_netmask    = 31,
  Integer        $tunnel_mtu       = 1476,
  Integer[0,255] $ttl              = 255,
  Boolean        $rp_filter        = true,
) {

  validate_re($remote_public_ip, '^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$')
  validate_re($local_ip, '^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$')

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

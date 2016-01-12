class gre (
  String[7,15] $local_public_ip,
  Integer[0,255] $routing_table  = $gre::params::routing_table,
  Integer[0,32766] $ip_rule_pref = $gre::params::ip_rule_pref,
  $ip_rule_pref_unreachable      = $gre::params::ip_rule_pref_unreachable,
) inherits gre::params {

  if $ip_rule_pref_unreachable == undef {
    $ip_rule_pref_unreachable = $ip_rule_pref + 1
  }

  validate_re($local_public_ip, '^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$')

  $ip_rule_pref_unreachable = assert_type(Integer[0,32767], $ip_rule_pref_unreachable)
  if $ip_rule_pref_unreachable <= $ip_rule_pref {
    fail('\$ip_rule_pref_unreachable must be greater than \$ip_rule_pref')
  }

}


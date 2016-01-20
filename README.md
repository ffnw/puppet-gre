# puppet-gre

#### Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with gre](#setup)
    * [Beginning with gre](#beginning-with-gre)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

This module creates GRE tunnels over IPv4 only along with new interfaces prefixed with "gre-" using specific kernel routing table.

It was originally designed for the [Freifunk Nordwest](http://nordwest.freifunk.net) server infrastructure to create direct links between the [Freifunk Nordwest](http://nordwest.freifunk.net) gateways and connect to [Freifunk Rheinland](http://rheinland.freifunk.net) as uplink.

## Setup

### Beginning with gre

To setup this module it is enough to load it and set the local public IP address like this:
```puppet
class { '::gre':
  local_public_ip => '1.2.3.4',
}
```

Afterwards GRE tunnels can be created using the gre::tunnel defined type.

## Usage

```puppet
class { '::gre':
  local_public_ip => '1.2.3.4',
}

gre::tunnel ( 'internal-srv01':
  remote_public_ip => '4.3.2.1',
  local_ip => '2.3.4.5/31',
  remote_ip => '2.3.4.4',
  local_ip6 => 'fe80:1::2/64',
)

gre::tunnel ( 'uplink-fra-a':
  remote_public_ip => '4.3.3.4',
  local_ip         => '2.3.3.2/31',
  remote_ip        => '2.3.3.1',
  local_ip6        => 'fe80:2::2/64',
  pre_up           => [ '/sbin/ip rule add pref 31000 iif $IFACE table 42',
                        '/sbin/ip rule add pref 31001 iif $IFACE unreachable',
                        '/sbin/iptables -t nat -A POSTROUTING ! -s 2.3.3.2/31'
                        + ' -o $IFACE -j SNAT --to-source 4.3.3.5' ],
  post_up          => [ '/sbin/sysctl -w net.ipv4.conf.$IFACE.rp_filter=0' ],
  post_down        => [ '/sbin/ip rule del pref 31000 iif $IFACE table 42',
                        '/sbin/ip rule del pref 31001 iif $IFACE unreachable',
                        '/sbin/iptables -t nat -D POSTROUTING ! -s 2.3.3.2/31'
                        + ' -o $IFACE -j SNAT --to-source 4.3.3.5' ],
)
```

## Reference

* class gre
  * $local\_public\_ip

* define gre::tunnel
  * $remote\_public\_ip
  * $local\_ip
  * $remote\_ip
  * $local\_ip6 (optional)
  * $mtu (optional, default 1476)
  * $ttl (optional, default 255)
  * $pre\_up (optional, default [])
  * $post\_up (optional, default [])
  * $pre\_down (optional, default [])
  * $post\_down (optional, default [])

## Limitations

### OS compatibility
* Debian 8

## Development

### How to contribute
Fork the project, work on it and submit pull requests, please.


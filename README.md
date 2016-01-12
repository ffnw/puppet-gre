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
  local_ip => '2.3.4.5',
)

gre::tunnel ( 'uplink-fra-a':
  remote_public_ip => '4.3.3.4',
  local_ip => '2.3.3.2',
  rp_filter => false,
)
```

## Reference

* class gre
  * $local\_public\_ip
  * $routing\_table (optional, default 42)
  * $ip\_rule\_pref (optional, default 31000)
  * $ip\_rule\_pref\_unreachable (optional, default $ip\_rule\_pref + 1)

* define gre::tunnel
  * $remote\_public\_ip
  * $local\_ip,
  * $local\_netmask (optional, default 31)
  * $tunnel\_mtu (optional, default 1476)
  * $ttl (optional, default 255)
  * $rp\_filter (optional, default true)

## Limitations

### OS compatibility
* Debian 8

## Development

### How to contribute
Fork the project, work on it and submit pull requests, please.


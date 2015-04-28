## puppet-tinc

A module for managing the 'tinc' VPN client

### Usage

#### Installing Tinc

The `tinc` class installs the tinc package and manages the tinc service. It takes an optional `manageservice` argument. If set to 'true', puppet will not attempt to start/stop/restart the tinc service.

#### Defining a network

The `tinc::network` define defines a tinc network.

| Parameter        | Default     |  Description   |
|------------------|-------------|----------------|
| $vpnaddress      | Required    | The VPN IP address that this host should be assigned in the network |
| $vpnroute        | []          | An array of subnets that should be routed over this VPN in CIDR notation. At a minimum this should include the VPN subnet |
| $netname         | $name       | The name of this network |
| $autostart       | true        | Should ticd connect this network automatically when it starts? |
| $addressfamily   | 'ipv4'      | Address family for this network. Supported values are 'ipv4', 'ipv6' and 'any' |
| $interface       | 'vpn0'      | The name of the network interface to create for this VPN |
| $connectto       | []          | The name of nodes to attempt to automatically connect to |
| $nodename        | $::hostname | The name of this node |
| $keysize         | '4096'      | Size of the RSA key to generate |

#### Defining a node

The `tinc::host` define defines a node in the network. It should be used as an exported resource

| Parameter        | Default     |  Description   |
|------------------|-------------|----------------|
| $netname         | Required    | The name of the network this host definition is for |
| $subnets         | Required    | The subnets that this host will route packets for. Should at least include its own VPN IP |
| $publickey       | Required    | The RSA public key of this host. The $tinckey_<netname> facts will be useful here |
| $publicaddress   | undef       | An address that this node can be connected to at. If not specified, other nodes will no be able to initiate a direct connection to this host |
| $nodename        | $name       | The name of this node |

### Example

Consider two hosts: 'foo' and 'bar'. Foo has a VPN address of 192.168.2.1, and is also connected to the 192.168.1.0/24 network and will route packets to this network (ie, it will be a bridge between the 192.168.0.1/24 network and the VPN). It also has a public IP address in DNS as foo.example.com. Bar has a VPN address of 192.168.2.2, and does not route packets for other networks. Bar does not have a stable IP address.

#### foo

````
  tinc::network { 'example':
    vpnaddress => '192.168.2.1',
    vpnroute   => ['192.168.2.0/24'],
  }

  @@tinc::host { 'foo':
    netname       => 'example',
    subnets       => ['192.168.2.1/32', '192.168.1.0/24'],
    publickey     => $::tinckey_example,
    publicaddress => 'foo.example.com',
  }
  ````

#### bar

````
  tinc::network { 'example':
    vpnaddress => '192.168.2.2',
    vpnroute   => ['192.168.2.0/24', '192.168.1.0/24'],
    connectto  => ['foo']
  }

  @@tinc::host { 'bar':
    netname       => 'hhome',
    subnets       => ['192.168.2.2/32'],
    publickey     => $::tinckey_example,
  }
````

### Compatibility

This module has had some amount of testing with Debian 7 'Wheezy' and Ubuntu 14.04 'Trusty'.

### Status

The tinc program itself carries the warning that "The cryptography in tinc is not well tested yet. Use it at your own risk!". This warning is extended to puppet-tinc as:

This module is not well tested yet, but works for me. Use at your own risk!


define tinc::network(
  $vpnaddress,
  $vpnroute=[],
  $netname=$name,
  $autostart=true,
  $addressfamily='ipv4',
  $interface='vpn0',
  $connectto=[],
  $nodename=$::hostname,
)
{

  validate_array($vpnroute)
  validate_array($connectto)

  if ($autostart == true) {
    concat::fragment { "nets.boot-${netname}":
      content => "${netname}\n",
      target  => '/etc/tinc/nets.boot',
      order   => '02'
    }
  }

  file { "/etc/tinc/${netname}":
    ensure => directory
  }
  ->
  file { "/etc/tinc/${netname}/hosts/":
    ensure => directory,
    purge  => true
  }

  file { "/etc/tinc/${netname}/tinc.conf":
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('tinc/tinc.conf.erb'),
    notify  => Service['tinc']
  }

  file { "/etc/tinc/${netname}/tinc-up":
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0544',
    content => template('tinc/tinc-up.erb'),
    require => File["/etc/tinc/${netname}"]
  }

  file { "/etc/tinc/${netname}/tinc-down":
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0544',
    content => template('tinc/tinc-down.erb'),
    require => File["/etc/tinc/${netname}"]
  }

  Tinc::Host <<| netname == $netname |>>

}

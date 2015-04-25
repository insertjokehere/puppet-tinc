
class tinc($manageservice=true) {

  $service_noop = ! $manageservice

  package { 'tinc':
    ensure => present,
  }
  ->
  service { 'tinc':
    ensure    => running,
    hasstatus => false,
    noop      => $service_noop
  }

  concat { '/etc/tinc/nets.boot':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Service['tinc']
  }

  concat::fragment { 'nets.boot-header':
    content => "# These nets will be started automatically on boot. This file is managed by puppet\n",
    target  => '/etc/tinc/nets.boot',
    order   => '01'
  }

}

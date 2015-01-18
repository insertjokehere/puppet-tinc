
class tinc {

  package { 'tinc':
    ensure => present
  }
  ->
  service { 'tinc':
    ensure => running
  }

  concat { '/etc/tinc/nets.boot':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Service['tinc']
  }

  concat::fragment { 'nets.boot-header':
    content => '# These nets will be started automatically on boot. This file is managed by puppet',
    target  => '/etc/tinc/nets.boot',
    order   => '01'
  }

}

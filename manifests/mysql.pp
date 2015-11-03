# == Class: observium::mysql
#
## Install MySQL for Observium
#
# Using the forge Apache/MySQL modules over the Apache/MySQL
# classes here is recommended.  This module uses its own
# Apache/MySQL classes due to an internal conflict with the
# forge modules in the environment for which it was developed.
#

class observium::mysql (
  $manage_mysql   = $observium::manage_mysql,
  $db_packages    = $observium::db_packages,
  $db_host        = $observium::db_host,
  $db_data_path   = $observium::db_data_path,
  $db_root_pass   = $observium::db_root_pass,
  $db_pass        = $observium::db_pass
  ) {

  ## Manage MySQL installation
  #
  package { $db_packages:
      ensure  => installed,
  }

  file { '/etc/my.cnf':
    content => template('observium/my.cnf.erb'),
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    require => Package[$db_packages],
  }

  service { 'mysqld':
      ensure  => 'running',
      require => File['/etc/my.cnf'],
  }

  exec { 'set mysql password':
    unless    => "mysqladmin -uroot -p${db_root_pass} status",
    path      => ['/bin', '/usr/bin'],
    command   => "mysqladmin -uroot password ${db_root_pass}",
    logoutput => 'on_failure',
    require   => Service['mysqld'],
  }

}

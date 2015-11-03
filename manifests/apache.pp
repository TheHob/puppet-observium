# == Class: observium::config
#
## Manage Observium apache
#
# Using the forge Apache/MySQL modules over the Apache/MySQL
# classes here is recommended.  This module uses its own
# Apache/MySQL classes due to an internal conflict with the
# forge modules in the environment for which it was developed.
#

class observium::apache (
  $httpd_conf     = $observium::httpd_conf,
  $app_httpd_conf = $observium::app_httpd_conf,
  $app_ssl_conf   = $observium::app_ssl_conf,
  $base_path      = $observium::base_path,
  $servername     = $observium::servername,
  $rrd_path       = $observium::rrd_path,
  $log_path       = $observium::log_path
) {

  package { 'httpd':
    ensure => installed,
  }
  
  package { 'mod_ssl':
    ensure => installed,
  }

  ## Ensure default RRD directory
  #
  file { $rrd_path:
    ensure => directory,
    mode   => '0644',
    owner  => apache,
    group  => apache,
  }

  ## Ensure default logging directory
  #
  file { $log_path:
    ensure => directory,
    mode   => '0644',
    owner  => root,
    group  => root,
  }

  file { $httpd_conf:
    ensure  => file,
    content => template('observium/httpd.conf.erb'),
    mode    => '0644',
    owner   => root,
    group   => root,
    require => Package['httpd'],
    notify  => Service[httpd],
  }

  file { $app_httpd_conf:
    ensure  => file,
    content => template('observium/observium.conf.erb'),
    mode    => '0644',
    owner   => root,
    group   => root,
    require => File[$log_path],
    notify  => Service[httpd],
  }

  file { $app_ssl_conf:
    ensure  => file,
    content => template('observium/ssl.conf.erb'),
    mode    => '0644',
    owner   => root,
    group   => root,
    require => File[$log_path],
    notify  => Service[httpd],
  }

    service { 'httpd':
      ensure  => running,
      require => File[$httpd_conf],
    }


}

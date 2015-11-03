# == Class: observium::install
#
## Default Observium installation
#

class observium::install (
  $manage_package        = $observium::manage_package,
  $version               = $observium::version,
  $package_name          = $observium::package_name
) {

  package { $package_name:
    ensure => installed,
  }

}

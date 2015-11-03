# == Class: observium::config
#
## Manage Observium configuration
#

class observium::config (
  $base_path            = $observium::base_path,
  $config_path          = $observium::config_path,
  $db_host              = $observium::db_host,
  $db_user              = $observium::db_user,
  $db_pass              = $observium::db_pass,
  $db_name              = $observium::db_name,
  $auth_method          = $observium::auth_method,
  $ldap_binddn          = $observium::ldap_binddn,
  $ldap_bindpw          = $observium::ldap_bindpw,
  $ldap_objectclass     = $observium::ldap_objectclass,
  $ldap_bindanonymous   = $observium::ldap_bindanonymous,
  $ldap_server          = $observium::ldap_server,
  $ldap_port            = $observium::ldap_port,
  $ldap_version         = $observium::ldap_version,
  $ldap_suffix          = $observium::ldap_suffix,
  $ldap_groupbase       = $observium::ldap_groupbase,
  $ldap_groups          = $observium::ldap_groups,
  $ldap_attr            = $observium::ldap_attr,
  $ldap_groupmemberattr = $observium::ldap_groupmemberattr,
  $ldap_groupmembertype = $observium::ldap_groupmembertype
) {

  ## Ensure the base_path
  #
  file { $base_path:
    ensure => directory,
    mode   => '0644',
    owner  => root,
    group  => root,
  }

  file { $config_path:
    ensure  => file,
    content => template('observium/config.php.erb'),
    mode    => '0644',
    owner   => root,
    group   => root,
    require => File[$base_path],
  }

}

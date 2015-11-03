# == Class: observium::params
#
# Parameters:

class observium::params {
  $manage_package        = true
  $manage_config         = false
  $manage_mysql          = false
  $manage_apache         = true
  $manage_schema         = false
  $manage_repo           = true
  $yum_repo              = 'observium'
  $version               = '0.14.11_600-6'
  $package_name          = "observium-${version}"
  $base_path             = '/opt/observium'
  $config_path           = "${base_path}/config.php"
  $httpd_conf            = '/etc/httpd/conf/httpd.conf'
  $app_httpd_conf        = '/etc/httpd/conf.d/observium.conf'
  $app_ssl_conf          = '/etc/httpd/conf.d/ssl.conf'
  $servername            = $::hostname
  $rrd_path              = "${base_path}/rrd"
  $log_path              = "${base_path}/logs"
  $db_data_path          = '/var/lib/mysql'
  $db_root_pass          = 'password'
  $db_pass               = 'password'
  $db_host               = 'localhost'
  $db_name               = 'observium'
  $db_user               = 'observium'
  $db_import             = '/root/observium.sql'
  $db_packages           = [ 'mysql', 'mysql-server' ]
  $sql_import            = '/root/observium.sql'
  $auth_method           = 'mysql'
  $ldap_binddn           = 'CN=svcuser,CN=Users,DC=example,DC=com'
  $ldap_bindpw           = 'password'
  $ldap_objectclass      = 'user'
  $ldap_bindanonymous    = 'FALSE'
  $ldap_server           = 'ldapserver.example.com'
  $ldap_port             = '389'
  $ldap_version          = '3'
  $ldap_suffix           = ',DC=example,DC=com'
  $ldap_groupbase        = 'DC=example,DC=com'
  $ldap_groupmemberattr  = 'member'
  $ldap_groupmembertype  = 'fulldn'
  $ldap_groups           = undef
  $ldap_attr             = undef
  $config_strings        = undef
  $devices               = undef
  $users                 = undef
}

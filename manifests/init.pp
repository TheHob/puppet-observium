# == Class: observium
#
# Observium installs, configures, and manages an Observium installation.
#
# === Parameters:
#
## Hooks
#
# [*manage_package*]             
#  Whether or not to install the Observium package. 
#  Default: true
#
# [*manage_config*]               
#  Whether or not to manage Observium configuration. 
#  Default: false
#
# [*manage_mysql*]               
#  Whether or not to install MySQL locally. 
#  Default: false
#
# [*manage_schema*]            
#  Whether or not to create Observium schema if it's absent. 
#  This will not run if the default observium database is present
#  to protect against wiping existing schema.
#  Default: false
#
# [*manage_apache*]             
#  Whether or not to install apache locally.  This will manage
#  the observium apache configuration.
#  Default: true
#
# [*manage_repo*]               
#  Whether or not to include a specific repo for Observium installation.  
#  Default: false
#
## Other parameters
#
# [*yum_repo*]               
#  The yum repo to include for Observium installation.  
#  Default: observium
#
# [*version*]            
#  The version of Observium to install. 
#  Default: 0.14.11_600-6
#
# [*package_name*]    
#  The name of the observium package plus the version.  
#  Default: observium-$version
#    
# [*base_path*]  
#  The path in which Observium will be installed.  
#  Default: /opt/observium
#                         
# [*config_path*]             
#  The full path to the observium config file.  
#  Default: $base_path/config.php
#
# [*httpd_conf*]   
#  The full path to the httpd.conf file.  
#  Default: /etc/httpd/conf/httpd.conf
#    
# [*app_httpd_conf*]             
#  The full path to the observium httpd conf file.  
#  Default: /etc/httpd/conf.d/observium.conf
#
# [*servername*] 
#  The servername that will be in the observium.conf file.  
#  Default: $::hostname (fact)
#
# [*rrd_path*]   
#  Observium's rrd path.  
#  Default: /opt/observium/rrd
#
# [*log_path*]     
#  Observium's log path.  
#  Default: /opt/observium/logs
#
# [*db_data_path*]
#  The MySQL database path.  
#  Default: /var/lib/mysql
#
# [*db_root_pass*]     
#  The MySQL root password that the module will set if manage_schema 
#  is set to true.
#  Default:  'password'
#
# [*db_pass*]
#  Password for Observium's database.
#  Default: 'password'
#
# [*db_host*]
#  The database host to put in Observium's config.php
#  Default: localhost
#
# [*db_name*]
#  The name of Observium's database for Observium's config.php and
#  the creation of schema if manage_schema is set to true.
#  Default: observium
#
# [*db_user*]
#  The user who is authorized to access Observium's database.
#  Default: observium
#        
# [*db_packages*]
#  The packages to install for mysql.
#  Default: mysql, mysql-server
#
# [*sql_import*]  
#  The full path of the file to import in order to create schema
#  if manage_schema is set to true.
#  Default: /root/observium.sql
#
# [*config_strings*]  
#  Any additional raw config strings you'd like to
#  include in config.php.
#  Only included in config if specified.
#
# [*auth_method*]
#  Observium's authorization method.  If set to 'ldap' an LDAP
#  authorization section will be included in config.php.
#  Default:  mysql (local)
#
### The below parameters are included in config.php
### if 'ldap' is set as the auth method.
#
# [*ldap_binddn*]   
#  The distinguished name of the user that will bind the LDAP server.
#  Default: CN=svcuser,CN=Users,DC=example,DC=com
# 
# [*ldap_bindpw*]
#  The password the binddn will use to bind the LDAP server.
#  Default:  'password'
#
# [*ldap_objectclass*]
#  The LDAP objectclass to use in the LDAP user search filter.
#  Default:  user
#
# [*ldap_bindanonymous*]
#  Whether or not your LDAP server allows anonymous bind.
#  Default: FALSE
#
# [*ldap_server*]
#  The hostname of the LDAP server.
#  Default: ldapserver.example.com
# 
# [*ldap_port*]    
#  The port on which to bind the LDAP server.
#  Default: 389
#
# [*ldap_version*]  
#  The LDAP version used by LDAP server/Observium.
#  Default: 3
#
# [*ldap_suffix*]
#  The LDAP suffix to use in the user search filter.
#  Default:  ,DC=example,DC=com
#
# [*ldap_groupbase*]  
#  The LDAP groupbase to use in the user search filter.
#  Default:  DC=example,DC=com
#
# [*ldap_groupmemberattr*]
#  The LDAP group member attribute to use in the user search filter.
#  to determine users' group membership.
#  Default:  member
#
# [*ldap_groupmembertype*]
#  The LDAP groupmembertype attribute to use in the user search filter.
#  Default:  fulldn
#
# [*ldap_groups*]
#  LDAP groups to include as authorized users of Observium.
#  Only included in config if specified.
#  Default:  undef
#
# [*ldap_attr*]
#  Any additional LDAP attributes you'd like to include
#  Only included in config if specified.
#  Default:  undef
#
### End of LDAP configurations
#
# [*devices*] 
#  Devices for Observium to add and monitor.
#  This is consumed by device.pp and is not 
#  invoked by default.  Accepts a hash of:
#  $community, $version, $port and $protocol for
#  any specified hostname.  
#  
# [*users*]  
#  Users to add and to Observium if using local
#  authentication.  Not a bad idea to create a local admin user.
#  This is consumed by user.pp and is not 
#  invoked by default.  Accepts a hash of:
#  $pass and auth $level for any specified user.

class observium (
  $manage_package        = $observium::params::manage_package,
  $manage_config         = $observium::params::manage_config,
  $manage_mysql          = $observium::params::manage_mysql,
  $manage_schema         = $observium::params::manage_schema,
  $manage_apache         = $observium::params::manage_apache,
  $manage_repo           = $observium::params::manage_repo,
  $yum_repo              = $observium::params::yum_repo,
  $version               = $observium::params::version,
  $package_name          = $observium::params::package_name,
  $base_path             = $observium::params::base_path,
  $config_path           = $observium::params::config_path,
  $httpd_conf            = $observium::params::httpd_conf,
  $app_httpd_conf        = $observium::params::app_httpd_conf,
  $app_ssl_conf          = $observium::params::app_ssl_conf,
  $servername            = $observium::params::servername,
  $rrd_path              = $observium::params::rrd_path,
  $log_path              = $observium::params::log_path,
  $db_data_path          = $observium::params::db_data_path,
  $db_root_pass          = $observium::params::db_root_pass,
  $db_pass               = $observium::params::db_pass,
  $db_host               = $observium::params::db_host,
  $db_name               = $observium::params::db_name,
  $db_user               = $observium::params::db_user,
  $db_import             = $observium::params::db_import,
  $db_packages           = $observium::params::db_packages,
  $sql_import            = $observium::params::sql_import,
  $auth_method           = $observium::params::auth_method,
  $ldap_binddn           = $observium::params::ldap_binddn,
  $ldap_bindpw           = $observium::params::ldap_bindpw,
  $ldap_objectclass      = $observium::params::ldap_objectclass,
  $ldap_bindanonymous    = $observium::params::ldap_bindanonymous,
  $ldap_server           = $observium::params::ldap_server,
  $ldap_port             = $observium::params::ldap_port,
  $ldap_version          = $observium::params::ldap_version,
  $ldap_suffix           = $observium::params::ldap_suffix,
  $ldap_groupbase        = $observium::params::ldap_groupbase,
  $ldap_groupmemberattr  = $observium::params::ldap_groupmemberattr,
  $ldap_groupmembertype  = $observium::params::ldap_groupmembertype,
  $ldap_groups           = $observium::params::ldap_groups,
  $ldap_attr             = $observium::params::ldap_attr,
  $config_strings        = $observium::params::config_strings,
  $devices               = $observium::params::devices,
  $users                 = $observium::params::users
) inherits observium::params {


  if $manage_package {
    ## Create repo before package
    ## if repo is managed
    if $manage_repo {
      # An 'observium' yum repo is a very notable
      # requirement of this module.  Observium
      # can be installed from source as well but
      # that requires refactoring.
      include yumrepos
      Yumrepo <| title == $yum_repo |>

      Yumrepo[$yum_repo] -> Package[$package_name]
    }
    
    include observium::install
    
    if $manage_schema {
      Package[$package_name] ~> Exec['run updates']
    }
  }

  if $manage_config {
    include observium::config

    if $manage_package {
      Class[observium::install] -> Class[observium::config]
    }
  }

  #  May want to include your own apache module here
  #  and only have observium::apache manage your config
  if $manage_apache {
    include observium::apache
    
    if $manage_package {
      Class[observium::install] -> Class[observium::apache]
    }
  }

  if $manage_mysql {
    include observium::mysql
    
    if $manage_package {
      Class[observium::install] -> Class[observium::mysql]
    }
  }

  if $manage_schema {
    include observium::schema

    if $manage_mysql {
      Class[observium::mysql] -> Class[observium::schema]
    }
  }
}

## This is a module to install Observium
A network device monitoring tool.

It has been tested and is being refined.

_This module will:_
- Install Observium
- Install MySQL (if manage_mysql = true)
- Create Database Schema (if manage_schema = true)
- Add users (if you set the users variable)
- Add devices (if you set the devices variable)
- Enable LDAP or MySQL (local) login

#### Important notes:  
- Using the forge Apache/MySQL modules over the Apache/MySQL classes here is recommended.  This module doesn't due to an internal conflict with the forge modules in the environment for which it was developed.
- This module currently requires a 'yumrepos' module with a virtual yum repo resource named 'observium.'  That repo needs to contain an Observium RPM at a minimum, at maximum all the packages noted in the Observium installation documents here:  http://www.observium.org/docs/rhel/.  You will need to get all the dependencies from somewhere, of course.  A nice future addition would be support for the install from source provider.

## The following parameters are available:

## Hooks

 [*manage_package*]             
  Whether or not to install the Observium package.
  Default: true

 [*manage_config*]               
  Whether or not to manage Observium configuration.
  Default: false

 [*manage_mysql*]               
  Whether or not to install MySQL locally.
  Default: false

 [*manage_schema*]            
  Whether or not to create Observium schema if it's absent.
  This will not run if the default observium database is present
  to protect against wiping existing schema.
  Default: false

 [*manage_apache*]             
  Whether or not to install apache locally.  This will manage
  the observium apache configuration.
  Default: true

 [*manage_repo*]               
  Whether or not to include a specific repo for Observium installation.  
  Default: false

## Other parameters

 [*yum_repo*]               
  The yum repo to include for Observium installation.  
  Default: observium

 [*version*]            
  The version of Observium to install.
  Default: 0.14.11_600-6

 [*package_name*]    
  The name of the observium package plus the version.  
  Default: observium-$version

 [*base_path*]  
  The path in which Observium will be installed.  
  Default: /opt/observium

 [*config_path*]             
  The full path to the observium config file.  
  Default: $base_path/config.php

 [*httpd_conf*]   
  The full path to the httpd.conf file.  
  Default: /etc/httpd/conf/httpd.conf

 [*app_httpd_conf*]             
  The full path to the observium httpd conf file.  
  Default: /etc/httpd/conf.d/observium.conf

 [*servername*]
  The servername that will be in the observium.conf file.  
  Default: $::hostname (fact)

 [*rrd_path*]   
  Observium's rrd path.  
  Default: /opt/observium/rrd

 [*log_path*]
  Observium's log path.  
  Default: /opt/observium/logs

 [*db_data_path*]
  The MySQL database path.  
  Default: /var/lib/mysql

 [*db_root_pass*]     
  The MySQL root password that the module will set if manage_schema
  is set to true.
  Default:  'password'

 [*db_pass*]
  Password for Observium's database.
  Default: 'password'

 [*db_host*]
  The database host to put in Observium's config.php
  Default: localhost

 [*db_name*]
  The name of Observium's database for Observium's config.php and
  the creation of schema if manage_schema is set to true.
  Default: observium

 [*db_user*]
  The user who is authorized to access Observium's database.
  Default: observium

 [*db_packages*]
  The packages to install for mysql.
  Default: mysql, mysql-server

 [*sql_import*]  
  The full path of the file to import in order to create schema
  if manage_schema is set to true.
  Default: /root/observium.sql

 [*config_strings*]  
  Any additional raw config strings you'd like to
  include in config.php.
  Only included in config if specified.

Example of string stored in hiera:

profiles::observium::config_strings:
  $config['fping'] = "/usr/sbin/fping";

Realized like this in config.php:

$config['fping'] = "/usr/sbin/fping";


 [*auth_method*]
  Observium's authorization method.  If set to 'ldap' an LDAP
  authorization section will be included in config.php.
  Default:  mysql (local)

## The below parameters are included in config.php if 'ldap' is set as the auth method.

 [*ldap_binddn*]
  The distinguished name of the user that will bind the LDAP server.
  Default: CN=svcuser,CN=Users,DC=example,DC=com

 [*ldap_bindpw*]
  The password the binddn will use to bind the LDAP server.
  Default:  'password'

 [*ldap_objectclass*]
  The LDAP objectclass to use in the LDAP user search filter.
  Default:  user

 [*ldap_bindanonymous*]
  Whether or not your LDAP server allows anonymous bind.
  Default: FALSE

 [*ldap_server*]
  The hostname of the LDAP server.
  Default: ldapserver.example.com

 [*ldap_port*]
  The port on which to bind the LDAP server.
  Default: 389

 [*ldap_version*]
  The LDAP version used by LDAP server/Observium.
  Default: 3

 [*ldap_suffix*]
  The LDAP suffix to use in the user search filter.
  Default:  ,DC=example,DC=com

 [*ldap_groupbase*]
  The LDAP groupbase to use in the user search filter.
  Default:  DC=example,DC=com

 [*ldap_groupmemberattr*]
  The LDAP group member attribute to use in the user search filter.
  to determine users' group membership.
  Default:  member

 [*ldap_groupmembertype*]
  The LDAP groupmembertype attribute to use in the user search filter.
  Default:  fulldn


 [*ldap_groups*]
  LDAP groups to include as authorized users of Observium.
  Only included in config if specified.
  Default:  undef

Example of a group stored in hiera:

profiles::observium::ldap_groups:
  'unix_group,OU=Unix Groups':
    level: 10

Realized like this in the config.php and there can be multiple entries:

$config['auth_ldap_groups']['unix_group,OU=Unix Groups']['level'] = 10;


 [*ldap_attr*]
  Any additional LDAP attributes you'd like to include
  Only included in config if specified.
  Default:  undef

Example of three attribute entries stored in hiera:

profiles::observium::ldap_attr:
  'uid':
    mapto: sAMAccountName
  'uidNumber':
    mapto: uid
  'cn':
    mapto: cn

Realized like this in the config.php (there can be multiple entries):

$config['auth_ldap_attr']['uid'] = "sAMAccountName";
$config['auth_ldap_attr']['uidNumber'] = "uid";
$config['auth_ldap_attr']['cn'] = "cn";


## End of LDAP configurations

 [*devices*]
  Devices for Observium to add and monitor.
  This is consumed by device.pp and is not
  invoked by default.  Accepts a hash of:
  $community, $version, $port and $protocol for
  any specified hostname.  

Examples of device info stored in hiera:

profiles::observium::devices:
  '1.1.1.1':
    community: community1
    version: v2c
    port: 514
    protocol: tcp
  '2.2.2.2':
    community: community2
    version: v1
    port: 514
    protocol: udp

 [*users*]  
  Users to add and to Observium if using local
  authentication.  Not a bad idea to create a local admin user.
  This is consumed by user.pp and is not
  invoked by default.  Accepts a hash of:
  $pass and auth $level for any specified user.

Example of user data stored in hiera:

profiles::observium::users:
  'admin':
  pass: password
  level: 10

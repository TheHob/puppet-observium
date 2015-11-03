# == Class: observium::schema
#
## Create the appropriate Observium schema
#

class observium::schema (
  $sql_import     = $observium::sql_import,
  $base_path      = $observium::base_path,
  $db_host        = $observium::db_host,
  $db_name        = $observium::db_name,
  $db_root_pass   = $observium::db_root_pass,
  $db_pass        = $observium::db_pass,
  $sql_import     = $observium::sql_import
  ) {

  ## Set the _server variable
  #
  $_server = $db_host ? {
    $::fqdn     => 'localhost',
    $::hostname => 'localhost',
    localhost   => 'localhost',
    default     => $::fqdn,
  }

  ## Create commands
  #
  $mysql_cmd     = "/usr/bin/mysql -h ${db_host} -uroot -p'${db_root_pass}' -e"
  $create_schema = "\"CREATE DATABASE IF NOT EXISTS ${db_name} DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;\""
  $create_user   = "\"GRANT ALL PRIVILEGES ON ${db_name}.* TO '${db_user}'@'${_server}' IDENTIFIED BY '${db_pass}';\""

  ## Create schema
  #
  exec { 'create observium schema':
    unless  => "${mysql_cmd} \"show databases like '${db_name}';\" |grep ${db_name}",
    command => "${mysql_cmd} ${create_schema}",
  }

  ## Create and authorize user
  #
  exec { 'create observium user':
    unless  => "${mysql_cmd} \"select user from mysql.user;\" |grep ${db_user}",
    command => "${mysql_cmd} ${create_user}",
    require => Exec['create observium schema'],
  }

  ## Run Observium schema update
  # We might want to add logic to
  # run updates if the Observium
  # package is updated.
  #
  exec { 'run updates':
    cwd         => $base_path,
    path        => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ],
    refreshonly => true,
    command     => "php ${base_path}/includes/update/update.php",
    require     => Exec['create observium schema'],
  }

}

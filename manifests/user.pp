# == Class: observium::user
#
## Create Observium users
#

define observium::user (
  $base_path = $observium::base_path,
  $db_host   = $observium::db_host,
  $db_host   = $observium::db_host,
  $db_user   = $observium::db_user,
  $db_pass   = $observium::db_pass,
  $db_name   = $observium::db_name,
  $pass      = 'V3rysAfeY',
  $level     = '1'
) {

  $user_query = "SELECT user_id FROM users WHERE username = \'${name}\'"
  $check_user = "/usr/bin/mysql -h ${db_host} -u${db_user} -p${db_pass} -s -e \"${user_query}\" ${db_name}"

  exec { "add user ${name}":
    onlyif  => "/usr/bin/test -z `${check_user}`",
    command => "${base_path}/adduser.php ${name} ${pass} ${level}",
  }
}

# == Class: observium::device.pp
#
# Observium installs, configures, and manages an Observium installation.
#
## Add device resource
#
define observium::device (
  $base_path = $observium::base_path,
  $db_host   = $observium::db_host,
  $db_user   = $observium::db_user,
  $db_pass   = $observium::db_pass,
  $db_name   = $observium::db_name,
  $community = 'default',
  $version   = 'v2c',
  $port      = '36602',
  $protocol  = 'tcp'
) {
  
  $device_query    = "SELECT device_id FROM devices WHERE hostname = \'${name}\'"
  $check_device    = "/usr/bin/mysql -h ${db_host} -u ${db_user} -p${db_pass} -s -e \"${device_query}\" ${db_name}"
  $device_add      = "${base_path}/add_device.php ${name} ${community} ${version} ${port} ${protocol}"
  $device_discover = "${base_path}/discovery.php -h ${name} && ${base_path}/poller.php -h ${name}"
  
  exec { "add device ${name}":
    onlyif  => "/usr/bin/test -z `${check_device}`",
    command => "${device_add} && ${device_discover}",
  }
}
  

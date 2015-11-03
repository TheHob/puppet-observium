node default {
  class { 'observium':
      manage_mysql         => true,
      manage_repo          => false,
      ldap_binddn          => 'CN=REDACTED,CN=Users,DC=examples,DC=com',
      auth_method          => 'ldap',
      ldap_bindpw          => 'password',
      ldap_objectclass     => 'user',
      ldap_bindanonymous   => 'FALSE',
      ldap_server          => 'ldap.example.com',
      ldap_port            => '389',
      ldap_version         => '3',
      ldap_suffix          => ',DC=example,DC=com',
      ldap_groupbase       => 'DC=example,DC=com',
      ldap_groupmemberattr => 'member',
      ldap_groupmembertype => 'fulldn'
  }
}

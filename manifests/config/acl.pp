# defined type allows you to declare a BIND ACL.
#
# Parameters:
#
# $ensure = ensure the persence or absence of the acl.
# $aclname = the name given to the ACL. This must be unique. This defaults to
#   the namevar.
# $data = an array of IP addresses or subnets using CIDR notation.
#
# Usage:
#
# dns::acl { 'trusted':
#   ensure => present,
#   data   => [ '10.0.0.0/8', '172.16.2.0/24', ]
# }
#
define dns::config::acl (
  $ensure = present,
  $aclname = $name,
  $data = [],
) {
  include dns::config::params

  $cfg_dir = $dns::cfg_dir

  concat::fragment { "named.conf.local.acl.${aclname}.include":
    target  => "${cfg_dir}/named.conf.local",
    order   => 2,
    content => template("${module_name}/acl.erb"),
  }

}

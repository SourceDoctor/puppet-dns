# == Define dns::server:srv
#
# Wrapper for dns::zone to set SRV records
#
define dns::record::srv (
  $zone,
  $service,
  $pri,
  $weight,
  $port,
  $target,
  $proto = 'tcp',
  $ttl = '',
  $data_dir = $dns::data_dir,
) {

  $alias = "${service}:${proto}@${target}:${port},${pri},${weight},SRV,${zone}"

  $host = "_${service}._${proto}.${zone}."

  dns::record::record_base { $alias:
    zone     => $zone,
    host     => $host,
    ttl      => $ttl,
    record   => 'SRV',
    data     => "${pri}\t${weight}\t${port}\t${target}",
    data_dir => $data_dir,
  }
}

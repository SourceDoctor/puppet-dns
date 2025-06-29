# == Define dns::zone
#
# `dns::zone` defines a DNS zone and creates both the zone entry
# in the `named.conf` files and the standardized zone file header
# to which the zone records will be added.
#
# === BIND Time Values
#
# BIND time values are numeric strings and default to representing a
# number of seconds (e.g. a time value of `3600` equals one hour).
# Time values may optionally be followed by a suffix of `m`, `h`,
# `d`, or `w`, meaning the time is in minutes, hours, days, or weeks,
# respectively.  For example, one week could be represented as any of
# `1w`, `7d`, `168h`, `10080m`, or `604800`.
#
# === FQDN Values
#
# The `dns::zone` type will append the final `.` dot to any value which
# is listed in the *Parameters* section as an *FQDN* (Fully Qualified
# Domain Name).  This has two implications:  First, any FQDN must *not*
# include the trailing `.` dot; second, any parameter listed as an FQDN
# _must_ be fully-qualified, and will not allow the hostname-only form
# of the name (e.g. in the `example.net` domain, `ns1.example.net` could
# not be referred to as `ns1` in any parameter that requires an FQDN).
#
# === Access Control Lists
#
# Any parameter which is an Access Control List is an array that may
# contain the pre-defined ACL names `none`, `any`, `localhost`, or
# `localnets`, or may contain ip addresses, optionally precededed by a
# `!` exclamation mark and optionally followed by a `/` and a prefix
# length for a subnet match.
#
# === Parameters
#
# [*allow_transfer*]
#   An array that indicates what other DNS servers may initiate a
#   zone transfer of this zone.  The array may contain IP addresses,
#   optionally followed by a `/` and a prefix length for a subnet match,
#   and optionally prefixed by a `!` exclamation mark (to indicate that
#   the IP address - or addresses, with a subnet match - are denied
#   rather than allowed) or the special ACL names `any`, `localhost`,
#   `localnets`, or `none`: `any` matches any host; `localhost` matches
#   only the name server itself; `localnets` matches the name server
#   and any request from the name server's subnet(s); and `none` is the
#   equivalent of `!any` - it denies all requests.  The first entry in
#   the array that matches the requester's address will be used.
#
# [*allow_forwarder*]
#   An array of IP addresses and optional port numbers to which queries
#   for this zone will be forwarded (based on the *forward_policy*
#   setting).  If the optional port number is included, it must be
#   separated from the IP address by the word `port` - for example, `[
#   '192.168.100.102 port 1234' ]`.  Defaults to an empty array, which
#   means no forwarding will be done.
#
# [*allow_query*]
#   An array of IP addresses from which queries should be allowed
#  Defaults to an empty array, which allows all ip to query the zone
#
# [*allow_update*]
#   An array of IP addresses from which updates should be allowed.
#  Defaults to an empty array, which allows updates to the zone.
#  If Array has entries, then zone file initial creation is allowed
#  but content will not be replaced. This capability allows dynamic
#  updates.
#
# [*also_notify*]
#   This is an array of IP addresses and optional port numbers to
#   which this DNS server will send notifies when the master DNS server
#   reloads the zone file.  See the *allow_forwarder* parameter for how
#   to include the optional port numbers.
#
# [*create_zone_file*]
#   When it is set to `true` the zone file will be created.
#   If it is `false`, only include of its filename for given zone will be created.
#   Zonefile itself has to be generated by yourself.
#
# [*data_dir*]
#   Bind data directory.
#   Default: /etc/bind/zones
#
# [*default_zone*]
#   When it is set to `true` the zone is added to the `named.conf.default-zones`
#   file instead of `named.conf.local` or a view file. Defaults to `false`. This
#   parameter should not be set to true when `view` parameter is also used.
#
# [*forward_policy*]
#   Either `first` or `only`.  If the *allow_forwarder* array is not
#   empty, this setting defines how query forwarding is handled.  With a
#   value of `only`, the DNS server will forward the request and return
#   the response to the client immediately.  With a value of `first`,
#   the DNS server will forward the request; if the forwarder server
#   returns a not-found response, the DNS server will attempt to answer
#   the request itself.
#
# [*nameservers*]
#   An array containing the FQDN's of each name server for this zone.
#   This will be used to create the `NS` records for the zone file.
#   Defaults to an array containing the `$::fqdn` fact.
#
# [*reverse*]
#   If `true`, the zone will have `.in-addr.arpa` appended to it.
#   If set to the string `reverse`, the `.`-separated components of
#   the zone will be reversed, and then have `.in-addr.arpa` appended
#   to it.
#   Defaults to `false`.
#
# [*serial*]
#   Optional set or time bases auto generated serial numver of zone file
#
# [*slave_masters*]
#   If *zone_type* is set to `slave` or `stub`, this holds an array or string
#   containing the IP addresses of the DNS servers from which this slave
#   transfers the zone.  If a string, the IP addresses must be separated
#   by semicolons (`;`).
#
# [*soa*]
#   The authoritative name server for this zone.  Defaults to the
#   `$::fqdn` fact.
#
# [*soa_email*]
#   The point-of-contact authoritative name server for this zone, in
#   the form _<username>_`.`_<domainname>_ (_<username>_ may not contain
#   `.` dots).  Defaults to `root.` followed by the `$::fqdn` fact.
#
# [*view*]
#   The view which this zone belongs to. Defaults to undef (it does not belong to
#   any view and the configuration is added to named.conf.local. This parameter
#   should not be used with `default_zone` set to true.
#
# [*zone_expire*]
#   This is the maximum amount of time after the last successful refresh
#   of the zone for which the slave will continue to respond to DNS
#   queries for records in this zone.
#
# [*zone_minimum*]
#   Despite _minimum_ in the parameter name, this is the maximum time
#   that a _negative_ for this zone (e.g. a host not found response)
#   may be cached by other resolvers.
#
# [*zone_notify*]
#   One of `yes`, `no`, or `explicit`.   With a value of `explicit`,
#   when sending notifies, the DNS server will send them only to the
#   slaves listed in the `also_notify` list.  With `yes`, the DNS server
#   will send notifies to the `also_notify` list _and_ to all nameservers
#   listed in the `NS` records for the zone _except_ for the nameserver
#   listed in the `soa` parameter and the sending name server.  With `no`,
#   the DNS server will never send notifies for this zone.
#
# [*zone_refresh*]
#   The minimum time between when slaves will check back with the zone
#   master(s) to check if the zone has been updated.  See *Time values*
#   above.  Defaults to 604800 seconds (7 days).
#
# [*zone_retry*]
#   If a slave tries and fails to contact the master(s), this is the
#   time the slave will wait before retrying.
#
# [*zone_ttl*]
#   The default TTL (time-to-live) for the zone records.  See *Time
#   values* above.  Defaults to 604800 seconds (7 days).
#
# [*zone_type*]
#   The type of DNS zone being described.  Can be one of `master`, `slave`
#   (requires *slave_masters* to be set), `stub` (requires *slave_masters*
#   to be set), `delegation-only`, or `forward` (requires both
#   *allow_forwarder* and *forward_policy* to be set).
#   Defaults to `master`.
#
define dns::config::zone (
  $soa = $::fqdn,
  $soa_email = "root.${::fqdn}",
  $zone_name = $name,
  $zone_ttl = '604800',
  $zone_refresh = '604800',
  $zone_retry = '86400',
  $zone_expire = '2419200',
  $zone_minimum = '604800',
  $nameservers = [ $::fqdn ],
  $reverse = false,
  $serial = false,
  $zone_type = 'master',
  $create_zone_file = true,
  $allow_transfer = [],
  $allow_forwarder = [],
  $allow_query =[],
  $allow_update =[],
  $forward_policy = 'first',
  $slave_masters = undef,
  $zone_notify = undef,
  $also_notify = [],
  $ensure = present,
  $view = undef,
  $default_zone = false,
) {

  $cfg_dir = $dns::cfg_dir
  $data_dir = $dns::data_dir

  $owner = $dns::owner
  $group = $dns::group

  $rfc1912_zones_cfg = $dns::config::params::rfc1912_zones_cfg

  validate_array($allow_transfer)
  validate_array($allow_forwarder)
  if !member(['first', 'only'], $forward_policy) {
    fail('The forward policy can only be set to either first or only')
  }
  validate_array($allow_query)

  validate_array($also_notify)
  $valid_zone_notify = ['yes', 'no', 'explicit', 'master-only']
  if $zone_notify != undef and !member($valid_zone_notify, $zone_notify) {
    fail("The zone_notify must be ${valid_zone_notify}")
  }

  $zone = $reverse ? {
    'reverse' => join(reverse(split("arpa.in-addr.${zone_name}", '\.')), '.'),
    true      => "${zone_name}.in-addr.arpa",
    default   => $zone_name
  }

  validate_string($zone_type)
  $valid_zone_type_array = ['master', 'slave', 'stub', 'forward', 'delegation-only']
  if !member($valid_zone_type_array, $zone_type) {
    $valid_zone_type_array_str = join($valid_zone_type_array, ',')
    fail("The zone_type must be one of [${valid_zone_type_array}]")
  }

  $zone_file = "${data_dir}/db.${zone_name}"
  $zone_file_stage = "${zone_file}.stage"

  validate_array($allow_update)
  # Replace when updates allowed
  if empty($allow_update) {
    $zone_replace = true
  } else {
    $zone_replace = false
  }

  if $view {
    validate_string($view)
  }

  validate_bool($create_zone_file)

  validate_bool($default_zone)

  if $view and $default_zone == true {
    fail('view and default parameters are mutually excluding')
  }

  if $ensure == absent {
    file { $zone_file:
      ensure => absent,
    }
  } elsif $zone_type == 'master' and $create_zone_file {
    # Zone Database

    # Create "fake" zone file without zone-serial
    concat { $zone_file_stage:
      owner   => $owner,
      group   => $group,
      mode    => '0644',
      replace => $zone_replace,
      notify  => Exec["bump-${zone}-serial"]
    }
    concat::fragment{"db.${zone_name}.soa":
      target  => $zone_file_stage,
      order   => 1,
      content => template("${module_name}/zone_file.erb")
    }

    # Generate real zone from stage file through replacement _SERIAL_ template
    # to current timestamp. A real zone file will be updated only at change of
    # the stage file, thanks to this serial is updated only in case of need.

    $zone_serial = $serial ? {
      false   => inline_template('<%= Time.now.to_i %>'),
      default => $serial
    }
    exec { "bump-${zone}-serial":
      command     => "sed '8s/_SERIAL_/${zone_serial}/' ${zone_file_stage} > ${zone_file}",
      path        => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
      refreshonly => true,
      provider    => posix,
      user        => $owner,
      group       => $group,
      notify      => Class['dns::config::service'],
    }
  } else {
    # For any zone file that is not a master zone, we should make sure
    # we don't have a staging file
    concat { $zone_file_stage:
      ensure => absent
    }
  }

  # Include Zone in named.conf.local or view file
  $target = $default_zone ? {
    true      => $rfc1912_zones_cfg,
    default   => $view ? {
      undef   => "${cfg_dir}/named.conf.local",
      ''      => "${cfg_dir}/named.conf.local",
      default => "${cfg_dir}/view-${view}.conf",
    }
  }
  concat::fragment{"named.conf.local.${zone_name}.include":
    target  => $target,
    order   => 3,
    content => template("${module_name}/zone.erb"),
  }
}

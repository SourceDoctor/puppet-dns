#
define dns::config::key (

  $keyname = $name,
  $owner   = $dns::owner,
  $group   = $dns::group,
  $cfg_dir = $dns::cfg_dir,

) {

  file { "/tmp/${keyname}-secret.sh":
    ensure  => file,
    mode    => '0777',
    content => template('dns/secret.erb'),
    notify  => Exec["dnssec-keygen-${keyname}"],
  }

  exec { "dnssec-keygen-${keyname}":
    path        => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
    command     => "dnssec-keygen -a HMAC-MD5 -r /dev/urandom -b 128 -n USER ${keyname}",
    cwd         => "${cfg_dir}/bind.keys.d",
    require     => File["${cfg_dir}/bind.keys.d"],
    refreshonly => true,
    notify      => Exec["get-secret-from-${keyname}"],
  }

  exec { "get-secret-from-${keyname}":
    command     => "/tmp/${keyname}-secret.sh",
    cwd         => "${cfg_dir}/bind.keys.d",
    creates     => "${cfg_dir}/bind.keys.d/${keyname}.secret",
    require     => [
      Exec["dnssec-keygen-${keyname}"],
      File["${cfg_dir}/bind.keys.d"],
      File["/tmp/${keyname}-secret.sh"],
    ],
    refreshonly => true,
  }

  file { "${cfg_dir}/bind.keys.d/${keyname}.secret":
    require => Exec["get-secret-from-${keyname}"],
  }

  concat { "${cfg_dir}/bind.keys.d/${keyname}.key":
    owner  => $owner,
    group  => $group,
    mode   => '0644',
    notify => Class['dns::config::service']
  }

  Concat::Fragment {
    target  => "${cfg_dir}/bind.keys.d/${keyname}.key",
    require => [
      Exec["get-secret-from-${keyname}"],
      File["${cfg_dir}/bind.keys.d/${keyname}.secret"],
    ],
  }

  concat::fragment { "${keyname}.key-header":
    order   => 1,
    content => template('dns/key.erb'),
  }

  concat::fragment { "${keyname}.key-secret":
    order  => 2,
    source => "${cfg_dir}/bind.keys.d/${keyname}.secret",
  }

  concat::fragment { "${keyname}.key-footer":
    order   => 3,
    content => '};',
  }
}

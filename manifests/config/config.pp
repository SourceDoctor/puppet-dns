#
class dns::config::config (
  $cfg_dir              = $dns::cfg_dir,
  $cfg_file             = $dns::cfg_file,
  $data_dir             = $dns::data_dir,
  $owner                = $dns::config::params::owner,
  $group                = $dns::config::params::group,
  $enable_default_zones = true,
) inherits dns::config::params {

  file { $cfg_dir:
    ensure => directory,
    owner  => $owner,
    group  => $group,
    mode   => '0755',
  }

  file { $data_dir:
    ensure => directory,
    owner  => $owner,
    group  => $group,
    mode   => '0755',
  }

  file { "${cfg_dir}/bind.keys.d/":
    ensure => directory,
    owner  => $owner,
    group  => $group,
    mode   => '0755',
  }

  file { $cfg_file:
    ensure  => present,
    owner   => $owner,
    group   => $group,
    mode    => '0644',
    content => template("${module_name}/named.conf.erb"),
    require => [
      File[$cfg_dir],
      Class['dns::config::install']
    ],
    notify  => Class['dns::config::service'],
  }

  concat { "${cfg_dir}/named.conf.local":
    owner  => $owner,
    group  => $group,
    mode   => '0644',
    notify => Class['dns::config::service']
  }

  concat::fragment{'named.conf.local.header':
    target  => "${cfg_dir}/named.conf.local",
    order   => 1,
    content => "// File managed by Puppet.\n"
  }

  # Configure default zones with a concat so we could add more zones in it
  concat {$dns::config::params::rfc1912_zones_cfg:
    owner          => $owner,
    group          => $group,
    mode           => '0644',
    ensure_newline => true,
    notify         => Class['dns::config::service'],
  }

  concat::fragment {'default-zones.header':
    target  => $dns::config::params::rfc1912_zones_cfg,
    order   => '00',
    content => template('dns/named.conf.default-zones.erb'),
  }
}

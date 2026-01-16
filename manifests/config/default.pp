class dns::config::default (
  $resolvconf            = $dns::resolvconf,
  $options               = $dns::options,
  $rootdir               = $dns::rootdir,
  $enable_zone_write     = $dns::enable_zone_write,
  $enable_sdb            = $dns::enable_sdb,
  $disable_named_dbus    = $dns::disable_named_dbus,
  $keytab_file           = $dns::keytab_file,
  $disable_zone_checking = $dns::disable_zone_checking,

) inherits dns {

  $cfg_dir           = $dns::cfg_dir
  $cfg_file          = $dns::cfg_file
  $data_dir          = $dns::data_dir
  $working_dir       = $dns::working_dir
  $root_hint         = $dns::config::params::root_hint
  $rfc1912_zones_cfg = $dns::config::params::rfc1912_zones_cfg
  $rndc_key_file     = $dns::config::params::rndc_key_file
  $default_file      = $dns::config::params::default_file
  $default_template  = $dns::config::params::default_template

  Stdlib::Absolutepath( $default_file )

  if $rootdir != undef {
    Stdlib::Absolutepath( $rootdir )
  }

  if $keytab_file != undef {
    Stdlib::Absolutepath( $keytab_file )
  }

  file { $default_file:
    ensure  => present,
    owner   => $::dns::config::params::owner,
    group   => $::dns::config::params::group,
    mode    => '0644',
    content => template("${module_name}/${default_template}"),
    notify  => Class['dns::config::service'],
    require => Package[$::dns::config::params::necessary_packages]
  }
}


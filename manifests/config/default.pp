class dns::config::default (
  $resolvconf            = $dns::config::resolvconf,
  $options               = $dns::config::options,
  $rootdir               = $dns::config::rootdir,
  $enable_zone_write     = $dns::config::enable_zone_write,
  $enable_sdb            = $dns::config::enable_sdb,
  $disable_named_dbus    = $dns::config::disable_named_dbus,
  $keytab_file           = $dns::config::keytab_file,
  $disable_zone_checking = $dns::config::disable_zone_checking,

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

  validate_absolute_path( $default_file )

  if $rootdir != undef {
    validate_absolute_path( $rootdir )
  }

  if $keytab_file != undef {
    validate_absolute_path( $keytab_file )
  }

  file { $default_file:
    ensure  => present,
    owner   => $::dns::config::owner,
    group   => $::dns::config::group,
    mode    => '0644',
    content => template("${module_name}/${default_template}"),
    notify  => Class['dns::config::service'],
    require => Package[$::dns::config::necessary_packages]
  }
}

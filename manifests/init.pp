class dns (
  String $owner                                    = $dns::config::params::owner,
  String $group                                    = $dns::config::params::group,

  $cfg_dir                                         = $dns::config::params::cfg_dir,
  $data_dir                                        = $dns::config::params::data_dir,
  $working_dir                                     = $dns::config::params::working_dir,

# options file
  Array[String] $listen_on                         = $dns::config::params::listen_on,
  Array[String] $listen_on_ipv6                    = $dns::config::params::listen_on_ipv6,
  Optional[Integer] $listen_on_port                = $dns::config::params::listen_on_port,

  Array[String] $forwarders                        = $dns::config::params::forwarders,
  Optional[Enum['first', 'only']] $forward_policy  = $dns::config::params::forward_policy,

  Optional[Enum['warn', 'fail', 'ignore']]
        $check_names_master                        = $dns::config::params::check_names_master,
  Optional[Enum['warn', 'fail', 'ignore']]
        $check_names_slave                         = $dns::config::params::check_names_slave,
  Optional[Enum['warn', 'fail', 'ignore']]
        $check_names_response                      = $dns::config::params::check_names_response,

  Array[String] $allow_recursion                   = $dns::config::params::allow_recursion,
  Array[String] $allow_query                       = $dns::config::params::allow_query,

  Optional[String] $zone_notify                    = $dns::config::params::zone_notify,
  Optional[Array[String]] $also_notify             = $dns::config::params::also_notify,

  Optional[Boolean] $no_empty_zones                = $dns::config::params::no_empty_zones,

  Optional[String] $notify_source                  = $dns::config::params::notify_source,

  Array[String] $transfers                         = $dns::config::params::transfers,
  Optional[String] $transfer_source                = $dns::config::params::transfer_source,

  Optional[Boolean] $dnssec_enable                 = undef,
  Optional[Enum['yes', 'no', 'auto']]
        $dnssec_validation                         = undef,

  Optional[String] $statistic_channel_ip           = undef,
  Optional[Integer] $statistic_channel_port        = undef,
  Optional[Array[String]] $statistic_channel_allow = undef,

  Optional[Boolean] $query_log_enable              = undef,
  Optional[Hash] $log_channels                     = $dns::config::params::log_channels,
  Optional[Hash] $log_categories                   = $dns::config::params::log_categories,

  Optional[Hash] $extra_options                    = $dns::config::params::extra_options,

# default file
  Optional[Boolean] $resolvconf                    = undef,
  Optional[Boolean] $disable_zone_checking         = undef,
  Optional[Boolean] $enable_zone_write             = undef,
  Optional[Boolean] $enable_sdb                    = undef,

  Optional[String] $options                        = undef,
  Optional[String] $rootdir                        = undef,

  Optional[String] $disable_named_dbus             = undef,
  Optional[String] $keytab_file                    = undef,

# TSIG
  Optional[Hash] $tsig                             = undef,

# Key
  Optional[String] $key                            = undef,

# Acl
  Optional[Hash] $acl                              = undef,

# Zone
  Optional[Hash] $zone                             = undef,

# View
  Optional[Hash] $view                             = undef,

) inherits dns::config::params {

  validate_absolute_path($cfg_dir)
  validate_absolute_path($data_dir)
  validate_absolute_path($working_dir)

  include dns::config::install
  include dns::config::default
  include dns::config::options
  include dns::config::config
  include dns::config::service

  if $tsig {
    create_resources('dns::config::tsig', $tsig)
  }

  if $key {
    dns::config::key {$key:}
  }

  if $acl {
    create_resources('dns::config::acl', $acl)
  }

  if $zone {
    create_resources('dns::config::zone', $zone)
  }

  if $view {
    create_resources('dns::config::view', $view)
  }
}

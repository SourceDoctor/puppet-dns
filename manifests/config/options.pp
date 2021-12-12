# BIND config template-based configuration definition.
#
# === Parameters
#
# [*allow_recursion*]
#   Array of IP addresses which are allowed to make recursive queries.
#   Default: empty, meaning "localnets; localhost"
#
# [*allow_query*]
#   Array of IP addresses which are allowed to ask ordinary DNS questions.
#   Default: empty, meaning "any"
#
# [*also_notify*]
#   The list of configs to which additional zone-change notifications
#   should be sent.
#   Default: empty, meaning no additional configs
#
# [*check_names_master*]
#   Restrict the character set and syntax of master zones.
#   Default: undefined, meaning "fail"
#
# [*check_names_slave*]
#   Restrict the character set and syntax of slave zones.
#   Default: undefined, meaning "warn"
#
# [*check_names_response*]
#   Restrict the character set and syntax of network responses.
#   Default: undefined, meaning "ignore"
#
# [*control_channel_ip*]
#   String of one ip for which the control api is bound.
#   Default: undef, meaning the control channel is disable,
#            both control_channel_port and control_channel_ip must be defined
#            for the control api to be enabled
#
# [*control_channel_port*]
#   String of one port for which the control api is bound.
#   Default: undef, meaning the control channel is disable
#            both control_channel_port and control_channel_ip must be defined
#            for the control api to be enabled
#
# [*control_channel_allow*]
#   Array of IPs that are allowed to query the controls channel.
#   Default: undef, meaning all IPs that can reach control_channel_ip are allowed
#            to query it
#
# [*data_dir*]
#   Bind data directory.
#   Default: `/etc/bind/zones` in Debian, `/var/named` in RedHat.
#
# [*dnssec_validation*]
#   Controls DNS-SEC validation.  String of "yes", "auto", "no", or
#   "absent" (to prevent the `dnssec-validation` option from being
#   included).  Default is "absent" on RedHat 5 (whose default bind
#   package is too old to include dnssec validation), and "auto" on
#   Debian and on RedHat 6 and above.
#   Note: If *dnssec_enable* is set to false, this option is ignored.
#
# [*dnssec_enable*]
#   Controls whether to enable/disable DNS-SEC support. Boolean.
#   Default is false on RedHat 5 (for the same reasons as
#   dnssec_validation above), and true on Debian and on RedHat 6
#   and above.
#
# [*forward_policy*]
#   The forwarding policy to use.  Must be `first` or `only`.
#   If not defined, the `named` default of `first` will be used.
#
# [*forwarders*]
#   Array of forwarders IP addresses. Default: empty
#
# [*response_policy_zones*]
#   Array of response policy zones. Default: empty
#   allows local overwrite of DNS Response to requesting Client
#
# [*listen_on*]
#   Array of IP addresses on which to listen. Default: empty, meaning "any"
#
# [*listen_on_ipv6*]
#   Array of IPv6 addresses on which to listen. Default: empty, meaning "any"
#
# [*listen_on_port*]:
#   UDP/TCP port number to use for receiving and sending traffic.
#   Default: undefined, meaning 53
#
# [*max_udp_size*]
#   Max Size of UDP Packages. Default: undefined, meaning 1232
#
# [*log_categories*]
#   Logging categories to use. It is a hash of arrays. Each key of the hash is a category
#   and its value is the array of options. If `query_log_enable` is set to true, then
#   this value is ignored.
#   Default: empty.
#
# [*log_channels*]
#   Logging channels to use. It is a hash of arrays. Each key of the hash is a channel
#   and its value is the array of options. If `query_log_enable` is set to true, then
#   this value is ignored.
#   Default: empty.
#
# [*no_empty_zones*]
#   Controls whether to enable/disable empty zones. Boolean values.
#   Default: false, meaning enable empty zones
#
# [*notify_source*]
#   The source IP address from which to send notifies.
#   Default: undef, meaning the primary IP address of the DNS config,
#   as determined by BIND.
#
# [*query_log_enable*]
#   If `true`, query logging will be turned on and directed to the
#   `named_querylog` file in the `working_dir` directory.  If `false`
#   or not defined, query logging will not be configured.
#
# [*statistics_file*]
#   String of an absolute path where bind statistics will be written to.
#   Default: undef, meaning the statistic file is disable,
#
# [*zone_statistics*]
#   Boolean which decides if statistics will be sorted per zone.
#   Default: undef, meaning the statistics will not be written per zone,
#
# [*statistic_channel_ip*]
#   String of one ip for which the statistic api is bound.
#   Default: undef, meaning the statistic channel is disable,
#            both statistic_channel_port and statistic_channel_ip must be defined
#            for the statistic api to be enabled
#
# [*statistic_channel_port*]
#   String of one port for which the statistic api is bound.
#   Default: undef, meaning the statistic channel is disable
#            both statistic_channel_port and statistic_channel_ip must be defined
#            for the statistic api to be enabled
#
# [*statistic_channel_allow*]
#   Array of IPs that are allowed to query the statistics channel.
#   Default: undef, meaning all IPs that can reach statistic_channel_ip are allowed
#            to query it
#
# [*transfers*]
#   Array of IP addresses or "none" allowed to transfer. Default: empty
#
# [*transfer_source*]
#   The source IP address from which to respond to transfer requests.
#   Default: undef, meaning the primary IP address of the DNS config,
#   as determined by BIND.
#
# [*zone_notify*]
#   Controls notifications when a zone for which this config is
#   authoritative changes.  String of yes (send notifications to zone's
#   NS records and to also-notify list), no (no notifications are sent),
#   master-only (only send notifications for master zones), or explicit
#   (send notifications only to also-notify list).
#   Default: undef, meaning the BIND default of "yes"
#
# [*working_dir*]
#   The working directory where the query log will be stored.
#   Default: `/var/cache/bind` in Debian, `${data_dir}/data` in RedHat
#
# [*extra_options* ]
#   Hash with other options that will be included.
#   Default: empty.
#
# === Examples
#
#  dns::options { '/etc/bind/named.conf.options':
#    forwarders => [ '8.8.8.8', '8.8.4.4' ],
#   }
#
class dns::config::options (
  $allow_query = $::dns::allow_query,
  $allow_recursion = $::dns::allow_recursion,
  $also_notify = $::dns::also_notify,
  $check_names_master = $::dns::check_names_master,
  $check_names_slave = $::dns::check_names_slave,
  $check_names_response = $::dns::check_names_reponse,
  $control_channel_ip = undef,
  $control_channel_port = undef,
  $control_channel_allow = undef,
  $cfg_dir = $dns::cfg_dir,
  $data_dir = $dns::data_dir,
  $dnssec_enable = $::dns::dnssec_enable,
  $dnssec_validation = $::dns::dnssec_validation,
  $forward_policy = $::dns::forward_policy,
  $forwarders = $::dns::forwarders,
  $response_policy_zones = $::dns::response_policy_zones,
  $listen_on = $::dns::listen_on,
  $listen_on_ipv6 = $::dns::listen_on_ipv6,
  $listen_on_port = $::dns::listen_on_port,
  $log_channels = $::dns::log_channels,
  $log_categories = $::dns::log_categories,
  $max_udp_size = undef,
  $no_empty_zones = $::dns::no_empty_zones,
  $notify_source = $::dns::notify_source,
  $query_log_enable = $::dns::query_log_enable,
  $statistics_file = $::dns::statistics_file,
  $zone_statistics = $::dns::zone_statistics,
  $statistic_channel_ip = $::dns::statistic_channel_ip,
  $statistic_channel_port = $::dns::statistic_channel_port,
  $statistic_channel_allow = $::dns::statistic_channel_allow,
  $transfers = $::dns::transfers,
  $transfer_source = $::dns::transfer_source,
  $working_dir = $dns::working_dir,
  $zone_notify = $::dns::zone_notify,
  $extra_options = $::dns::extra_options,

) inherits dns {

  file { "${cfg_dir}/named.conf.options":
    ensure  => present,
    owner   => $dns::owner,
    group   => $dns::group,
    mode    => '0644',
    require => [File[$cfg_dir], Class['::dns::config::install']],
    content => template("${module_name}/named.conf.options.erb"),
    notify  => Class['dns::config::service'],
  }
}

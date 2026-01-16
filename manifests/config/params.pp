class dns::config::params {
  case $facts['os']['family'] {
    'Debian': {
      $cfg_dir            = '/etc/bind'
      $cfg_file           = "${cfg_dir}/named.conf"
      $data_dir           = '/var/cache/bind'
      $working_dir        = '/var/cache/bind'
      $root_hint          = "${cfg_dir}/db.root"
      $rfc1912_zones_cfg  = "${cfg_dir}/named.conf.default-zones"
      $rndc_key_file      = "${cfg_dir}/rndc.key"
      $group              = 'bind'
      $owner              = 'bind'
      $package            = 'bind9'
      $service            = 'bind9'
      $default_file       = '/etc/default/bind9'
      $default_template   = 'default.debian.erb'
      $default_dnssec_enable     = true
      $default_dnssec_validation = 'auto'
      $necessary_packages = ['bind9']
    }
    'RedHat': {
      $cfg_dir            = '/etc/named'
      $cfg_file           = '/etc/named.conf'
      $data_dir           = '/var/named'
      $working_dir        = "${data_dir}/data"
      $root_hint          = "${data_dir}/named.ca"
      $rfc1912_zones_cfg  = '/etc/named.rfc1912.zones'
      $rndc_key_file      = '/etc/named.root.key'
      $group              = 'named'
      $owner              = 'named'
      $package            = 'bind'
      $service            = 'named'
      $necessary_packages = [ 'bind', ]
      $default_file       = '/etc/sysconfig/named'
      $default_template   = 'default.redhat.erb'
      if $facts['os']['release']['major'] =~ /^[1-5]$/ {
        $default_dnssec_enable     = false
        $default_dnssec_validation = 'absent'
      } else {
        $default_dnssec_enable     = true
        $default_dnssec_validation = 'auto'
      }
    }
    default: {
      fail("dns is incompatible with this osfamily: ${facts['os']['family']}")
    }
  }

  $ensure_packages             = latest

  $listen_on                   = []
  $listen_on_ipv6              = []
  $forwarders                  = []
  $response_policy_zones       = []
  $forward_policy              = undef
  $listen_on_port              = undef
  $max_udp_size                = undef
  $transfers                   = []
  $allow_recursion             = []
  $allow_query                 = []
  $check_names_master          = undef
  $check_names_slave           = undef
  $check_names_response        = undef
  $zone_notify                 = undef
  $also_notify                 = []
  $no_empty_zones              = undef
  $notify_source               = undef
  $transfer_source             = undef
  $log_channels                = {}
  $log_categories              = {}
  $extra_options               = {}
}


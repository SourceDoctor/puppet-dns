#
# defines a DNS view.
#
# Zones to the view could be added by using the `zones` parameter of
# `dns::view` or by declaring `dns::zone` resources with its `view`
# parameter set to this resource name.
#
# === Parameters
#
# [*ensure*]
#   If the view should be `present` or `absent. Defaults to `present`.
#
# [*enable_default_zones*]
#   Boolean indicating if the default zones (`named.conf.default-zones`) should
#   be included in this view or not. Defaults to `true`.
#
# [*match_clients*]
#   Array (of strings) with the `match-clients` for the zone. Defaults to empty.
#
# [*match_destinations*]
#   Array (of strings) with the `match-destinations` for the view. Defaults to empty.
#
# [*match_recursive_only*]
#   Value for the `match-recursive-only` option of the view. Defaults to undef
#   (the option is not configured). Valid values are `yes` and `no`.
#
# [*options* ]
#   Hash with additional options that should be configured in the view.
#   Defaults to empty (no additional option is added). It should be a hash where
#   every value should be a string or an array.
#
# [*order*]
#   Order of different views could be important (for example, if `match_clients`
#   of a view is a superset of the `match_clients` of another). This parameter
#   could be used to force a different order of the alphatical one.
#   Defaults to `50`.
#
# [*viewname*]
#   Name of the view. Defaults to `$name`.
#
# [*zones*]
#   Hash of zones resources that should be included in this view.
#   Defaults to empty (no zone is added).
#
define dns::config::view (
  $ensure               = 'present',
  $enable_default_zones = true,
  $match_clients        = [],
  $match_destinations   = [],
  $match_recursive_only = undef,
  $options              = {},
  $order                = '50',
  $viewname             = $name,
  $zones                = {},
) {
#  include ::dns::params

  $cfg_dir = $dns::cfg_dir
  $data_dir = $dns::data_dir

  $owner = $dns::owner
  $group = $dns::group

  $rfc1912_zones_cfg = $dns::config::params::rfc1912_zones_cfg

  $valid_ensure = ['present', 'absent']
  if !member($valid_ensure, $ensure) {
    fail("ensure parameter must be ${valid_ensure}")
  }
  if $match_recursive_only != undef {
      validate_bool($match_recursive_only)
  }

  concat { "${cfg_dir}/view-${viewname}.conf":
    ensure         => $ensure,
    owner          => $owner,
    group          => $group,
    mode           => '0644',
    ensure_newline => true,
    notify         => Class['dns::config::service'],
  }

  if $ensure == 'present' {
    concat::fragment {"view-${viewname}.header":
      target  => "${cfg_dir}/view-${viewname}.conf",
      order   =>  '00',
      content => template("${module_name}/view.erb"),
    }

    concat::fragment {"view-${viewname}.tail":
      target  => "${cfg_dir}/view-${viewname}.conf",
      order   => '99',
      content => '}; ',
    }

    # Include view configuration in main config
    concat::fragment {"named.conf.local.view.${viewname}.include":
      target  => "${cfg_dir}/named.conf.local",
      order   => $order,
      content => "include \"${cfg_dir}/view-${viewname}.conf\";\n",
      require => Concat["${cfg_dir}/view-${viewname}.conf"],
    }

    # Create zone config
    create_resources(dns::config::zone, $zones, { view => $viewname })
  }
}


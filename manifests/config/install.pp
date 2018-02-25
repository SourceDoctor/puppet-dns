class dns::config::install (
  $necessary_packages = $dns::config::params::necessary_packages,
  $ensure_packages    = $dns::config::params::ensure_packages,
) inherits dns {

  package { $necessary_packages :
    ensure => $ensure_packages,
  }
}

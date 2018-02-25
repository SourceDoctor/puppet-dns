class dns::config::service (
  $service = $dns::config::params::service
) inherits dns::config::params {

  service { $service:
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
    enable     => true,
    require    => Class['dns::config::config']
  }

}

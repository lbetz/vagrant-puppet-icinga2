class profile::puppet::master {

  #
  # Postgresql 9.6 from PuppetDB
  #

  class { 'puppetdb::database::postgresql':
    manage_package_repo => true,
    postgres_version    => '9.6',
    listen_addresses    => '*',
  }

  #
  # Puppetmaster / PuppetDB
  #

  Systemd::Unit_file['puppetmaster.service']
    -> Class['puppet']
  Service['puppetmaster']
    -> Class['puppetdb::server']
    -> Class['puppetdb::master::config']

  systemd::unit_file { 'puppetmaster.service':
   source => "puppet:///modules/profile/puppetmaster.service",
  }

  class { '::puppet':
    server                        => true,
    server_implementation         => 'master',
    server_package                => 'puppetserver',
    server_passenger              => false,
    server_service_fallback       => true,
    agent                         => true,
    vardir                        => '/opt/puppetlabs/server/data/puppetserver',
    server_common_modules_path    => '/etc/puppetlabs/code/modules',
    server_directory_environments => true,
    server_dynamic_environments   => false,
    server_environments           => [ 'production' ],
    show_diff                     => true,
    server_storeconfigs_backend   => 'puppetdb',
    server_reports                => 'store',
    server_foreman                => false,
    server_external_nodes         => '',
    server_environments_owner     => 'puppet',
    server_environments_group     => 'puppet',
    server_manage_user            => false,
  }

  class { '::puppetdb::server':
    manage_firewall   => false,
    java_args         => [ '-Xmx128m' ],
  }

  user { 'puppet':
    ensure  => present,
    shell   => '/bin/bash',
    require => Package['puppetserver'],
  }

  class { '::puppetdb::master::config':
    restart_puppet              => false,
    puppetdb_soft_write_failure => true,
    strict_validation           => false,
    enable_reports              => true,
  }

}

node 'puppet.localdomain' {

  host { 'puppet.localdomain':
    ip           => '192.168.7.2',
    host_aliases => 'puppet',
  }

  unless $::operatingsystem in ['redhat', 'centos'] and Integer($::operatingsystemmajrelease) >= 7 {
    fail("'Your plattform ${::operatingsystem} is not supported.'")
  }

  yumrepo { 'puppet5':
    baseurl  => "http://yum.puppet.com/puppet5/el/${::operatingsystemmajrelease}/\$basearch",
    descr    => 'Puppet 5 Repository el 7 - $basearch',
    enabled  => 1,
    gpgcheck => 1,
    gpgkey   => 'http://yum.puppet.com/RPM-GPG-KEY-puppet',
  }

  Yumrepo['puppet5'] -> Package<||>

  include ::profile::puppet::master
}


node default {

  host { 'puppet.localdomain':
    ip           => '192.168.7.2',
    host_aliases => 'puppet',
  }

  if $::kernel != 'windows' and $::shared_folders {
    if member(values($::shared_folders), '/etc/puppetlabs/code/environments/production') {
      file { '/root/puppetcode':
        ensure => link,
        target => '/etc/puppetlabs/code/environments/production',
      }
    }
  }

}
